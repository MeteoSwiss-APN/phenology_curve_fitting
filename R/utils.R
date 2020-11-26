#' Create a Comparison Plot of Pollen Concentrations
#'
#' @param taxon The selected Pollen Type
#' @param station The selected Pollen Type
#' @param resolution Temporal resolution c("daily" or "hourly")
#' @param rm_zeros Should zero/NA pollen measurements be removed from the plot
#' @param combined Return the combined plots with title or seperate plots
#'
#' @return A list of ggplots or a combined ggplot


plot_comb <- function(data_plot,
                      taxon,
                      station,
                      resolution,
                      rm_zeros,
                      combined) {
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
    station
  ))

  alpha_plot <- 0.5

  gg1 <- data_plot %>%
    group_by(type, datetime) %>%
    summarise(value = mean(value)) %>%
    ungroup() %>%
    ggplot() +
    geom_line(aes(x = datetime, y = value, col = type, alpha = alpha_plot)) +
    scale_color_manual(values = swatch()[c(2, 4)]) +
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
    scale_fill_manual(values = swatch()[c(2, 4)]) +
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
    scale_fill_manual(values = swatch()[c(2, 4)]) +
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
  myheader <- c("dummy" = 9)
  names(myheader) <- paste(title)

  data %>%
    select(-metric) %>%
    mutate(value = round(value)) %>%
    pivot_wider(names_from = taxon, values_from = value) %>%
    pivot_wider(names_from = type, values_from = Alnus:Poaceae) %>%
    setNames(c("Station", rep(c("Cosmo", "Hirst"), times = 4))) %>%
    kable() %>%
    kable_styling("striped", full_width = FALSE) %>%
    add_header_above(c(
      " " = 1,
      "Alnus" = 2,
      "Ambrosia" = 2,
      "Betula" = 2,
      "Poaceae" = 2
    )) %>%
    add_header_above(myheader, font_size = 18)
}
