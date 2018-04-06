//
//  EditWorkOrderViewController.m
//  GoBoardPro
//
//  Created by Optiquall Solutions on 18/12/17.
//  Copyright © 2017 IndiaNIC. All rights reserved.
//

#import "AddNoteWorkOrderViewController.h"
#import "AddNoteTableViewCell.h"
#import "DatePopOverView.h"
#import "DropDownPopOver.h"
#import "UserHomeViewController.h"
#import "SearchWorkOrdersViewController.h"
#import "ThankYouViewController.h"
#import "MyWorkOrdersViewController.h"
@interface AddNoteWorkOrderViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,DropDownValueDelegate,UITextViewDelegate>
    {
        NSMutableArray * arrAssignedTo,*arrStatus;
        NSInteger selectedIndex;
        NSString * selectedNumber;
        NSDictionary * responceDic;
    }
    @property (weak, nonatomic) IBOutlet UITextField *txtWorkOrderID;
    @property (weak, nonatomic) IBOutlet UITextField *txtType;
 //   @property (weak, nonatomic) IBOutlet UITextField *txtImageORVideo;
    @property (weak, nonatomic) IBOutlet UITextField *txtDateSubmitted;
    @property (weak, nonatomic) IBOutlet UITextField *txtCurrentStatus;
    @property (weak, nonatomic) IBOutlet UITextField *txtLastUpdated;
    @property (weak, nonatomic) IBOutlet UITextField *txtUpdatedBy;
    @property (weak, nonatomic) IBOutlet UITextView *txtNotes;
    @property (weak, nonatomic) IBOutlet UITableView *tblAssignedTo;
    @property (weak, nonatomic) IBOutlet UILabel *lblLastUpdated;
    @property (weak, nonatomic) IBOutlet UILabel *lblUpdatedBy;
    @property (weak, nonatomic) IBOutlet UILabel *lblNotes;
    @property (weak, nonatomic) IBOutlet UIImageView *imgBGTableAssignedTo;
    @property (weak, nonatomic) IBOutlet UIImageView *imgBGLastUpdated;
    @property (weak, nonatomic) IBOutlet UIImageView *imgBGDateLastUpdated;
    @property (weak, nonatomic) IBOutlet UIImageView *imgBGUpdatedBy;
    @property (weak, nonatomic) IBOutlet UIImageView *imgBGNotes;
@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;
@property (weak, nonatomic) IBOutlet UILabel *lblAssignTo;
@property (weak, nonatomic) IBOutlet UIView *viewBG;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *lblPlaceholderNotes;

@end

