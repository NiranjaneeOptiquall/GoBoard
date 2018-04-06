//
//  CreateWorkOrderViewController.m
//  GoBoardPro
//
//  Created by Optiquall Solutions on 21/12/17.
//  Copyright © 2017 IndiaNIC. All rights reserved.
//

#import "CreateWorkOrderViewController.h"
#import "MyWorkOrdersTableViewCell.h"
#import "CreateWorkOrderTableViewCell.h"
#import "DatePopOverView.h"
#import "DropDownPopOver.h"
#import "UserHomeViewController.h"
#import "SearchWorkOrdersViewController.h"
#import "ALAssetsLibrary+CustomPhotoAlbum.h"
#import <AVKit/AVKit.h>

@import AVFoundation;

@interface CreateWorkOrderViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,DropDownValueDelegate,UIPopoverControllerDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate,AVCaptureMetadataOutputObjectsDelegate,UITextViewDelegate>
{
     CGRect rect;
      UIPopoverController *popOver;
    NSMutableArray * arrAssignedTo,*arrStatus,*arrCategoty,*arrGenralNature,*arrGenralActionTaken,*arrEquipmentNature,*arrEquipmentActionTaken,*arrRepairType,*arrInventoryPartsUsed,*arrPositon,*arrUsers,*arrNotification,*arrVideoOrImage,*arrInventoryPartUsed,*arrManufactur,*arrEquipmentType,*arrModel,*arrBrand,*selectedPositionArr,*selectedUserArr,*arrEquipmentId,*arrEmployeeReq,*arrEquipmentReq,*arrGenReq;
    NSInteger selectedImgVidIndex;
    NSString * selectedNumber,*tempstrDataType,*selectedStatusId,*selectedNature,*selectedActionTaken,*flagReloadHeader,*selectedFacilityId,*selectedLocationId,*flagServiseCall;
    NSDictionary * responceDic,*equipmentResponceDic,*responceEquipmentIdDic;
    NSMutableDictionary *submitDic;
    NSInteger  totalSizeOFUploadedVideo;
    NSMutableArray *arrFacility,*arrLocation;
   UIButton * tempBtn;
    UILabel * disclaimer,*disclaimerNote;
}
@property (strong, nonatomic) AVPlayerViewController *playerViewController;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewPhotoVideo;
@property (weak, nonatomic) IBOutlet UIView *viewFullBGImageVideo;
@property (weak, nonatomic) IBOutlet UILabel *lblShowImageVideo;
@property (weak, nonatomic) IBOutlet UIButton *btnBackground;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UILabel *lblInstructions;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UIImageView *imgBgDateOfWorkOrder;
@property (weak, nonatomic) IBOutlet UIImageView *imgDateOfWorkOrder;
@property (weak, nonatomic) IBOutlet UITextField *txtDateOfWorkOrder;
@property (weak, nonatomic) IBOutlet UITextField *txtFacilityRelatedToWorkOrder;
@property (weak, nonatomic) IBOutlet UIImageView *imgBGTimeWorkOrder;
@property (weak, nonatomic) IBOutlet UIImageView *imgTime;
@property (weak, nonatomic) IBOutlet UITextField *txtTimeWorkOrder;
@property (weak, nonatomic) IBOutlet UIImageView *imgBGLocationWorkOrder;
@property (weak, nonatomic) IBOutlet UIImageView *imgLocation;
@property (weak, nonatomic) IBOutlet UITextField *txtLocation;
@property (weak, nonatomic) IBOutlet UIImageView *imgBGFacility;
@property (weak, nonatomic) IBOutlet UIImageView *imgFacility;
@property (weak, nonatomic) IBOutlet UIImageView *imgBgCategory;
@property (weak, nonatomic) IBOutlet UIImageView *imgCategory;
@property (weak, nonatomic) IBOutlet UITextField *txtCategory;
@property (weak, nonatomic) IBOutlet UIImageView *imgBGDescriptionIssue;
@property (weak, nonatomic) IBOutlet UILabel *lblBgDescriptionIssue;
@property (weak, nonatomic) IBOutlet UILabel *lblStarDescriptionIssue;
@property (weak, nonatomic) IBOutlet UITextView *txtDescriptionIssue;
@property (weak, nonatomic) IBOutlet UILabel *lblServity;
@property (weak, nonatomic) IBOutlet UIButton *radioBtnServity1;
@property (weak, nonatomic) IBOutlet UIButton *radioBtnServity2;
@property (weak, nonatomic) IBOutlet UIButton *radioBtnServity3;
@property (weak, nonatomic) IBOutlet UIButton *radioBtnServity4;
@property (weak, nonatomic) IBOutlet UILabel *lblMaintenanceType;
@property (weak, nonatomic) IBOutlet UIButton *radioBtnMaintenanceType1;
@property (weak, nonatomic) IBOutlet UIButton *radioBtnMaintenanceType2;
@property (weak, nonatomic) IBOutlet UITextField *txtNature;
@property (weak, nonatomic) IBOutlet UIImageView *imgBgNature;
@property (weak, nonatomic) IBOutlet UIImageView *imgNature;
@property (weak, nonatomic) IBOutlet UITextField *txtActionTaken;
@property (weak, nonatomic) IBOutlet UIImageView *imgBgActionTaken;
@property (weak, nonatomic) IBOutlet UIImageView *imgActionTaken;
@property (weak, nonatomic) IBOutlet UILabel *lblTitleGeneralActionTaken;
@property (weak, nonatomic) IBOutlet UIWebView *webViewVideoShow;

@property (weak, nonatomic) IBOutlet UILabel *lblAddImg;
@property (weak, nonatomic) IBOutlet UIButton *radioBtnImg;
@property (weak, nonatomic) IBOutlet UIButton *radioBtnVideo;
@property (weak, nonatomic) IBOutlet UITableView *tblVideoList;
@property (weak, nonatomic) IBOutlet UILabel *lblVideo;
@property (weak, nonatomic) IBOutlet UIButton *btnAttachVideoOrPhoto;
@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;
@property (weak, nonatomic) IBOutlet UITableView *tblScrollBG;
@property (weak, nonatomic) IBOutlet UIView *viewTblHeader;
@property (strong, nonatomic) UIImage *imgBodilyFluid;
@property (weak, nonatomic) IBOutlet UIView *viewBGVideoImage;
@property (weak, nonatomic) IBOutlet UIView *viewBgBarcode;
@property (weak, nonatomic) IBOutlet UIImageView *imgBgQRCode;
@property (weak, nonatomic) IBOutlet UITextField *txtQRCode;
@property (weak, nonatomic) IBOutlet UIImageView *imgBGEquipmentId;
@property (weak, nonatomic) IBOutlet UITextField *txtEquipmentId;
@property (weak, nonatomic) IBOutlet UIImageView *imgBgSerialId;
@property (weak, nonatomic) IBOutlet UITextField *txtSerialId;
@property (weak, nonatomic) IBOutlet UIImageView *imgBgEquipmentName;
@property (weak, nonatomic) IBOutlet UITextField *txtEquipmentName;
@property (weak, nonatomic) IBOutlet UIImageView *imgBgManufacture;
@property (weak, nonatomic) IBOutlet UIImageView *imgManufacture;
@property (weak, nonatomic) IBOutlet UITextField *txtManufacture;
@property (weak, nonatomic) IBOutlet UIImageView *imgBgType;
@property (weak, nonatomic) IBOutlet UIImageView *imgType;
@property (weak, nonatomic) IBOutlet UITextField *txtType;
@property (weak, nonatomic) IBOutlet UIImageView *imgBgMode;
@property (weak, nonatomic) IBOutlet UIImageView *imgMode;
@property (weak, nonatomic) IBOutlet UITextField *txtMode;
@property (weak, nonatomic) IBOutlet UIImageView *imgBgBrand;
@property (weak, nonatomic) IBOutlet UIImageView *imgBrand;
@property (weak, nonatomic) IBOutlet UITextField *txtBrand;
@property (weak, nonatomic) IBOutlet UIImageView *imgBgNature2;
@property (weak, nonatomic) IBOutlet UIImageView *imgNature2;
@property (weak, nonatomic) IBOutlet UITextField *txtNature2;
@property (weak, nonatomic) IBOutlet UIImageView *imgBgActionTaken2;
@property (weak, nonatomic) IBOutlet UIImageView *imgActionTaken2;
@property (weak, nonatomic) IBOutlet UITextField *txtActionTaken2;
@property (weak, nonatomic) IBOutlet UIButton *btnFill;
@property (weak, nonatomic) IBOutlet UILabel *lblEmployeeReprt;
@property (weak, nonatomic) IBOutlet UIImageView *imgBgFname;
@property (weak, nonatomic) IBOutlet UITextField *txtFname;
@property (weak, nonatomic) IBOutlet UIImageView *imgBgMname;
@property (weak, nonatomic) IBOutlet UITextField *txtMname;
@property (weak, nonatomic) IBOutlet UIImageView *imgBgLname;
@property (weak, nonatomic) IBOutlet UITextField *txtLname;
@property (weak, nonatomic) IBOutlet UIImageView *imgBgEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
//@property (weak, nonatomic) IBOutlet UIImageView *imgBgAlertBriefDesc;
//@property (weak, nonatomic) IBOutlet UILabel *lblAlertBriefDesc;
//@property (weak, nonatomic) IBOutlet UITextView *txtAlertBriefDesc;
@property (weak, nonatomic) IBOutlet UIImageView *imgBgAddiInfo;
@property (weak, nonatomic) IBOutlet UILabel *lblAddiInfo;
@property (weak, nonatomic) IBOutlet UITextView *txtAddiInfo;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;

@property (weak, nonatomic) IBOutlet UIImageView *imgBgStatus;
@property (weak, nonatomic) IBOutlet UIImageView *imgStatus;
@property (weak, nonatomic) IBOutlet UITextField *txtStatus;
@property (weak, nonatomic) IBOutlet UILabel *lblStarDateofAccident;
@property (weak, nonatomic) IBOutlet UILabel *lblStarTimeofAccident;
@property (weak, nonatomic) IBOutlet UILabel *lblStarFacility;
@property (weak, nonatomic) IBOutlet UILabel *lblStarLocation;
@property (weak, nonatomic) IBOutlet UILabel *lblStarCategory;
@property (weak, nonatomic) IBOutlet UILabel *lblStarStatus;
@property (weak, nonatomic) IBOutlet UIButton *btnSubmitLatter;
@property (weak, nonatomic) IBOutlet UILabel *lblInventoryNotFound;

@property (weak, nonatomic) IBOutlet UILabel *lblStarGNature;
@property (weak, nonatomic) IBOutlet UILabel *lblStarGAction;
@property (weak, nonatomic) IBOutlet UILabel *lblStarEqipId;
@property (weak, nonatomic) IBOutlet UILabel *lblStarSerialId;
@property (weak, nonatomic) IBOutlet UILabel *lblStarEqipName;
@property (weak, nonatomic) IBOutlet UILabel *lblStarManufact;
@property (weak, nonatomic) IBOutlet UILabel *lblStarEqType;
@property (weak, nonatomic) IBOutlet UILabel *lblStarEqMode;
@property (weak, nonatomic) IBOutlet UILabel *lblStarEqBrand;
@property (weak, nonatomic) IBOutlet UILabel *lblStarEqNature;
@property (weak, nonatomic) IBOutlet UILabel *lblStarEqAction;
@property (weak, nonatomic) IBOutlet UILabel *lblStarFName;
@property (weak, nonatomic) IBOutlet UILabel *lblStarMName;
@property (weak, nonatomic) IBOutlet UILabel *lblStarLName;
@property (weak, nonatomic) IBOutlet UILabel *lblStarEmail;
@property (weak, nonatomic) IBOutlet UIButton *btnScanCode;

@end

