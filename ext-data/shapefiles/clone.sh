# Execute this script inside the /ext-data/shapefiles/ folder so retrieve the date
# This data is not freely available! DO NOT SHARE!
# Here is the blogpost
https://timogrossenbacher.ch/2016/12/beautiful-thematic-maps-with-ggplot2-only/


# Here is the code and data:
git clone git@github.com:grssnbchr/bivariate-maps-ggplot2-sf.git

# Copy the necessary files
cp bivariate-maps-ggplot2-sf/analysis/input/* ../../data/shapefiles/

# Remove the original git repo (we only needed the shapefiles)
rm -rf bivariate-maps-ggplot2-sf
rm ../../data/shapefiles/data.csv ../../data/shapefiles/scale.png