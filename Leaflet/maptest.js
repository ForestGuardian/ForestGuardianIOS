/**
 * Created by luisalonsomurilloalonso on 11/12/16.
 */

 var attr_osm = 'Map data &copy; <a href="http://openstreetmap.org/">OpenStreetMap</a> contributors',
   attr_overpass = 'POI via <a href="http://www.overpass-api.de/">Overpass API</a>';
 var osm = new L.TileLayer('http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {opacity: 0.7, attribution: [attr_osm, attr_overpass].join(', ')});
 var map = new L.Map('map').addLayer(osm).setView(new L.LatLng(9.934739, -84.087502), 8);
 //OverPassAPI overlay
 var opl = new L.OverPassLayer({
   endpoint: "http://overpass.osm.rambler.ru/cgi/",
   query: "node(BBOX)['amenity'='fire_station'];out;",
   callback: function(data) {
     for(var i=0;i<data.elements.length;i++) {
       var e = data.elements[i];
       if (e.id in this.instance._ids) return;
       this.instance._ids[e.id] = true;
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
     }
   }
 });
 map.addLayer(opl);

 var opl2 = new L.OverPassLayer({
   endpoint: "http://overpass.osm.rambler.ru/cgi/",
   query: "way(BBOX)['waterway'='river'];out;",
   debug: true,
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

 var geojsonLayer = new L.GeoJSON.AJAX("http://forestdev6339.cloudapp.net/Leaflet/central_america.json", {
   middleware:function(data){
     return L.geoJson(data, {
       onEachFeature: function (feature, layer) {
         layer.setIcon(fireIcon);
       }
     }).addTo(map);
   }
 });
 geojsonLayer.addTo(map);
