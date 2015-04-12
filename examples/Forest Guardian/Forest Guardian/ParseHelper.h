//
//  ParseHelper.h
//  Forest Guardian
//
//  Created by Luis Alonso Murillo Rojas on 11/4/15.
//  Copyright (c) 2015 TEC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ParseHelper : NSObject

+ (void) addNewUser:(NSString*)name;
+ (void) addNewReport:(NSString*)title withDescription:(NSString*)description image:(UIImage*)image withLocation:(CLLocationCoordinate2D)location andUserId:(NSString*)userId;
+(void)getReport:(NSString*)reportID withBlock:(void (^)(PFObject *responseObject, NSError *error))completedBlock;

@end
