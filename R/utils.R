#' Create a Comparison Plot of Pollen Concentrations
#'
#' @param data_plot A dataframe containing pollen concentrations
#' @param taxon The selected Pollen Type
#' @param station The selected Pollen Type
#' @param resolution Temporal resolution c("daily" or "hourly")
#' @param rm_zeros Should zero/NA pollen measurements be removed from the plot
#' @param combined Return the combined plots with title or seperate plots
#' @param plot_dwh Should the Measurements from the DWH be plotted
#' @param scale Should the timeseries be rescaled to 0-1
#'
#' @return A list of ggplots or a combined ggplot


plot_comb <- function(data_plot,
                      taxon,
                      station,
                      resolution,
                      rm_zeros,
                      combined,
                      plot_dwh, 
                      scale) {

  if (!plot_dwh){
    data_plot <- data_plot %>%
      filter(type != "Hirst")
  }

  if (scale){
    data_plot <- data_plot %>%
      group_by(station, type) %>%
      mutate(value = rescale(value)) %>%
      ungroup()
  }

  data_plot <- data_plot %>%
    filter(
      taxon %in% !!taxon,
      station %in% !!station,
      measurement == "concentration"
    )

  if (rm_zeros) {
    data_plot <- data_plot %>%
      filter(value > 0)
  }

  title <- tools::toTitleCase(paste0(
    resolution,
    " average concentrations of ",
    taxon,
    " Pollen in ",
    station,
    " ",
    stations %>% 
      filter(station == !!station) %>%
      pull(hirst_station)

  ))

  alpha_plot <- 0.5

  gg1 <- data_plot %>%
    group_by(type, datetime) %>%
    summarise(value = mean(value)) %>%
    ungroup() %>%
    ggplot() +
    geom_line(aes(x = datetime, y = value, col = type, alpha = alpha_plot)) +
    scale_color_manual(values = swatch()[c(2:4)]) +
    theme(legend.position = "none") +
    labs(y = "Mean Conc. [Pollen/m³]", x = "")

  gg2 <- data_plot %>%
    ggplot() +
    geom_boxplot(aes(y = log10(value + 1), fill = type), alpha = alpha_plot) +
    theme(
      legend.position = "none",
      axis.ticks.x = element_blank(),
      axis.text.x = element_blank()
    ) +
    scale_fill_manual(values = swatch()[c(2:4)]) +
    labs(y = "Log Mean Conc. [Pollen/m³]", x = "")

  gg3 <- data_plot %>%
    ggplot() +
    geom_histogram(aes(
      y = log10(value + 1),
      fill = type
    ),
    alpha = alpha_plot,
    binwidth = 0.1
    ) +
    facet_wrap(vars(type), ncol = 1) +
    theme(legend.position = "bottom") +
    scale_fill_manual(values = swatch()[c(2:4)]) +
    coord_flip() +
    labs(
      x = "Occurence of Pollen Concentrations",
      y = "Log Mean Conc. [Pollen/m³]"
    )

  if (!combined) {
    list(
      gg1 + ggtitle(title),
      gg2 + ggtitle(title),
      gg3 + ggtitle(title)
    )
  } else {
    ggthemr::ggthemr("fresh")
    ggarrange(ggarrange(gg1, gg2, nrow = 2), gg3) %>%
      annotate_figure(top = title)
  }
}

#' Create a Comparison Plot of Pollen Concentrations
#'
#' @param data A data frame that contains pollen data
#' @param title The title for the table
#' @return a kable object

create_kable <- function(data, title = "") {
  myheader <- c("dummy" = 4)
  names(myheader) <- paste(title)
  data %>%
    select(-metric) %>%
    mutate(value = round(value)) %>%
    pivot_wider(names_from = type, values_from = value) %>%
    select(-taxon) %>%
    kable() %>%
    kable_styling("striped", full_width = FALSE) %>%
    add_header_above(myheader, font_size = 18)
}

#' Retrieve Pollendata from txt-file (COSMO output with Fieldextra)
#'
#' @param datapath File path to the txt-file containing the data
#' @param type Hirst, Cosmo or Assim

import_data_cosmo <- function(datapath, type) {
  read_table2(paste(datapath), col_names = TRUE) %>%
    # setting na during import failed for some reason
    mutate_at(vars(CHBASE:CHZUER), ~ ifelse(. < 0, NA_real_, .)) %>%
    pivot_longer(CHBASE:CHZUER,
      names_to = "station_tag",
      values_to = "value"
    ) %>%
    mutate(
      measurement = case_when(
        str_detect(PARAMETER, pattern = "sdes") ~ "phenology",
        str_detect(PARAMETER, pattern = "fe") ~ "emission",
        TRUE ~ "concentration"
      ),
      PARAMETER = str_replace_all(PARAMETER, "sdes|fe", "")
    ) %>%
    inner_join(species, by = c("PARAMETER" = "cosmo_taxon")) %>%
    inner_join(stations, by = c("station_tag" = "cosmo_station")) %>%
    mutate(
      datetime = ymd_h(paste0(
        YYYY, sprintf("%02d", MM),
        sprintf("%02d", DD),
        sprintf("%02d", hh)
      )),
      date = lubridate::date(datetime),
      hour = lubridate::hour(datetime),
      type = type
    ) %>%
    select(taxon, station, date, hour, value, datetime, type, measurement)
}


