//
//  ViewController.h
//  Forest Guardian
//
//  Created by Luis Alonso Murillo Rojas on 11/4/15.
//  Copyright (c) 2015 TEC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Mapbox.h"
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController <CLLocationManagerDelegate>

@property (nonatomic, strong) RMMapView *mapView;
@property (strong, nonatomic) CLLocation *location;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;

@end

