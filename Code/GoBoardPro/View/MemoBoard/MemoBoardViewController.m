//
//  MemoBoardViewController.m
//  GoBoardPro
//
//  Created by ind558 on 11/12/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import "MemoBoardViewController.h"

@interface MemoBoardViewController ()

@end

@implementation MemoBoardViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    //changes by chetan kasundra
    // Add the sorting Funcationality with Date and Time
    
    mutArrMemoListTemp=[[NSMutableArray alloc]init];
    
    for (NSMutableDictionary *dic in [gblAppDelegate.mutArrMemoList mutableCopy])
    {
        NSString *strDate=[[dic[@"Date"] componentsSeparatedByString:@"."] firstObject ];
        NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        NSDate *date=[formatter dateFromString:strDate];
        
        [formatter setTimeZone:[NSTimeZone systemTimeZone]];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSString *date1=[formatter stringFromDate:date];
        [formatter setDateFormat:@"HH:mm:ss"];
        NSString *time1=[formatter stringFromDate:date];
        [dic setValue:date1 forKey:@"Date1"];
        [dic setValue:time1 forKey:@"Time1"];
    
        [mutArrMemoListTemp addObject:dic];
    }
    
    NSSortDescriptor *sortDescriptorDate=[[NSSortDescriptor alloc]initWithKey:@"Date1" ascending:NO];
    NSSortDescriptor *sortDescriptorTime=[[NSSortDescriptor alloc]initWithKey:@"Time1" ascending:NO];
        
    [mutArrMemoListTemp sortUsingDescriptors:@[sortDescriptorDate,sortDescriptorTime]];
    mutArrMemoList=mutArrMemoListTemp;

    //-------------------------------//
    
    mutArrSelectedMemo = [NSMutableArray array];
    // Do any additional setup after loading the view.
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


- (IBAction)btnBackTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnDeleteTapped:(id)sender {
    if ([mutArrSelectedMemo count] == 0) {
        alert(@"", @"Please select memos to delete.");
        return;
    }
    NSMutableArray *mutArrIds = [NSMutableArray array];
    for (NSIndexPath *indexPath in mutArrSelectedMemo) {
        [mutArrIds addObject:mutArrMemoList[indexPath.row][@"Id"]];
    }
    NSDictionary *aDict = @{@"UserId":[[User currentUser] userId], @"MemoIds":mutArrIds};
    [gblAppDelegate callWebService:MEMO parameters:aDict httpMethod:@"DELETE" complition:^(NSDictionary *response) {
        for (NSIndexPath *indexPath in mutArrSelectedMemo) {
            [mutArrMemoList removeObjectAtIndex:indexPath.row];
        }
        alert(@"", @"Selected memos has been deleted");
        [_tblMemoList reloadData];
    } failure:^(NSError *error, NSDictionary *response) {
        
    }];
}

- (void)btnCheckboxTapped:(UIButton *)sender {
    [sender setSelected:!sender.isSelected];
    UITableViewCell *aCell = (UITableViewCell *)sender.superview;
    while (![aCell isKindOfClass:[UITableViewCell class]]) {
        aCell = (UITableViewCell *)aCell.superview;
    }
    NSIndexPath *indexPath = [_tblMemoList indexPathForCell:aCell];
    if (sender.isSelected) {
        [mutArrSelectedMemo addObject:indexPath];
    }
    else {
        [mutArrSelectedMemo removeObject:indexPath];
    }
}

#pragma mark - Methods

#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [mutArrMemoList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *aCell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    UILabel *aLblTo = (UILabel*)[aCell.contentView viewWithTag:3];
    UILabel *aLblSubject = (UILabel*)[aCell.contentView viewWithTag:4];
    UILabel *aLblDate = (UILabel*)[aCell.contentView viewWithTag:5];
    UILabel *aLblTime = (UILabel*)[aCell.contentView viewWithTag:6];
    UILabel *aLblFrom = (UILabel*)[aCell.contentView viewWithTag:7];
    UIButton *aBtn = (UIButton*)[aCell.contentView viewWithTag:8];
    NSDictionary *aDict = mutArrMemoList[indexPath.row];
    [aLblTo setText:[NSString stringWithFormat:@"To: %@", aDict[@"To"]]];
    [aLblFrom setText:[NSString stringWithFormat:@"From: %@", aDict[@"From"]]];
    [aLblSubject setText:[NSString stringWithFormat:@"Subject: %@", aDict[@"Subject"]]];
//    2014-12-12T05:19:55.4471315+00:00
    NSString *aStrDate = [[aDict[@"Date"] componentsSeparatedByString:@"."] firstObject];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    //[formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    NSDate *aDate = [formatter dateFromString:aStrDate];
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
    [formatter setDateFormat:@"MM/dd/yyyy"];
    aLblDate.text = [NSString stringWithFormat:@"Date: %@", [formatter stringFromDate:aDate]];
    [formatter setDateFormat:@"hh:mm a"];
    aLblTime.text = [NSString stringWithFormat:@"Time: %@", [formatter stringFromDate:aDate]];
    
    [aBtn addTarget:self action:@selector(btnCheckboxTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    UIFont *font = nil;
    if (![aDict[@"IsRead"] boolValue]) {
        font = [UIFont boldSystemFontOfSize:17.0];
    }
    else {
        font = [UIFont systemFontOfSize:17.0];
    }
    aLblTo.font = font;
    aLblFrom.font = font;
    aLblSubject.font = font;
    aLblDate.font = font;
    aLblTime.font = font;
    [aCell setBackgroundColor:[UIColor clearColor]];
    
    return aCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (popOver) {
        [popOver dismissPopoverAnimated:NO];
        popOver.contentViewController.view = nil;
        popOver = nil;
    }
    if (![[[mutArrMemoList objectAtIndex:indexPath.row] objectForKey:@"IsRead"] boolValue]) {
        [self markMemoAsRead:indexPath.row];
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
    
   // _txvPopOver.text=@"Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?";
    _txvPopOver.text = [[mutArrMemoList objectAtIndex:indexPath.row] objectForKey:@"Body"];
    UIViewController *viewController = [[UIViewController alloc] init];
    viewController.view = _vwPopOver;
    popOver = [[UIPopoverController alloc] initWithContentViewController:viewController];
    viewController = nil;
    [popOver setDelegate:self];
    [popOver setPopoverContentSize:_vwPopOver.frame.size];
    UITableViewCell *aCell = [tableView cellForRowAtIndexPath:indexPath];
    CGRect frame = [tableView convertRect:aCell.frame toView:self.view];
    [popOver presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    popOver.contentViewController.view = nil;
    popOver = nil;
}


- (void)markMemoAsRead:(NSInteger)index {
    NSString *memoId = mutArrMemoList[index][@"Id"];
    [gblAppDelegate callWebService:[NSString stringWithFormat:@"%@?memoId=%@&userId=%@", MEMO, memoId, [[User currentUser] userId]] parameters:nil httpMethod:@"POST" complition:^(NSDictionary *response) {
        [mutArrMemoList[index] setObject:[NSNumber numberWithBool:YES] forKey:@"IsRead"];
        [_tblMemoList reloadData];
    } failure:^(NSError *error, NSDictionary *response) {
       
    }];
}

@end
