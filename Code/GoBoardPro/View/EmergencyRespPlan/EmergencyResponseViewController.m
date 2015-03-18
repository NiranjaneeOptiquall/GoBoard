//
//  EmergencyResponseViewController.m
//  GoBoardPro
//
//  Created by ind558 on 24/09/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import "EmergencyResponseViewController.h"
#import "ERPHeaderView.h"
#import "ERPDetailViewController.h"
#import "ERPCategory.h"
#import "ERPSubcategory.h"
#import "ERPTask.h"

@interface EmergencyResponseViewController ()

@end

@implementation EmergencyResponseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self getAllEmergencyList];
   
    if (!_dictERPCategory) {
        [_btnERPList setHidden:YES];
        [_lblTitle setText:@"Emergency Reponse Plan"];
        [_tblERPCategory setHidden:YES];
       [self getAllEmergencyList];
    }
    else {
        [_lblTitle setHidden:YES];
        CGRect frame = _tblERPCategory.frame;
        frame.size.height = _mutArrCategoryHierarchy.count * _tblEmergencyList.rowHeight;
        _tblERPCategory.frame = frame;
        
        if (CGRectGetMaxY(frame) > _tblERPCategory.frame.origin.y) {
            frame = _tblEmergencyList.frame;
            frame.origin.y = CGRectGetMaxY(_tblERPCategory.frame) + 5;
            frame.size.height = self.view.frame.size.height - frame.origin.y;
            _tblEmergencyList.frame = frame;
            
        }
        
        frame = _lblDescription.frame;
        frame.origin.y = CGRectGetMinY(_tblEmergencyList.frame) ;
        [_lblDescription setFrame:frame];
        
        frame = _viewWeb.frame;
        frame.origin.y = CGRectGetMinY(_tblEmergencyList.frame) ;
        [_viewWeb setFrame:frame];
        
        NSSortDescriptor *sortBySequence = [[NSSortDescriptor alloc] initWithKey:@"Sequence.intValue" ascending:YES];
        NSSortDescriptor *sortByTitle = [[NSSortDescriptor alloc] initWithKey:@"Title" ascending:YES];
        mutArrEmergencies = [NSMutableArray arrayWithArray:[[_dictERPCategory objectForKey:@"Children"] sortedArrayUsingDescriptors:@[sortBySequence,sortByTitle]]];
        
        //If Type has a value of 1 (Link) then the 'Link' property should be set
        //If Type has a value of 2 (Text) then the 'Description' property should be set
        
        [_lblDescription setHidden:YES];
        [_viewWeb setHidden:YES];
        
        if ([[_dictERPCategory objectForKey:@"Type"] integerValue] == 2) {
            [_lblDescription setHidden:NO];
            NSString *aStrDescription = [NSString stringWithFormat:@"%@",[_dictERPCategory objectForKey:@"Description"]];
            [_lblDescription setText:aStrDescription];
            
            NSDictionary *stringAttributes = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:20] forKey: NSFontAttributeName];
            float height = [aStrDescription boundingRectWithSize:CGSizeMake(_lblDescription.frame.size.width, 9999) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin  attributes:stringAttributes context:nil].size.height +20;
            CGRect frameLblDescription  = _lblDescription.frame;
            frameLblDescription.size.height = height;
            _lblDescription.frame = frameLblDescription;
            _lblDescription.numberOfLines = 0;
            [_lblDescription setFont:[UIFont systemFontOfSize:20]];
            [_lblDescription setTextAlignment:NSTextAlignmentLeft];
            
            frame = _tblEmergencyList.frame;
            frame.origin.y = CGRectGetMaxY(_lblDescription.frame) + 5;
            frame.size.height = self.view.frame.size.height - frame.origin.y;
            _tblEmergencyList.frame = frame;
            
        }else if ([[_dictERPCategory objectForKey:@"Type"] integerValue] == 1){
            [_viewWeb setHidden:NO];
            
            frame = _viewWeb.frame;
            frame.size.height = self.view.frame.size.height - _tblEmergencyList.frame.origin.y;
            [_viewWeb setFrame:frame];
            
            NSString *aStrLink = [NSString stringWithFormat:@"%@",[_dictERPCategory objectForKey:@"Link"]];
            [_viewWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:aStrLink]]];
        }
    }
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
    if ([[segue identifier] isEqualToString:@"ERPDetails"]) {
        ERPDetailViewController *destination = (ERPDetailViewController*)segue.destinationViewController;
        destination.dictCategory = [mutArrEmergencies objectAtIndex:selectedIndexPath.section];
        destination.erpSubcategory = [[[[mutArrEmergencies objectAtIndex:selectedIndexPath.section] erpTitles] allObjects] objectAtIndex:selectedIndexPath.row];
        destination.selectedIndex = selectedIndexPath.row;
    }
    
}


