//
//  ViewController.m
//  Forest Guardian
//
//  Created by Luis Alonso Murillo Rojas on 11/4/15.
//  Copyright (c) 2015 TEC. All rights reserved.
//

#import "ViewController.h"
#import "Tiempo.h"


@interface ViewController ()

@property(nonatomic,strong) BZFoursquareRequest *request;
@property(nonatomic,copy) NSDictionary *meta;
@property(nonatomic,copy) NSArray *notifications;
@property(nonatomic,copy) NSDictionary *response;

@property (nonatomic) BOOL center;
@property (nonatomic) BOOL state;

@property (weak, nonatomic) IBOutlet UIView *mainContainer;
@property (weak, nonatomic) IBOutlet UISearchBar *placesSearch;
@property (weak, nonatomic) IBOutlet UITableView *tableResults;

@property (weak, nonatomic) IBOutlet UILabel *lat_longLabel;
@property (weak, nonatomic) IBOutlet UILabel *tempLabel;

@property (weak, nonatomic) IBOutlet UIImageView *alertSymbol;

@property (strong, nonatomic) NSMutableArray *placesList;

@end

@implementation ViewController

//- (id)init
//{
//    self = [super init];
//    if (self) {
//        self.foursquare = [[BZFoursquare alloc] initWithClientID:@"CRCWPLE13BPWDCBKNXA0AAYFOTN3UDRKHM2ZIIVYIVR1HFHU" callbackURL:@"forest-guardian://foursquare"];
//        _foursquare.version = @"20120609";
//        _foursquare.locale = [[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode];
//        _foursquare.sessionDelegate = self;
//    }
//    return self;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.foursquare = [[BZFoursquare alloc] initWithClientID:@"CRCWPLE13BPWDCBKNXA0AAYFOTN3UDRKHM2ZIIVYIVR1HFHU" callbackURL:@"forest-guardian://foursquare"];
    _foursquare.version = @"20120609";
    _foursquare.locale = [[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode];
    _foursquare.sessionDelegate = self;
    
    _center = NO;
    _state = NO;
    
    _placesList = [[NSMutableArray alloc] init];
    
    [_tableResults setDelegate:self];
    [_tableResults setDataSource:self];
    
    [self setUpLocation];
    [self drawMapLayer];
    [self setUpGesture];
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(animationToAlertSymbol) userInfo:nil repeats:YES];
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    [runLoop addTimer:timer forMode:NSDefaultRunLoopMode];
    
    //[self animationOfAlert];
    
    //[self searchVenues:@"A" withPositions:CLLocationCoordinate2DMake(-77.032458, 38.913175)];

}

- (void)animationOfAlert
{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(animationToAlertSymbol) userInfo:nil repeats:YES];
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    [runLoop addTimer:timer forMode:NSDefaultRunLoopMode];
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
    [self.lat_longLabel setText:[NSString stringWithFormat:@"%f,%f", [self.mapView pixelToCoordinate:tapPoint].latitude, [self.mapView pixelToCoordinate:tapPoint].longitude]];
    
    int alert = arc4random_uniform(3) + 1;
    NSString *image = [NSString stringWithFormat:@"%i_alert.png", alert];
    [self.alertSymbol setImage:[UIImage imageNamed:image]];
    //[self animationOfAlert];
    
//    Tiempo *hotSpot = [[Tiempo alloc] init];
//    
//    CLLocationDegrees latitude = [self.mapView pixelToCoordinate:tapPoint].latitude;
//    CLLocationDegrees longitude = [self.mapView pixelToCoordinate:tapPoint].longitude;
//    
//    [hotSpot buildTimeof:CLLocationCoordinate2DMake(latitude,longitude) :^(Tiempo *responseObject, NSError *error) {
//        if (!error) {
//            NSLog(@"Tiempo: %@", responseObject.temp);
//        }
//    }];
    
    bool willShow = true;
    for (UIView *subview in self.view.subviews) {    // UIView.subviews
        if (subview.tag == 555) {
            [subview removeFromSuperview];
            willShow = false;
            
        }
    }
    if (willShow){
        [self drawFireLine:CGPointMake(tapPoint.x, tapPoint.y) withangle:-M_PI_2];
        [self drawFireLine:CGPointMake(tapPoint.x, tapPoint.y+150) withangle:-M_PI_2];
        [self drawFireLine:CGPointMake(tapPoint.x, tapPoint.y+300) withangle:-M_PI_2];
        
        [self drawFireLine:CGPointMake(tapPoint.x+20, tapPoint.y) withangle:-M_PI_2];
        [self drawFireLine:CGPointMake(tapPoint.x+20, tapPoint.y+150) withangle:-M_PI_2];
        [self drawFireLine:CGPointMake(tapPoint.x+40, tapPoint.y+300) withangle:-M_PI_2-0.25];
        
        [self drawFireLine:CGPointMake(tapPoint.x-20, tapPoint.y) withangle:-M_PI_2];
        [self drawFireLine:CGPointMake(tapPoint.x-20, tapPoint.y+150) withangle:-M_PI_2];
        [self drawFireLine:CGPointMake(tapPoint.x-40, tapPoint.y+300) withangle:-M_PI_2+0.25];
        
        [self drawLine:CGPointMake(tapPoint.x+60, tapPoint.y) withangle:-M_PI_2];
        [self drawLine:CGPointMake(tapPoint.x+60, tapPoint.y+150) withangle:-M_PI_2];
        [self drawLine:CGPointMake(tapPoint.x+65, tapPoint.y+300) withangle:-M_PI_2];
        
        [self drawLine:CGPointMake(tapPoint.x+80, tapPoint.y) withangle:-M_PI_2];
        [self drawLine:CGPointMake(tapPoint.x+80, tapPoint.y+150) withangle:-M_PI_2];
        [self drawLine:CGPointMake(tapPoint.x+85, tapPoint.y+300) withangle:-M_PI_2];
        
        [self drawLine:CGPointMake(tapPoint.x-60, tapPoint.y) withangle:-M_PI_2];
        [self drawLine:CGPointMake(tapPoint.x-60, tapPoint.y+150) withangle:-M_PI_2];
        [self drawLine:CGPointMake(tapPoint.x-65, tapPoint.y+300) withangle:-M_PI_2];
        
        [self drawLine:CGPointMake(tapPoint.x-80, tapPoint.y) withangle:-M_PI_2];
        [self drawLine:CGPointMake(tapPoint.x-80, tapPoint.y+150) withangle:-M_PI_2];
        [self drawLine:CGPointMake(tapPoint.x-85, tapPoint.y+300) withangle:-M_PI_2];
    }
}


