/**
 * Created by luisalonsomurilloalonso on 11/12/16.
 */

 var attr_osm = 'Map data &copy; <a href="http://openstreetmap.org/">OpenStreetMap</a> contributors',
   attr_overpass = 'POI via <a href="http://www.overpass-api.de/">Overpass API</a>';
 var osm = new L.TileLayer('http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {opacity: 0.7, attribution: [attr_osm, attr_overpass].join(', ')});
 var map = new L.Map('map').addLayer(osm).setView(L.latLng(10.07568504578726, -84.31182861328125), 8);

//Global variables
var currentFireCoordinates = null;

 var fireIcon = L.icon({
     iconUrl: 'fire.png',
     iconSize:     [32, 37],
     iconAnchor:   [16, 36],
     popupAnchor:  [0, -37]
 });

 function onEachFeature(feature, layer) {
     layer.setIcon(fireIcon);
     if (feature.properties) {
       var link = '<br><a href="javascript:displayWildfiresDetails('
                  + feature.properties.LATITUDE + ','
                  + feature.properties.LONGITUDE + ','
                  + feature.properties.BRIGHTNESS + ','
                  + feature.properties.SCAN + ','
                  + feature.properties.TRACK + ','
                  + '\'' + feature.properties.ACQ_DATE + '\','
                  + '\'' + feature.properties.ACQ_TIME + '\','
                  + '\'' + feature.properties.SATELLITE + '\','
                  + feature.properties.CONFIDENCE + ','
                  + '\'' + feature.properties.VERSION + '\','
                  + feature.properties.BRIGHT_T31 + ','
                  + feature.properties.FRP + ','
                  + '\'' + feature.properties.DAYNIGHT + '\''
                  + ');">Details</a>';

       layer.bindPopup("<b>Wildfire point</b>"
                      + "<br>BRIGHTNESS: " + feature.properties.BRIGHTNESS
                      + "<br>DATE: " + feature.properties.ACQ_DATE
                      + "<br>TIME: " + feature.properties.ACQ_TIME
                      + "<br>SATELLITE: " + feature.properties.SATELLITE
                      + link);
     }
     layer.on('click', function (e) {
       map.setView(e.latlng, 13);
       currentFireCoordinates = L.latLng(e.latlng.lat, e.latlng.lng);
    });
 }

 function displayWildfiresDetails(lat, lng, brightness, scan, track, date, time, satellite, confidence, version, bright_t31, frp, daynight) {
   var jsonMODIS = {"LATITUDE":lat,
                    "LONGITUDE":lng,
                    "BRIGHTNESS":brightness,
                    "SCAN":scan,
                    "TRACK":track,
                    "ACQ_DATE":date,
                    "ACQ_TIME":time,
                    "SATELLITE":satellite,
                    "CONFIDENCE":confidence,
                    "VERSION":version,
                    "BRIGHT_T31":bright_t31,
                    "FRP":frp,
                    "DAYNIGHT":daynight};
   console.log(JSON.stringify(jsonMODIS));
   try {
     mobile.getMODISData(JSON.stringify(jsonMODIS));
   } catch(err) {
     console.log("Error trying to invoke mobile method");
   }
 }

 function setUserCurrentLocation(latitude, longitude) {
   map.setView(L.latLng(latitude, longitude), 8);
   try {
     mobile.notifyCurrentLocation();
   } catch (err) {
     console.log("Error trying to invoke mobile method");
   }
 }

 var geojsonLayer = new L.GeoJSON.AJAX("http://forestdev6339.cloudapp.net/Leaflet/central_america.json", {
    onEachFeature: onEachFeature
});
 geojsonLayer.addTo(map);

 /*L.Routing.control({
    waypoints: [
        L.latLng(10.07568504578726, -84.31182861328125),
        L.latLng(10.032393450810494, -84.29382562637329)
    ],
    routeWhileDragging: true
}).addTo(map);*/
