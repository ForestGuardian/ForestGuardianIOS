/**
 * Created by luisalonsomurilloalonso on 11/12/16.
 */

 var attr_osm = 'Map data &copy; <a href="http://openstreetmap.org/">OpenStreetMap</a> contributors',
   attr_overpass = 'POI via <a href="http://www.overpass-api.de/">Overpass API</a>';
 var osm = new L.TileLayer('http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {opacity: 0.7, attribution: [attr_osm, attr_overpass].join(', ')});
 var map = new L.Map('map').addLayer(osm).setView(new L.LatLng(9.934739, -84.087502), 8);

//Global variables
var currentFireCoordinates = null;
var routeLayer = null;
var isRouter = false;

 //OverPassAPI overlay
 /* Getting the data of the fire stations */
 var opl = new L.OverPassLayer({
   endpoint: "http://overpass.osm.rambler.ru/cgi/",
   query: "node(BBOX)['amenity'='fire_station'];out;",
   debug: true,
   minzoom: 13,
   callback: function(data) {
     for(var i=0;i<data.elements.length;i++) {
       var e = data.elements[i];
       console.log(e.tags.name);
       if (e.id in this.instance._ids) return;
       this.instance._ids[e.id] = true;

       /*Add the marker to the map*/
       var pos = new L.LatLng(e.lat, e.lon);
       var popup = this.instance._poiInfo(e.tags,e.id);
       var color = e.tags.collection_times ? 'green':'red';
       var circle = L.circle(pos, 50, {
         color: color,
         fillColor: '#fa3',
         fillOpacity: 0.5
       })
       .bindPopup(popup);
       this.instance.addLayer(circle);

       /* Check if there is a route */
       if (routeLayer != null && !isRouter) {
         console.log("Trying to remove the old route");
         map.removeLayer(routeLayer);
         routeLayer = null;
       }

       /* Check if there is a fire selected */
       if (currentFireCoordinates != null && !isRouter) {
        routeLayer =  L.Routing.control({
            waypoints: [
                pos,
                currentFireCoordinates
            ],
            routeWhileDragging: true
        });
        routeLayer.addTo(map);
        isRouter = true;
       }
     }
   }
 });
 map.addLayer(opl);

/* Getting the data of the different water resources */
 var opl2 = new L.OverPassLayer({
   endpoint: "http://overpass.osm.rambler.ru/cgi/",
   query: "way(BBOX)['waterway'='river'];out;",
   debug: false,
   callback: function(data) {
     for(var i=0;i<data.elements.length;i++) {
       var e = data.elements[i];
       if (e.id in this.instance._ids) return;
       this.instance._ids[e.id] = true;
       console.log(e.tags.name);
     }
   }
 });
 map.addLayer(opl2);

 var fireIcon = L.icon({
     iconUrl: 'fire.png',
     iconSize:     [32, 37],
     iconAnchor:   [16, 36]
 });

 function onEachFeature(feature, layer) {
     layer.setIcon(fireIcon);
     layer.on('click', function (e) {
       // Data is located in: e.layer.feature...
       //console.log(e);
       //map.setZoom(15);
       //map.setView(e.latlng);
       map.setView(e.latlng, 13);
       currentFireCoordinates = L.latLng(e.latlng.lat, e.latlng.lng);
       isRouter = false;
    });
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
