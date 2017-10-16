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
    
    @IBOutlet weak var rootContainer: UIView!
    
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
