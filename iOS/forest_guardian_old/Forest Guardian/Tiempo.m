//
//  Tiempo.m
//  Forest Guardian
//
//  Created by Luis Alonso Murillo Rojas on 12/4/15.
//  Copyright (c) 2015 TEC. All rights reserved.
//

#import "Tiempo.h"

@implementation Tiempo

- (void) buildTimeof:(CLLocationCoordinate2D)coordinates:(void (^)(Tiempo *responseObject, NSError *error))completedBlock
{
    _weatherAPI = [[OWMWeatherAPI alloc] initWithAPIKey:@"58287bee46d0b29681931fd98adfe0c5"];
    [_weatherAPI setTemperatureFormat:kOWMTempCelcius];
    
    [_weatherAPI currentWeatherByCoordinate:coordinates withCallback:^(NSError *error, NSDictionary *result) {
        if (!error) {
            NSDictionary *main = [result objectForKey:@"main"];
            NSDictionary *wind = [result objectForKey:@"wind"];
            
            self.temp = main[@"temp"];
            self.temp_max = main[@"temp_min"];
            self.temp_min = main[@"temp_max"];
            
            self.wind_speed = wind[@"speed"];
            self.degree = [[wind valueForKey:@"deg"] floatValue];
            
            completedBlock(self, nil);
        }
        else {
            completedBlock(nil, error);
            self.error = error;
        }
    }];
}

@end
