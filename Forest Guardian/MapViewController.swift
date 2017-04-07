//
//  MapViewController.swift
//  Forest Guardian
//
//  Created by Luis Alonso Murillo Rojas on 2/7/16.
//  Copyright © 2016 ForestGuardian. All rights reserved.
//

import UIKit
import Mapbox

class MapViewController: UIViewController {
    
    @IBOutlet weak var GeneralMap: MGLMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set the access token
        MGLAccountManager.setAccessToken("pk.eyJ1IjoibHVtdXJpbGxvIiwiYSI6IlVRTlZkbFkifQ.nFkWwVMJm_5mUy-9ye65Og");
        GeneralMap.styleURL = NSURL(string: "mapbox://styles/lumurillo/cikw0v5qo00dx9flxwfm4rbnd");
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}