@implementation CreateWorkOrderViewController
{
    AVCaptureSession *captureSession;
    AVCaptureVideoPreviewLayer *captureLayer;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _isUpdate = NO;
    
    disclaimer = [[UILabel alloc]init];
    disclaimer.backgroundColor = [UIColor clearColor];
    disclaimer.text = @"Disclaimer";
    disclaimer.font = [UIFont systemFontOfSize:22.0f];
    disclaimer.textColor = [UIColor whiteColor];
    [disclaimer setTextAlignment:NSTextAlignmentCenter];
    [_viewTblHeader addSubview:disclaimer];
    disclaimer.hidden=YES;
    
    disclaimerNote = [[UILabel alloc]init];
    disclaimerNote.backgroundColor = [UIColor clearColor];
    disclaimerNote.text = @"You understand that by selecting the severity noted with (A), an alert will be sent to inform the appropriate parties that a work order has been created.";
    disclaimerNote.font = [UIFont systemFontOfSize:15.0f];
    disclaimerNote.numberOfLines = 2;
    disclaimerNote.lineBreakMode = NSLineBreakByWordWrapping;
    disclaimerNote.textColor = [UIColor colorWithHexCodeString:@"#149F9E"];
    [disclaimerNote setTextAlignment:NSTextAlignmentCenter];
    [_viewTblHeader addSubview:disclaimerNote];
    disclaimerNote.hidden=YES;
    
    tempBtn = [[UIButton alloc]init];
    
    selectedLocationId=@"";
    _btnBackground.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    flagServiseCall = @"YES";
    _viewBGVideoImage.hidden = YES;
        _viewFullBGImageVideo.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
     //_viewBgHeaderAddInventoryPart.hidden = YES;
    flagReloadHeader = @"YES";
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    _viewBgBarcode.hidden = YES;
    _txtDateOfWorkOrder.text = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:[NSDate date]]];
     [dateFormatter setDateFormat:@"hh:mm a"];
    _txtTimeWorkOrder.text = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:[NSDate date]]];
   
    [_tblVideoList sizeToFit];
    [_tblScrollBG sizeToFit];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _tblVideoList.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, _tblVideoList.bounds.size.width, 0.01f)];
    _tblScrollBG.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, _tblScrollBG.bounds.size.width, 0.01f)];

    _tblVideoList.frame = CGRectMake(_tblVideoList.frame.origin.x, _tblVideoList.frame.origin.y, _tblVideoList.frame.size.width, 200);
    _tblScrollBG.frame = CGRectMake(0, 89, 768, 900);
  
    self.edgesForExtendedLayout = UIRectEdgeNone;
    arrAssignedTo = [[NSMutableArray alloc]init];
    arrStatus = [[NSMutableArray alloc]init];
    arrFacility = [[NSMutableArray alloc]init];
    arrLocation = [[NSMutableArray alloc]init];
    arrCategoty = [[NSMutableArray alloc]init];
    arrGenralNature = [[NSMutableArray alloc]init];
    arrGenralActionTaken= [[NSMutableArray alloc]init];
    arrEquipmentNature = [[NSMutableArray alloc]init];
    arrEquipmentActionTaken= [[NSMutableArray alloc]init];
    arrRepairType = [[NSMutableArray alloc]init];
    arrInventoryPartsUsed = [[NSMutableArray alloc]init];
    arrPositon = [[NSMutableArray alloc]init];
    arrUsers = [[NSMutableArray alloc]init];
    arrNotification = [[NSMutableArray alloc]init];
    arrVideoOrImage = [[NSMutableArray alloc]init];
    arrInventoryPartUsed = [[NSMutableArray alloc]init];
    arrManufactur = [[NSMutableArray alloc]init];
    arrEquipmentType = [[NSMutableArray alloc]init];
    arrModel = [[NSMutableArray alloc]init];
    arrBrand = [[NSMutableArray alloc]init];
    selectedUserArr = [[NSMutableArray alloc]init];
    selectedPositionArr = [[NSMutableArray alloc]init];
    arrEquipmentId = [[NSMutableArray alloc]init];
    submitDic =[[NSMutableDictionary alloc]init];
    arrEmployeeReq = [[NSMutableArray alloc]init];
  arrEquipmentReq = [[NSMutableArray alloc]init];
    arrGenReq = [[NSMutableArray alloc]init];
    
    _lblStarGNature.hidden = YES;
    _lblStarGAction.hidden = YES;
    
    _lblStarEqipId.hidden = YES;
    _lblStarSerialId.hidden = YES;
    _lblStarEqipName.hidden = YES;
    _lblStarManufact.hidden = YES;
    _lblStarEqType.hidden = YES;
    _lblStarEqMode.hidden = YES;
    _lblStarEqBrand.hidden = YES;
    _lblStarEqNature.hidden = YES;
    _lblStarEqAction.hidden = YES;
    
    _lblStarMName.hidden = YES;
    _lblStarLName.hidden = YES;
    _lblStarEmail.hidden = YES;
    _lblStarFName.hidden = YES;

    
    if ([User checkUserExist]) {
  
            _txtFname.text = [[User currentUser] firstName];
       
        if ([[User currentUser] middleInitials]) {
            _txtMname.text = @"";
        }
        else{
            _txtMname.text = [[[User currentUser] middleInitials] substringToIndex:1];
        }
        
            _txtLname.text = [[User currentUser] lastName];
        
        
       
            _txtEmail.text = [[User currentUser] email];
        
        
    }

    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"UserFacility"];
    [request setPropertiesToFetch:@[@"name", @"value"]];
    NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    [request setSortDescriptors:@[sortByName]];
    NSArray * arr = [gblAppDelegate.managedObjectContext executeFetchRequest:request error:nil];
    arrFacility = [arr mutableCopy];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"createWorkOrderRecponce"];
 
    
    [gblAppDelegate showActivityIndicator];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
    
    [[WebSerivceCall webServiceObject]callServiceForGetCreateWorkOrder:YES complition:^{
        
        NSData *dictionaryData = [[NSUserDefaults standardUserDefaults] objectForKey:@"createWorkOrderRecponce"];
        responceDic = [NSKeyedUnarchiver unarchiveObjectWithData:dictionaryData];
    //    //NSLog(@"%@",responceDic);
        
  // [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//       if ([responceDic isKindOfClass:[NSNull class]] || responceDic == nil) {
//              //[self.navigationController popViewControllerAnimated:YES];
//           [self btnBackTapped:_btnBack];
//        }
   //       }];
        arrCategoty = [[responceDic valueForKey:@"WorkOrderSetupModel"] valueForKey:@"CategoryOptions"];
        arrEquipmentNature = [[responceDic valueForKey:@"WorkOrderSetupModel"] valueForKey:@"EquipmentNatureOptions"];
        arrEquipmentActionTaken = [[responceDic valueForKey:@"WorkOrderSetupModel"] valueForKey:@"EquipmentActionOptions"];
        arrGenralNature = [[responceDic valueForKey:@"WorkOrderSetupModel"] valueForKey:@"GeneralNatureOptions"];
        arrGenralActionTaken = [[responceDic valueForKey:@"WorkOrderSetupModel"] valueForKey:@"GeneralActionOptions"];
        arrStatus = [[responceDic valueForKey:@"WorkOrderSetupModel"] valueForKey:@"StatusOptions"];
     //   arrInventoryPartsUsed = [[responceDic valueForKey:@"WorkOrderSetupModel"] valueForKey:@"InventoryPartsUsedOptions"];
        arrPositon = [[responceDic valueForKey:@"WorkOrderSetupModel"] valueForKey:@"PositionOptions"];
        arrUsers = [[responceDic valueForKey:@"WorkOrderSetupModel"] valueForKey:@"UserItems"];
        arrNotification = [[responceDic valueForKey:@"WorkOrderSetupModel"] valueForKey:@"NotificationFieldOptions"];
        arrManufactur = [[responceDic valueForKey:@"WorkOrderSetupModel"] valueForKey:@"ManufactureOptions"];
        arrEquipmentType = [[responceDic valueForKey:@"WorkOrderSetupModel"] valueForKey:@"InventoryType"];
        arrModel = [[responceDic valueForKey:@"WorkOrderSetupModel"] valueForKey:@"ModelOptions"];
        arrBrand = [[responceDic valueForKey:@"WorkOrderSetupModel"] valueForKey:@"BrandOptions"];
        arrRepairType = [[responceDic valueForKey:@"WorkOrderSetupModel"] valueForKey:@"RepairTypeOptions"];
        arrEquipmentReq = [[responceDic valueForKey:@"WorkOrderSetupModel"] valueForKey:@"EquipmentRequiredFields"];
         arrGenReq = [[responceDic valueForKey:@"WorkOrderSetupModel"] valueForKey:@"GeneralMaintenanceRequiredFields"];
        arrEmployeeReq = [[responceDic valueForKey:@"WorkOrderSetupModel"] valueForKey:@"EmployeeRequiredFields"];
        _lblInstructions.text = [[responceDic valueForKey:@"WorkOrderSetupModel"] valueForKey:@"Instructions"];
        [_radioBtnMaintenanceType1 setSelected:YES];
        [_radioBtnImg setSelected:YES];
        _lblVideo.text = @"Image(s)";
        _lblBgDescriptionIssue.text = [[responceDic valueForKey:@"WorkOrderSetupModel"] valueForKey:@"Description"];
        [_btnAttachVideoOrPhoto setTitle:@"Attach image" forState:UIControlStateNormal];
        
        if ([[[arrNotification valueForKey:@"Visible"] objectAtIndex:0] boolValue]) {
            if (![[[arrNotification valueForKey:@"Text"] objectAtIndex:0] isKindOfClass:[NSNull class]]) {
                if ([[[arrNotification valueForKey:@"Alert"] objectAtIndex:0] boolValue]) {
                    [_radioBtnServity1 setTitle:[NSString stringWithFormat:@"%@ (A)",[[arrNotification valueForKey:@"Text"] objectAtIndex:0]] forState:UIControlStateNormal];
                }
                else{
                    [_radioBtnServity1 setTitle:[[arrNotification valueForKey:@"Text"] objectAtIndex:0] forState:UIControlStateNormal];
                }
            }
            else{
                [_radioBtnServity1 setHidden:YES];
            }

        }
        else{
            [_radioBtnServity1 setHidden:YES];
        }
        
        if ([[[arrNotification valueForKey:@"Visible"] objectAtIndex:1] boolValue]) {
            if (![[[arrNotification valueForKey:@"Text"] objectAtIndex:1] isKindOfClass:[NSNull class]]) {
                if ([[[arrNotification valueForKey:@"Alert"] objectAtIndex:1] boolValue]) {
                    [_radioBtnServity2 setTitle:[NSString stringWithFormat:@"%@ (A)",[[arrNotification valueForKey:@"Text"] objectAtIndex:1]] forState:UIControlStateNormal];
                    
                }
                else{
                    [_radioBtnServity2 setTitle:[[arrNotification valueForKey:@"Text"] objectAtIndex:1] forState:UIControlStateNormal];
                    
                }
                
            }
            else{
                [_radioBtnServity2 setHidden:YES];
            }
        }
        else{
            [_radioBtnServity2 setHidden:YES];
        }

        
   if ([[[arrNotification valueForKey:@"Visible"] objectAtIndex:2] boolValue]) {
                if (![[[arrNotification valueForKey:@"Text"] objectAtIndex:2] isKindOfClass:[NSNull class]]) {
                    if ([[[arrNotification valueForKey:@"Alert"] objectAtIndex:2] boolValue]) {
                        [_radioBtnServity3 setTitle:[NSString stringWithFormat:@"%@ (A)",[[arrNotification valueForKey:@"Text"] objectAtIndex:2]] forState:UIControlStateNormal];
                        
                    }
                    else{
                        [_radioBtnServity3 setTitle:[[arrNotification valueForKey:@"Text"] objectAtIndex:2] forState:UIControlStateNormal];
                        
                    }

        }
        else{
            [_radioBtnServity3 setHidden:YES];
        }
   }
   else{
       [_radioBtnServity3 setHidden:YES];
   }
         if ([[[arrNotification valueForKey:@"Visible"] objectAtIndex:3] boolValue]) {
               if (![[[arrNotification valueForKey:@"Text"] objectAtIndex:3] isKindOfClass:[NSNull class]]) {
                   if ([[[arrNotification valueForKey:@"Alert"] objectAtIndex:3] boolValue]) {
                       [_radioBtnServity4 setTitle:[NSString stringWithFormat:@"%@ (A)",[[arrNotification valueForKey:@"Text"] objectAtIndex:3]] forState:UIControlStateNormal];
                       
                   }
                   else{
                       [_radioBtnServity4 setTitle:[[arrNotification valueForKey:@"Text"] objectAtIndex:3] forState:UIControlStateNormal];
                       
                   }

        }
        else{
            [_radioBtnServity4 setHidden:YES];
        }
         }
         else{
             [_radioBtnServity4 setHidden:YES];
         }
        
        
        //[_radioBtnServity1 setTitle:[[arrNotification valueForKey:@"Text"] objectAtIndex:0] forState:UIControlStateNormal];
        if (![[[arrNotification valueForKey:@"Color"] objectAtIndex:0] isKindOfClass:[NSNull class]]) {
            [_radioBtnServity1 setTitleColor:[UIColor colorWithHexCodeString:[[arrNotification valueForKey:@"Color"] objectAtIndex:0]] forState:UIControlStateNormal];
        }
       // [_radioBtnServity2 setTitle:[[arrNotification valueForKey:@"Text"] objectAtIndex:1] forState:UIControlStateNormal];
        if (![[[arrNotification valueForKey:@"Color"] objectAtIndex:1] isKindOfClass:[NSNull class]]) {
               [_radioBtnServity2 setTitleColor:[UIColor colorWithHexCodeString:[[arrNotification valueForKey:@"Color"] objectAtIndex:1]] forState:UIControlStateNormal];
        }
     
        //[_radioBtnServity3 setTitle:[[arrNotification valueForKey:@"Text"] objectAtIndex:2] forState:UIControlStateNormal];
        if (![[[arrNotification valueForKey:@"Color"] objectAtIndex:2] isKindOfClass:[NSNull class]]) {
             [_radioBtnServity3 setTitleColor:[UIColor colorWithHexCodeString:[[arrNotification valueForKey:@"Color"] objectAtIndex:2]] forState:UIControlStateNormal];
        }
       
    //    [_radioBtnServity4 setTitle:[[arrNotification valueForKey:@"Text"] objectAtIndex:3] forState:UIControlStateNormal];
        if (![[[arrNotification valueForKey:@"Color"] objectAtIndex:3] isKindOfClass:[NSNull class]]) {
                    [_radioBtnServity4 setTitleColor:[UIColor colorWithHexCodeString:[[arrNotification valueForKey:@"Color"] objectAtIndex:3]] forState:UIControlStateNormal];
        }

        
        
        
      
        if (_radioBtnMaintenanceType1.isSelected) {
            
        for (int i =0; i<arrEquipmentReq.count; i++) {
            if ([[NSString stringWithFormat:@"%@",[[arrEquipmentReq valueForKey:@"Id"] objectAtIndex:i]] isEqualToString:@"13"]) {
                if ([[[arrEquipmentReq valueForKey:@"Selected"] objectAtIndex:i] boolValue]) {
                    _lblStarEqAction.hidden = NO;
                }
            }
            else if ([[NSString stringWithFormat:@"%@",[[arrEquipmentReq valueForKey:@"Id"] objectAtIndex:i]] isEqualToString:@"12"]) {
                if ([[[arrEquipmentReq valueForKey:@"Selected"] objectAtIndex:i] boolValue]) {
                    _lblStarEqNature.hidden = NO;
                }
            }
            else if ([[NSString stringWithFormat:@"%@",[[arrEquipmentReq valueForKey:@"Id"] objectAtIndex:i]] isEqualToString:@"11"]) {
                if ([[[arrEquipmentReq valueForKey:@"Selected"] objectAtIndex:i] boolValue]) {
                    _lblStarEqBrand.hidden = NO;
                }
            }
            else if ([[NSString stringWithFormat:@"%@",[[arrEquipmentReq valueForKey:@"Id"] objectAtIndex:i]] isEqualToString:@"10"]) {
                if ([[[arrEquipmentReq valueForKey:@"Selected"] objectAtIndex:i] boolValue]) {
                    _lblStarEqMode.hidden = NO;
                }
            }
            else if ([[NSString stringWithFormat:@"%@",[[arrEquipmentReq valueForKey:@"Id"] objectAtIndex:i]] isEqualToString:@"9"]) {
                if ([[[arrEquipmentReq valueForKey:@"Selected"] objectAtIndex:i] boolValue]) {
                    _lblStarEqType.hidden = NO;
                }
            }
            else if ([[NSString stringWithFormat:@"%@",[[arrEquipmentReq valueForKey:@"Id"] objectAtIndex:i]] isEqualToString:@"8"]) {
                if ([[[arrEquipmentReq valueForKey:@"Selected"] objectAtIndex:i] boolValue]) {
                    _lblStarManufact.hidden = NO;
                }
            }
            else if ([[NSString stringWithFormat:@"%@",[[arrEquipmentReq valueForKey:@"Id"] objectAtIndex:i]] isEqualToString:@"7"]) {
                if ([[[arrEquipmentReq valueForKey:@"Selected"] objectAtIndex:i] boolValue]) {
                    _lblStarEqipName.hidden = NO;
                }
            }
            else if ([[NSString stringWithFormat:@"%@",[[arrEquipmentReq valueForKey:@"Id"] objectAtIndex:i]] isEqualToString:@"6"]) {
                if ([[[arrEquipmentReq valueForKey:@"Selected"] objectAtIndex:i] boolValue]) {
                    _lblStarSerialId.hidden = NO;
                }
            }
            else if ([[NSString stringWithFormat:@"%@",[[arrEquipmentReq valueForKey:@"Id"] objectAtIndex:i]] isEqualToString:@"5"]) {
                if ([[[arrEquipmentReq valueForKey:@"Selected"] objectAtIndex:i] boolValue]) {
                    _lblStarEqipId.hidden = NO;
                }
            }
        }
        
          
            
            
 }
        else{
            for (int i =0; i<arrGenReq.count; i++) {
                if ([[NSString stringWithFormat:@"%@",[[arrGenReq valueForKey:@"Id"] objectAtIndex:i]] isEqualToString:@"14"]) {
                    if ([[[arrGenReq valueForKey:@"Selected"] objectAtIndex:i] boolValue]) {
                        _lblStarGAction.hidden = NO;
                    }
                }
                else if ([[NSString stringWithFormat:@"%@",[[arrGenReq valueForKey:@"Id"] objectAtIndex:i]] isEqualToString:@"15"]) {
                    if ([[[arrGenReq valueForKey:@"Selected"] objectAtIndex:i] boolValue]) {
                        _lblStarGNature.hidden = NO;
                    }
                }
        }
        }
        
        for (int i =0; i<arrEmployeeReq.count; i++) {
            if ([[NSString stringWithFormat:@"%@",[[arrEmployeeReq valueForKey:@"Id"] objectAtIndex:i]] isEqualToString:@"1"]) {
                if ([[[arrEmployeeReq valueForKey:@"Selected"] objectAtIndex:i] boolValue]) {
                    _lblStarFName.hidden = NO;
                }
            }
            else if ([[NSString stringWithFormat:@"%@",[[arrEmployeeReq valueForKey:@"Id"] objectAtIndex:i]] isEqualToString:@"2"]) {
                if ([[[arrEmployeeReq valueForKey:@"Selected"] objectAtIndex:i] boolValue]) {
                    _lblStarMName.hidden = NO;
                }
            }
            else if ([[NSString stringWithFormat:@"%@",[[arrEmployeeReq valueForKey:@"Id"] objectAtIndex:i]] isEqualToString:@"3"]) {
                if ([[[arrEmployeeReq valueForKey:@"Selected"] objectAtIndex:i] boolValue]) {
                    _lblStarLName.hidden = NO;
                }
            }
            else if ([[NSString stringWithFormat:@"%@",[[arrEmployeeReq valueForKey:@"Id"] objectAtIndex:i]] isEqualToString:@"4"]) {
                if ([[[arrEmployeeReq valueForKey:@"Selected"] objectAtIndex:i] boolValue]) {
                    _lblStarEmail.hidden = NO;
                }
            }
          
        }
        
        
        _txtStatus.text = [[arrStatus valueForKey:@"Text"] objectAtIndex:0];
          arrVideoOrImage = [[NSMutableArray alloc]init];
 
//        GeneralMaintenanceRequiredFields =         (
//                                                    {
//                                                        Id = 14;
//                                                        Selected = 1;
//                                                        Text = "General Maintenance Action Taken";
//                                                        Value = "<null>";
//                                                    },
//                                                    {
//                                                        Id = 15;
//                                                        Selected = 1;
//                                                        Text = "General Maintenance Nature";
//                                                        Value = "<null>";
//                                                    }
//                                                    );
        
        
//        CGRect frame1 =  _tblVideoList.frame;
//        frame1.size.height = 50;
//        _tblVideoList.frame = frame1;
        [_tblVideoList reloadData];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (![[[responceDic valueForKey:@"WorkOrderSetupModel"] valueForKey:@"ShowAdditionalInformation"] boolValue]) {
                _txtAddiInfo.hidden = YES;
                _lblAddiInfo.hidden = YES;
                 _imgBgAddiInfo.hidden = YES;
            }
            if (![[[responceDic valueForKey:@"WorkOrderSetupModel"] valueForKey:@"ShowInstruction"] boolValue]) {
                _lblInstructions.hidden = YES;
            }
            if (![[[responceDic valueForKey:@"WorkOrderSetupModel"] valueForKey:@"AllowDataCapture"] boolValue]) {
                _txtQRCode.hidden = YES;
                _imgBgQRCode.hidden = YES;
                _btnScanCode.hidden = YES;
            }

         //  [self viewSetUp:YES];

        });
          [self viewSetUp:YES];
    }];
       });
}
-(void)viewDidLayoutSubviews{
    
}
-(void)viewWillAppear:(BOOL)animated{
     [self viewSetUp:NO];
  
}
- (IBAction)btnBackTapped:(UIButton *)sender {
    if (_isUpdate) {
        UIAlertController * alertBackWorkOrder = [[UIAlertController alloc]init];
        alertBackWorkOrder=[UIAlertController alertControllerWithTitle:@"" message:@"If you press \"Back\" you will lose your information. Do you want to proceed?"preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"Yes"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action)
                                    {
                                        [self.navigationController popViewControllerAnimated:YES];
                                        
                                    }];
        UIAlertAction* noButton = [UIAlertAction
                                    actionWithTitle:@"No"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action)
                                    {
                                        
                                    }];
        [alertBackWorkOrder addAction:yesButton];
          [alertBackWorkOrder addAction:noButton];
        [self presentViewController:alertBackWorkOrder animated:YES completion:nil];

    }
    else{
        [self.navigationController popViewControllerAnimated:YES];

    }
}

