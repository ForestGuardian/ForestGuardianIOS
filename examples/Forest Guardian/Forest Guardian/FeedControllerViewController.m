//
//  FeedControllerViewController.m
//  Forest Guardian
//
//  Created by Luis Alonso Murillo Rojas on 11/4/15.
//  Copyright (c) 2015 TEC. All rights reserved.
//

#import "FeedControllerViewController.h"
#import "ReportCellTableViewCell.h"
#import "ParseHelper.h"

@interface FeedControllerViewController ()
@property (weak, nonatomic) IBOutlet UITableView *reportsTable;
@property (strong, nonatomic) NSMutableArray *reportList;

@end

@implementation FeedControllerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _reportList = [[NSMutableArray alloc] init];
    
    [self.reportsTable setDelegate:self];
    [self.reportsTable setDataSource:self];
    
    [ParseHelper getAllReportsWithBlock:^(NSMutableArray *responseObject, NSError *error) {
        if (!error) {
            NSLog(@"Total de resportes: %@", responseObject);
            _reportList = responseObject;
            [_reportsTable reloadData];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _reportList.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(ReportCellTableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ReportCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"report_cell"];
    
    if (cell == nil)
    {
        cell = [[ReportCellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:@"report_cell"];
    }
    
    [cell loadReport:[_reportList objectAtIndex:indexPath.row]];
    
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)returnFromReportCreation:(UIStoryboardSegue*)sender
{}

@end
