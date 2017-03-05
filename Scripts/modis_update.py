#!/usr/bin/python
import os
import time

while True:
    #Downlad the modis data
    os.system("wget https://firms.modaps.eosdis.nasa.gov/active_fire/c6/shapes/zips/MODIS_C6_Central_America_24h.zip --no-check-certificate")

    #Unzip the modis data package
    os.system("unzip MODIS_C6_Central_America_24h.zip -d ~/")

    #Convert from shapefile to geojson
    os.system("ogr2ogr -f GeoJSON central_america.json MODIS_C6_Central_America_24h.shp")

    #Delete the old MODIS data
    os.system("rm ~/ROOT/Leaflet/central_america.json")

    #Place the new MODIS data
    os.system("mv central_america.json ~/ROOT/Leaflet/")

    #Clean up
    os.system("rm MODIS_C6_Central_America_24h.dbf MODIS_C6_Central_America_24h.shp MODIS_C6_Central_America_24h.shx MODIS_C6_Central_America_24h.zip")

    #Sleep of 24 hours
    time.sleep(3600)
