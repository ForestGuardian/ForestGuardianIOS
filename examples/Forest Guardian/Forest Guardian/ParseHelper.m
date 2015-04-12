//
//  ParseHelper.m
//  Forest Guardian
//
//  Created by Luis Alonso Murillo Rojas on 11/4/15.
//  Copyright (c) 2015 TEC. All rights reserved.
//

#import "ParseHelper.h"

@implementation ParseHelper

+ (void) addNewUser:(NSString*)name
{
    PFObject *newUser = [PFObject objectWithClassName:@"Usuarios"];
    newUser[@"Name"] = name;
    
    [newUser saveInBackground];
}

+ (void) addNewReport:(NSString*)title withDescription:(NSString*)description image:(UIImage*)image withLocation:(CLLocationCoordinate2D)location andUserId:(NSString*)userId
{
    NSData *imageData = UIImagePNGRepresentation(image);
    PFFile *imageFile = [PFFile fileWithName:@"image.png" data:imageData];
    
    PFGeoPoint *point = [PFGeoPoint geoPointWithLatitude:location.latitude longitude:location.longitude];
    
    PFObject *newReport = [PFObject objectWithClassName:@"Reportes"];
    newReport[@"Title"] = title;
    newReport[@"Description"] = description;
    newReport[@"Image"] = imageFile;
    newReport[@"Location"] = point;
    newReport[@"UserId"] = userId;
    
    [newReport saveInBackground];
}

+(void)getReport:(NSString*)reportID withBlock:(void (^)(PFObject *responseObject, NSError *error))completedBlock
{
    PFQuery *query = [PFQuery queryWithClassName:@"Reportes"];
    [query getObjectInBackgroundWithId:reportID block:^(PFObject *report, NSError *error) {
        if (!error) {
            completedBlock(report, nil);
        } else {
            completedBlock(nil, error);
        }
    }];
}

@end
