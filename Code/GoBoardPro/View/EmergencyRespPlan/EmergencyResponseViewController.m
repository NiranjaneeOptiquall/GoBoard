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
#import "DynamicFormsViewController.h"
#import "AccidentReportViewController.h"
#import "IncidentDetailViewController.h"
#import "SOPViewController.h"

@interface EmergencyResponseViewController ()<UITextFieldDelegate>
{
    NSString *searchTextString;
    NSMutableArray *searchArray,*allDataForLinkedSopErp;
    BOOL isFilter;
    CGPoint contentOffset;
    bool isScroll;
    NSString * scrollFlag;
    NSInteger childSelectCount;
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


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_txtSearchTag resignFirstResponder];
}
- (void)viewDidLoad {
    [super viewDidLoad];
 
    if (_isBtnERPListHidden) {
        [_btnERPList setHidden:YES];
    }
    scrollFlag=@"NO";
    [_lblSearchNote setHidden:YES];

    _txtSearchTag.delegate=self;
    [self.txtSearchTag addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    if (!_dictERPCategory) {
        allSearchData=[[NSMutableArray alloc]init];

        [_btnERPList setHidden:YES];
        [_lblTitle setText:@"Emergency Reponse Plan"];
        [_tblERPCategory setHidden:YES];
        [[NSUserDefaults standardUserDefaults]setValue:@"" forKey:@"NOTE"];;

        [self getAllEmergencyList];
        
        CGRect frame = _mainScrollView.frame;
        frame.origin.y = CGRectGetMinY(_txtSearchTag.frame) + CGRectGetHeight(_txtSearchTag.frame)+20 ;
        CGFloat newYPosition= CGRectGetMinY(_txtSearchTag.frame) +CGRectGetHeight(_txtSearchTag.frame)+20;
        CGFloat height=newYPosition - _mainScrollView.frame.origin.y;
        frame.size.height=frame.size.height - height;
        [_mainScrollView setFrame:frame];
        
        frame = _tblEmergencyList.frame;
        frame.origin.y = 0;
        // frame.size.height = self.view.frame.size.height - frame.origin.y;
        _tblEmergencyList.frame = frame;
        
    }
    else {
        [_lblTitle setHidden:YES];
        CGRect frame = _tblERPCategory.frame;
        frame.size.height = _mutArrCategoryHierarchy.count * _tblERPCategory.rowHeight;
        _tblERPCategory.frame = frame;

        frame = _txtSearchTag.frame;
        frame.origin.y = CGRectGetMinY(_tblERPCategory.frame) + CGRectGetHeight(_tblERPCategory.frame) +20;
        [_txtSearchTag setFrame:frame];
        
        frame = _btnSearchTag.frame;
        frame.origin.y = CGRectGetMinY(_tblERPCategory.frame) + CGRectGetHeight(_tblERPCategory.frame) + 20;
        [_btnSearchTag setFrame:frame];
        
        frame = _lblSearchNote.frame;
        frame.origin.y = CGRectGetMinY(_tblERPCategory.frame) + CGRectGetHeight(_tblERPCategory.frame) +35;
        [_lblSearchNote setFrame:frame];
        
        
        frame = _mainScrollView.frame;
        frame.origin.y = CGRectGetMinY(_txtSearchTag.frame) + CGRectGetHeight(_txtSearchTag.frame) +20;
        CGFloat newYPosition= CGRectGetMinY(_txtSearchTag.frame) +CGRectGetHeight(_txtSearchTag.frame)+20;
        CGFloat height=newYPosition - _mainScrollView.frame.origin.y;
        frame.size.height=frame.size.height - height;
        [_mainScrollView setFrame:frame];
        

        frame = _viewWebDescription.frame;
        frame.origin.y = 0 ;
        [_viewWebDescription setFrame:frame];
        
        frame = _viewWeb.frame;
        frame.origin.y = _mainScrollView.frame.origin.y ;
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
           
//            frame = _tblEmergencyList.frame;
//            frame.origin.y = 600;//CGRectGetMaxY(_txtDescription.frame) + 15;
//            frame.size.height = self.view.frame.size.height - frame.origin.y - _mainScrollView.frame.origin.y;
//            _tblEmergencyList.frame = frame;
            
        }
        else if ([[_dictERPCategory objectForKey:@"Type"] integerValue] == 1){
            
            
            [_viewWeb setHidden:NO];
            [_txtSearchTag setHidden:YES];
            [_btnSearchTag setHidden:YES];
            frame = _viewWeb.frame;
           frame.size.height = self.view.frame.size.height - _tblEmergencyList.frame.origin.y;
          //  frame.size.height = _mainScrollView.frame.size.height;

            frame.origin.y=frame.origin.y - 50;
            [_viewWeb setFrame:frame];
            
            NSString *aStrLink = [NSString stringWithFormat:@"%@",[_dictERPCategory objectForKey:@"Link"]];
            [_viewWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:aStrLink]]];
            
            CGFloat height= _viewWeb.scrollView.contentSize.height;
            if (height > 870) {
                frame = _viewWeb.frame;
                   frame.origin.y = _mainScrollView.frame.origin.y;
                frame.size.height = 870;
                [_viewWeb setFrame:frame];
            }
        }
    }