-(void)viewSetUp:(BOOL)isDataLoaded
{
    if (isDataLoaded) {

      if ([responceDic isKindOfClass:[NSNull class]] || responceDic == nil) {
            [self.navigationController popViewControllerAnimated:YES];
        }

    }

    CGRect frame =  _lblDate.frame;
    frame.origin.y = _lblInstructions.frame.origin.y + _lblInstructions.frame.size.height + 20;
    _lblDate.frame = frame;
    
    frame =  _lblTime.frame;
    frame.origin.y = _lblInstructions.frame.origin.y + _lblInstructions.frame.size.height + 20;
    _lblTime.frame = frame;
    
    frame =  _imgBgDateOfWorkOrder.frame;
    frame.origin.y = _lblDate.frame.origin.y + _lblDate.frame.size.height + 20;
    _imgBgDateOfWorkOrder.frame = frame;
    
    frame =  _lblStarDateofAccident.frame;
    frame.origin.y = _imgBgDateOfWorkOrder.frame.origin.y + (_imgBgDateOfWorkOrder.frame.size.height/2) -5;
    _lblStarDateofAccident.frame = frame;
    
    frame =  _imgBGTimeWorkOrder.frame;
    frame.origin.y = _lblDate.frame.origin.y + _lblDate.frame.size.height + 20;
    _imgBGTimeWorkOrder.frame = frame;
    
    frame =  _txtDateOfWorkOrder.frame;
    frame.origin.y = _lblDate.frame.origin.y + _lblDate.frame.size.height + 25;
    _txtDateOfWorkOrder.frame = frame;
    
    frame =  _txtTimeWorkOrder.frame;
    frame.origin.y = _lblDate.frame.origin.y + _lblDate.frame.size.height + 25;
    _txtTimeWorkOrder.frame = frame;
    
    frame =  _lblStarTimeofAccident.frame;
    frame.origin.y = _imgBGTimeWorkOrder.frame.origin.y + (_imgBGTimeWorkOrder.frame.size.height/2) -5;
    _lblStarTimeofAccident.frame = frame;
    
    frame =  _imgDateOfWorkOrder.frame;
    frame.origin.y = _lblDate.frame.origin.y + _lblDate.frame.size.height + 25;
    _imgDateOfWorkOrder.frame = frame;
    
    frame =  _imgTime.frame;
    frame.origin.y = _lblDate.frame.origin.y + _lblDate.frame.size.height + 25;
    _imgTime.frame = frame;
    
    frame =  _imgBGFacility.frame;
    frame.origin.y = _imgBgDateOfWorkOrder.frame.origin.y + _imgBgDateOfWorkOrder.frame.size.height + 20;
    _imgBGFacility.frame = frame;
    
    frame =  _lblStarFacility.frame;
    frame.origin.y = _imgBGFacility.frame.origin.y + (_imgBGFacility.frame.size.height/2) -5;
    _lblStarFacility.frame = frame;
    
    frame =  _imgFacility.frame;
    frame.origin.y = _imgBgDateOfWorkOrder.frame.origin.y + _imgBgDateOfWorkOrder.frame.size.height + 25;
    _imgFacility.frame = frame;
    
    frame =  _txtFacilityRelatedToWorkOrder.frame;
    frame.origin.y = _imgBgDateOfWorkOrder.frame.origin.y + _imgBgDateOfWorkOrder.frame.size.height + 25;
    _txtFacilityRelatedToWorkOrder.frame = frame;
    
    frame =  _imgBGLocationWorkOrder.frame;
    frame.origin.y = _imgBgDateOfWorkOrder.frame.origin.y + _imgBgDateOfWorkOrder.frame.size.height + 20;
    _imgBGLocationWorkOrder.frame = frame;
    
    frame =  _imgLocation.frame;
    frame.origin.y = _imgBgDateOfWorkOrder.frame.origin.y + _imgBgDateOfWorkOrder.frame.size.height + 25;
    _imgLocation.frame = frame;
    
    frame =  _lblStarLocation.frame;
    frame.origin.y = _imgBGLocationWorkOrder.frame.origin.y + (_imgBGLocationWorkOrder.frame.size.height/2) -5;
    _lblStarLocation.frame = frame;
    
    frame =  _txtLocation.frame;
    frame.origin.y = _imgBgDateOfWorkOrder.frame.origin.y + _imgBgDateOfWorkOrder.frame.size.height + 25;
    _txtLocation.frame = frame;
    
    frame =  _imgBgCategory.frame;
    frame.origin.y = _imgBGFacility.frame.origin.y + _imgBGFacility.frame.size.height + 20;
    _imgBgCategory.frame = frame;
    
    frame =  _imgCategory.frame;
    frame.origin.y = _imgBGFacility.frame.origin.y + _imgBGFacility.frame.size.height + 25;
    _imgCategory.frame = frame;
    
    frame =  _txtCategory.frame;
    frame.origin.y = _imgBGFacility.frame.origin.y + _imgBGFacility.frame.size.height + 25;
    _txtCategory.frame = frame;
    
    frame =  _imgBGDescriptionIssue.frame;
    frame.origin.y = _imgBgCategory.frame.origin.y + _imgBgCategory.frame.size.height + 20;
    _imgBGDescriptionIssue.frame = frame;
    
    frame =  _lblStarDescriptionIssue.frame;
    frame.origin.y = _imgBgCategory.frame.origin.y + _imgBgCategory.frame.size.height + 30;
    _lblStarDescriptionIssue.frame = frame;
    
    frame =  _lblBgDescriptionIssue.frame;
    frame.origin.y = _imgBgCategory.frame.origin.y + _imgBgCategory.frame.size.height + 30;
    _lblBgDescriptionIssue.frame = frame;
    
    frame =  _txtDescriptionIssue.frame;
    frame.origin.y = _imgBgCategory.frame.origin.y + _imgBgCategory.frame.size.height + 30;
    _txtDescriptionIssue.frame = frame;
    
    frame =  _lblServity.frame;
    frame.origin.y = _imgBGDescriptionIssue.frame.origin.y + _imgBGDescriptionIssue.frame.size.height + 20;
    _lblServity.frame = frame;
    
    frame =  _radioBtnServity1.frame;
    frame.origin.y = _lblServity.frame.origin.y + _lblServity.frame.size.height + 20;
    _radioBtnServity1.frame = frame;
    
    frame =  _radioBtnServity2.frame;
    frame.origin.y = _lblServity.frame.origin.y + _lblServity.frame.size.height + 20;
    _radioBtnServity2.frame = frame;
    
    frame =  _radioBtnServity3.frame;
    frame.origin.y = _radioBtnServity1.frame.origin.y + _radioBtnServity1.frame.size.height + 10;
    _radioBtnServity3.frame = frame;
    
    frame =  _radioBtnServity4.frame;
    frame.origin.y = _radioBtnServity1.frame.origin.y + _radioBtnServity1.frame.size.height + 10;
    _radioBtnServity4.frame = frame;
    
    frame =  disclaimer.frame;
    frame.origin.y = _radioBtnServity4.frame.origin.y + _radioBtnServity4.frame.size.height + 10;
    frame.origin.x = 1;
    frame.size.width = self.view.frame.size.width;
    frame.size.height = 30;
    disclaimer.frame = frame;
    
    frame =  disclaimerNote.frame;
    frame.origin.y = disclaimer.frame.origin.y + disclaimer.frame.size.height + 10;
    frame.origin.x = 20;
    frame.size.width = self.view.frame.size.width - 40;
    frame.size.height = 40;
    disclaimerNote.frame = frame;
    
    
    frame =  _lblMaintenanceType.frame;
    frame.origin.y = disclaimerNote.frame.origin.y + disclaimerNote.frame.size.height + 20;
    _lblMaintenanceType.frame = frame;
    
    frame =  _radioBtnMaintenanceType1.frame;
    frame.origin.y = _lblMaintenanceType.frame.origin.y + _lblMaintenanceType.frame.size.height + 20;
    _radioBtnMaintenanceType1.frame = frame;
    
    frame =  _radioBtnMaintenanceType2.frame;
    frame.origin.y = _lblMaintenanceType.frame.origin.y + _lblMaintenanceType.frame.size.height + 20;
    _radioBtnMaintenanceType2.frame = frame;
    
    frame = _lblTitleGeneralActionTaken.frame;
    frame.origin.y = _radioBtnMaintenanceType2.frame.origin.y + _radioBtnMaintenanceType2.frame.size.height + 20;
    _lblTitleGeneralActionTaken.frame = frame;
    
    frame =  _imgBgNature.frame;
    frame.origin.y = _lblTitleGeneralActionTaken.frame.origin.y + _lblTitleGeneralActionTaken.frame.size.height + 20;
    _imgBgNature.frame = frame;
    
    frame =  _imgNature.frame;
    frame.origin.y = _lblTitleGeneralActionTaken.frame.origin.y + _lblTitleGeneralActionTaken.frame.size.height + 25;
    _imgNature.frame = frame;
    
    frame =  _lblStarGNature.frame;
    frame.origin.y = _imgBgNature.frame.origin.y + (_imgBgNature.frame.size.height /2) -5;
    frame.origin.x = _imgBgNature.frame.origin.x + _imgBgNature.frame.size.width -5;
    _lblStarGNature.frame = frame;
    
    frame =  _txtNature.frame;
    frame.origin.y = _lblTitleGeneralActionTaken.frame.origin.y + _lblTitleGeneralActionTaken.frame.size.height + 25;
    _txtNature.frame = frame;
    
    frame =  _imgBgActionTaken.frame;
    frame.origin.y = _lblTitleGeneralActionTaken.frame.origin.y + _lblTitleGeneralActionTaken.frame.size.height + 20;
    _imgBgActionTaken.frame = frame;
    
    frame =  _lblStarGAction.frame;
    frame.origin.y = _imgBgActionTaken.frame.origin.y + (_imgBgActionTaken.frame.size.height /2) -5;
      frame.origin.x = _imgBgActionTaken.frame.origin.x + _imgBgActionTaken.frame.size.width -5;
    _lblStarGAction.frame = frame;
    
    frame =  _imgActionTaken.frame;
    frame.origin.y = _lblTitleGeneralActionTaken.frame.origin.y + _lblTitleGeneralActionTaken.frame.size.height + 25;
    _imgActionTaken.frame = frame;
    
    frame =  _txtActionTaken.frame;
    frame.origin.y = _lblTitleGeneralActionTaken.frame.origin.y + _lblTitleGeneralActionTaken.frame.size.height + 25;
    _txtActionTaken.frame = frame;
    
    
    
    frame =  _viewBgBarcode.frame;
    frame.origin.y = _radioBtnMaintenanceType1.frame.origin.y + _radioBtnMaintenanceType1.frame.size.height + 20;
    _viewBgBarcode.frame = frame;
 
    if (_radioBtnMaintenanceType1.selected) {
        
        frame =  _lblAddImg.frame;
        frame.origin.y = _viewBgBarcode.frame.origin.y + _viewBgBarcode.frame.size.height + 20;
        _lblAddImg.frame = frame;
        
        _imgBgNature.hidden = YES;
        _imgNature.hidden = YES;
        _txtNature.hidden = YES;
        _imgBgActionTaken.hidden = YES;
        _imgActionTaken.hidden = YES;
        _txtActionTaken.hidden = YES;
        _lblTitleGeneralActionTaken.hidden = YES;
         _viewBgBarcode.hidden = NO;
        
    }else{
        
        _imgBgNature.hidden = NO;
        _imgNature.hidden = NO;
        _txtNature.hidden = NO;
        _imgBgActionTaken.hidden = NO;
        _imgActionTaken.hidden = NO;
        _txtActionTaken.hidden = NO;
         _lblTitleGeneralActionTaken.hidden = NO;
        _viewBgBarcode.hidden = YES;
        frame =  _lblAddImg.frame;
        frame.origin.y = _imgBgNature.frame.origin.y + _imgBgNature.frame.size.height + 20;
        _lblAddImg.frame = frame;
        
    }
    
    frame =  _radioBtnImg.frame;
    frame.origin.y = _lblAddImg.frame.origin.y + _lblAddImg.frame.size.height + 20;
    _radioBtnImg.frame = frame;
    
    frame =  _radioBtnVideo.frame;
    frame.origin.y = _lblAddImg.frame.origin.y + _lblAddImg.frame.size.height + 20;
    _radioBtnVideo.frame = frame;
    
    frame =  _lblVideo.frame;
    frame.origin.y = _radioBtnVideo.frame.origin.y + _radioBtnVideo.frame.size.height + 20;
    _lblVideo.frame = frame;
    
    _viewBGVideoImage.frame = CGRectMake(0, 0, _viewBGVideoImage.frame.size.width,50);
 //   _tblVideoList.contentSize = CGSizeMake(_tblVideoList.frame.size.width, (arrVideoOrImage.count*50)+50);
    frame =  _tblVideoList.frame;
    frame.origin.y = _lblVideo.frame.origin.y + _lblVideo.frame.size.height + 20;
    _tblVideoList.frame = frame;
    
    frame =  _btnAttachVideoOrPhoto.frame;
    frame.origin.y = _tblVideoList.frame.origin.y + _tblVideoList.frame.size.height + 20;
    _btnAttachVideoOrPhoto.frame = frame;
    
    frame =  _lblEmployeeReprt.frame;
    frame.origin.y = _btnAttachVideoOrPhoto.frame.origin.y + _btnAttachVideoOrPhoto.frame.size.height + 20;
    _lblEmployeeReprt.frame = frame;

    frame =  _imgBgFname.frame;
    frame.origin.y = _lblEmployeeReprt.frame.origin.y + _lblEmployeeReprt.frame.size.height + 20;
    _imgBgFname.frame = frame;
    
    frame =  _lblStarFName.frame;
    frame.origin.y = _lblEmployeeReprt.frame.origin.y + _lblEmployeeReprt.frame.size.height + 30;
    frame.origin.x = _imgBgFname.frame.origin.x + _imgBgFname.frame.size.width -5;

    _lblStarFName.frame = frame;
    
    frame =  _txtFname.frame;
    frame.origin.y = _lblEmployeeReprt.frame.origin.y + _lblEmployeeReprt.frame.size.height + 25;
    _txtFname.frame = frame;
    
    frame =  _imgBgMname.frame;
    frame.origin.y = _lblEmployeeReprt.frame.origin.y + _lblEmployeeReprt.frame.size.height + 20;
    _imgBgMname.frame = frame;
    
    frame =  _lblStarMName.frame;
    frame.origin.y = _lblEmployeeReprt.frame.origin.y + _lblEmployeeReprt.frame.size.height + 25;
       frame.origin.x = _imgBgMname.frame.origin.x + _imgBgMname.frame.size.width -5;
    _lblStarMName.frame = frame;
    
    frame =  _txtMname.frame;
    frame.origin.y = _lblEmployeeReprt.frame.origin.y + _lblEmployeeReprt.frame.size.height + 25;
    _txtMname.frame = frame;
    
    frame =  _imgBgLname.frame;
    frame.origin.y = _lblEmployeeReprt.frame.origin.y + _lblEmployeeReprt.frame.size.height + 20;
    _imgBgLname.frame = frame;
    
    frame =  _lblStarLName.frame;
    frame.origin.y = _lblEmployeeReprt.frame.origin.y + _lblEmployeeReprt.frame.size.height + 30;
    frame.origin.x = _imgBgLname.frame.origin.x + _imgBgLname.frame.size.width -5;
    _lblStarLName.frame = frame;
    
    frame =  _txtLname.frame;
    frame.origin.y = _lblEmployeeReprt.frame.origin.y + _lblEmployeeReprt.frame.size.height + 25;
    _txtLname.frame = frame;
    
    frame =  _imgBgEmail.frame;
    frame.origin.y = _imgBgFname.frame.origin.y + _imgBgFname.frame.size.height + 20;
    _imgBgEmail.frame = frame;
    
    frame =  _lblStarEmail.frame;
    frame.origin.y = _imgBgFname.frame.origin.y + _imgBgFname.frame.size.height + 30;
    frame.origin.x = _imgBgEmail.frame.origin.x + _imgBgEmail.frame.size.width -5;
    _lblStarEmail.frame = frame;
    
    frame =  _txtEmail.frame;
    frame.origin.y = _imgBgFname.frame.origin.y + _imgBgFname.frame.size.height + 25;
    _txtEmail.frame = frame;

    frame =  _imgBgAddiInfo.frame;
    frame.origin.y = _imgBgEmail.frame.origin.y + _imgBgEmail.frame.size.height + 20;
    _imgBgAddiInfo.frame = frame;
    
    frame =  _lblAddiInfo.frame;
    frame.origin.y = _imgBgEmail.frame.origin.y + _imgBgEmail.frame.size.height + 40;
    _lblAddiInfo.frame = frame;
    
    frame =  _txtAddiInfo.frame;
    frame.origin.y = _imgBgEmail.frame.origin.y + _imgBgEmail.frame.size.height + 30;
    _txtAddiInfo.frame = frame;
    
    frame =  _lblStatus.frame;
    frame.origin.y = _imgBgAddiInfo.frame.origin.y + _imgBgAddiInfo.frame.size.height + 20;
    _lblStatus.frame = frame;
    
    frame =  _imgBgStatus.frame;
    frame.origin.y = _lblStatus.frame.origin.y + _lblStatus.frame.size.height + 20;
    _imgBgStatus.frame = frame;
    
    frame =  _lblStarStatus.frame;
    frame.origin.y = _imgBgStatus.frame.origin.y + (_imgBgStatus.frame.size.height/2) -5;
    _lblStarStatus.frame = frame;
    
    frame =  _imgStatus.frame;
    frame.origin.y = _lblStatus.frame.origin.y + _lblStatus.frame.size.height + 20;
    _imgStatus.frame = frame;
    
    frame =  _txtStatus.frame;
    frame.origin.y = _lblStatus.frame.origin.y + _lblStatus.frame.size.height + 25;
    _txtStatus.frame = frame;

    frame =  _btnSubmit.frame;
    frame.origin.y = _imgBgStatus.frame.origin.y + _imgBgStatus.frame.size.height + 30;
    _btnSubmit.frame = frame;
    
    frame =  _btnSubmitLatter.frame;
    frame.origin.y = _imgBgStatus.frame.origin.y + _imgBgStatus.frame.size.height + 30;
    _btnSubmitLatter.frame = frame;

    _viewTblHeader.frame = CGRectMake(0, 0, 768,_btnSubmit.frame.origin.y + _btnSubmit.frame.size.height + 480);
    _tblScrollBG.contentSize = CGSizeMake(_tblScrollBG.frame.size.width, _viewTblHeader.frame.size.height);

    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    if ([tableView isEqual:_tblScrollBG]) {
 
        return _viewTblHeader;
    }else if ([tableView isEqual:_tblVideoList]){
        UIView * viewHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-40, 50)];
        viewHeader.backgroundColor = [UIColor lightGrayColor];
        UILabel * lbl1 = [[UILabel alloc] initWithFrame:CGRectMake(1, 1, 100, viewHeader.frame.size.height - 3)];
        lbl1.backgroundColor = [UIColor colorWithHexCodeString:@"#A52A2A"];
        lbl1.text = @"Id";
        lbl1.textColor = [UIColor whiteColor];
        [lbl1 setTextAlignment:NSTextAlignmentCenter];
        [viewHeader addSubview:lbl1];
     
        UILabel * lbl2 = [[UILabel alloc] initWithFrame:CGRectMake(102, 1, (viewHeader.frame.size.width-106)/2, viewHeader.frame.size.height - 3)];
        lbl2.backgroundColor = [UIColor colorWithHexCodeString:@"#A52A2A"];
        lbl2.text = @"File Name";
         lbl2.textColor = [UIColor whiteColor];
          [lbl2 setTextAlignment:NSTextAlignmentCenter];
        [viewHeader addSubview:lbl2];
        
        UILabel * lbl3 = [[UILabel alloc] initWithFrame:CGRectMake(lbl2.frame.origin.x+lbl2.frame.size.width+1, 1, (viewHeader.frame.size.width-lbl1.frame.size.width-4)/2, viewHeader.frame.size.height - 3)];
        lbl3.backgroundColor = [UIColor colorWithHexCodeString:@"#A52A2A"];
        lbl3.text = @"Type";
         lbl3.textColor = [UIColor whiteColor];
          [lbl3 setTextAlignment:NSTextAlignmentCenter];
        [viewHeader addSubview:lbl3];
        return viewHeader;
      
    }

    else
        return nil;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:_tblScrollBG]) {
         return 1;
    }
    else {
         return arrVideoOrImage.count;
    }
   
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CreateWorkOrderTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
   
    if ([tableView isEqual:_tblScrollBG]) {
    
    }
   if ([tableView isEqual:_tblVideoList]) {

       cell.lblId.text = [NSString stringWithFormat:@"%ld",indexPath.row+1];
       cell.lblFileName.text = [[arrVideoOrImage valueForKey:@"Key"] objectAtIndex:indexPath.row];
       if (_radioBtnImg.selected) {
           cell.lblFileType.text = @"Image";
       }else {
           cell.lblFileType.text = @"Video";
           
       }
       
       [cell.btnViewImageVideo addTarget:self action:@selector(btnViewImageVideoTapped:) forControlEvents:UIControlEventTouchUpInside];
       cell.btnViewImageVideo.tag = indexPath.row;
       
       [cell.btnDeleteImageVideo addTarget:self action:@selector(btnDeleteImageVideoTapped:) forControlEvents:UIControlEventTouchUpInside];
       cell.btnDeleteImageVideo.tag = indexPath.row;
       
         }
       return cell;
}

