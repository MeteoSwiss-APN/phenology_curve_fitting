# This retrieves the daily data for ALNUS, BETULA and POACEAE,CORYLUS for the years 2000-2021
# Running this script inside the /ext-data/dwh folder of the project prepares the data
# This only works within the MeteoSwiss Network

module purge

# # The UTC 0-0 values are only available from 2017 onwards, hence local time are retrieved
dwh_retrieve -s surface_stations -l 45,48,5,11 -i nat_abbr,PBE,PBS,PBU,PCF,PDS,PGE,PLO,PLS,PLU,PLZ,PMU,PNE,PVI,PZH \
  -t 200001010000-202107010000 -f atab -p 1315,1323,1469,1343 -o pollen_dwh_daily.txt

# Separator should always be one blank and not multiple
sed -i 's/  */ /g' pollen_dwh_daily.txt

# Remove trailing blank at end of lines
sed -i 's/[[:blank:]]*$//' pollen_dwh_daily.txt

mv pollen_dwh_daily.txt ../../data/dwh/