//    [_txtSearchTag setHidden:YES];

}
-(void)viewWillAppear:(BOOL)animated{
    
    if (mutArrEmergencies.count == 0) {
        [_btnSearchTag setHidden:YES];
        [_txtSearchTag setHidden:YES];
    }
    
    if ([[_dictERPCategory objectForKey:@"Type"] integerValue] == 2)
    {
        [_btnSearchTag setHidden:YES];
        [_txtSearchTag setHidden:YES];
        if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"NOTE"] isEqualToString:@""]) {
            [_lblSearchNote setHidden:YES];
        }
        else{
            [_lblSearchNote setHidden:NO];
            
            _lblSearchNote.text=[NSString stringWithFormat:@"Showing search result for '%@'",[[NSUserDefaults standardUserDefaults]valueForKey:@"NOTE"]];
        }
    }
    else if ([[_dictERPCategory objectForKey:@"Type"] integerValue] == 1)
    {
        [_btnSearchTag setHidden:YES];
        [_txtSearchTag setHidden:YES];
        if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"NOTE"] isEqualToString:@""]) {
            [_lblSearchNote setHidden:YES];
        }
        else{
            [_lblSearchNote setHidden:NO];
            
            _lblSearchNote.text=[NSString stringWithFormat:@"Showing search result for '%@'",[[NSUserDefaults standardUserDefaults]valueForKey:@"NOTE"]];
        }
    }