-(void)btnViewImageVideoTapped:(UIButton*)sender{
    
//    _viewFullBGImageVideo.hidden = NO;
//
//    NSData* data = [[NSData alloc] initWithBase64EncodedString:[[arrVideoOrImage valueForKey:@"Value"] objectAtIndex:sender.tag] options:0];
////    UIImage* image = [UIImage imageWithData:data];
////
////  _imgViewPhotoVideo.image = image;
//
//    UIWebView * webview = [[UIWebView alloc]initWithFrame:CGRectMake(0, 30, 500, 500)];
//
//    [_viewFullBGImageVideo addSubview:webview];
//
//    NSCachedURLResponse* response = [[NSURLCache sharedURLCache] cachedResponseForRequest:[webview request]];
//    NSString *MIMEType = response.response.MIMEType;
//  //  NSData * data1 = [response data];
//
//    [webview loadData: data MIMEType:MIMEType textEncodingName:@"UTF-8" baseURL:[NSURL URLWithString:@""]];
    _viewFullBGImageVideo.hidden = NO;
    

 NSData* data = [[NSData alloc] initWithBase64EncodedString:[[arrVideoOrImage valueForKey:@"Value"] objectAtIndex:sender.tag] options:0];

    if (_radioBtnImg.selected){
        
        _imgViewPhotoVideo.hidden = NO;
        _webViewVideoShow.hidden = YES;
        UIImage* image = [UIImage imageWithData:data];
        _imgViewPhotoVideo.image = image;
        
    }
    else if (_radioBtnVideo.selected){
        _imgViewPhotoVideo.hidden = YES;
        _webViewVideoShow.hidden = NO;
        NSString *base64String = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        
        NSString *str = [NSString stringWithFormat:@" \
                         <div style=\"height:100%%;\"> \
                         <p style=\"position: absolute; top: 50%%; left: 50%%; transform: translate(-50%%, -50%%)\"> \
                         <video controls> \
                         <source src=\"data:video/mp4;base64,%@\"> \
                         </video></p></div>", base64String];
        
        
        [_webViewVideoShow loadHTMLString:str baseURL:nil];
    }
    
}
-(NSString *)getNSDataFromCache{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDirectory = [paths objectAtIndex:0];
    return cachesDirectory;
}
-(void)btnDeleteImageVideoTapped:(UIButton*)sender{
    _isUpdate = YES;
    [arrVideoOrImage removeObjectAtIndex:sender.tag];
    [_tblVideoList reloadData];
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    if ([tableView isEqual:_tblScrollBG]) {
        return   _viewTblHeader.frame.size.height + 150;
    }else if ([tableView isEqual:_tblVideoList]){
        return   50;//_viewBGVideoImage.frame.size.height;// +(arrVideoOrImage.count*50);
    }
    else return 1.0;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{

       return  50;

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:_tblVideoList]) {
        selectedImgVidIndex = indexPath.row;
    }
    
}
-(void)textViewDidBeginEditing:(UITextView *)textView{
    _isUpdate = YES;
    if ([textView isEqual:_txtDescriptionIssue]) {
        _lblBgDescriptionIssue.hidden =YES;
    }
    else if ([textView isEqual:_txtAddiInfo]) {
        _lblAddiInfo.hidden =YES;
    }
//    else if ([textView isEqual:_txtAlertBriefDesc]) {
//        _lblAlertBriefDesc.hidden =YES;
//    }
}
-(void)textViewDidEndEditing:(UITextView *)textView{
    _isUpdate = YES;
    if ([textView.text isEqualToString:@""]) {
        if ([textView isEqual:_txtDescriptionIssue]) {
            _lblBgDescriptionIssue.hidden =NO;
        }
        else if ([textView isEqual:_txtAddiInfo]) {
            _lblAddiInfo.hidden =NO;
        }
//        else if ([textView isEqual:_txtAlertBriefDesc]) {
//            _lblAlertBriefDesc.hidden =NO;
//        }
    }
   
}
-(BOOL)textViewShouldEndEditing:(UITextView *)textView{
    [textView resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    [textField resignFirstResponder];
    return YES;
    
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    _isUpdate = YES;
    if ([textField isEqual:_txtEquipmentId]){
            _txtSerialId.text = @"";
            _txtEquipmentName.text = @"";
            _txtManufacture.text = @"";
            _txtType.text = @"";
            _txtMode.text = @"";
            _txtBrand.text = @"";
        
        _txtSerialId.userInteractionEnabled = YES;
        _txtEquipmentName.userInteractionEnabled = YES;
        _txtManufacture.userInteractionEnabled = YES;
        _txtType.userInteractionEnabled = YES;
        _txtMode.userInteractionEnabled = YES;
        _txtBrand.userInteractionEnabled = YES;
        
        if ([_txtEquipmentId.text length] >1) {
            popOver = nil;
            NSString * strTemp = _txtEquipmentId.text;
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{

            [[WebSerivceCall webServiceObject]callServiceForGetInventoryPartsUsedWorkOrder:YES equipmentId:strTemp checkFilter:@"true" complition:^{
                
                NSData *dictionaryData = [[NSUserDefaults standardUserDefaults] objectForKey:@"inventoryPartsUsedRecponce"];
                responceEquipmentIdDic = [NSKeyedUnarchiver unarchiveObjectWithData:dictionaryData];
           //     //NSLog(@"%@",responceEquipmentIdDic);
                if (![[responceEquipmentIdDic valueForKey:@"Success"] boolValue]) {
                    return ;
                }
                
                arrEquipmentId = [[NSMutableArray alloc]init];
                arrEquipmentId= [responceEquipmentIdDic valueForKey:@"InventoryParts"];
                if (arrEquipmentId.count != 0) {
                    DropDownPopOver *dropDown = (DropDownPopOver*)[[[NSBundle mainBundle] loadNibNamed:@"DropDownPopOver" owner:self options:nil] firstObject];
                    dropDown.delegate = self;
                    [dropDown showDropDownWith:arrEquipmentId view:textField key:@"Text"];
                }
                
                
                
            }];
                     });
        }
        else{
            popOver = nil;
            
        }
    }
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    _isUpdate = YES;
    BOOL allowEditing = YES;
    if ([textField isEqual:_txtDateOfWorkOrder]) {
        DatePopOverView *datePopOver = (DatePopOverView *)[[[NSBundle mainBundle] loadNibNamed:@"DatePopOverView" owner:self options:nil] firstObject];
        [datePopOver showInPopOverFor:textField limit:DATE_LIMIT_ALL_DATE option:DATE_SELECTION_DATE_ONLY updateField:textField];
        allowEditing = NO;
        
    }
    else if ([textField isEqual:_txtTimeWorkOrder]) {
        DatePopOverView *datePopOver = (DatePopOverView *)[[[NSBundle mainBundle] loadNibNamed:@"DatePopOverView" owner:self options:nil] firstObject];
  [datePopOver showInPopOverFor:textField limit:DATE_LIMIT_ALL_DATE option:DATE_SELECTION_TIME_ONLY updateField:textField];
        allowEditing = NO;
        
    }

    else if ([textField isEqual:_txtLocation]){
        DropDownPopOver *dropDown = (DropDownPopOver*)[[[NSBundle mainBundle] loadNibNamed:@"DropDownPopOver" owner:self options:nil] firstObject];
        dropDown.delegate = self;
        [dropDown showDropDownWith:arrLocation view:textField key:@"name"];
        allowEditing = NO;
    }
    else if ([textField isEqual:_txtFacilityRelatedToWorkOrder]){
        DropDownPopOver *dropDown = (DropDownPopOver*)[[[NSBundle mainBundle] loadNibNamed:@"DropDownPopOver" owner:self options:nil] firstObject];
        dropDown.delegate = self;
        [dropDown showDropDownWith:arrFacility view:textField key:@"name"];
        
          allowEditing = NO;
       
      
    }
    else if ([textField isEqual:_txtCategory]){
        DropDownPopOver *dropDown = (DropDownPopOver*)[[[NSBundle mainBundle] loadNibNamed:@"DropDownPopOver" owner:self options:nil] firstObject];
        dropDown.delegate = self;
        [dropDown showDropDownWith:arrCategoty view:textField key:@"Text"];
        allowEditing = NO;
    }
    else if ([textField isEqual:_txtNature]){
        DropDownPopOver *dropDown = (DropDownPopOver*)[[[NSBundle mainBundle] loadNibNamed:@"DropDownPopOver" owner:self options:nil] firstObject];
        dropDown.delegate = self;
            [dropDown showDropDownWith:arrGenralNature view:textField key:@"Text"];

        allowEditing = NO;
    }
    else if ([textField isEqual:_txtActionTaken]){
        DropDownPopOver *dropDown = (DropDownPopOver*)[[[NSBundle mainBundle] loadNibNamed:@"DropDownPopOver" owner:self options:nil] firstObject];
        dropDown.delegate = self;
            [dropDown showDropDownWith:arrGenralActionTaken view:textField key:@"Text"];

        allowEditing = NO;
    }
    else if ([textField isEqual:_txtNature2]){
        DropDownPopOver *dropDown = (DropDownPopOver*)[[[NSBundle mainBundle] loadNibNamed:@"DropDownPopOver" owner:self options:nil] firstObject];
        dropDown.delegate = self;
                  [dropDown showDropDownWith:arrEquipmentNature view:textField key:@"Text"];
        
        allowEditing = NO;
    }
    else if ([textField isEqual:_txtManufacture]){
        DropDownPopOver *dropDown = (DropDownPopOver*)[[[NSBundle mainBundle] loadNibNamed:@"DropDownPopOver" owner:self options:nil] firstObject];
        dropDown.delegate = self;
        [dropDown showDropDownWith:arrManufactur view:textField key:@"Text"];
        allowEditing = NO;
    }
    else if ([textField isEqual:_txtType]){
        DropDownPopOver *dropDown = (DropDownPopOver*)[[[NSBundle mainBundle] loadNibNamed:@"DropDownPopOver" owner:self options:nil] firstObject];
        dropDown.delegate = self;
        [dropDown showDropDownWith:arrEquipmentType view:textField key:@"Text"];
        allowEditing = NO;
    }
    else if ([textField isEqual:_txtMode]){
        DropDownPopOver *dropDown = (DropDownPopOver*)[[[NSBundle mainBundle] loadNibNamed:@"DropDownPopOver" owner:self options:nil] firstObject];
        dropDown.delegate = self;
        [dropDown showDropDownWith:arrModel view:textField key:@"Text"];
        allowEditing = NO;
    }
    else if ([textField isEqual:_txtBrand]){
        DropDownPopOver *dropDown = (DropDownPopOver*)[[[NSBundle mainBundle] loadNibNamed:@"DropDownPopOver" owner:self options:nil] firstObject];
        dropDown.delegate = self;
        [dropDown showDropDownWith:arrBrand view:textField key:@"Text"];
        allowEditing = NO;
    }
    else if ([textField isEqual:_txtActionTaken2]){
        DropDownPopOver *dropDown = (DropDownPopOver*)[[[NSBundle mainBundle] loadNibNamed:@"DropDownPopOver" owner:self options:nil] firstObject];
        dropDown.delegate = self;
 
            [dropDown showDropDownWith:arrEquipmentActionTaken view:textField key:@"Text"];
     
        allowEditing = NO;
    }
    else if ([textField isEqual:_txtStatus]){
//        DropDownPopOver *dropDown = (DropDownPopOver*)[[[NSBundle mainBundle] loadNibNamed:@"DropDownPopOver" owner:self options:nil] firstObject];
//        dropDown.delegate = self;
//        [dropDown showDropDownWith:arrStatus view:textField key:@"Text"];
        allowEditing = NO;
    }

    return allowEditing;
    
}
- (void)dropDownControllerDidSelectValue:(id)value atIndex:(NSInteger)index sender:(id)sender {
    _isUpdate = YES;
    if ([sender isEqual:_txtFacilityRelatedToWorkOrder]) {
                for (int i = 0; i<arrFacility.count; i++) {
            if ([[value valueForKey:@"name"] isEqualToString:[[arrFacility valueForKey:@"name"] objectAtIndex:i]]) {
                selectedFacilityId = [[arrFacility valueForKey:@"value"] objectAtIndex:i];
            }
        }
        NSFetchRequest *requestLoc = [[NSFetchRequest alloc] initWithEntityName:@"UserInventoryLocation"];
        NSPredicate *predicateLoc = [NSPredicate predicateWithFormat:@"%K MATCHES[cd] %@", @"facility.value", selectedFacilityId];
        [requestLoc setPredicate:predicateLoc];
        NSSortDescriptor *sortByName2 = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        [requestLoc setSortDescriptors:@[sortByName2]];
        [requestLoc setPropertiesToFetch:@[@"name", @"value"]];
     //   arrLocation = [gblAppDelegate.managedObjectContext executeFetchRequest:requestLoc error:nil];

        NSArray * arr = [gblAppDelegate.managedObjectContext executeFetchRequest:requestLoc error:nil];
        arrLocation = [arr mutableCopy];
        
        for (int i=0; i<arrLocation.count; i++) {
            NSMutableString *str = [[[arrLocation valueForKey:@"name"] objectAtIndex:i] mutableCopy];
            
            NSRegularExpression *regex = [NSRegularExpression
                                          regularExpressionWithPattern:@"\\(.+?\\)"
                                          options:NSRegularExpressionCaseInsensitive
                                          error:NULL];
            
            [regex replaceMatchesInString:str
                                  options:0
                                    range:NSMakeRange(0, [str length])
                             withTemplate:@""];
            
            NSMutableDictionary * tempDic = [arrLocation objectAtIndex:i];
            [tempDic setValue:str forKey:@"name"];
            [arrLocation replaceObjectAtIndex:i withObject:tempDic];
            
        }

        
        
        [sender setText:[value valueForKey:@"name"]];
    }
    else if ([sender isEqual:_txtLocation]){
        for (int i = 0; i<arrLocation.count; i++) {
            if ([[value valueForKey:@"name"] isEqualToString:[[arrLocation valueForKey:@"name"] objectAtIndex:i]]) {
                selectedLocationId = [[arrLocation valueForKey:@"value"] objectAtIndex:i];
            }
        }
          [sender setText:[value valueForKey:@"name"]];
    }
    else if ([sender isEqual:_txtEquipmentId]){
        
        [sender setText:[value valueForKey:@"Text"]];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
             [tempBtn setTitle:@"Fill" forState:UIControlStateNormal];
            [self btnFillTapped:tempBtn];
        });
        
        
    }
    else
    [sender setText:[value valueForKey:@"Text"]];
}

