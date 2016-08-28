//
//  ReportCellTableViewCell.m
//  Forest Guardian
//
//  Created by Luis Alonso Murillo Rojas on 12/4/15.
//  Copyright (c) 2015 TEC. All rights reserved.
//

#import "ReportCellTableViewCell.h"
#import "ParseHelper.h"

@implementation ReportCellTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)loadReport:(NSString*)reportId
{
    [ParseHelper getReport:reportId withBlock:^(PFObject *responseObject, NSError *error) {
        if (!error) {
            [self.reportTitle setText:responseObject[@"Title"]];
            
            PFFile *userImageFile = responseObject[@"Image"];
            [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
                if (!error) {
                    UIImage *image = [UIImage imageWithData:imageData];
                    [self.reportImage setImage:image];
                }
            }];
        }
    }];
}

@end
