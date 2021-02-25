# This retrieves the daily data for ALNUS, BETULA and POACEAE for the years 2017-2020
# The UTC 0-0 values are only available from 2017 onwards, hence local time are retrieved
# dwh_retrieve -s surface_stations -l 45,48,5,11 -i nat_abbr,PBE,PBS,PBU,PCF,PDS,PGE,PLO,PLS,PLU,PLZ,PMU,PNE,PVI,PZH -t 201701010000-202101010000 -f atab -p 4839,4837,4870 -o pollen_dwh_daily.txt
dwh_retrieve -s surface_stations -l 45,48,5,11 -i nat_abbr,PBE,PBS,PBU,PCF,PDS,PGE,PLO,PLS,PLU,PLZ,PMU,PNE,PVI,PZH -t 200001010000-202101010000 -f atab -p 1315,1323,1469 -o pollen_dwh_daily.txt
# This retrieves the hourly values for the same three species for the years 2019-2020
dwh_retrieve -s surface_stations -l 45,48,5,11 -i nat_abbr,PBE,PBS,PBU,PCF,PDS,PGE,PLO,PLS,PLU,PLZ,PMU,PNE,PVI,PZH -t 201901010000-202101010000 -f atab -p 5993,6086,5994 -o pollen_dwh_hourly.txt

# Afterwards read the textfiles with the package of your choice. I saved the data as Rdata to save space.