- (IBAction)servityRadioBtnTapped:(UIButton *)sender {
    _isUpdate = YES;
    disclaimerNote.hidden =YES;
    disclaimer.hidden = YES;
    [_radioBtnServity1 setSelected:NO];
     [_radioBtnServity2 setSelected:NO];
     [_radioBtnServity3 setSelected:NO];
     [_radioBtnServity4 setSelected:NO];
     [sender setSelected:YES];
    for (int i = 0; i<arrNotification.count; i++) {
        if ([[[arrNotification valueForKey:@"Alert"] objectAtIndex:i] boolValue]) {
            if ([[NSString stringWithFormat:@"%@ (A)",[[arrNotification valueForKey:@"Text"] objectAtIndex:i]] isEqualToString:sender.titleLabel.text]) {
                disclaimerNote.hidden =NO;
                disclaimer.hidden = NO;
            }
        }
    }
   
}

- (IBAction)maintenanceRadioBtnTapped:(UIButton *)sender {
    _isUpdate = YES;
     [_radioBtnMaintenanceType1 setSelected:NO];
     [_radioBtnMaintenanceType2 setSelected:NO];
     [sender setSelected:YES];
    _txtNature.text = @"";
    _txtActionTaken.text = @"";
    _txtQRCode.text = @"";
    _txtEquipmentId.text = @"";
    _txtManufacture.text = @"";
    _txtEquipmentName.text = @"";
    _txtMode.text = @"";
    _txtBrand.text = @"";
    _txtSerialId.text = @"";
    _txtType.text = @"";
    _txtNature2.text = @"";
    _txtActionTaken2.text = @"";
   if(_radioBtnMaintenanceType1.isSelected) {
       _lblStarGAction.hidden = YES;
 _lblStarGNature.hidden = YES;
        for (int i =0; i<arrEquipmentReq.count; i++) {
            if ([[NSString stringWithFormat:@"%@",[[arrEquipmentReq valueForKey:@"Id"] objectAtIndex:i]] isEqualToString:@"13"]) {
                if ([[[arrEquipmentReq valueForKey:@"Selected"] objectAtIndex:i] boolValue]) {
                    _lblStarEqAction.hidden = NO;
                }
            }
            else if ([[NSString stringWithFormat:@"%@",[[arrEquipmentReq valueForKey:@"Id"] objectAtIndex:i]] isEqualToString:@"12"]) {
                if ([[[arrEquipmentReq valueForKey:@"Selected"] objectAtIndex:i] boolValue]) {
                    _lblStarEqNature.hidden = NO;
                }
            }
            else if ([[NSString stringWithFormat:@"%@",[[arrEquipmentReq valueForKey:@"Id"] objectAtIndex:i]] isEqualToString:@"11"]) {
                if ([[[arrEquipmentReq valueForKey:@"Selected"] objectAtIndex:i] boolValue]) {
                    _lblStarEqBrand.hidden = NO;
                }
            }
            else if ([[NSString stringWithFormat:@"%@",[[arrEquipmentReq valueForKey:@"Id"] objectAtIndex:i]] isEqualToString:@"10"]) {
                if ([[[arrEquipmentReq valueForKey:@"Selected"] objectAtIndex:i] boolValue]) {
                    _lblStarEqMode.hidden = NO;
                }
            }
            else if ([[NSString stringWithFormat:@"%@",[[arrEquipmentReq valueForKey:@"Id"] objectAtIndex:i]] isEqualToString:@"9"]) {
                if ([[[arrEquipmentReq valueForKey:@"Selected"] objectAtIndex:i] boolValue]) {
                    _lblStarEqType.hidden = NO;
                }
            }
            else if ([[NSString stringWithFormat:@"%@",[[arrEquipmentReq valueForKey:@"Id"] objectAtIndex:i]] isEqualToString:@"8"]) {
                if ([[[arrEquipmentReq valueForKey:@"Selected"] objectAtIndex:i] boolValue]) {
                    _lblStarManufact.hidden = NO;
                }
            }
            else if ([[NSString stringWithFormat:@"%@",[[arrEquipmentReq valueForKey:@"Id"] objectAtIndex:i]] isEqualToString:@"7"]) {
                if ([[[arrEquipmentReq valueForKey:@"Selected"] objectAtIndex:i] boolValue]) {
                    _lblStarEqipName.hidden = NO;
                }
            }
            else if ([[NSString stringWithFormat:@"%@",[[arrEquipmentReq valueForKey:@"Id"] objectAtIndex:i]] isEqualToString:@"6"]) {
                if ([[[arrEquipmentReq valueForKey:@"Selected"] objectAtIndex:i] boolValue]) {
                    _lblStarSerialId.hidden = NO;
                }
            }
            else if ([[NSString stringWithFormat:@"%@",[[arrEquipmentReq valueForKey:@"Id"] objectAtIndex:i]] isEqualToString:@"5"]) {
                if ([[[arrEquipmentReq valueForKey:@"Selected"] objectAtIndex:i] boolValue]) {
                    _lblStarEqipId.hidden = NO;
                }
            }
        }
   }else{
       _lblStarEqipId.hidden = YES;
       _lblStarSerialId.hidden = YES;
       _lblStarEqipName.hidden = YES;
       _lblStarManufact.hidden = YES;
       _lblStarEqType.hidden = YES;
       _lblStarEqMode.hidden = YES;
       _lblStarEqBrand.hidden = YES;
       _lblStarEqNature.hidden = YES;
       _lblStarEqAction.hidden = YES;
      
           for (int i =0; i<arrGenReq.count; i++) {
               if ([[NSString stringWithFormat:@"%@",[[arrGenReq valueForKey:@"Id"] objectAtIndex:i]] isEqualToString:@"14"]) {
                   if ([[[arrGenReq valueForKey:@"Selected"] objectAtIndex:i] boolValue]) {
                       _lblStarGAction.hidden = NO;
                   }
               }
               else if ([[NSString stringWithFormat:@"%@",[[arrGenReq valueForKey:@"Id"] objectAtIndex:i]] isEqualToString:@"15"]) {
                   if ([[[arrGenReq valueForKey:@"Selected"] objectAtIndex:i] boolValue]) {
                       _lblStarGNature.hidden = NO;
                   }
               }
           }
   }
      [self viewSetUp:NO];
 //[_tblScrollBG reloadData];

}
- (IBAction)imageOrVideoRadioBtnTapped:(UIButton *)sender {
    _isUpdate = YES;
     [_radioBtnImg setSelected:NO];
     [_radioBtnVideo setSelected:NO];
     [sender setSelected:YES];
    
    if ([_radioBtnImg isSelected]) {
        _lblVideo.text = @"Image(s)";
        [_btnAttachVideoOrPhoto setTitle:@"Attach image" forState:UIControlStateNormal];
        arrVideoOrImage = [NSMutableArray new];
            }
    else
    {
        _lblVideo.text = @"Video(s)";
        [_btnAttachVideoOrPhoto setTitle:@"Attach video" forState:UIControlStateNormal];
        arrVideoOrImage = [NSMutableArray new];

    }
    [_tblVideoList reloadData];

}
- (IBAction)btnAttachVideoOrPhotoTapped:(UIButton *)sender {
    _isUpdate = YES;
    if ([_radioBtnVideo isSelected]) {
        if (!(arrVideoOrImage.count < 1)) {
               alert(@"", @"Sorry! You cannot attach more than 1 video.");
            return;
        }
    }
    else if ([_radioBtnImg isSelected]) {
        if (!(arrVideoOrImage.count < 3)) {
            alert(@"", @"Sorry! You cannot attach more than 3 images.");
            return;
        }
    }

    UIActionSheet *actionSheet = [[UIActionSheet alloc] init];
    if ([_radioBtnImg isSelected]) {
        actionSheet = [[UIActionSheet alloc] initWithTitle:@"Capture Image" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Select Photo",@"Select Camera",nil];
    }else  if ([_radioBtnVideo isSelected]) {
        actionSheet = [[UIActionSheet alloc] initWithTitle:@"Capture Image" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Select Video",@"Select Camera",nil];
    }

    
    rect = [self.view convertRect:CGRectMake(self.view.frame.size.width/2-80, self.view.frame.size.height/2-240, sender.frame.size.width, sender.frame.size.height) toView:self.view];
    rect = [self.view convertRect:rect toView:self.view];
    [actionSheet showInView:self.view];

    
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
          if ([_radioBtnImg isSelected]) {
        if (buttonIndex == 0) {
            [self showPhotoLibrary:@"image"];
        }
        else if (buttonIndex == 1){
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                [self showCamera];
            }
            else
            {
                alert(@"Error!!", @"Camera is not available");
            }
        }
          }
          else  if ([_radioBtnVideo isSelected]) {
               if (buttonIndex == 0){
            [self showPhotoLibrary:@"video"];
        }
             else if (buttonIndex == 1){
                  if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
                  {
                      [self showCamera];
                  }
                  else
                  {
                      alert(@"Error!!", @"Camera is not available");
                  }
              }
          }
        
        
    }];
}
- (void)showPhotoLibrary:(NSString*)str {
    
    UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
    if ([str isEqualToString:@"image"]) {
        [imgPicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [imgPicker setDelegate:self];
        [imgPicker setAllowsEditing:YES];
        
    }else if ([str isEqualToString:@"video"]){
        [imgPicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        imgPicker.delegate = self;
        imgPicker.modalPresentationStyle = UIModalPresentationCurrentContext;
        imgPicker.mediaTypes =[UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        imgPicker.mediaTypes = @[(NSString*)kUTTypeMovie, (NSString*)kUTTypeAVIMovie, (NSString*)kUTTypeVideo, (NSString*)kUTTypeMPEG4];
        imgPicker.videoQuality = UIImagePickerControllerQualityTypeHigh;
    }
    
    popOver = [[UIPopoverController alloc] initWithContentViewController:imgPicker];
    [popOver setPopoverContentSize:CGSizeMake(320, 480)];
    [popOver setDelegate:self];
    [popOver presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    _isUpdate = YES;
    __block NSString *strEncoded = nil;
 //   NSMutableDictionary *aDict = [mutArrQuestions objectAtIndex:currentIndex];
    
    if ([info objectForKey:UIImagePickerControllerOriginalImage]) {
        _imgBodilyFluid = [info objectForKey:UIImagePickerControllerOriginalImage];
    //    //NSLog(@"%@",info);
        strEncoded = [UIImageJPEGRepresentation(_imgBodilyFluid, 1.0) base64EncodedStringWithOptions:0];
        tempstrDataType=@"data:image/gif;base64,";

        NSMutableDictionary * tempDic = [[NSMutableDictionary alloc] init];
//        [tempDic setValue:[[info objectForKey:UIImagePickerControllerReferenceURL] lastPathComponent] forKey:@"fileName"];
//          [tempDic setValue:[[info objectForKey:UIImagePickerControllerReferenceURL] pathExtension] forKey:@"fileType"];
        [tempDic setValue:@"Image" forKey:@"Key"];
        [tempDic setValue:strEncoded forKey:@"Value"];//
        [arrVideoOrImage addObject:tempDic];
              //  [aDict setObject:strEncoded forKey:@"answer"];
      //  [aDict setObject:tempstrDataType forKey:@"existingResponse"];
        
    }
    else if ([info objectForKey: UIImagePickerControllerMediaType]){
        NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
        if (CFStringCompare ((__bridge CFStringRef) mediaType, kUTTypeMovie, 0) == kCFCompareEqualTo) {
            NSURL *videoUrl=(NSURL*)[info objectForKey:UIImagePickerControllerMediaURL];
            NSString *moviePath = [videoUrl path];
            
            if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum (moviePath)) {
                UISaveVideoAtPathToSavedPhotosAlbum (moviePath, nil, nil, nil);
            }
            
            NSData *zipFileData = [NSData dataWithContentsOfFile:moviePath];
            strEncoded = [zipFileData base64EncodedStringWithOptions:0];
            NSURL * mediaURL = [info objectForKey:UIImagePickerControllerMediaURL];
            NSDictionary * properties = [[NSFileManager defaultManager] attributesOfItemAtPath:mediaURL.path error:nil];
            
        //          NSString * validationSize=@"4000096"; //in byte limit for 4Mb
            NSString * validationSize=@"15000000";//in byte limit for 15Mb
         //   //NSLog(@"%ld %ld", (long)[properties fileSize],(long)[validationSize integerValue]);
            NSInteger  tempVideoSize=[[NSString stringWithFormat:@"%llu",[properties fileSize]] integerValue];
            totalSizeOFUploadedVideo = totalSizeOFUploadedVideo + tempVideoSize;
            //NSLog(@">> %ld >> %ld",(long)tempVideoSize,(long)totalSizeOFUploadedVideo);
            if (totalSizeOFUploadedVideo > [validationSize integerValue]) {
                [[NSUserDefaults standardUserDefaults]setValue:@"YES" forKey:@"largeFileSiz"];
            }
            else{
                [[NSUserDefaults standardUserDefaults]setValue:@"NO" forKey:@"largeFileSiz"];
                
            }
            if (totalSizeOFUploadedVideo > 70000000) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    alert(@"WARNING", @"You cannot upload total size of file(files) more than 15MB.")
                    
                });
                
            }
            else if ([properties fileSize] > [validationSize integerValue]) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    alert(@"WARNING", @"Please upload file size less than 15MB.")
                    
                });
                
            }
            else{
                tempstrDataType=@"data:video/mp4;base64,";
                NSMutableDictionary * tempDic = [[NSMutableDictionary alloc] init];
                //        [tempDic setValue:[[info objectForKey:UIImagePickerControllerReferenceURL] lastPathComponent] forKey:@"fileName"];
                //          [tempDic setValue:[[info objectForKey:UIImagePickerControllerReferenceURL] pathExtension] forKey:@"fileType"];
                [tempDic setValue:@"Video" forKey:@"Key"];
                [tempDic setValue:strEncoded forKey:@"Value"];
                [arrVideoOrImage addObject:tempDic];

              //  [aDict setObject:strEncoded forKey:@"answer"];
              //  [aDict setObject:tempstrDataType forKey:@"existingResponse"];
                
            }
        }
    }
    
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        [library saveImage:_imgBodilyFluid toAlbum:@"Connect2" withCompletionBlock:^(NSError *error) {
            if (error!=nil)
            {
                //NSLog(@"error: %@", [error description]);
            }               [gblAppDelegate.navigationController dismissViewControllerAnimated:YES completion:^{
            }];
        }];
    }else{
        if (popOver)
        {
            
            
            [popOver dismissPopoverAnimated:YES];
        }
        else
        {
            
            [gblAppDelegate.navigationController dismissViewControllerAnimated:YES completion:^{
            }];
        }
    }
