//
//  DailyLogViewController.m
//  GoBoardPro
//
//  Created by ind558 on 10/12/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import "DailyLogViewController.h"

@interface DailyLogViewController ()

@end

@implementation DailyLogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"EEEE, MM/dd/yyyy"];
    [_lblTodayTime setText:[NSString stringWithFormat:@"Today's Time:%@", [formatter stringFromDate:[NSDate date]]]];
    [_tblDailyLog setBackgroundColor:[UIColor clearColor]];
    [formatter setDateFormat:@"HH:mm a"];
    _lblTimeStamp.text = [formatter stringFromDate:[NSDate date]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - IBActions

- (IBAction)btnBackTapped:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnSubmitTapped:(id)sender {
}

- (IBAction)btnEditTapped:(id)sender {
}

#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *aCell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    [aCell setBackgroundColor:[UIColor clearColor]];
    return aCell;
}

#pragma mark - UITextView Delegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    [_lblLogPlaceholder setHidden:YES];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([_txvDailyLog.text isEqualToString:@""]) {
        [_lblLogPlaceholder setHidden:NO];
    }
}
@end