#pragma mark - IBActions & Selectors

- (void)btnHeaderTapped:(UIButton*)btn {
    BOOL isExpanded = [[mutArrEmergencies objectAtIndex:btn.tag] isExpanded];
    isExpanded = !isExpanded;
    [[mutArrEmergencies objectAtIndex:btn.tag] setIsExpanded:isExpanded];
    [_tblEmergencyList reloadData];
}

- (IBAction)unwindBackToERPListScreen:(UIStoryboardSegue*)segue{
    
}

#pragma mark - Methods

- (void)getAllEmergencyList {
//    [[WebSerivceCall webServiceObject] callServiceForEmergencyResponsePlan:NO complition:^{
//        [self fetchOfflineERPData];
//        [_tblEmergencyList reloadData];
//    }];

    [gblAppDelegate callWebService:[NSString stringWithFormat:@"%@/%@", ERP_CATEGORY, [[User currentUser] userId]] parameters:nil httpMethod:[SERVICE_HTTP_METHOD objectForKey:ERP_CATEGORY] complition:^(NSDictionary *response) {
        
        NSSortDescriptor *sortBySequence = [[NSSortDescriptor alloc] initWithKey:@"Sequence.intValue" ascending:YES];
        NSSortDescriptor *sortByTitle = [[NSSortDescriptor alloc] initWithKey:@"Title" ascending:YES];
        mutArrEmergencies = [NSMutableArray arrayWithArray:[[response objectForKey:@"ErpCategories"] sortedArrayUsingDescriptors:@[sortBySequence,sortByTitle]]];
        
        if ([mutArrEmergencies count] == 0) {
            [_lblNoRecords setHidden:NO];
        }
        [_tblEmergencyList reloadData];
    } failure:^(NSError *error, NSDictionary *response) {
         [_lblNoRecords setHidden:NO];
    }];
    
}

- (void)fetchOfflineERPData {
    mutArrEmergencies = [[NSMutableArray alloc] init];
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"ERPCategory"];
//    [request setPropertiesToFetch:@[@"categoryId", @"title", @"erpTitles", @"erpTitles.subCateId", @"erpTitles.title"]];
    NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
    [request setSortDescriptors:@[sortByName]];
    NSError *error = nil;
    NSArray *aryCategories = [gblAppDelegate.managedObjectContext executeFetchRequest:request error:&error];
    if (!error) {
        [mutArrEmergencies addObjectsFromArray:aryCategories];
    }
    if ([mutArrEmergencies count] == 0) {
        [_lblNoRecords setHidden:NO];
    }
}

