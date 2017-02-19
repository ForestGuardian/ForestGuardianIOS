/**
 * Created by luisalonsomurilloalonso on 11/12/16.
 */

 var attr_osm = 'Map data &copy; <a href="http://openstreetmap.org/">OpenStreetMap</a> contributors',
 attr_overpass = 'POI via <a href="http://www.overpass-api.de/">Overpass API</a>';
 var osm = new L.TileLayer('http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {opacity: 0.7, attribution: [attr_osm, attr_overpass].join(', ')});

 var map = new L.Map('map').addLayer(osm).setView(new L.LatLng(9.934739, -84.087502), 8);

 //OverPassAPI overlay
 var opl = new L.OverPassLayer({
   query: "node(BBOX)['amenity'='post_box'];out;",
 });

 map.addLayer(opl);
