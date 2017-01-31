/**
 * Created by luisalonsomurilloalonso on 11/12/16.
 */

var windytyInit = {
  // Required: API key
  key: 'pBEnvSWfnXaWpNC',

  // Optional: Initial state of the map
  lat: 9.934739,
  lon: -84.087502,
  zoom: 8,
};

function windytyMain(map) {
  var geojsonLayer = new L.GeoJSON.AJAX("http://forestdev6339.cloudapp.net/Leaflet/central_america.json");
  geojsonLayer.addTo(map);
}
