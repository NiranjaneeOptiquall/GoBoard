//
//  GuestHomeViewController.m
//  GoBoardPro
//
//  Created by ind558 on 23/09/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import "GuestFormViewController.h"

@interface GuestFormViewController ()

@end

@implementation GuestFormViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpInitials];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"SurveyLinkDetail"]) {
        
    }
}


#pragma mark - Methods

- (void)setUpInitials {
    if (_guestFormType == 1) {
        // Configure for Take a Survey screen
        [_imvIcon setImage:[UIImage imageNamed:@"take_a_survey.png"]];
        [_lblFormTitle setText:@"Guest Survey"];
        mutArrFormList = [NSMutableArray arrayWithObjects:@"Fitness Center Survey", @"Swimming Pool Survey", nil];
    }
    else if (_guestFormType == 2) {
        // Configure for Make a Suggestion screen
        [_imvIcon setImage:[UIImage imageNamed:@"make_a_suggestion.png"]];
        [_lblFormTitle setText:@"Guest Suggestion"];
        mutArrFormList = [NSMutableArray arrayWithObjects:@"Fitness Center Suggestion", @"Swimming Pool Suggestion", @"Cafeteria's Suggestion", nil];
    }
    else if (_guestFormType == 3) {
        // Configure for Complete Form screen
        [_imvIcon setImage:[UIImage imageNamed:@"complete_a_form.png"]];
        [_lblFormTitle setText:@"Guest Forms"];
        mutArrFormList = [NSMutableArray arrayWithObjects:@"Fitness Center Form", @"Swimming Pool Form", @"Badminton Court's Form", nil];
    }
    else if (_guestFormType == 4) {
        // Configure for User Forms
        [_imvIcon setImage:[UIImage imageNamed:@"complete_a_form.png"]];
        [_lblFormTitle setText:@"User Form List"];
        mutArrFormList = [NSMutableArray arrayWithObjects:@"Fitness Center Form", @"Swimming Pool Form", @"Badminton Court's Form", nil];
    }
    else if (_guestFormType == 5) {
        // Configure for User Forms
        [_imvIcon setImage:[UIImage imageNamed:@"complete_a_form.png"]];
        [_lblFormTitle setText:@"User Survey Forms"];
        [gblAppDelegate callWebService:[NSString stringWithFormat:@"%@/%@", SURVEY_SETUP, [[User currentUser] userId]] parameters:nil httpMethod:[SERVICE_HTTP_METHOD objectForKey:SURVEY_SETUP] complition:^(NSDictionary *response) {
            mutArrFormList = [response objectForKey:@"Surveys"];
            [_tblFormList reloadData];
        } failure:^(NSError *error, NSDictionary *response) {
            NSLog(@"%@", response);
        }];
       
    }
}

#pragma mark - IBActions


- (IBAction)btnBackTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)btnLinkTapped:(UIButton*)btn {
    [self performSegueWithIdentifier:@"SurveyLinkDetail" sender:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [mutArrFormList count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *aCell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (indexPath.row == 0 || indexPath.row % 2 == 0) {
        [aCell setBackgroundColor:[UIColor colorWithRed:228.0/255.0 green:228.0/255.0 blue:228.0/255.0 alpha:1.0]];
    }
    else {
        [aCell setBackgroundColor:[UIColor colorWithRed:241.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0]];
    }
    NSDictionary *dictObject = [mutArrFormList objectAtIndex:indexPath.row];
    UILabel *aLbl = (UILabel *)[aCell.contentView viewWithTag:2];
    [aLbl setText:[dictObject objectForKey:@"Name"]];
    UIButton *btnLink = (UIButton*)[aCell.contentView viewWithTag:5];
    [btnLink addTarget:self action:@selector(btnLinkTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *aView = [aCell.contentView viewWithTag:4];
    CGRect frame = aView.frame;
    frame.origin.y = aCell.frame.size.height - 3;
    frame.size.height = 3;
    [aView setFrame:frame];
    return aCell;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dictObject = [mutArrFormList objectAtIndex:indexPath.row];
    if (![[dictObject objectForKey:@"Questions"] isKindOfClass:[NSNull class]]) {
        [self performSegueWithIdentifier:@"ShowDynamicForm" sender:nil];
    }
}

@end
