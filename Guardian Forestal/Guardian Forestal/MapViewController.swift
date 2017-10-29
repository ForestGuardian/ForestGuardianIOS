//
//  MapViewController.swift
//  Guardian Forestal
//
//  Created by Luis Alonso Murillo Rojas on 8/10/17.
//  Copyright © 2017 Forest Guardian. All rights reserved.
//

import UIKit
import WebKit
import SwiftLocation
import CoreLocation
import MapboxGeocoder
import ModernSearchBar

class MapViewController: UIViewController, WKScriptMessageHandler, ModernSearchBarDelegate {

    
    private var mapWebView: WKWebView?
    private var weatherState: Bool!
    private var windState: Bool!
    private var forestState: Bool!
    private var geocoder: Geocoder!
    private var isSearchOpen: Bool!
    private var isCurrentLocationSet: Bool!
    private var currentLocation: CLLocation! {
        didSet {
            //self.changeLocation(location: self.currentLocation)
        }
    }
    
    @IBOutlet weak var topContainer: UIView!
    @IBOutlet weak var rootContainer: UIView!
    @IBOutlet weak var weatherButton: UIButton!
    @IBOutlet weak var windButton: UIButton!
    @IBOutlet weak var forestButton: UIButton!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var modernSearchBar: ModernSearchBar!
    
