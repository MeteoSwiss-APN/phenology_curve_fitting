#!bin/bash
# Execute this script in its location in /ext-data/model_output/
# This script retrieves model output data using fieldextra from any supported grib-file
# Unless you are at MeteoSwiss this is probably not possible
# With the default settings hourly Alnus-Pollen concentrations at ground level are retrieved
date=20022300
path="/scratch/sadamov/wd/20_alnu_fit_sdes_all/${date}_c1e_tsa_alnu_fit_sdes_all/lm_coarse"
species="ALNU"

/bin/cat > pollen.nl <<EOM

&RunSpecification
strict_nl_parsing  = .true.
verbosity          = "moderate"
diagnostic_length  = 110
/

&GlobalResource
 dictionary           = "/oprusers/osm/opr.rh7.7/config/resources/dictionary_cosmo.txt"
 grib_definition_path = "/oprusers/osm/opr.rh7.7/config/resources/eccodes_definitions_cosmo",
                        "/oprusers/osm/opr.rh7.7/config/resources/eccodes_definitions_vendor"
location_list         = "./mylocation_list.txt"
/

&GlobalSettings
default_model_name    = "cosmo-1e"
location_to_gridpoint = "sn" 
/

&ModelSpecification
model_name         = "cosmo-1e"
earth_axis_large   = 6371229.
earth_axis_small   = 6371229.
/

&Process
in_file  = "${path}/laf20${date}"
out_type = "INCORE"
/
&Process in_field  = "FR_LAND" /
&Process in_field  = "HSURF  ", tag='HSURF' /


&Process
in_file  = "${path}/lfff00<HH>0000",
out_file = "mod_pollen.csv", 
tstart=5,
tstop=5,
tincr=1,
out_type = "XLS_TABLE",
out_type_separator=' ',
locgroup = "chall",           
/            

&Process in_field  = "${species}", levlist=80 /

EOM

## RUNNING FIELDEXTRA TO RETRIEVE DATA - CAN TAKE SEVERAL HOURS IF TOO MUCH DATA IS RETRIEVED
fieldextra pollen.nl

rm pollen.nl fieldextra.diagnostic # namelist is removed by default

sed -i '1,17d' mod_pollen.csv

mv mod_pollen.csv ../../data/model_output