-(void) drawLine: (CGPoint)point withangle:(CGFloat)degree{
    UIImageView* animatedImageView = [[UIImageView alloc] init];
    animatedImageView.animationImages = [NSArray arrayWithObjects:
                                         [UIImage imageNamed:@"flecha1.png"],
                                         [UIImage imageNamed:@"flecha2.png"],
                                         [UIImage imageNamed:@"flecha3.png"], nil];
    animatedImageView.animationDuration = 1.0f;
    animatedImageView.animationRepeatCount = 0;
    [animatedImageView startAnimating];
    animatedImageView.center = point;
    [self.view addSubview: animatedImageView];
    animatedImageView.transform = CGAffineTransformMakeRotation(degree);
    [animatedImageView setBounds:CGRectMake(0, 0,150, 50)];
    animatedImageView.tag = 555;
    
}

-(void) drawFireLine: (CGPoint)point withangle:(CGFloat)degree{
    UIImageView* animatedImageView = [[UIImageView alloc] init];
    animatedImageView.animationImages = [NSArray arrayWithObjects:
                                         [UIImage imageNamed:@"flecha_b1.png"],
                                         [UIImage imageNamed:@"flecha_b2.png"],
                                         [UIImage imageNamed:@"flecha_b3.png"], nil];
    animatedImageView.animationDuration = 1.0f;
    animatedImageView.animationRepeatCount = 0;
    [animatedImageView startAnimating];
    animatedImageView.center = point;
    [self.view addSubview: animatedImageView];
    animatedImageView.transform = CGAffineTransformMakeRotation(degree);
    [animatedImageView setBounds:CGRectMake(0, 0,150, 50)];
    animatedImageView.tag = 555;
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
    if (!_center) {
        self.mapView.centerCoordinate = _location.coordinate;
        _center = YES;
    }
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
    self.mapView.zoom = 13;
    
    // center the map to the coordinates
    self.mapView.centerCoordinate = center;
    
    [self.mapView addTileSource:[[RMMapboxSource alloc]
                                 initWithMapID:@"ldiego08.2c02c779"]];
    
    [self.view addSubview:self.mapView];
    
    
}

- (IBAction)onChangeButtonClicked:(id)sender {
}

- (IBAction)returnFromReportFeed:(UIStoryboardSegue*)sender
{}

//tableview

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _placesList.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"Place";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:MyIdentifier];
    }
    
    [cell.textLabel setText:[_placesList objectAtIndex:indexPath.row]];
    
    return cell;
}

#pragma mark -
#pragma mark BZFoursquareRequestDelegate

- (void)requestDidFinishLoading:(BZFoursquareRequest *)request {
    self.meta = request.meta;
    self.notifications = request.notifications;
    self.response = request.response;
    self.request = nil;
    
    NSLog(@"FOURSQUARE: %@", self.request);
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)request:(BZFoursquareRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"%s: %@", __PRETTY_FUNCTION__, error);
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[error userInfo][@"errorDetail"] delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
    [alertView show];
    self.meta = request.meta;
    self.notifications = request.notifications;
    self.response = request.response;
    self.request = nil;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

#pragma mark -
#pragma mark Venues

- (void)cancelRequest {
    if (_request) {
        _request.delegate = nil;
        [_request cancel];
        self.request = nil;
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
}

- (void)prepareForRequest {
    [self cancelRequest];
    self.meta = nil;
    self.notifications = nil;
    self.response = nil;
}

- (void)searchVenues:(NSString*)name withPositions:(CLLocationCoordinate2D)coodinates {
    [self prepareForRequest];
    NSDictionary *parameters = @{@"ll": [NSString stringWithFormat:@"%f,%f", coodinates.latitude, coodinates.longitude],
                                 @"near":name};
    self.request = [_foursquare requestWithPath:@"venues/search" HTTPMethod:@"GET" parameters:parameters delegate:self];
    [_request start];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

//Animation

- (void)animationToAlertSymbol
{
    if (self.alertSymbol.hidden) {
        [self.alertSymbol setHidden:NO];
    } else {
        [self.alertSymbol setHidden:YES];
    }
}


@end