//    else{
//        
//        [_btnSearchTag setHidden:NO];
//        [_lblSearchNote setHidden:YES];
//
//        if(!_btnSearchTag.isSelected)
//        {
//            
//            _txtSearchTag.hidden=YES;
//        }
//        else{
//            _txtSearchTag.hidden=NO;
//            
//        }
//        
//    }
    
    
    
}
- (IBAction)btnSearchTagClicked:(id)sender {
    
//    if(!_btnSearchTag.isSelected)
//    {
//        _txtSearchTag.hidden=NO;
//        [_btnSearchTag setSelected:YES];
//    }
//    else{
//        _txtSearchTag.hidden=YES;
//        [_btnSearchTag setSelected:NO];
//    }
}
-(void)textFieldDidChange:(UITextField *)textField
{
    searchTextString=textField.text;
    [[NSUserDefaults standardUserDefaults]setValue:textField.text forKey:@"NOTE"];

    [self updateSearchArray:searchTextString];
}
-(void)updateSearchArray:(NSString *)searchText
{
    if(searchText.length==0)
    {
        [[NSUserDefaults standardUserDefaults]setValue:@"NO" forKey:@"noteHidden"];

        isFilter=NO;
    }
    else{
        [[NSUserDefaults standardUserDefaults]setValue:@"YES" forKey:@"noteHidden"];

        isFilter=YES;
        searchArray=[[NSMutableArray alloc]init];
        for(int q=0;q<allSearchData.count;q++){
            
            NSString *stringTitle=[[allSearchData valueForKey:@"Title"] objectAtIndex:q];
            
            if ([stringTitle isKindOfClass:[NSNull class]]) {
                stringTitle=@"";
            }
            NSRange stringRangeTitle=[stringTitle rangeOfString:searchText options:NSCaseInsensitiveSearch];
            
            NSString *stringTag=[[allSearchData valueForKey:@"Tag"] objectAtIndex:q];
            if ([stringTag isKindOfClass:[NSNull class]]) {
                stringTag=@"";
            }
            NSArray *tagItems = [stringTag componentsSeparatedByString:@","];
            NSRange stringRangeTag = NSMakeRange(0,  stringTag.length);
            stringRangeTag=[[tagItems objectAtIndex:0] rangeOfString:searchText options:NSCaseInsensitiveSearch];
            for (int i = 0; i<tagItems.count; i++) {
                if (stringRangeTag.location !=NSNotFound) {
                    break;
                }
                else{
                    stringRangeTag=[[tagItems objectAtIndex:i] rangeOfString:searchText options:NSCaseInsensitiveSearch];
                }
            }
            
            if(stringRangeTitle.location !=NSNotFound || stringRangeTag.location !=NSNotFound){
                
                [searchArray addObject:[allSearchData objectAtIndex:q]];
            }        }
        
    }
    if (searchArray.count == 0) {
        _lblNoRecords.frame=CGRectMake(_lblNoRecords.frame.origin.x, _tblEmergencyList.frame.origin.y + 20, _lblNoRecords.frame.size.width, _lblNoRecords.frame.size.height);
           [_lblNoRecords setHidden:NO];
    }
    else{
        [_lblNoRecords setHidden:YES];

    }
    
    [self.tblEmergencyList reloadData];
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    [_txtSearchTag resignFirstResponder];
  //  isScroll = NO;
    [self.mainScrollView setContentOffset:contentOffset animated:YES];
    [textField endEditing:true];
    //  return  true;

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
 
        //CGFloat height=[[webView stringByEvaluatingJavaScriptFromString:@"document.height"] floatValue];
        if(isFilter){

            if (searchArray.count < 4) {
                
                //58
                [self webviewHeight:58*(int)[searchArray count] view:webView];

            }
            else{
                [self webviewHeight:58*4 view:webView];

            }
        }
        else{
            
            if (mutArrEmergencies.count < 4) {
                [self webviewHeight:58*(int)[mutArrEmergencies count] view:webView];
            }
            else{
                [self webviewHeight:58*4 view:webView];

            }
        }
  
    
}
-(void)webviewHeight:(int)heightView view:(UIWebView *)webView
{
    
    if ([webView isEqual:_viewWebDescription])
    {
        
        CGFloat height= webView.scrollView.contentSize.height - heightView;
        
        CGRect frameWebView=_viewWebDescription.frame;
        if (heightView !=0) {
            if (heightView < 232) {
                
                height=_mainScrollView.frame.size.height - heightView-30;
            }
           else if (_viewWebDescription.frame.origin.y + height >= 600)
            {
                height= 600 - _viewWebDescription.frame.origin.y;
            }
   
        }
        else if (_viewWebDescription.frame.origin.y + height >= 830){
             height= 830 - _viewWebDescription.frame.origin.y;
        }
        else{
            height = _mainScrollView.frame.size.height;

        }
        frameWebView.size.height=height;
        _viewWebDescription.frame= frameWebView;
    }
    CGRect frame = _tblEmergencyList.frame;
    frame.origin.y = _viewWebDescription.frame.origin.y+ _viewWebDescription.frame.size.height + 20; //CGRectGetMaxY(_txtDescription.frame) + 15;
    frame.size.height = heightView;
    if (frame.size.height > CGRectGetHeight(_mainScrollView.frame) - 620) {
            frame.size.height = CGRectGetHeight(_mainScrollView.frame) - 620 -20 ;
    }
    _tblEmergencyList.frame = frame;
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
  
    [[NSUserDefaults standardUserDefaults]setInteger:0 forKey:@"childSelectCount"];

}

#pragma mark - Methods

