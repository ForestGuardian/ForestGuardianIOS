//
//  ReportCellTableViewCell.h
//  Forest Guardian
//
//  Created by Luis Alonso Murillo Rojas on 12/4/15.
//  Copyright (c) 2015 TEC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReportCellTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *reportImage;
@property (weak, nonatomic) IBOutlet UILabel *reportTitle;

-(void)loadReport:(NSString*)reportId;
@end
