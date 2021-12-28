# Overview

In the jupyter notebook in the vignette folder, phenology curves are fitted
to historic pollen measurements. By default measurements from 2000-2020 are considered.
With the AeRobiology package, species specific season start and end are calculated.
The sums of all years and median of all stations is then used to fit a double sigmoidal curve,
using the sicegar package.

## Setup

The whole analysis is carried out in a Jupyter Notebook (https://jupyter.org/).
For maximum reproducibility all required dependencies are neatly organized in a conda
environment file (https://docs.conda.io/en/latest/).

The setup works as follow:

  1. Open a terminal
  2. If not already installed, please install miniconda (https://docs.conda.io/projects/conda/en/latest/user-guide/install/linux.html)
  3. Clone this repository: `

## Data

There is quite a lot of external data required for this analysis and only people working
at MeteoSwiss will have access to all of it. In the folder */ext-data* scripts are stored
that will retrieve and preprocess the data from external sources. The ready-made data is
then stored in the */data* folder and accessed by various scripts.

- **dwh**: Text files of Pollen-Measurements (Concentrations 1/m^3) averaged daily.
  The data is retrieved with the ruby script dwh_retrieve(). Used in various vignettes.