#' Retrieve Pollendata from txt-file (DWH)
#'
#' @param datapath File path to the txt-file containing the data
#' 

import_data_dwh <- function(datapath) {
  read_delim(paste(datapath), delim = " ", skip = 17) %>%
  pivot_longer(PLO:PCF, names_to = "station_short", values_to = "value") %>%
  mutate(
    value = if_else(value == -9999, NA_real_, value),
    type = "Measurements",
    measurement = "concentration",
    datetime = ymd_h(paste0(
      YYYY, sprintf("%02d", MM),
      sprintf("%02d", DD),
      sprintf("%02d", HH))),
    date = lubridate::date(datetime),
    hour = lubridate::hour(datetime)
  ) %>%
  inner_join(species, by = c("PARAMETER" = "fieldextra_taxon")) %>%
  inner_join(stations, by = c("station_short" = "hirst_station")) %>%
  select('taxon', 'station', 'date', 'hour', 'value', 'datetime', 'type', 'measurement')
}

#' Aggregate Hourly Data into Daily
#'
#' @param data Data Frame containing hourly concentrations

aggregate_pollen <- function(data) {
  data %>%
    group_by(taxon, station, date, type, measurement) %>%
    # Values are not averaged per hour but simply retrieved at every hour
    summarise(value = mean(value, na.rm = TRUE)) %>%
    ungroup() %>%
    mutate(
      hour = 0,
      # date = date + days(1), # Depends on the definition
      datetime = ymd_hm(paste0(
        as.character(date),
        paste0(sprintf("%02d", hour), ":00")
      ))
    )
}

#' Impute Hourly Data
#'
#' @param data Data Frame containing hourly concentrations

impute_hourly <- function(data) {
  data %>%
    filter(
      between(
        datetime,
        min(data_assim_hourly$datetime),
        max(data_assim_hourly$datetime)
      ),
      taxon == unique(data_assim_hourly$taxon)
    ) %>%
    pad(
      start_val = min(data_assim_hourly$datetime),
      end_val = max(data_assim_hourly$datetime),
      group = c("station", "taxon"),
      by = "datetime",
      break_above = 2
    ) %>%
    mutate(
      date = lubridate::date(datetime),
      hour = lubridate::hour(datetime),
      type = unique(data$type),
      measurement = "concentration",
      value = if_else(is.na(value), 0, value)
    )
}

#' Impute Daily Data
#'
#' @param data Data Frame containing daily concentrations

impute_daily <- function(data) {
  data %>%
    filter(
      between(
        datetime,
        min(data_assim_daily$datetime),
        max(data_assim_daily$datetime)
      ),
      taxon == unique(data_assim_daily$taxon)
    ) %>%
    pad(
      start_val = min(data_assim_daily$datetime),
      end_val = max(data_assim_daily$datetime),
      group = c("station", "taxon"),
      by = "datetime",
      break_above = 2
    ) %>%
    mutate(
      date = lubridate::date(datetime),
      hour = lubridate::hour(datetime),
      type = unique(data$type),
      measurement = "concentration",
      value = if_else(is.na(value), 0, value)
    )
}

#' Define a customized theme for ggplot
#'

my_maptheme <- function(...) {
  theme_minimal() +
    theme(
      text = element_text(
        family = "Verdana",
        color = "#22211d"
      ),
      # remove all axes
      axis.line = element_blank(),
      axis.text.x = element_blank(),
      axis.text.y = element_blank(),
      axis.ticks = element_blank(),
      # add a subtle grid
      panel.grid.major = element_line(color = "#dbdbd9", size = 0.2),
      panel.grid.minor = element_blank(),
      # background colors
      plot.background = element_rect(
        fill = "#f5f5f2",
        color = NA
      ),
      panel.background = element_rect(
        fill = "#f5f5f2",
        color = NA
      ),
      legend.background = element_rect(
        fill = "#f5f5f2",
        color = NA
      ),
      # borders and margins
      plot.margin = unit(c(.5, .5, .2, .5), "cm"),
      panel.border = element_blank(),
      panel.spacing = unit(c(-.1, 0.2, .2, 0.2), "cm"),
      # titles
      legend.title = element_text(size = 11),
      legend.text = element_text(
        size = 9, hjust = 0,
        color = "#22211d"
      ),
      plot.title = element_text(
        size = 15, hjust = 0.5,
        color = "#22211d"
      ),
      plot.subtitle = element_text(
        size = 10, hjust = 0.5,
        color = "#22211d",
        margin = margin(
          b = -0.1,
          t = -0.1,
          l = 2,
          unit = "cm"
        ),
        debug = F
      ),
      # captions
      plot.caption = element_text(
        size = 7,
        hjust = .5,
        margin = margin(
          t = 0.2,
          b = 0,
          unit = "cm"
        ),
        color = "#939184"
      ),
      ...
    )
}
