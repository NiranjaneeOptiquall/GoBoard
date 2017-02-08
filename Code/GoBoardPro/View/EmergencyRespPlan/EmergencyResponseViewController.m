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

@interface EmergencyResponseViewController ()<UITextFieldDelegate>
{
    NSString *searchTextString;
    NSMutableArray *searchArray;
    BOOL isFilter;
    
}


@end

@implementation EmergencyResponseViewController

/*- (void)viewDidLoad {
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
        frame = _txtDescription.frame;
        frame.origin.y = CGRectGetMinY(_tblEmergencyList.frame) ;
        [_txtDescription setFrame:frame];
        
        frame = _viewWeb.frame;
        frame.origin.y = CGRectGetMinY(_tblEmergencyList.frame) ;
        [_viewWeb setFrame:frame];
        
        NSSortDescriptor *sortBySequence = [[NSSortDescriptor alloc] initWithKey:@"Sequence.intValue" ascending:YES];
        NSSortDescriptor *sortByTitle = [[NSSortDescriptor alloc] initWithKey:@"Title" ascending:YES];
        
        NSMutableArray *aMutArrEmergenciesList = [NSMutableArray arrayWithArray:[[_dictERPCategory objectForKey:@"Children"] sortedArrayUsingDescriptors:@[sortBySequence,sortByTitle]]];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"Published == 1"];
        
        mutArrEmergencies = [NSMutableArray arrayWithArray:[aMutArrEmergenciesList filteredArrayUsingPredicate:predicate]];

        //If Type has a value of 1 (Link) then the 'Link' property should be set
        //If Type has a value of 2 (Text) then the 'Description' property should be set
        
        [_txtDescription setHidden:YES];
        [_viewWeb setHidden:YES];
        
        if ([[_dictERPCategory objectForKey:@"Type"] integerValue] == 2) {
            [_txtDescription setHidden:NO];
            NSString *aStrDescription = [NSString stringWithFormat:@"%@",[_dictERPCategory objectForKey:@"Description"]];
            [_txtDescription setText:aStrDescription];
            
            NSDictionary *stringAttributes = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:20] forKey: NSFontAttributeName];
            float height = 0;
            
            if ([[_dictERPCategory objectForKey:@"Children"] count] > 0) {
                height = [aStrDescription boundingRectWithSize:CGSizeMake(_txtDescription.frame.size.width, 625) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin  attributes:stringAttributes context:nil].size.height +20;
            }else{
                height = [aStrDescription boundingRectWithSize:CGSizeMake(_txtDescription.frame.size.width, self.view.frame.size.height - _txtDescription.frame.origin.y - 15) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin  attributes:stringAttributes context:nil].size.height +20;
            }
            
            if (_txtDescription.frame.origin.y + height >= 745) {
                height = 745-_txtDescription.frame.origin.y;
            }
            
            CGRect frameLblDescription  = _txtDescription.frame;
            frameLblDescription.size.height = height;
            _txtDescription.frame = frameLblDescription;
            [_txtDescription setFont:[UIFont systemFontOfSize:20]];
            [_txtDescription setTextAlignment:NSTextAlignmentLeft];
            
            frame = _tblEmergencyList.frame;
            frame.origin.y = 765;//CGRectGetMaxY(_txtDescription.frame) + 15;
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
*/

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self getAllEmergencyList];
    isFilter = NO;
    _txtSearchTag.delegate=self;
    _txtSearchTag.hidden=YES;
    [self.txtSearchTag addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    if (!_dictERPCategory) {
        [_btnERPList setHidden:YES];
        [_lblTitle setText:@"Emergency Reponse Plan"];
        [_tblERPCategory setHidden:YES];
        [self getAllEmergencyList];
    }
    else {
        [_lblTitle setHidden:YES];
        CGRect frame = _tblERPCategory.frame;
        _txtSearchTag.frame=CGRectMake(_txtSearchTag.frame.origin.x, frame.origin.y+frame.size.height+5, _txtSearchTag.frame.size.width, _txtSearchTag.frame.size.height);
        _btnSearchTag.frame=CGRectMake(_btnSearchTag.frame.origin.x, frame.origin.y+frame.size.height+5, _btnSearchTag.frame.size.width, _btnSearchTag.frame.size.height);
        frame.size.height = _mutArrCategoryHierarchy.count * _tblEmergencyList.rowHeight;
        _tblERPCategory.frame = frame;
        
        if (CGRectGetMaxY(frame) > _tblERPCategory.frame.origin.y) {
            _txtSearchTag.frame=CGRectMake(_txtSearchTag.frame.origin.x, _tblERPCategory.frame.origin.y+_tblERPCategory.frame.size.height+5, _txtSearchTag.frame.size.width, _txtSearchTag.frame.size.height);
            _btnSearchTag.frame=CGRectMake(_btnSearchTag.frame.origin.x, frame.origin.y+frame.size.height+5, _btnSearchTag.frame.size.width, _btnSearchTag.frame.size.height);
            frame = _tblEmergencyList.frame;
            frame.origin.y = CGRectGetMaxY(_tblERPCategory.frame) + 5;
            frame.size.height = self.view.frame.size.height - frame.origin.y;
            _tblEmergencyList.frame = frame;
            
            
        }
        
        frame = _txtSearchTag.frame;
        frame.origin.y = CGRectGetMinY(_tblEmergencyList.frame) ;
        frame.origin.y=frame.origin.y+35;
        [_txtSearchTag setFrame:frame];
        
        frame = _btnSearchTag.frame;
        frame.origin.y = CGRectGetMinY(_tblEmergencyList.frame) ;
        frame.origin.y=frame.origin.y+35;
        [_btnSearchTag setFrame:frame];
        
        frame = _viewWebDescription.frame;
        frame.origin.y = CGRectGetMinY(_txtSearchTag.frame) + 40 ;
        frame.origin.y=frame.origin.y+35;
        [_viewWebDescription setFrame:frame];
        
        frame = _viewWeb.frame;
        frame.origin.y = CGRectGetMinY(_tblEmergencyList.frame) ;
        
        [_viewWeb setFrame:frame];
        
        NSSortDescriptor *sortBySequence = [[NSSortDescriptor alloc] initWithKey:@"Sequence.intValue" ascending:YES];
        NSSortDescriptor *sortByTitle = [[NSSortDescriptor alloc] initWithKey:@"Title" ascending:YES];
        
        NSMutableArray *aMutArrEmergenciesList = [NSMutableArray arrayWithArray:[[_dictERPCategory objectForKey:@"Children"] sortedArrayUsingDescriptors:@[sortBySequence,sortByTitle]]];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"Published == 1"];
        
        mutArrEmergencies = [NSMutableArray arrayWithArray:[aMutArrEmergenciesList filteredArrayUsingPredicate:predicate]];
        
        //If Type has a value of 1 (Link) then the 'Link' property should be set
        //If Type has a value of 2 (Text) then the 'Description' property should be set
        
        [_viewWebDescription setHidden:YES];
        [_viewWeb setHidden:YES];
        
        if ([[_dictERPCategory objectForKey:@"Type"] integerValue] == 2)
        {
            
            
            [_viewWebDescription setHidden:NO];
            NSString *aStrDescription = [NSString stringWithFormat:@"%@",[_dictERPCategory objectForKey:@"Description"]];
            _viewWebDescription.delegate=self;
            [_viewWebDescription loadHTMLString:aStrDescription baseURL:nil];
            
            frame = _tblEmergencyList.frame;
            frame.origin.y = 765;//CGRectGetMaxY(_txtDescription.frame) + 15;
            frame.size.height = self.view.frame.size.height - frame.origin.y;
            _tblEmergencyList.frame = frame;
            
        }else if ([[_dictERPCategory objectForKey:@"Type"] integerValue] == 1){
            
            
            [_viewWeb setHidden:NO];
            
            frame = _viewWeb.frame;
            frame.size.height = self.view.frame.size.height - _tblEmergencyList.frame.origin.y;
            frame.origin.y=frame.origin.y+30;
            [_viewWeb setFrame:frame];
            
            NSString *aStrLink = [NSString stringWithFormat:@"%@",[_dictERPCategory objectForKey:@"Link"]];
            [_viewWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:aStrLink]]];
        }
    }
}
-(void)viewWillAppear:(BOOL)animated{
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"isBackToMainView"]isEqualToString:@"YES"]) {
        [[NSUserDefaults standardUserDefaults]setValue:@"NO" forKey:@"isBackToMainView"];
        
        isFilter=NO;
        [self.tblEmergencyList reloadData];
    }
    
}
- (IBAction)btnSearchTagClicked:(id)sender {
    
    _txtSearchTag.hidden=NO;

}
-(void)textFieldDidChange:(UITextField *)textField
{
    searchTextString=textField.text;
    
    [self updateSearchArray:searchTextString];
}
-(void)updateSearchArray:(NSString *)searchText
{
    if(searchText.length==0)
    {
        isFilter=NO;
    }
    else{
        
        isFilter=YES;
        searchArray=[[NSMutableArray alloc]init];
        for(int q=0;q<mutArrEmergencies.count;q++){
            
            NSString *stringTitle=[[mutArrEmergencies valueForKey:@"Title"] objectAtIndex:q];
            NSString *stringTag=[[mutArrEmergencies valueForKey:@"Tag"] objectAtIndex:q];
            
            
            NSRange stringRangeTitle=[stringTitle rangeOfString:searchText options:NSCaseInsensitiveSearch];
            NSRange stringRangeTag=[stringTag rangeOfString:searchText options:NSCaseInsensitiveSearch];
            
            if(stringRangeTitle.location !=NSNotFound || stringRangeTag.location !=NSNotFound){
                
                [searchArray addObject:[mutArrEmergencies objectAtIndex:q]];
            }        }
        
    }
    if (searchArray.count == 0) {
        _lblNoRecords.frame=CGRectMake(_lblNoRecords.frame.origin.x, _tblEmergencyList.frame.origin.y + 20, _lblNoRecords.frame.size.width, _lblNoRecords.frame.size.height);
           [_lblNoRecords setHidden:NO];
    }
    
    [self.tblEmergencyList reloadData];
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    [_txtSearchTag resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


#pragma mark UIWebViewDelgate

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    if ([webView isEqual:_viewWebDescription])
    {
        //CGFloat height=[[webView stringByEvaluatingJavaScriptFromString:@"document.height"] floatValue];
        
        CGFloat height= webView.scrollView.contentSize.height;
        
        CGRect frameWebView=_viewWebDescription.frame;
        
        if (_viewWebDescription.frame.origin.y + height >= 745)
        {
            height= 745 - _viewWebDescription.frame.origin.y;
        }
        
        frameWebView.size.height=height;
        _viewWebDescription.frame= frameWebView;
    }
    
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
        
        NSMutableArray *aMutArrEmergenciesList = [NSMutableArray arrayWithArray:[[response objectForKey:@"ErpCategories"] sortedArrayUsingDescriptors:@[sortBySequence,sortByTitle]]];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"Published == 1"];
        
        mutArrEmergencies = [NSMutableArray arrayWithArray:[aMutArrEmergenciesList filteredArrayUsingPredicate:predicate]];
        
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
    else{
        if(isFilter){
            return [searchArray count];
        }
        return [mutArrEmergencies count];
    }
    
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
        if (isFilter) {
            NSDictionary *aDict = [searchArray objectAtIndex:indexPath.row];
            UILabel *aLbl = (UILabel *)[aCell.contentView viewWithTag:2];
            UIImageView *aImgView = (UIImageView *)[aCell.contentView viewWithTag:1];
            
            NSString *aStrTitle = [NSString stringWithFormat:@"%@",[aDict objectForKey:@"Title"]];
            [aLbl setText:aStrTitle];
            
            UILabel *lblDisplaySequence = (UILabel*)[aCell.contentView viewWithTag:6];
            [lblDisplaySequence setText:[NSString stringWithFormat:@"%@",[aDict objectForKey:@"DisplaySequence"]]];
            
            
            //LinkType = 0 Text ,LinkType = 1 Link, LinkType = 2 Photo, LinkType = 3 Video, LinkType = 4 PDF.
            
            if ([[[searchArray objectAtIndex:indexPath.row] objectForKey:@"LinkType"] integerValue] == 0) {
                [aImgView setImage:[UIImage imageNamed:@"list_icon.png"]];
            }else if ([[[searchArray objectAtIndex:indexPath.row] objectForKey:@"LinkType"] integerValue] == 1){
                [aImgView setImage:[UIImage imageNamed:@"erp_link_icon.png"]];
            }else if ([[[searchArray objectAtIndex:indexPath.row] objectForKey:@"LinkType"] integerValue] == 2){
                [aImgView setImage:[UIImage imageNamed:@"erp_photo_icon.png"]];
            }else if ([[[searchArray objectAtIndex:indexPath.row] objectForKey:@"LinkType"] integerValue] == 3){
                [aImgView setImage:[UIImage imageNamed:@"erp_video_icon.png"]];
            }else if ([[[searchArray objectAtIndex:indexPath.row] objectForKey:@"LinkType"] integerValue] == 4){
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
        else{
            NSDictionary *aDict = [mutArrEmergencies objectAtIndex:indexPath.row];
            UILabel *aLbl = (UILabel *)[aCell.contentView viewWithTag:2];
            UIImageView *aImgView = (UIImageView *)[aCell.contentView viewWithTag:1];
            
            NSString *aStrTitle = [NSString stringWithFormat:@"%@",[aDict objectForKey:@"Title"]];
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
    
 
    _txtSearchTag.hidden=YES;
    if (isFilter) {
           isFilter = NO;
        NSDictionary *aDict = [searchArray objectAtIndex:indexPath.row];
        if (!_mutArrCategoryHierarchy) {
            _mutArrCategoryHierarchy = [NSMutableArray array];
        }
        
        EmergencyResponseViewController *ERPView = [self.storyboard instantiateViewControllerWithIdentifier:@"ERPViewController"];
        ERPView.dictERPCategory = aDict;
        ERPView.mutArrCategoryHierarchy = _mutArrCategoryHierarchy;
        [ERPView.mutArrCategoryHierarchy addObject:[NSDictionary dictionaryWithObjectsAndKeys:[aDict objectForKey:@"Title"],@"Title",[aDict objectForKey:@"DisplaySequence"],@"DisplaySequence", nil]];
        [self.navigationController pushViewController:ERPView animated:YES];
    }
    else{
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
    
}

- (IBAction)btnBackTapped:(UIButton *)sender {
    
    [[NSUserDefaults standardUserDefaults]setValue:@"YES" forKey:@"isBackToMainView"];

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
