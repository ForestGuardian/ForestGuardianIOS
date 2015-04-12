//
//  ViewController.m
//  Forest Guardian
//
//  Created by Luis Alonso Murillo Rojas on 11/4/15.
//  Copyright (c) 2015 TEC. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self drawMapLayer];
    [self setUpGesture];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setUpGesture
{
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    [tapRecognizer setNumberOfTapsRequired:1];
    [self.mapView addGestureRecognizer:tapRecognizer];
}

-(IBAction) handleTapGesture:(UIGestureRecognizer *) sender {
    CGPoint tapPoint = [sender locationInView:self.mapView];
    NSLog(@"You tapped at %f, %f",
          [self.mapView pixelToCoordinate:tapPoint].latitude,
          [self.mapView pixelToCoordinate:tapPoint].longitude);
}

- (void) setUpLocation
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    if ([self.locationManager respondsToSelector:@selector
         (requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    _location = [locations lastObject];
    NSLog(@"location info object=%@", [locations lastObject]);
}

- (void) drawMapLayer
{
    [[RMConfiguration sharedInstance] setAccessToken:@"pk.eyJ1IjoiZW1tYW1tMDUiLCJhIjoiM1ZBVExhOCJ9.0uVTeXUebK-S6oBTFpCMmQ"];
    
    RMMapboxSource *tileSource = [[RMMapboxSource alloc]
                                  initWithMapID:@"mapbox.light"];
    
    // set coordinates
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(_location.coordinate.latitude,
                                                               _location.coordinate.longitude);
    
    self.mapView = [[RMMapView alloc] initWithFrame:self.view.bounds
                                      andTilesource:tileSource];
    
    // make map expand to fill screen when rotated
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleHeight |
    UIViewAutoresizingFlexibleWidth;
    
    // set zoom
    self.mapView.zoom = 3;
    
    // center the map to the coordinates
    self.mapView.centerCoordinate = center;
    
    [self.mapView addTileSource:[[RMMapboxSource alloc]
                                 initWithMapID:@"emmamm05.7586db7d"]];
    
    [self.view addSubview:self.mapView];
}


- (IBAction)returnFromReportFeed:(UIStoryboardSegue*)sender
{}


@end
