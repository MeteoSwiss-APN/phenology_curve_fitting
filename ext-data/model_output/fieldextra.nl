
&RunSpecification
strict_nl_parsing  = .true.
verbosity          = "moderate"
diagnostic_length  = 110
/

&GlobalResource
 dictionary           = "/oprusers/osm/opr.rh7.7/config/resources/dictionary_cosmo.txt"
 grib_definition_path = "/oprusers/osm/opr.rh7.7/config/resources/eccodes_definitions_cosmo",
                        "/oprusers/osm/opr.rh7.7/config/resources/eccodes_definitions_vendor"
location_list         = "/users/sadamov/RProjects/CHAPo/data/model_output/mylocation_list.txt"
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
in_file  = "/scratch/sadamov/wd/osm/20022500_c1e_tsa_alnus_osm/lm_coarse/laf2020022500"
out_type = "INCORE"
/
&Process in_field  = "FR_LAND" /
&Process in_field  = "HSURF  ", tag='HSURF' /


&Process
in_file  = "/scratch/sadamov/wd/osm/20022500_c1e_tsa_alnus_osm/lm_coarse/lfff00<HH>0000",
out_file = "mod_pollen.csv", 
tstart=0,
tstop=1,
tincr=1,
out_type = "XLS_TABLE",
out_type_separator='    ',
locgroup = "chall",           
/            

&Process in_field  = "ALNU", levlist=80 /