//    CGRect frame1 =  _tblVideoList.frame;
//    frame1.size.height = (arrVideoOrImage.count * 50) + 50;
//    _tblVideoList.frame = frame1;
    [_tblVideoList reloadData];
   [self viewSetUp:NO];

//    DynamicFormCell *aCell = [_tblForm dequeueReusableCellWithIdentifier:@"cell"];
//    [aCell.lblUploadFile setHidden:NO];
//    [self.tblForm reloadData];
}



- (void)showCamera {
    
    UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
    if ([_radioBtnImg isSelected]) {
        [imgPicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    }
    else{
        [imgPicker setSourceType:UIImagePickerControllerSourceTypeCamera];
        [imgPicker setMediaTypes:[[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil]];
    }
    [imgPicker setDelegate:self];
    [imgPicker setAllowsEditing:YES];
    [gblAppDelegate.navigationController presentViewController:imgPicker animated:YES completion:^{
        
    }];
}

- (IBAction)btnSubmitTapped:(UIButton *)sender {
    if ([self validationFinalSubmit]) {
        
        NSDictionary *aDictParams = [self sendData];
   //     //NSLog(@"%@",aDictParams);
    [[WebSerivceCall webServiceObject]callServiceForAddNewCreateWorkOrder:YES paraDic:aDictParams isReadyForFollowupcomplition:@"true" complition:^{
         [self.navigationController popViewControllerAnimated:YES];
       alert(@"", @"Work Order created successfully");
       

    }];
}

}
- (IBAction)btnSubmitLatterTapped:(UIButton *)sender {
    NSDictionary *aDictParams = [self sendData];
    ////NSLog(@"%@",aDictParams);
    [[WebSerivceCall webServiceObject]callServiceForAddNewCreateWorkOrder:YES paraDic:aDictParams isReadyForFollowupcomplition:@"false" complition:^{
          [self.navigationController popViewControllerAnimated:YES];
        alert(@"", @"Your work order has been saved in progress.  It can be found under My Work Orders.");
      
        
    }];

}
-(NSDictionary*)sendData{
    
    
    NSString* date,* time ,*maintenanceType = @"";

    NSDateFormatter * dateformatter = [[NSDateFormatter alloc]init];
    [dateformatter setDateFormat:@"MM/dd/yyyy"];
    NSDate *from = [dateformatter dateFromString:_txtDateOfWorkOrder.text];
    [dateformatter setDateFormat:@"yyyy/MM/dd"];
    date = [dateformatter stringFromDate:from];
    
    [dateformatter setDateFormat:@"hh:mm a"];
    NSDate *to = [dateformatter dateFromString:_txtTimeWorkOrder.text];
    [dateformatter setDateFormat:@"yyyy/MM/dd HH:mm"];
    time = [dateformatter stringFromDate:to];


    
    if (_radioBtnMaintenanceType1.selected) {
        
        maintenanceType = @"2";
        
    }
    else if (_radioBtnMaintenanceType2.selected)
    {

        maintenanceType = @"1";
        
    }

    
    
    NSDictionary *aDict = @{
                                  @"Id":@"0",
                                  @"WorkOrderSetUpId":@"0",
                                  @"WorkOrderDate":date,
                                  @"WorkOrderTime":time,
                                  @"DescriptionOfIssue":[NSString stringWithFormat:@"%@",_txtDescriptionIssue.text],
                                  @"AdditionalInformation":[NSString stringWithFormat:@"%@",_txtAddiInfo.text],
                                  @"StatusId":[self returnSelectedId:arrStatus selectedStr:_txtStatus.text],
                                  @"EquipmentActionId":[self returnSelectedId:arrEquipmentActionTaken selectedStr:_txtActionTaken2.text],
                                  @"EquipmentNatureId":[self returnSelectedId:arrEquipmentNature selectedStr:_txtNature2.text],
                                  @"GeneralActionId":[self returnSelectedId:arrGenralActionTaken selectedStr:_txtActionTaken.text],
                                  @"GeneralNatureId":[self returnSelectedId:arrGenralNature selectedStr:_txtNature.text],
                                  @"MaintenanceType":maintenanceType,
                                  @"InventorySetupId":@"0",
                                  @"InventoryManufactureId":[self returnSelectedId:arrManufactur selectedStr:_txtManufacture.text],
                                  @"InventoryBrandId":[self returnSelectedId:arrBrand selectedStr:_txtBrand.text],
                                  @"InventoryModelId":[self returnSelectedId:arrModel selectedStr:_txtMode.text],
                                  @"InventoryLocationId":selectedLocationId,
                                  @"InventoryTypeId":[self returnSelectedId:arrEquipmentType selectedStr:_txtType.text],
                                  @"InventoryCategoryId":[self returnSelectedId:arrCategoty selectedStr:_txtCategory.text],
                                  @"IsNotificationField1Selected":[self radioBtnSelected:_radioBtnServity1],
                                  @"IsNotificationField2Selected":[self radioBtnSelected:_radioBtnServity2],
                                  @"IsNotificationField3Selected":[self radioBtnSelected:_radioBtnServity3],
                                  @"IsNotificationField4Selected":[self radioBtnSelected:_radioBtnServity4],
                                  @"EquipmentId":[NSString stringWithFormat:@"%@",_txtEquipmentId.text],
                                  @"EquipmentName":[NSString stringWithFormat:@"%@",_txtEquipmentName.text],
                                  @"IsPhotoExists":[self isPgotoVideoExist:arrVideoOrImage index:0 strImageOrVideo:@"img"],
                                  @"IsVideoExist":[self isPgotoVideoExist:arrVideoOrImage index:0 strImageOrVideo:@"vid"],
                                  @"Photo1":[self returnBase64String:arrVideoOrImage index:0 strImageOrVideo:@"img"],
                                  @"Photo2":[self returnBase64String:arrVideoOrImage index:1 strImageOrVideo:@"img"],
                                  @"Photo3":[self returnBase64String:arrVideoOrImage index:2 strImageOrVideo:@"img"],
                                  @"Video1":[self returnBase64String:arrVideoOrImage index:0 strImageOrVideo:@"vid"],
                                  @"PersonFirstName":[NSString stringWithFormat:@"%@",_txtFname.text],
                                  @"PersonMiddleInitial":[NSString stringWithFormat:@"%@",_txtMname.text],
                                  @"PersonLastName":[NSString stringWithFormat:@"%@",_txtLname.text],
                                  @"PersonHomePhone":@"",//[NSString stringWithFormat:@"%@",_txtDescriptionIssue.text],
                                  @"PersonAlternatePhone":@"",//[NSString stringWithFormat:@"%@",_txtDescriptionIssue.text],
                                  @"PersonEmail":[NSString stringWithFormat:@"%@",_txtEmail.text]
                                  };
    ////NSLog(@"%@",aDict);
    return aDict;
}
-(NSString*)returnBase64String:(NSMutableArray*)arr index:(int)index strImageOrVideo:(NSString*)strImageOrVideo{
    
        if (arrVideoOrImage.count > index) {
           if (_radioBtnImg.isSelected) {
               if ([strImageOrVideo isEqualToString:@"vid"]) {
                   return @"";
               }else
               return [[arrVideoOrImage valueForKey:@"Value"] objectAtIndex:index];
        }
           else if (_radioBtnVideo.isSelected){
                if ([strImageOrVideo isEqualToString:@"img"]) {
                    return @"";
                }else
               return [[arrVideoOrImage valueForKey:@"Value"] objectAtIndex:index];

           }
    }
    return @"";
}
-(NSString*)isPgotoVideoExist:(NSMutableArray*)arr index:(int)index strImageOrVideo:(NSString*)strImageOrVideo{
    
    if (arrVideoOrImage.count > 0) {
        if (_radioBtnImg.isSelected) {
            if ([strImageOrVideo isEqualToString:@"img"]) {
                 return @"true";
            }
            else{
                return @"false";
            }
        }
        else if (_radioBtnVideo.isSelected){
            if ([strImageOrVideo isEqualToString:@"vid"]) {
                return @"true";
            }
            else{
                return @"false";
            }
    }
    }
    return @"false";
}
-(NSString*)radioBtnSelected:(UIButton*)senderBtn{
    if (senderBtn.selected) {
        return @"true";
    }
    else
        return @"false";
}
- (NSString*)returnSelectedId:(NSArray*)arr selectedStr:(NSString*)selectedStr{
    for (int i = 0;  i< arr.count; i++) {
        if ([selectedStr isEqualToString:[[arr valueForKey:@"Text"] objectAtIndex:i]]) {
            return [NSString stringWithFormat:@"%@",[[arr valueForKey:@"Value"] objectAtIndex:i]];
        }
    }
    return @"";
}
-(BOOL)validationFinalSubmit{


    if ([_txtDateOfWorkOrder.text isEqualToString:@""]) {
        alert(@"", @"Please select Work Order date");
         return NO;
    }
    else if ([_txtTimeWorkOrder.text isEqualToString:@""]) {
         alert(@"", @"Please select Work Order time");
        return NO;
    }
    else if ([_txtFacilityRelatedToWorkOrder.text isEqualToString:@""]) {
         alert(@"", @"Please select Work Order facility");
        return NO;
    }
    else if ([_txtLocation.text isEqualToString:@""]) {
         alert(@"", @"Please select Work Order location");
        return NO;
    }
    else if ([_txtCategory.text isEqualToString:@""]) {
         alert(@"", @"Please select Work Order category");
        return NO;
    }
    else if ([_txtDescriptionIssue.text isEqualToString:@""]) {
         alert(@"", @"Please write some Work Order issue description");
        return NO;
    }
        else if ([_txtStatus.text isEqualToString:@""]) {
         alert(@"", @"Please select Work Order status");
            return NO;
        }
    
 if (!_lblStarFName.isHidden) {
            if ([_txtFname.text isEqualToString:@""]) {
                alert(@"", @"Please enter employee first name");
                return NO;
            }
        }
          if (!_lblStarMName.isHidden) {
            if ([_txtMname.text isEqualToString:@""]) {
                alert(@"", @"Please enter employee middle name");
                return NO;
            }
        }
          if (!_lblStarLName.isHidden) {
            if ([_txtLname.text isEqualToString:@""]) {
                alert(@"", @"Please enter employee last name");
                return NO;
            }
        }
          if (!_lblStarEmail.isHidden) {
            if ([_txtEmail.text isEqualToString:@""]) {
                alert(@"", @"Please enter employee email");
                return NO;
            }
        }
    
         if ([_radioBtnMaintenanceType1 isSelected]){
            if (!_lblStarEqipId.isHidden) {
                if ([_txtEquipmentId.text isEqualToString:@""]) {
                    alert(@"", @"Please enter eqipment id");
                    return NO;
                }
            }
              if (!_lblStarSerialId.isHidden) {
                if ([_txtSerialId.text isEqualToString:@""]) {
                    alert(@"", @"Please enter serial id");
                    return NO;
                }
            }
              if (!_lblStarEqipName.isHidden) {
                if ([_txtEquipmentName.text isEqualToString:@""]) {
                    alert(@"", @"Please enter eqipment name");
                    return NO;
                }
            }
            if (!_lblStarManufact.isHidden) {
                if ([_txtManufacture.text isEqualToString:@""]) {
                    alert(@"", @"Please enter eqipment manufacture");
                    return NO;
                }
            }
              if (!_lblStarEqType.isHidden) {
                if ([_txtType.text isEqualToString:@""]) {
                    alert(@"", @"Please enter eqipment type");
                    return NO;
                }
            }
         if (!_lblStarEqMode.isHidden) {
                if ([_txtMode.text isEqualToString:@""]) {
                    alert(@"", @"Please enter eqipment model");
                    return NO;
                }
            }
           if (!_lblStarEqBrand.isHidden) {
                if ([_txtBrand.text isEqualToString:@""]) {
                    alert(@"", @"Please enter eqipment brand");
                    return NO;
                }
            }
             if (!_lblStarEqAction.isHidden) {
                if ([_txtActionTaken2.text isEqualToString:@""]) {
                    alert(@"", @"Please enter eqipment action taken");
                    return NO;
                }
            }
           if (!_lblStarEqNature.isHidden) {
                if ([_txtNature2.text isEqualToString:@""]) {
                    alert(@"", @"Please enter eqipment nature");
                    return NO;
                }
            }
         }else if ([_radioBtnMaintenanceType2 isSelected]){
             if (!_lblStarGAction.isHidden) {
                 if ([_txtActionTaken.text isEqualToString:@""]) {
                     alert(@"", @"Please enter general action taken");
                     return NO;
                 }
             }
             if (!_lblStarGNature.isHidden) {
                 if ([_txtNature.text isEqualToString:@""]) {
                     alert(@"", @"Please enter general nature");
                     return NO;
                 }
             }
         }
    

    return YES;
}
- (void)btnFillTapped:(UIButton *)sender {
    _isUpdate = YES;
    NSString * strIsBarCode, *strBarcode;
 //   //NSLog(@"%@",sender.titleLabel.text);
    if ([sender.titleLabel.text isEqualToString:@"Fill"]) {
        strIsBarCode = @"false";
        strBarcode = _txtEquipmentId.text;
    }
    else
    {
        strIsBarCode = @"true";
        strBarcode = sender.titleLabel.text;
    }
    [[WebSerivceCall webServiceObject]callServiceForGetEquipmentDetailsWorkOrder:YES strBarcode:strBarcode strIsBarCode:strIsBarCode complition:^{
    
        NSData *dictionaryData = [[NSUserDefaults standardUserDefaults] objectForKey:@"equipmentWorkOrderRecponce"];
        equipmentResponceDic = [NSKeyedUnarchiver unarchiveObjectWithData:dictionaryData];
        //NSLog(@"%@",equipmentResponceDic);
        
        if ([[equipmentResponceDic valueForKey:@"Success"] boolValue]) {
            _txtSerialId.text = [equipmentResponceDic valueForKey:@"SerialId"];
            _txtEquipmentName.text = [equipmentResponceDic valueForKey:@"ItemName"];
            _txtManufacture.text = [equipmentResponceDic valueForKey:@"InventoryManufactureName"];
            _txtType.text = [equipmentResponceDic valueForKey:@"InventoryTypeName"];
            _txtMode.text = [equipmentResponceDic valueForKey:@"InventoryModelName"];
            _txtBrand.text = [equipmentResponceDic valueForKey:@"InventoryBrandName"];
            _txtEquipmentId.text = [equipmentResponceDic valueForKey:@"ItemId"];
            _lblInventoryNotFound.hidden = YES;
           
            _txtSerialId.userInteractionEnabled = NO;
            _txtEquipmentName.userInteractionEnabled = NO;
            _txtManufacture.userInteractionEnabled = NO;
            _txtType.userInteractionEnabled = NO;
            _txtMode.userInteractionEnabled = NO;
            _txtBrand.userInteractionEnabled = NO;
            
        }
        else{
            _txtSerialId.text = @"";
            _txtEquipmentName.text = @"";
            _txtManufacture.text = @"";
            _txtType.text = @"";
            _txtMode.text = @"";
            _txtBrand.text = @"";
            _lblInventoryNotFound.hidden = NO;
        }
        
}];
    
}

- (IBAction)btnScanBarcodeTapped:(id)sender {
    _isUpdate = YES;
    // _viewCamera.hidden = false;
    _btnBackground.hidden = false;
    captureSession = [[AVCaptureSession alloc] init];
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    [captureSession addInput:input];
    
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [captureSession addOutput:captureMetadataOutput];
    // Create a new queue and set delegate for metadata objects scanned.
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("scanQueue", NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    // Delegate should implement captureOutput:didOutputMetadataObjects:fromConnection: to get callbacks on detected metadata.
    [captureMetadataOutput setMetadataObjectTypes:[captureMetadataOutput availableMetadataObjectTypes]];
    
    captureLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:captureSession];
    [captureLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [captureLayer setFrame:CGRectMake((self.view.frame.size.width/2) - 300, (self.view.frame.size.height/2)-300, 600, 600)];
    [self.btnBackground.layer addSublayer:captureLayer];
    [captureSession startRunning];
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    // Do your action on barcode capture here:
    NSString *capturedBarcode = nil;
    
    // Specify the barcodes you want to read here:
    NSArray *supportedBarcodeTypes = @[AVMetadataObjectTypeUPCECode,
                                       AVMetadataObjectTypeCode39Code,
                                       AVMetadataObjectTypeCode39Mod43Code,
                                       AVMetadataObjectTypeEAN13Code,
                                       AVMetadataObjectTypeEAN8Code,
                                       AVMetadataObjectTypeCode93Code,
                                       AVMetadataObjectTypeCode128Code,
                                       AVMetadataObjectTypePDF417Code,
                                       AVMetadataObjectTypeQRCode,
                                       AVMetadataObjectTypeAztecCode];
    
    // In all scanned values..
 //   //NSLog(@"%@",metadataObjects);
 //   //NSLog(@"%@",supportedBarcodeTypes);
    for (AVMetadataObject *barcodeMetadata in metadataObjects) {
        // ..check if it is a suported barcode
     //   //NSLog(@"%@",barcodeMetadata);
        for (NSString *supportedBarcode in supportedBarcodeTypes) {
        //    //NSLog(@"%@",supportedBarcode);
            if ([supportedBarcode isEqualToString:barcodeMetadata.type]) {
                // This is a supported barcode
                // Note barcodeMetadata is of type AVMetadataObject
                // AND barcodeObject is of type AVMetadataMachineReadableCodeObject
                AVMetadataMachineReadableCodeObject *barcodeObject = (AVMetadataMachineReadableCodeObject *)[captureLayer transformedMetadataObjectForMetadataObject:barcodeMetadata];
                capturedBarcode = [barcodeObject stringValue];
                // Got the barcode. Set the text in the UI and break out of the loop.
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [captureSession stopRunning];
                    //self.scannedBarcode.text = capturedBarcode;
                 //   //NSLog(capturedBarcode);
                    // _viewBackground.hidden = true;
                    _btnBackground.hidden = true;
                    _txtQRCode.text = capturedBarcode;
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                      
                        [tempBtn setTitle:capturedBarcode forState:UIControlStateNormal];
                        [self btnFillTapped:tempBtn];

                    });
                                   });
                
                return;
            }
        }
    }
}
- (IBAction)btnBackgroundClick:(id)sender {
    _btnBackground.hidden = true;
}

- (IBAction)btnHideImageViewTapped:(UIButton *)sender {
    _viewFullBGImageVideo.hidden = YES;
}
- (IBAction)btnDeleteImageVideo:(UIButton *)sender {
    _isUpdate = YES;
    _viewFullBGImageVideo.hidden = YES;
    [arrVideoOrImage removeObjectAtIndex:selectedImgVidIndex];
      [_tblVideoList reloadData];
}
@end
