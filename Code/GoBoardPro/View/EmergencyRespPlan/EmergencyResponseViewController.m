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
    [self getAllEmergencyList];
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

- (IBAction)unwindBackToEmergencyListScreen:(UIStoryboardSegue*)segue {
    
}

#pragma mark - Methods

- (void)getAllEmergencyList {
    if (gblAppDelegate.isNetworkReachable) {
        [gblAppDelegate callWebService:[NSString stringWithFormat:@"%@/%@", ERP_CATEGORY, [[User currentUser] userId]] parameters:nil httpMethod:[SERVICE_HTTP_METHOD objectForKey:ERP_CATEGORY] complition:^(NSDictionary *response) {
            [self deleteAllERPData];
            for (NSDictionary *aDict in [response objectForKey:@"ErpCategories"]) {
                ERPCategory *aCategory = [NSEntityDescription insertNewObjectForEntityForName:@"ERPCategory" inManagedObjectContext:gblAppDelegate.managedObjectContext];
                aCategory.title = [aDict objectForKey:@"Title"];
                aCategory.categoryId = [NSString stringWithFormat:@"%ld", (long)[[aDict objectForKey:@"Id"] integerValue]];
                NSMutableSet *subcategories = [NSMutableSet set];
                for (NSDictionary *aDictSubCate in [aDict objectForKey:@"Subcategories"]) {
                    ERPSubcategory *aSubCate = [NSEntityDescription insertNewObjectForEntityForName:@"ERPSubcategory" inManagedObjectContext:gblAppDelegate.managedObjectContext];
                    aSubCate.title = [aDictSubCate objectForKey:@"Title"];
                    aSubCate.subCateId = [NSString stringWithFormat:@"%ld", (long)[[aDictSubCate objectForKey:@"Id"] integerValue]];
                    NSMutableSet *taskList = [NSMutableSet set];
                    for (NSDictionary *aTask in [aDictSubCate objectForKey:@"Tasks"]) {
                        ERPTask *task = [NSEntityDescription insertNewObjectForEntityForName:@"ERPTask" inManagedObjectContext:gblAppDelegate.managedObjectContext];
                        task.taskID = [NSString stringWithFormat:@"%ld", (long)[[aTask objectForKey:@"Id"] integerValue]];
                        task.task = [aTask objectForKey:@"Description"];
                        if (![aTask objectForKey:@"AttachmentLink"] || [[aTask objectForKey:@"AttachmentLink"] isKindOfClass:[NSNull class]]) {
                            task.attachmentLink = @"";
                        }
                        else {
                            task.attachmentLink = [aTask objectForKey:@"AttachmentLink"];
                        }
                        
                        task.erpTitle = aSubCate;
                        [taskList addObject:task];
                    }
                    aSubCate.erpTasks = taskList;
                    aSubCate.erpHeader = aCategory;
                    [subcategories addObject:aSubCate];
                }
                aCategory.erpTitles = subcategories;
                [gblAppDelegate.managedObjectContext insertObject:aCategory];
            }
            if ([gblAppDelegate.managedObjectContext save:nil]) {
                [self fetchOfflineERPData];
                [_tblEmergencyList reloadData];
            }
        } failure:^(NSError *error, NSDictionary *response) {
            
        }];
    }
    else {
        [self fetchOfflineERPData];
    }
}


- (void)deleteAllERPData {
    NSFetchRequest * allCategory = [[NSFetchRequest alloc] init];
    [allCategory setEntity:[NSEntityDescription entityForName:@"ERPCategory" inManagedObjectContext:gblAppDelegate.managedObjectContext]];
    [allCategory setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    NSError * error = nil;
    NSArray * categories = [gblAppDelegate.managedObjectContext executeFetchRequest:allCategory error:&error];
    //error handling goes here
    for (NSManagedObject * cate in categories) {
        [gblAppDelegate.managedObjectContext deleteObject:cate];
    }
    NSError *saveError = nil;
    [gblAppDelegate.managedObjectContext save:&saveError];
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
}

#pragma mark - UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [mutArrEmergencies count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    BOOL isExpanded = [[mutArrEmergencies objectAtIndex:section] isExpanded];
    if (isExpanded) {
        return [[[mutArrEmergencies objectAtIndex:section] erpTitles] count];
    }
    return 0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *aCell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    NSInteger currentIndex = indexPath.section + indexPath.row + 1;
    for (int i = 0; i < indexPath.section; i++) {
        ERPCategory *category = [mutArrEmergencies objectAtIndex:i];
        if (category.isExpanded) {
            currentIndex += [category.erpTitles count];
        }
    }
    if (currentIndex == 0 || currentIndex % 2 == 0) {
        [aCell setBackgroundColor:[UIColor colorWithRed:228.0/255.0 green:228.0/255.0 blue:228.0/255.0 alpha:1.0]];
    }
    else {
        [aCell setBackgroundColor:[UIColor colorWithRed:241.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0]];
    }
    ERPCategory *category = [mutArrEmergencies objectAtIndex:indexPath.section];
    ERPSubcategory *subCate = [[category.erpTitles allObjects] objectAtIndex:indexPath.row];
    UILabel *aLbl = (UILabel *)[aCell.contentView viewWithTag:2];
    [aLbl setText:subCate.title];
    UIView *aView = [aCell.contentView viewWithTag:4];
    CGRect frame = aView.frame;
    frame.origin.y = aCell.frame.size.height - 3;
    [aView setFrame:frame];
    return aCell;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSInteger currentIndex = section;
    for (int i = 0; i < section; i++) {
        ERPCategory *category = [mutArrEmergencies objectAtIndex:i];
        if (category.isExpanded) {
            currentIndex += [category.erpTitles count];
        }
    }
    
    ERPHeaderView *aHeaderView = [[[NSBundle mainBundle] loadNibNamed:@"ERPHeaderView" owner:self options:nil] firstObject];
    if (currentIndex == 0 || currentIndex % 2 == 0) {
        [aHeaderView setBackgroundColor:[UIColor colorWithRed:228.0/255.0 green:228.0/255.0 blue:228.0/255.0 alpha:1.0]];
    }
    else {
        [aHeaderView setBackgroundColor:[UIColor colorWithRed:241.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0]];
    }
    [aHeaderView.lblSectionHeaser setText:[[mutArrEmergencies objectAtIndex:section] title]];
    [aHeaderView.btnSection setTag:section];
    [aHeaderView.btnSection addTarget:self action:@selector(btnHeaderTapped:) forControlEvents:UIControlEventTouchUpInside];
    BOOL isExpanded = [[mutArrEmergencies objectAtIndex:section] isExpanded];
    if (isExpanded) {
        [aHeaderView.imvExpandCollapse setImage:[UIImage imageNamed:@"collaps_icon@2x.png"]];
    }
    else {
        [aHeaderView.imvExpandCollapse setImage:[UIImage imageNamed:@"expand_icon@2x.png"]];
    }
    return aHeaderView;
}
#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    selectedIndexPath = indexPath;
    [self performSegueWithIdentifier:@"ERPDetails" sender:self];
}

@end
