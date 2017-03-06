/**
 * Created by luisalonsomurilloalonso on 11/12/16.
 */

 var attr_osm = 'Map data &copy; <a href="http://openstreetmap.org/">OpenStreetMap</a> contributors',
   attr_overpass = 'POI via <a href="http://www.overpass-api.de/">Overpass API</a>';
 var osm = new L.TileLayer('http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {opacity: 0.7, attribution: [attr_osm, attr_overpass].join(', ')});
 var map = new L.Map('map').addLayer(osm).setView(L.latLng(27.6648274, -81.51575350000002), 8);

//Global variables
var currentFireCoordinates = null;

 var fireIcon = L.icon({
     iconUrl: 'fire.png',
     iconSize:     [32, 37],
     iconAnchor:   [16, 36]
 });

 function onEachFeature(feature, layer) {
     layer.setIcon(fireIcon);
     layer.on('click', function (e) {
       map.setView(e.latlng, 13);
       currentFireCoordinates = L.latLng(e.latlng.lat, e.latlng.lng);
    });
 }

 function setUserCurrentLocation(latitude, longitude) {
   console.log("lat = " + latitude + ", long = " + longitude);
   map.setView(L.latLng(latitude, longitude), 8);
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
