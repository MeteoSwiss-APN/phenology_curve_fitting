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
  3. Clone this repository: `git clone https://github.com/sadamov/phenology_curve_fitting.git`
  4. Change into the newly cloned directory: `cd phenology_curve_fitting`
  5. Create a new conda environment: `conda env create -f environment.yml` (confirm with y, this will take a minute)
  6. Activate the new conda environment: `conda activate phenology_curve_fitting`
  7. Start the R-Console: `r`
  8. Install two additional R-Packages not available in conda: `install.packages("sicegar", "AeRobiology")` (this will also take a while)
  9.  Make the IRKernel available by executing: `IRkernel::installspec()`
  10. Close the R-Console: `q()`
  11. Start the Jupyter Notebook: `jupyter notebook` in the BASH terminal
  12. Navigate through the content in your browser webbrowser of choice (e.g. Firefox or Brave), by clicking on the link displayed in the terminal.
## Data

There is data required for this analysis. In the folder */ext-data* a script is stored
that will retrieve and preprocess the data from external sources. The ready-made data is
then stored in the */data* folder. The retrieval is only available within the MeteoSwiss
Network

- **dwh**: Text files of Pollen-Measurements (Concentrations 1/m^3) averaged daily.
  The data is retrieved with the ruby script dwh_retrieve().