    override func loadView() {
         super.loadView()
        
        let contentController = WKUserContentController()
        contentController.add(
            self,
            name: "mobile"
        )
        
        let config = WKWebViewConfiguration()
        config.userContentController = contentController
        
        self.mapWebView = WKWebView(
            frame: self.rootContainer.bounds,
            configuration: config
        )
        self.rootContainer.addSubview(self.mapWebView!)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Init the location configuration
        self.initLocation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Init the MapViewController views
        self.initView()
        self.initSearchBar()
        
        //Set default values
        self.weatherState = false
        self.windState = true
        self.forestState = false
        self.isSearchOpen = false
        self.isCurrentLocationSet = false
        //self.currentLocation = CLLocation()
        self.geocoder = Geocoder(accessToken: "pk.eyJ1IjoibHVtdXJpbGxvIiwiYSI6IlVRTlZkbFkifQ.nFkWwVMJm_5mUy-9ye65Og")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func initView() {
        // Setup the WebView
        let url = URL(string: "http://app.forestguardian.org/maps/windy")
        let request = URLRequest(url: url!)
        self.mapWebView?.load(request)
    }
    
    private func initLocation() {
        let x = Location.getLocation(accuracy: .room, frequency: .continuous, timeout: 60*60*5, cancelOnError: true, success: { (_, location) -> (Void) in
            self.currentLocation = location
        }) { (request, last, error) -> (Void) in
            print("Location monitoring failed due to an error \(error)")
            request.cancel()
        }
        x.register(observer: LocObserver.onAuthDidChange(.main, { (request, oldAuth, newAuth) -> (Void) in
            print("Authorization moved from '\(oldAuth)' to '\(newAuth)'")
        }))
        
        Location.onReceiveNewLocation = {location in
            self.currentLocation = location
            
            // Set the current address
            if (!self.isCurrentLocationSet) {
                self.isCurrentLocationSet = true
                self.setLocationAddress()
            }
        }
    }
    
    private func initSearchBar() {
        self.modernSearchBar.delegateModernSearchBar = self
        self.modernSearchBar.showsCancelButton = true
        self.modernSearchBar.shadowView_alpha = 0
    }
    
    func onClickItemWithUrlSuggestionsView(item: ModernSearchBarModel) {
        let coordinatesStrings = item.url.description.components(separatedBy: ",")
        let lat = Double(coordinatesStrings[0])
        let lon = Double(coordinatesStrings[1])
        self.changeLocation(location: CLLocation(latitude: lat!, longitude: lon!))
        
        // Close the search bar
        self.isSearchOpen = false
        self.modernSearchBar.isHidden = true
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func onClickShadowView(shadowView: UIView) {
        print("User click the shadow")
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("Searching: " + searchText)
        self.getLocationPoints(locationQuery: searchText)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print("Searching: " + searchBar.text!)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.isSearchOpen = false
        self.modernSearchBar.isHidden = true
        self.topContainer.isHidden = true
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func getLocationPoints(locationQuery: String) {
        let options = ForwardGeocodeOptions(query: locationQuery)
        //options.allowedScopes = [.address, .pointOfInterest]
        
        _ = geocoder.geocode(options) { (placemarks, attribution, error) in
            if ((placemarks?.first) == nil) {
                return
            }
            
            var suggestionListWithUrl = Array<ModernSearchBarModel>()
            for place in placemarks! {
                let lat = Double(place.location.coordinate.latitude)
                let lon = Double(place.location.coordinate.longitude)
                
                suggestionListWithUrl.append(ModernSearchBarModel(title: place.name, url: "" + String(lat) + "," + String(lon)))
            }
            self.modernSearchBar.setDatasWithUrl(datas: suggestionListWithUrl)
        }
    }
    
    private func setLocationAddress() {
        let options = ReverseGeocodeOptions(coordinate: CLLocationCoordinate2D(latitude: self.currentLocation.coordinate.latitude, longitude: self.currentLocation.coordinate.longitude))
        
        _ = geocoder.geocode(options) { (placemarks, attribution, error) in
            guard let placemark = placemarks?.first else {
                return
            }
            
            let street: String = placemark.addressDictionary?[AnyHashable("street")] as! String
            let city: String = placemark.addressDictionary?[AnyHashable("city")] as! String
            let state: String = placemark.addressDictionary?[AnyHashable("state")] as! String
            let country: String = placemark.addressDictionary?[AnyHashable("country")] as! String
            let address: String = street + ", " + city + ", " + state + ", " + country
            
            self.addressLabel.text = address
        }
    }
    
    private func changeLocation( location: CLLocation) {
        let lat: Double = Double(location.coordinate.latitude)
        let lon: Double = Double(location.coordinate.longitude)
        let setLocation: String = "setUserCurrentLocation(" + String(lat) + ", " + String(lon) + ")"
        
        NSLog("Lat: %f, Lon: %f", self.currentLocation.coordinate.latitude, self.currentLocation.coordinate.longitude)
        self.mapWebView?.evaluateJavaScript(setLocation, completionHandler: nil)
        self.mapWebView?.evaluateJavaScript("moveToUserCurrentLocation()", completionHandler: nil)
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if (message.name == "mobile") {
            
        }
    }
    
    @IBAction func onCurrentLocation(_ sender: Any) {
        self.changeLocation(location: self.currentLocation)
    }
    
    @IBAction func onRainLayer(_ sender: Any) {
        if (self.weatherState) {
            self.weatherState = false
            self.weatherButton.setBackgroundImage(UIImage(named: "rain_off_icon"), for: UIControlState.normal)
            self.mapWebView?.evaluateJavaScript("hideWeatherLayer()", completionHandler: nil)
        } else {
            self.weatherState = true
            self.weatherButton.setBackgroundImage(UIImage(named: "rain_on_icon"), for: UIControlState.normal)
            self.mapWebView?.evaluateJavaScript("showWeatherLayer()", completionHandler: nil)
        }
    }
    
    @IBAction func onWindLayer(_ sender: Any) {
        if (self.windState) {
            self.windState = false
            self.windButton.setBackgroundImage(UIImage(named: "wind_off_icon"), for: UIControlState.normal)
            self.mapWebView?.evaluateJavaScript("hideWindsLayer()", completionHandler: nil)
        } else {
            self.windState = true
            self.windButton.setBackgroundImage(UIImage(named: "wind_on_icon"), for: UIControlState.normal)
            self.mapWebView?.evaluateJavaScript("showWindsLayer()", completionHandler: nil)
        }
    }
    
    @IBAction func onForestLayer(_ sender: Any) {
        if (self.forestState) {
            self.forestState = false
            self.forestButton.setBackgroundImage(UIImage(named: "forest_off_icon"), for: UIControlState.normal)
            self.mapWebView?.evaluateJavaScript("hideForestLayer()", completionHandler: nil)
        } else {
            self.forestState = true
            self.forestButton.setBackgroundImage(UIImage(named: "forest_on_icon"), for: UIControlState.normal)
            self.mapWebView?.evaluateJavaScript("showForestLayer()", completionHandler: nil)
        }
    }
    
    @IBAction func onSearch(_ sender: Any) {
        if (self.isSearchOpen) {
            self.isSearchOpen = false
            self.modernSearchBar.isHidden = true
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        } else {
            self.isSearchOpen = true
            self.modernSearchBar.isHidden = false
            self.modernSearchBar.becomeFirstResponder()
            self.topContainer.isHidden = false
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
