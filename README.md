# Overview

This readme document should give an overview of the project and its main components. For a full documentation of the newly developed pollen code to assimilate real-time pollen date into COSMO/ICON please refer to this confluence page: <https://service.meteoswiss.ch/confluence/x/dYQYBQ>

There is e second git-repo available here: <https://github.com/sadamov/cosmo.git> that contains the newly developed Fortran Subroutines to assimilate the real-time pollen data in COSMO/ICON.

This repository is used for additional work in R that was needed to write the Fortran Subroutines. The specific analyses are displayed below in the section *Vignettes*.

## Setup

The analysis was conducted in R 4.0.3.
The vignettes are Jupyter notebooks, as they can be run inside Sarus containers at CSCS.

The project is set up as a minimal R-package to assure maximum reproducibility (<https://r-pkgs.org/index.html>). It is using renv dependency management, for more info: <https://cran.r-project.org/web/packages/renv/vignettes/renv.html> To install all packages needed in your local R-environment simply run `renv::restore()` in your local clone of this git repo.

Packages installed by renv might depend on some shared libraries not available on the reader's system. For that reason I added the environment YAML file of my conda environment to this repo. Be aware that some libraries in there are not required for this project (it is the default env I use for R analyses). This command would install all libraries into a new conda environment called "new_env": `conda env create -n new_env -f environment.yml`

## Branches

There are two branches in this repo:

- Main: Protected main branch containing the latest fully functional version of all vignettes and scripts.
- Develop: Branch used to test out the latest code developments.

## Data

There is quite a lot of external data required for this analysis and only people working at MeteoSwiss will have access to all of it.
In the folder */ext-data* scripts are stored that will retrieve and preprocess the data from external sources. The ready-made data is then stored in the */data* folder and accessed by various scripts.

- **dwh**: Text files of Pollen-Measurements (Concentrations 1/m^3) averaged daily and hourly. Daily surface temperatures. The data is retrieved with the ruby script dwh_retrieve(). Used in various vignettes.
- **model_output**: Text file of Pollen Concentrations (1/m^3) predicted by COSMO for one specific hour. The data is retrieved with Fieldextra and used in the other_stuff vignette.
- **other**: Dataframes containing names and abbreviations of Swiss pollen stations and species. Manually typed (information available in various MeteoSwiss documentations) and used in various vignettes.
- **shapefiles**: Various shape files to display beautiful maps of Switzerland from here: <https://timogrossenbacher.ch/2016/12/beautiful-thematic-maps-with-ggplot2-only/> The data is used in the other_stuff vignette.

## Vignettes

- **architecture.drawio**: A schematic drawing of the data input/output, to be used in the confluence documentation.
- **fitting_the_curve**: Using historic pollen measurements to fit optimal double-sigmoid curve representing the season description of a species (phenology)
- **init.R**: As we are using jupyter notebooks, renv was not able to create a snapshot of all used packages. Hence I am adding the required libraries manually in this R-File. Let's hope they support jupyter soon.
- **initial_tuning**: Finding optimal starting values for the tuning factor, instead of constant values across the domain (not finished).
- **quick_map**: Draws a quick raster map of an netCDF file, ugly but fast.
- **season_animation**: Creates an animated GIF to display the changes in the season description curve in the model (phenology).
- **verification_multi_model**: Validates model output, creating all required plots and statistical metrics wo identify model weaknesses and strengths.
- **verification_single_model**: Collection of plots and maps to evaluate the output of one model versus the measurements.
