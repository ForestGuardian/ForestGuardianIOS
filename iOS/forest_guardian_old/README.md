# ForestGuardian

Forest Guardian is an application that handles the prediction and control of forest fires. This through obtaining information from maps based on MODIS data and apis NASA climate information to generate alerts. Also estimate the effects of a fire reported by users the of app.

This app was presented in the International Space Apps, Cartago, Costa Rica. The prototype of this project is developed on iOS 8 and was tested on the iPad Air. The information is taken from the NASA's MODIS database and the Costa Rica´s Atlas database.

As a *future work*, the implementation of Data Mining or Machine Learning, over all the data that the app has, would be processing in order to predict fire locations and allow the people that manage those fires to prepare themselves.

The following are the thid party libraries used for the prototype of this project:

1) [**MapBox**](https://www.mapbox.com/mapbox-ios-sdk/ "Mapbox - iOS SDK"): To implement the application maps; the services offered by cloud MapBox and MapBox Studio tool for styles of maps and editing layers is used.

2) [**Open Weather Map Api**](http://openweathermap.org/api "Open Weather Map - API"): To obtain some climate variables in real time, such as temperature, humidity, wind speed and direction.

3) [**Parse**](https://parse.com/ "Parse - Backend"): To implement the backend and store information and pictures of the reports.
