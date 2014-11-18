//
//  SOPDetailViewController.m
//  GoBoardPro
//
//  Created by ind558 on 26/09/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import "SOPDetailViewController.h"
#import "WebViewController.h"

@interface SOPDetailViewController ()

@end

@implementation SOPDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect frame = _tblSOPCategory.frame;
    frame.size.height = _mutArrCategoryHierarchy.count * _tblSOPCategory.rowHeight;
    _tblSOPCategory.frame = frame;
    if (CGRectGetMaxY(frame) > _tblSOPList.frame.origin.y) {
        frame = _tblSOPList.frame;
        frame.origin.y = CGRectGetMaxY(_tblSOPCategory.frame) + 5;
        frame.size.height = self.view.frame.size.height - frame.origin.y;
        _tblSOPList.frame = frame;
    }
    [self getAllActionListForSOP];
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
    if ([[segue identifier] isEqualToString:@"SOPLinkDetail"]) {
        WebViewController *webVC = (WebViewController *)[segue destinationViewController];
        webVC.strRequestURL = [[[dictSOPDetails objectForKey:@"SopDetails"] objectAtIndex:selectedRow] objectForKey:@"AttachmentLink"];
    }
    else {
        [_mutArrCategoryHierarchy removeLastObject];
    }
}


#pragma mark - IBActions & Selectors

- (void)btnViewLinkTapped:(UIButton *)btn {
    UITableViewCell *cell = (UITableViewCell *)[btn superview];
    while (![cell isKindOfClass:[UITableViewCell class]]) {
        cell = (UITableViewCell*)[cell superview];
    }
    NSIndexPath *indexPath = [_tblSOPList indexPathForCell:cell];
    selectedRow = indexPath.row;
    [self performSegueWithIdentifier:@"SOPLinkDetail" sender:nil];
}

#pragma mark - Methods

- (void)getAllActionListForSOP {
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [gblAppDelegate callWebService:[NSString stringWithFormat:@"%@/%@",SOP_DETAIL, [_dictSopCategry objectForKey:@"Id"]] parameters:nil httpMethod:[SERVICE_HTTP_METHOD objectForKey:SOP_DETAIL] complition:^(NSDictionary *response) {
        dictSOPDetails = response;
        if ([dictSOPDetails count] == 0) {
            [_lblNoRecords setHidden:NO];
        }
        [_tblSOPList reloadData];
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    } failure:^(NSError *error, NSDictionary *response) {
        [_lblNoRecords setHidden:NO];
        alert(@"", [response objectForKey:@"ErrorMessage"]);
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    }];
}

#pragma mark - UITableView Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView isEqual:_tblSOPCategory]) {
        return [_mutArrCategoryHierarchy count];
    }
    return [[dictSOPDetails objectForKey:@"SopDetails"] count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *aCell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if ([tableView isEqual:_tblSOPCategory]) {
        [aCell setBackgroundColor:[UIColor clearColor]];
        UILabel *lbl = (UILabel*)[aCell.contentView viewWithTag:2];
        [lbl setText:[_mutArrCategoryHierarchy objectAtIndex:indexPath.row]];
        CGRect frame = lbl.frame;
        frame.origin.x = indexPath.row * 50 + 5;
        frame.size.width = 532 - frame.origin.x;
        lbl.frame = frame;
    }
    else {
        if (indexPath.row == 0 || indexPath.row % 2 == 0) {
            [aCell setBackgroundColor:[UIColor colorWithRed:228.0/255.0 green:228.0/255.0 blue:228.0/255.0 alpha:1.0]];
        }
        else {
            [aCell setBackgroundColor:[UIColor colorWithRed:241.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0]];
        }
        UILabel *aLbl = (UILabel*)[aCell viewWithTag:2];
        [aLbl setText:[[[dictSOPDetails objectForKey:@"SopDetails"] objectAtIndex:indexPath.row] objectForKey:@"Description"]];
        [aLbl sizeToFit];
        UIView *aView = [aCell.contentView viewWithTag:4];
        UIButton *linkBtn = (UIButton*)[aCell viewWithTag:3];
        if (![[[dictSOPDetails objectForKey:@"SopDetails"] objectAtIndex:indexPath.row] objectForKey:@"AttachmentLink"] || [[[[dictSOPDetails objectForKey:@"SopDetails"] objectAtIndex:indexPath.row] objectForKey:@"AttachmentLink"] isKindOfClass:[NSNull class]]) {
            [linkBtn setHidden:YES];
        }
        else {
            [linkBtn setHidden:NO];
        }
        [linkBtn addTarget:self action:@selector(btnViewLinkTapped:) forControlEvents:UIControlEventTouchUpInside];
        CGRect frame = aView.frame;
        frame.origin.y = aCell.frame.size.height - 3;
        [aView setFrame:frame];
    }
    
    return aCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:_tblSOPCategory]) {
        return 35;
    }
    UILabel *aLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 632, 21)];
    NSString *aStr = [[[dictSOPDetails objectForKey:@"SopDetails"] objectAtIndex:indexPath.row] objectForKey:@"Description"];
    [aLbl setText:aStr];
    [aLbl setFont:[UIFont systemFontOfSize:17.0]];
    [aLbl setNumberOfLines:0];
    [aLbl sizeToFit];
    CGFloat height = aLbl.frame.size.height + 30;
    aLbl = nil;
    if (height < 40) {
        height = 40;
    }
    return height;
}


@end
