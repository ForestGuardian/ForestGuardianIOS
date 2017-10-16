//
//  MapViewController.swift
//  Guardian Forestal
//
//  Created by Luis Alonso Murillo Rojas on 8/10/17.
//  Copyright © 2017 Forest Guardian. All rights reserved.
//

import UIKit
import WebKit

class MapViewController: UIViewController, WKScriptMessageHandler {

    
    private var mapWebView: WKWebView?
    private var weatherState: Bool!
    private var windState: Bool!
    private var forestState: Bool!
    
    @IBOutlet weak var rootContainer: UIView!
    @IBOutlet weak var weatherButton: UIButton!
    @IBOutlet weak var windButton: UIButton!
    @IBOutlet weak var forestButton: UIButton!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Init the MapViewController views
        self.initView()
        
        //Set default values
        self.weatherState = false
        self.windState = true
        self.forestState = false
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
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if (message.name == "mobile") {
            
        }
    }
    
    @IBAction func onCurrentLocation(_ sender: Any) {
        NSLog("Clicking the current location button")
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
        NSLog("Clicking the search button")
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