@implementation AddNoteWorkOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    arrAssignedTo = [[NSMutableArray alloc]init];
     arrStatus = [[NSMutableArray alloc]init];
  responceDic = [[NSDictionary alloc]init];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"addNoteWorkOrderRecponce"];
    NSDateFormatter * dateformatter = [[NSDateFormatter alloc]init];
    [dateformatter setDateFormat:@"MM/dd/yyyy"];
   _txtDateSubmitted.text = [dateformatter stringFromDate:[NSDate date]];
    
    [gblAppDelegate showActivityIndicator];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
   
    
    [[WebSerivceCall webServiceObject]callServiceForGetAddNoteWorkOrder:YES orderId:_orderId complition:^{
        
        NSData *dictionaryData = [[NSUserDefaults standardUserDefaults] objectForKey:@"addNoteWorkOrderRecponce"];
        responceDic = [NSKeyedUnarchiver unarchiveObjectWithData:dictionaryData];
        NSLog(@"%@",responceDic);
//        /     [aTempDateFormate setDateFormat:@"MM/dd/yyyy hh:mm a"];
        if ([[responceDic valueForKey:@"Status"]  isKindOfClass:[NSNull class]]) {
            
        }    else{
                arrStatus = [responceDic valueForKey:@"Status"];
        }
  if ([[responceDic valueForKey:@"AssignedToUsers"] isKindOfClass:[NSNull class]]) {
      
  }    else{
      NSArray*tempArrAssignedTo = [responceDic valueForKey:@"AssignedToUsers"];
      //[_tblAssignedTo reloadData];
      
      
      for (int i =0; i<tempArrAssignedTo.count; i++) {
          if ([[[tempArrAssignedTo valueForKey:@"Selected"] objectAtIndex:i] boolValue]) {
              [arrAssignedTo addObject:[tempArrAssignedTo objectAtIndex:i]];
          }
      }
      
  }
     
        
        if ([[responceDic valueForKey:@"WorkOrderIdString"] isKindOfClass:[NSNull class]]) {
            
        }
        else{
            _txtWorkOrderID.text = [responceDic valueForKey:@"WorkOrderIdString"];
        }
        if ([[responceDic valueForKey:@"maintenanceType"] isKindOfClass:[NSNull class]] || [[responceDic valueForKey:@"maintenanceType"] count] == 0) {
            
            
        }
        else{
            _txtType.text = [[[responceDic valueForKey:@"maintenanceType"]valueForKey:@"Text"] objectAtIndex:0];
        }
        if ([[responceDic valueForKey:@"StatusId"]  isKindOfClass:[NSNull class]]) {
            
        }
        else{
            NSLog(@"%@",arrStatus);
            for (int i = 0; i<arrStatus.count; i++) {
                
                NSString * str1 = [NSString stringWithFormat:@"%@",[[arrStatus valueForKey:@"Value"]objectAtIndex:i]];
                NSString * str2 = [NSString stringWithFormat:@"%@",[responceDic valueForKey:@"StatusId"]];
                
                NSLog(@"%@",str1);
                NSLog(@"%@",str2);
                NSLog(@"%@",[[arrStatus valueForKey:@"Text"]objectAtIndex:i]);
                
                if ([str1 isEqualToString:str2]){
                    _txtCurrentStatus.text = [[arrStatus valueForKey:@"Text"]objectAtIndex:i];
                }
            }
            
        }
        
        if ([[responceDic valueForKey:@"IsMediaPresent"]  isKindOfClass:[NSNull class]]) {
            
        }
        else{
            BOOL imgAvailable = [responceDic valueForKey:@"IsMediaPresent"];
            if (imgAvailable) {
                
                //   _txtImageORVideo.text = [NSString stringWithFormat:@"Image available : Yes"];
            }
            else{
                //        _txtImageORVideo.text = [NSString stringWithFormat:@"Image available : No"];
            }
            
        }
        //    if ([[responceDic valueForKey:@"DateSubmited"] isKindOfClass:[NSNull class]]) {
        //
        //
        //    }
        //    else{
        //        //2017-12-25T22:13:00
        //        NSDateFormatter * dateformatter = [[NSDateFormatter alloc]init];
        //            [dateformatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]]; // Prevent adjustment to user's local time zone.
        //        [dateformatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        //        NSDate *date = [dateformatter dateFromString:[responceDic valueForKey:@"DateSubmited"]];
        //        [dateformatter setDateFormat:@"MM/dd/yyyy"];
        //         _txtDateSubmitted.text = [dateformatter stringFromDate:date];
        //    }
//        if ([[responceDic valueForKey:@"AssignedToUsers"] isKindOfClass:[NSNull class]]) {
//            
//        }
//        else{
//            
//            arrAssignedTo = [responceDic valueForKey:@"AssignedToUsers"];
//            [_tblAssignedTo reloadData];
//        }
        
        if ([[responceDic valueForKey:@"LastUpdated"] isKindOfClass:[NSNull class]]) {
            
        }
        else{
            NSDateFormatter * dateformatter = [[NSDateFormatter alloc]init];
            [dateformatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]]; // Prevent adjustment to user's local time zone.
            [dateformatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
            NSDate *date = [dateformatter dateFromString:[responceDic valueForKey:@"LastUpdated"]];
            [dateformatter setDateFormat:@"MM/dd/yyyy"];
            _txtLastUpdated.text = [dateformatter stringFromDate:date];
            
        }
        if ([[responceDic valueForKey:@"UpdatedBy"] isKindOfClass:[NSNull class]]) {
            
        }
        else{
            
            _txtUpdatedBy.text = [responceDic valueForKey:@"UpdatedBy"];
        }
        if ([[responceDic valueForKey:@"Notes"] isKindOfClass:[NSNull class]]) {
            //  _txtNotes.text = @"Notes";
            
            _lblPlaceholderNotes.hidden= NO;
        }
        else{
            if ([[responceDic valueForKey:@"Notes"] isEqualToString:@""]) {
                _lblPlaceholderNotes.hidden= NO;
            }
            else{
                _lblPlaceholderNotes.hidden= YES;
            }
            _txtNotes.text = [responceDic valueForKey:@"Notes"];
        }
      
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tblAssignedTo reloadData];
                 [self viewSetup];
        });

   
        
        
  }];
    
       });
}
-(void)viewSetup{
    
    CGRect frame =  _tblAssignedTo.frame;
    if (arrAssignedTo.count > 3) {
        frame.size.height = 3 * 44;
    }
    else
        frame.size.height = arrAssignedTo.count * 44;
    _tblAssignedTo.frame = frame;
    
    
    if (frame.size.height == 0){
        
        frame.size.height = 0;
        _imgBGTableAssignedTo.frame = frame;
        
//        frame = _lblAssignTo.frame;
//        frame.size.height = 0;
//        _lblAssignTo.frame = frame;
        _lblAssignTo.hidden = YES;
        
        frame = _lblLastUpdated.frame;
        frame.origin.y = _imgBGTableAssignedTo.frame.origin.y + _imgBGTableAssignedTo.frame.size.height + 20;
        _lblLastUpdated.frame = frame;
        
        frame = _imgBGLastUpdated.frame;
        frame.origin.y = _imgBGTableAssignedTo.frame.origin.y + _imgBGTableAssignedTo.frame.size.height + 20;
        _imgBGLastUpdated.frame = frame;
    }
    else{
        _lblAssignTo.hidden = NO;
        
        frame.size.height = frame.size.height + 10;
        _imgBGTableAssignedTo.frame = frame;
        
        frame = _lblLastUpdated.frame;
        frame.origin.y = _imgBGTableAssignedTo.frame.origin.y + _imgBGTableAssignedTo.frame.size.height + 20;
        _lblLastUpdated.frame = frame;
        
        frame = _imgBGLastUpdated.frame;
        frame.origin.y = _imgBGTableAssignedTo.frame.origin.y + _imgBGTableAssignedTo.frame.size.height + 20;
        _imgBGLastUpdated.frame = frame;
    }
    frame = _txtLastUpdated.frame;
    frame.origin.y = _imgBGLastUpdated.frame.origin.y + 10;
    _txtLastUpdated.frame = frame;
    
    frame = _imgBGDateLastUpdated.frame;
    frame.origin.y = _imgBGLastUpdated.frame.origin.y + 5;
    _imgBGDateLastUpdated.frame = frame;
    
    frame = _lblUpdatedBy.frame;
    frame.origin.y = _imgBGLastUpdated.frame.origin.y + _imgBGLastUpdated.frame.size.height + 20;
    _lblUpdatedBy.frame = frame;
    
    frame = _imgBGUpdatedBy.frame;
    frame.origin.y = _imgBGLastUpdated.frame.origin.y + _imgBGLastUpdated.frame.size.height + 20;
    _imgBGUpdatedBy.frame = frame;
    
    frame = _txtUpdatedBy.frame;
    frame.origin.y = _imgBGUpdatedBy.frame.origin.y + 10;
    _txtUpdatedBy.frame = frame;
    
    frame = _lblNotes.frame;
    frame.origin.y = _imgBGUpdatedBy.frame.origin.y + _imgBGUpdatedBy.frame.size.height + 20;
    _lblNotes.frame = frame;
    
    frame = _imgBGNotes.frame;
    frame.origin.y = _imgBGUpdatedBy.frame.origin.y + _imgBGUpdatedBy.frame.size.height + 20;
    _imgBGNotes.frame = frame;
    
    frame = _txtNotes.frame;
    frame.origin.y = _imgBGNotes.frame.origin.y + 10;
    _txtNotes.frame = frame;
    
    frame = _lblPlaceholderNotes.frame;
    frame.origin.y = _imgBGNotes.frame.origin.y + 20;
    _lblPlaceholderNotes.frame = frame;
    
    frame = _btnSubmit.frame;
    frame.origin.y =  _imgBGNotes.frame.origin.y + _imgBGNotes.frame.size.height + 40;
    _btnSubmit.frame = frame;
    
    
    
    frame = _viewBG.frame;
    frame.size.height = _btnSubmit.frame.origin.y +_btnSubmit.frame.size.height + 30;
    _viewBG.frame = frame;
    frame = _scrollView.frame;
    frame.size.height = _btnSubmit.frame.origin.y +_btnSubmit.frame.size.height + 30;
    [_scrollView setContentSize:CGSizeMake(_scrollView.frame.size.width, CGRectGetMaxY(frame))];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [self viewSetup];
}
- (IBAction)btnBackTapped:(UIButton *)sender {
    for (UIViewController *aVCObj in self.navigationController.viewControllers) {
        if ([aVCObj isKindOfClass:[MyWorkOrdersViewController class]]) {
            [self.navigationController popToViewController:aVCObj animated:YES];
        }
    }
    
}
-(BOOL)validation{
    if ([_txtCurrentStatus.text isEqualToString:@""]) {
        return NO;
    }
    else if ([_txtNotes.text isEqualToString:@""]) {
        return NO;
    }
//    else if ([_txtDateSubmitted.text isEqualToString:@""]) {
//        return NO;
//    }
       return YES;
}
- (IBAction)btnSubmitTapped:(UIButton *)sender {
    
    NSString * statusID = @"2";
    NSString * statusDate = @"";
    NSDateFormatter * dateformatter = [[NSDateFormatter alloc]init];
    [dateformatter setDateFormat:@"MM/dd/yyyy"];
    NSDate *from = [dateformatter dateFromString:_txtDateSubmitted.text];
    
    [dateformatter setDateFormat:@"yyyy/MM/dd"];
    statusDate = [dateformatter stringFromDate:from];
    if (arrStatus.count != 0) {
        for (int i = 0; i<arrStatus.count; i++) {
            if ([_txtCurrentStatus.text isEqualToString:[[arrStatus valueForKey:@"Text"] objectAtIndex:i]]) {
                statusID = [[arrStatus valueForKey:@"Value"] objectAtIndex:i];
            }
        }
    }
   [[WebSerivceCall webServiceObject]callServiceForUpdateAddNoteWorkOrder:YES orderId:_orderId statusId:statusID notesId:_txtNotes.text dateSubmited:statusDate sequence:[responceDic valueForKey:@"Sequence"] complition:^{
  
              [self performSegueWithIdentifier:@"ThankYouEditScreen" sender:nil];

 }];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
        return arrAssignedTo.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath    {
        
    AddNoteTableViewCell *aCell =  [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    aCell.lblAssignedTo.text = [[arrAssignedTo valueForKey:@"Text"]objectAtIndex:indexPath.row];
    return aCell;
}
    
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
    
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    BOOL allowEditing = YES;
    if ([textField isEqual:_txtDateSubmitted]) {
        DatePopOverView *datePopOver = (DatePopOverView *)[[[NSBundle mainBundle] loadNibNamed:@"DatePopOverView" owner:self options:nil] firstObject];
        [datePopOver showInPopOverFor:textField limit:DATE_LIMIT_ALL_DATE option:DATE_SELECTION_DATE_ONLY updateField:textField];
        allowEditing = NO;
    }
//    else if ([textField isEqual:_txtCurrentStatus]){
//
//
//        DropDownPopOver *dropDown = (DropDownPopOver*)[[[NSBundle mainBundle] loadNibNamed:@"DropDownPopOver" owner:self options:nil] firstObject];
//        dropDown.delegate = self;
//        [dropDown showDropDownWith:arrStatus view:textField key:@"Text"];
//        allowEditing = NO;
//
//    }
    return allowEditing;
}
- (void)dropDownControllerDidSelectValue:(id)value atIndex:(NSInteger)index sender:(id)sender {

    [sender setText:[value valueForKey:@"Text"]];
}
- (IBAction)buttonSubmit:(id)sender {
    
}
-(void)textViewDidBeginEditing:(UITextView *)textView{
    _lblPlaceholderNotes.hidden= YES;
}
-(void)textViewDidEndEditing:(UITextView *)textView{
    if ([textView.text isEqualToString: @""]){
          _lblPlaceholderNotes.hidden= NO;
    }
    else{
          _lblPlaceholderNotes.hidden= YES;
    }
    
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ThankYouEditScreen"]) {
        ThankYouViewController *thanksVC = (ThankYouViewController*)segue.destinationViewController;
        thanksVC.strMsg = @"Thank you. Your Work Order has been updated successfully.";
        thanksVC.strBackTitle = @"Back to Work Order list";
    }
}



@end
