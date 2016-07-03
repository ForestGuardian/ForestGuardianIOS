//
//  Tiempo.h
//  Forest Guardian
//
//  Created by Luis Alonso Murillo Rojas on 12/4/15.
//  Copyright (c) 2015 TEC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "OWMWeatherAPI.h"

@interface Tiempo : NSObject

@property (strong, nonatomic) NSString *temp;
@property (strong, nonatomic) NSString *temp_min;
@property (strong, nonatomic) NSString *temp_max;
@property (strong, nonatomic) NSString *wind_speed;
@property (nonatomic) float degree;
@property (strong, nonatomic) OWMWeatherAPI *weatherAPI;
@property (strong, nonatomic) NSError *error;

- (void) buildTimeof:(CLLocationCoordinate2D)coordinates:(void (^)(Tiempo *responseObject, NSError *error))completedBlock;

@end