- (void)getAllEmergencyList {


    // allSopArrList=[[NSMutableArray alloc]init];

    
    [gblAppDelegate callWebService:[NSString stringWithFormat:@"%@/%@", ERP_CATEGORY, [[User currentUser] userId]] parameters:nil httpMethod:[SERVICE_HTTP_METHOD objectForKey:ERP_CATEGORY] complition:^(NSDictionary *response) {
        
        NSSortDescriptor *sortBySequence = [[NSSortDescriptor alloc] initWithKey:@"Sequence.intValue" ascending:YES];
        NSSortDescriptor *sortByTitle = [[NSSortDescriptor alloc] initWithKey:@"Title" ascending:YES];
        
        NSMutableArray *aMutArrEmergenciesList = [NSMutableArray arrayWithArray:[[response objectForKey:@"ErpCategories"] sortedArrayUsingDescriptors:@[sortBySequence,sortByTitle]]];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"Published == 1"];
        
        mutArrEmergencies = [NSMutableArray arrayWithArray:[aMutArrEmergenciesList filteredArrayUsingPredicate:predicate]];
        
        //  allSopArrList =[self allDAtaMethode:mutArrSOPList];
        //   for (NSMutableDictionary * tempDic in mutArrSOPList) {
        
        [self allDAtaMethode:mutArrEmergencies];
        
        //  }

        if ([mutArrEmergencies count] == 0) {
            [_lblNoRecords setHidden:NO];
        }
        if (mutArrEmergencies.count == 0) {
            [_btnSearchTag setHidden:YES];
        }
        else{
            [_btnSearchTag setHidden:NO];
            [_txtSearchTag setHidden:NO];

        }
        [_tblEmergencyList reloadData];
    } failure:^(NSError *error, NSDictionary *response) {
         [_lblNoRecords setHidden:NO];
    }];
  
}
-(void) allDAtaMethode : (NSMutableArray *)arr {
    
    for (NSMutableDictionary * tempDic in arr) {
        [allSearchData addObject:tempDic];
        if ([[tempDic valueForKey:@"Children"] count] ==0) {
            
            [allSopArrList addObject:tempDic];
            
        }
        else{
            [self allDAtaMethode:[tempDic valueForKey:@"Children"]];
        }
    }
    NSData * data=[NSKeyedArchiver archivedDataWithRootObject:allSearchData];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"allSearchData"];
    
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
    
 
    childSelectCount=[[NSUserDefaults standardUserDefaults]integerForKey:@"childSelectCountERP"];
    [[NSUserDefaults standardUserDefaults]setInteger:childSelectCount + 1 forKey:@"childSelectCountERP"];
 //   [_btnSearchTag setHidden:YES];
    
    [_lblNoRecords setHidden:YES];    if (isFilter) {
       //    isFilter = NO;
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
   
    if ([[NSUserDefaults standardUserDefaults]integerForKey:@"childSelectCountERP"] == 0) {
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"isBackToMainView"];
        [[NSUserDefaults standardUserDefaults]setValue:@"" forKey:@"NOTE"];
        
    }
    else{
        [[NSUserDefaults standardUserDefaults]setValue:@"YES" forKey:@"isBackToMainView"];
    }
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
-(void)getLinkedSopData:(NSArray*)dataDic{
    
    for (NSMutableDictionary * tempDic in dataDic) {
        if ([[tempDic valueForKey:@"Children"] count] ==0) {
            
            [allDataForLinkedSopErp addObject:tempDic];
            
        }
        else{
            [self getLinkedSopData:[tempDic valueForKey:@"Children"]];
        }
    }
    
}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    NSURL *url = [request URL];
    NSString * strUrl = [NSString stringWithFormat:@"%@",url];
    NSLog(@"%@",strUrl);
    if ( [strUrl containsString:@"IsLinked=true"]) {
        //  NSLog(@"linked type");
        if ([strUrl containsString:@"SOPs"]) {
            NSLog(@"linked type SOPs");
            
            NSRange r1 = [strUrl rangeOfString:@"id="];
            NSRange r2 = [strUrl rangeOfString:@"&"];
            NSRange rSub = NSMakeRange(r1.location + r1.length, r2.location - r1.location - r1.length);
            NSString *sopId = [strUrl substringWithRange:rSub];
            
            [gblAppDelegate callWebService:[NSString stringWithFormat:@"%@/%@",SOP_CATEGORY, [[User currentUser] userId]] parameters:nil httpMethod:[SERVICE_HTTP_METHOD objectForKey:SOP_CATEGORY] complition:^(NSDictionary *response) {
                
                
                
                
                SOPViewController *sopView = [self.storyboard instantiateViewControllerWithIdentifier:@"SOPViewController"];
                allDataForLinkedSopErp= [[NSMutableArray alloc]init];
                for (NSMutableDictionary * tempDic in [response valueForKey:@"SopCategories"]) {
                    [allDataForLinkedSopErp addObject:tempDic];
                }
                [self getLinkedSopData:[response valueForKey:@"SopCategories"]];
                
                for (int i = 0; i<allDataForLinkedSopErp.count; i++) {
                    if ([[NSString stringWithFormat:@"%@",[[allDataForLinkedSopErp valueForKey:@"Id"] objectAtIndex:i]] isEqualToString:sopId]) {
                        sopView.dictSOPCategory = [allDataForLinkedSopErp objectAtIndex:i];
                    }
                }
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (sopView.dictSOPCategory == nil) {
                        alert(@"", @"This link is broken or no longer exists.");
                        return;
                    }else{
                        sopView.mutArrCategoryHierarchy = [NSMutableArray array];
                         [sopView.mutArrCategoryHierarchy addObject:sopView.dictSOPCategory];
                        sopView.isBtnSOPListHidden = YES;
                        [[NSUserDefaults standardUserDefaults]setValue:@"" forKey:@"NOTE"];

                        [self.navigationController pushViewController:sopView animated:YES];
                    }
                    
                });
               
                
            } failure:^(NSError *error, NSDictionary *response) {
                
            }];
            
        }
        else if ([strUrl containsString:@"ERP"]) {
            NSLog(@"linked type SOPs");
            
            NSRange r1 = [strUrl rangeOfString:@"id="];
            NSRange r2 = [strUrl rangeOfString:@"&"];
            NSRange rSub = NSMakeRange(r1.location + r1.length, r2.location - r1.location - r1.length);
            NSString *sopId = [strUrl substringWithRange:rSub];
            
          [gblAppDelegate callWebService:[NSString stringWithFormat:@"%@/%@", ERP_CATEGORY, [[User currentUser] userId]] parameters:nil httpMethod:[SERVICE_HTTP_METHOD objectForKey:ERP_CATEGORY] complition:^(NSDictionary *response) {

                EmergencyResponseViewController *erpView = [self.storyboard instantiateViewControllerWithIdentifier:@"ERPViewController"];
                allDataForLinkedSopErp= [[NSMutableArray alloc]init];
              for (NSMutableDictionary * tempDic in [response valueForKey:@"ErpCategories"]) {
                  [allDataForLinkedSopErp addObject:tempDic];
              }
                [self getLinkedSopData:[response valueForKey:@"ErpCategories"]];
                
                for (int i = 0; i<allDataForLinkedSopErp.count; i++) {
                    if ([[NSString stringWithFormat:@"%@",[[allDataForLinkedSopErp valueForKey:@"Id"] objectAtIndex:i]] isEqualToString:sopId]) {
                        erpView.dictERPCategory = [allDataForLinkedSopErp objectAtIndex:i];
                    }
                }
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (erpView.dictERPCategory == nil) {
                        alert(@"", @"This link is broken or no longer exists.");
                        return;
                    }else{
                        erpView.mutArrCategoryHierarchy = [NSMutableArray array];
                        [erpView.mutArrCategoryHierarchy addObject:erpView.dictERPCategory];
                        erpView.isBtnERPListHidden = YES;
                        [[NSUserDefaults standardUserDefaults]setValue:@"" forKey:@"NOTE"];

                        [self.navigationController pushViewController:erpView animated:YES];
                    }
                    
                });
              
                
            } failure:^(NSError *error, NSDictionary *response) {
                
            }];
            
        }
        else if ([strUrl containsString:@"Accident"]) {
            NSLog(@"linked type Accident");
            AccidentReportViewController * acciView = [self.storyboard instantiateViewControllerWithIdentifier:@"AccidentReportViewController"];
            [self.navigationController pushViewController:acciView animated:YES];
        }
        else if ([strUrl containsString:@"Incident"]) {
            
            if ([strUrl containsString:@"Misconduct"]) {
                NSLog(@"linked type Misconduct");
                IncidentDetailViewController * inciView = [self.storyboard instantiateViewControllerWithIdentifier:@"IncidentDetailViewController"];
                inciView.incidentType = 1;
                [self.navigationController pushViewController:inciView animated:YES];
            }
            else if ([strUrl containsString:@"CustomerService"]) {
                NSLog(@"linked type CustomerService");
                IncidentDetailViewController * inciView = [self.storyboard instantiateViewControllerWithIdentifier:@"IncidentDetailViewController"];
                inciView.incidentType = 2;
                [self.navigationController pushViewController:inciView animated:YES];
                
            }
            else if ([strUrl containsString:@"Other"]) {
                NSLog(@"linked type Other");
                IncidentDetailViewController * inciView = [self.storyboard instantiateViewControllerWithIdentifier:@"IncidentDetailViewController"];
                inciView.incidentType = 3;
                [self.navigationController pushViewController:inciView animated:YES];
                
            }
        }
        else if ([strUrl containsString:@"Survey"]) {
            NSLog(@"linked type Survey");
            NSRange r1 = [strUrl rangeOfString:@"surveyId="];
            NSRange r2 = [strUrl rangeOfString:@"&"];
            NSRange rSub = NSMakeRange(r1.location + r1.length, r2.location - r1.location - r1.length);
            NSString *surveyId = [strUrl substringWithRange:rSub];
            
            [[WebSerivceCall webServiceObject] callServiceForSurvey:NO linkedSurveyId:surveyId complition:^{
                DynamicFormsViewController * formView = [self.storyboard instantiateViewControllerWithIdentifier:@"DYFormsView"];
                
                NSString *strSurveyUserType = @"1";
                if ([User checkUserExist]) {
                    strSurveyUserType = @"2";
                }
                NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"SurveyList"];
//                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userTypeId ==[CD] %@ AND NOT (typeId ==[cd] %@)",strSurveyUserType,[NSString stringWithFormat:@"%d", 3]];
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userTypeId ==[CD] %@",strSurveyUserType];

                
                [request setPredicate:predicate];
                
                NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"sequence" ascending:YES];
                NSSortDescriptor *sort1 = [NSSortDescriptor sortDescriptorWithKey:@"surveyId" ascending:YES];
                
                [request setSortDescriptors:@[sort,sort1]];
                NSMutableArray * mutArrFormList = [NSMutableArray arrayWithArray:[gblAppDelegate.managedObjectContext executeFetchRequest:request error:nil]];
                NSLog(@"%@",mutArrFormList);
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (mutArrFormList.count == 0) {
                        alert(@"", @"This link is broken or no longer exists.");
                        return;
                    }else{
                        formView.objFormOrSurvey = [mutArrFormList objectAtIndex:0];
                        
                        formView.isSurvey = YES;
                        
                        [self.navigationController pushViewController:formView animated:YES];

                    }
                });
                
            }];
        }
        else if ([strUrl containsString:@"Form"]) {
            NSLog(@"linked type Form");
            NSRange r1 = [strUrl rangeOfString:@"formId="];
            NSRange r2 = [strUrl rangeOfString:@"&"];
            NSRange rSub = NSMakeRange(r1.location + r1.length, r2.location - r1.location - r1.length);
            NSString *formId = [strUrl substringWithRange:rSub];
            
            [[WebSerivceCall webServiceObject] callServiceForForms:NO linkedFormId:formId complition:^{
                DynamicFormsViewController * formView = [self.storyboard instantiateViewControllerWithIdentifier:@"DYFormsView"];
                
                NSString *strSurveyUserType = @"1";
                if ([User checkUserExist]) {
                    strSurveyUserType = @"2";
                }
                NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"FormsList"];
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userTypeId ==[CD] %@ AND NOT (typeId ==[cd] %@)",strSurveyUserType,[NSString stringWithFormat:@"%d", 3]];
                [request setPredicate:predicate];
                NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"sequence" ascending:YES];
                NSSortDescriptor *sort1 = [NSSortDescriptor sortDescriptorWithKey:@"formId" ascending:YES];
                [request setSortDescriptors:@[sort,sort1]];
                NSMutableArray *mutArrFormList = [NSMutableArray arrayWithArray:[gblAppDelegate.managedObjectContext executeFetchRequest:request error:nil]];
                NSLog(@"%@",mutArrFormList);
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (mutArrFormList.count == 0) {
                        alert(@"", @"This link is broken or no longer exists.");
                        return;
                    }else{
                        formView.objFormOrSurvey = [mutArrFormList objectAtIndex:0];
                        
                        formView.isSurvey = NO;
                        
                        [self.navigationController pushViewController:formView animated:YES];

                    }
                });
                
            }];
            
            
        }
        return NO;
    }
    
    return YES;
}
@end
