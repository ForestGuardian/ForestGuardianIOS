/**
 * Created by luisalonsomurilloalonso on 11/12/16.
 */

var mymap = L.map('map').setView([9.934739, -84.087502], 8);

L.tileLayer('https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token={accessToken}', {
    attribution: 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, Imagery © <a href="http://mapbox.com">Mapbox</a>',
    maxZoom: 16,
    id: 'mapbox.satellite',
    accessToken: 'pk.eyJ1IjoibHVtdXJpbGxvIiwiYSI6IlVRTlZkbFkifQ.nFkWwVMJm_5mUy-9ye65Og'
}).addTo(mymap);

mymap.locate({setView: true, maxZoom: 10});

var geojsonLayer = new L.GeoJSON.AJAX("http://forestdev6339.cloudapp.net/Leaflet/central_america.json");
geojsonLayer.addTo(mymap);

