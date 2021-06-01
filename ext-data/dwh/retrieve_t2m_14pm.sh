# This retrieves the surface temperature (t_2m) for ALNUS, BETULA and POACEAE for the years 2000-2020
# The daily maximum temperatures are retrieved at each pollen-station in CH and averaged over all years
# Running this script inside the /ext-data/dwh folder of the project prepares the data

# These are the Temperature stations closest to the Pollen stations:
# They are sorted by Abbr of the Pollen stations: PBE,PBS,PBU,PCF,PDS,PGE,PLO,PLS,PLU,PLZ,PMU,PNE,PVI,PZH

######## Network                                Ind Abbr Alt Name              SwissName
#----------------------------------------------------------------------------------------------
# 1.  Manuelle_Pollenstation_MeteoSchweiz      5523 PBE  551 Bern              Bern
# 1.  Automatische_Messstation_MeteoSchweiz    5520 BER  553 Bern / Zollikofen Zollikofen
# 2.  Automatische_Pollenstation_MeteoSchweiz  1943 PBS  256 Basel             Basel
# 2.  Automatische_Messstation_MeteoSchweiz    1940 BAS  316 Basel / Binningen Binningen
# 3.  Automatische_Pollenstation_MeteoSchweiz   863 PBU  446 Buchs SG          Buchs (SG)
# 3.  Automatische_Messstation_MeteoSchweiz     830 VAD  457 Vaduz             Vaduz
# 4.  Manuelle_Pollenstation_MeteoSchweiz      8547 PCF 1037 La Chaux-de-Fonds La Chaux-de-Fonds
# 4.  Automatische_Messstation_MeteoSchweiz    8545 CDF 1017 La Chaux-de-Fonds La Chaux-de-Fonds
# 5.  Manuelle_Pollenstation_MeteoSchweiz       437 PDS 1587 Davos-Wolfgang    Wolfgang
# 5.  Automatische_Messstation_MeteoSchweiz     460 DAV 1594 Davos             Davos
# 6.  Manuelle_Pollenstation_MeteoSchweiz      8391 PGE  382 Genève            Genève
# 6.  Automatische_Messstation_MeteoSchweiz    8440 GVE  411 Genève / Cointrin Genève
# 7.  Automatische_Pollenstation_MeteoSchweiz  9398 PLO  376 Locarno-Monti     Locarno
# 7.  Automatische_Messstation_MeteoSchweiz    9400 OTL  367 Locarno / Monti   Locarno
# 8.  Automatische_Pollenstation_MeteoSchweiz  8135 PLS  569 Lausanne          Lausanne
# 8.  Automatische_Messstation_MeteoSchweiz    8100 PUY  456 Pully             Pully
# 9.  Manuelle_Pollenstation_MeteoSchweiz      9479 PLU  275 Lugano            Lugano
# 9.  Automatische_Messstation_MeteoSchweiz    9480 LUG  273 Lugano            Lugano
# 10. Manuelle_Pollenstation_MeteoSchweiz      4593 PLZ  463 Luzern            Luzern
# 10. Automatische_Messstation_MeteoSchweiz    4590 LUZ  454 Luzern            Luzern
# 11. Manuelle_Pollenstation_MeteoSchweiz      1093 PMU  412 Münsterlingen     Münsterlingen
# 11. Automatische_Messstation_MeteoSchweiz    1080 GUT  440 Güttingen         Güttingen
# 12. Manuelle_Pollenstation_MeteoSchweiz      6337 PNE  489 Neuchâtel         Neuchâtel
# 12. Automatische_Messstation_MeteoSchweiz    6340 NEU  485 Neuchâtel         Neuchâtel
# 13. Manuelle_Pollenstation_MeteoSchweiz      7252 PVI  648 Visp              Visp
# 13. Automatische_Messstation_MeteoSchweiz    7255 VIS  639 Visp              Visp
# 14. Automatische_Pollenstation_MeteoSchweiz  3702 PZH  558 Zürich            Zürich
# 14. Automatische_Messstation_MeteoSchweiz    3700 SMA  556 Zürich / Fluntern Zürich

# This retrieves the hourly values for the same three species for the years 2019-2020
dwh_retrieve -s surface_stations -l 45,48,5,11 -i nat_abbr,BER,BAS,VAD,CDF,DAV,GVE,OTL,PUY,LUG,LUZ,GUT,NEU,VIS,SMA \
  -t 200001010000-202101010000 -f atab -p 212 -o t2m_dwh_daily.txt

# Separator should always be one blank and not multiple
sed -i 's/  */ /g' t2m_dwh_daily.txt

# Remove trailing blank at end of lines
sed -i 's/[[:blank:]]*$//' t2m_dwh_daily.txt

mv t2m_dwh_daily.txt ../../data/dwh/