#pragma mark - UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1; //[mutArrEmergencies count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    BOOL isExpanded = [[mutArrEmergencies objectAtIndex:section] isExpanded];
//    if (isExpanded) {
//        return [[[mutArrEmergencies objectAtIndex:section] erpTitles] count];
//    }
//    return 0;
    
    
    if ([tableView isEqual:_tblERPCategory]) {
        return [_mutArrCategoryHierarchy count];
    }
    return [mutArrEmergencies count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *aCell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
//    NSInteger currentIndex = indexPath.section + indexPath.row + 1;
//    for (int i = 0; i < indexPath.section; i++) {
//        ERPCategory *category = [mutArrEmergencies objectAtIndex:i];
//        if (category.isExpanded) {
//            currentIndex += [category.erpTitles count];
//        }
//    }
//    if (currentIndex == 0 || currentIndex % 2 == 0) {
//        [aCell setBackgroundColor:[UIColor colorWithRed:228.0/255.0 green:228.0/255.0 blue:228.0/255.0 alpha:1.0]];
//    }
//    else {
//        [aCell setBackgroundColor:[UIColor colorWithRed:241.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0]];
//    }
//    ERPCategory *category = [mutArrEmergencies objectAtIndex:indexPath.section];
//    ERPSubcategory *subCate = [[category.erpTitles allObjects] objectAtIndex:indexPath.row];
//    UILabel *aLbl = (UILabel *)[aCell.contentView viewWithTag:2];
//    [aLbl setText:subCate.title];
//    UIView *aView = [aCell.contentView viewWithTag:4];
//    CGRect frame = aView.frame;
//    frame.origin.y = aCell.frame.size.height - 3;
//    [aView setFrame:frame];
//    return aCell;

    
    
    UITableViewCell *aCell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if ([tableView isEqual:_tblERPCategory]) {
        [aCell setBackgroundColor:[UIColor clearColor]];
        UILabel *lbl = (UILabel*)[aCell.contentView viewWithTag:2];
        [lbl setText:[[_mutArrCategoryHierarchy objectAtIndex:indexPath.row] objectForKey:@"Title"]];
        UILabel *lblDisplaySequence = (UILabel*)[aCell.contentView viewWithTag:4];
        [lblDisplaySequence setText:[[_mutArrCategoryHierarchy objectAtIndex:indexPath.row] objectForKey:@"DisplaySequence"]];
        
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
        NSDictionary *aDict = [mutArrEmergencies objectAtIndex:indexPath.row];
        UILabel *aLbl = (UILabel *)[aCell.contentView viewWithTag:2];
        UIImageView *aImgView = (UIImageView *)[aCell.contentView viewWithTag:1];
       
        NSString *aStrTitle = [NSString stringWithFormat:@"%@ %@",[aDict objectForKey:@"DisplaySequence"],[aDict objectForKey:@"Title"]];
        [aLbl setText:aStrTitle];
        
        UILabel *lblDisplaySequence = (UILabel*)[aCell.contentView viewWithTag:6];
        [lblDisplaySequence setText:[NSString stringWithFormat:@"%@",[aDict objectForKey:@"DisplaySequence"]]];
       
        
        //LinkType = 0 Text ,LinkType = 1 Link, LinkType = 2 Photo, LinkType = 3 Video, LinkType = 4 PDF.
        
        if ([[[mutArrEmergencies objectAtIndex:indexPath.row] objectForKey:@"LinkType"] integerValue] == 0) {
            [aImgView setImage:[UIImage imageNamed:@"list_icon.png"]];
        }else if ([[[mutArrEmergencies objectAtIndex:indexPath.row] objectForKey:@"LinkType"] integerValue] == 1){
            [aImgView setImage:[UIImage imageNamed:@"erp_link_icon.png"]];
        }else if ([[[mutArrEmergencies objectAtIndex:indexPath.row] objectForKey:@"LinkType"] integerValue] == 2){
            [aImgView setImage:[UIImage imageNamed:@"erp_photo_icon.png"]];
        }else if ([[[mutArrEmergencies objectAtIndex:indexPath.row] objectForKey:@"LinkType"] integerValue] == 3){
            [aImgView setImage:[UIImage imageNamed:@"erp_video_icon.png"]];
        }else if ([[[mutArrEmergencies objectAtIndex:indexPath.row] objectForKey:@"LinkType"] integerValue] == 4){
            [aImgView setImage:[UIImage imageNamed:@"erp_pdf_icon.png"]];
        }
        
        if (![aDict objectForKey:@"Children"]  || [[aDict objectForKey:@"Children"] isKindOfClass:[NSNull class]]) {
            [aCell setAccessoryType:UITableViewCellAccessoryNone];
        }
        else {
            [aCell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        }
        UIView *aView = [aCell.contentView viewWithTag:4];
        CGRect frame = aView.frame;
        frame.origin.y = aCell.frame.size.height - 3;
        [aView setFrame:frame];
    }
    return aCell;
}

//- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    NSInteger currentIndex = section;
//    for (int i = 0; i < section; i++) {
//        ERPCategory *category = [mutArrEmergencies objectAtIndex:i];
//        if (category.isExpanded) {
//            currentIndex += [category.erpTitles count];
//        }
//    }
//    
//    NSMutableArray *aMutArr = [[NSMutableArray alloc]initWithArray:[[NSBundle mainBundle] loadNibNamed:@"ERPHeaderView" owner:self options:nil]];
//
//    ERPHeaderView *aHeaderView = [aMutArr firstObject];
//    
//    aMutArr = nil;
//    
//    if (currentIndex == 0 || currentIndex % 2 == 0) {
//        [aHeaderView setBackgroundColor:[UIColor colorWithRed:228.0/255.0 green:228.0/255.0 blue:228.0/255.0 alpha:1.0]];
//    }
//    else {
//        [aHeaderView setBackgroundColor:[UIColor colorWithRed:241.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0]];
//    }
//    [aHeaderView.lblSectionHeaser setText:[[mutArrEmergencies objectAtIndex:section] title]];
//    [aHeaderView.btnSection setTag:section];
//    [aHeaderView.btnSection addTarget:self action:@selector(btnHeaderTapped:) forControlEvents:UIControlEventTouchUpInside];
//    BOOL isExpanded = [[mutArrEmergencies objectAtIndex:section] isExpanded];
//    if (isExpanded) {
//        [aHeaderView.imvExpandCollapse setImage:[UIImage imageNamed:@"collaps_icon@2x.png"]];
//    }
//    else {
//        [aHeaderView.imvExpandCollapse setImage:[UIImage imageNamed:@"expand_icon@2x.png"]];
//    }
//    return aHeaderView;
//}
#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    selectedIndexPath = indexPath;
//    [self performSegueWithIdentifier:@"ERPDetails" sender:self];
    
    
    NSDictionary *aDict = [mutArrEmergencies objectAtIndex:indexPath.row];
    if (!_mutArrCategoryHierarchy) {
        _mutArrCategoryHierarchy = [NSMutableArray array];
    }
    
    EmergencyResponseViewController *ERPView = [self.storyboard instantiateViewControllerWithIdentifier:@"ERPViewController"];
    ERPView.dictERPCategory = aDict;
    ERPView.mutArrCategoryHierarchy = _mutArrCategoryHierarchy;
    [ERPView.mutArrCategoryHierarchy addObject:[NSDictionary dictionaryWithObjectsAndKeys:[aDict objectForKey:@"Title"],@"Title",[aDict objectForKey:@"DisplaySequence"],@"DisplaySequence", nil]];
    [self.navigationController pushViewController:ERPView animated:YES];
}

- (IBAction)btnBackTapped:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
    [_mutArrCategoryHierarchy removeLastObject];
}

- (IBAction)btnERPListTapped:(UIButton *)sender {
    
    [_mutArrCategoryHierarchy removeAllObjects];
    NSArray *vcs = [self.navigationController viewControllers];
    for (int i = 0; i < [vcs count]; i++) {
        if ([vcs[i] isKindOfClass:[EmergencyResponseViewController class]]) {
            [self.navigationController popToViewController:vcs[i] animated:YES];
            break;
        }
    }
}
@end
