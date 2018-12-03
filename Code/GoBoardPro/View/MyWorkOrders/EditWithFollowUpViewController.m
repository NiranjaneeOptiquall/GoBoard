//
//  EditWithFollowUpViewController.m
//  GoBoardPro
//
//  Created by Optiquall Solutions on 08/01/18.
//  Copyright © 2018 IndiaNIC. All rights reserved.
//

#import "EditWithFollowUpViewController.h"
#import "MyWorkOrdersTableViewCell.h"
#import "EditWorkOrderTableViewCell.h"
#import "DatePopOverView.h"
#import "DropDownPopOver.h"
#import "UserHomeViewController.h"
#import "SearchWorkOrdersViewController.h"
#import "ALAssetsLibrary+CustomPhotoAlbum.h"
@import AVFoundation;

@interface EditWithFollowUpViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,DropDownValueDelegate,UIPopoverControllerDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate,AVCaptureMetadataOutputObjectsDelegate,UITextViewDelegate,UIWebViewDelegate,UIGestureRecognizerDelegate>
{
    CGRect rect;
    UIPopoverController *popOver;
    NSMutableArray * arrAssignedTo,*arrStatus,*arrCategoty,*arrGenralNature,*arrGenralActionTaken,*arrEquipmentNature,*arrEquipmentActionTaken,*arrRepairType,*arrInventoryPartsUsed,*arrPositon,*arrUsers,*arrNotification,*arrVideo, *arrViewImgVideo,*arrImage,*arrInventoryPartUsed,*arrManufactur,*arrEquipmentType,*arrModel,*arrBrand,*selectedPositionArr,*selectedUserArr,*arrAddFollowUpLog,*arrF_UStatus,*arrAddFollowUpQuestions,*arrEquipmentId,*arrNotes,*arrEmployeeReq,*arrEquipmentReq,*arrSortedUser,*arrGenReq,*arrOfLoadedMedia;
    NSInteger strEditSaveIndex,selectedImgVidIndex;
    NSString * selectedNumber,*tempstrDataType,*selectedStatusId,*selectedNature,*selectedActionTaken,*flagReloadHeader,*selectedFacilityId,*selectedLocationId,*flagServiseCall,*selectedF_UQNumber;
    NSDictionary * responceDic,*equipmentResponceDic,*responceInventoryDic,*responceEquipmentIdDic,*responcePhotoVideoDic,*responcePhotoVideoData;
    NSMutableDictionary *submitDic;
    NSInteger  totalSizeOFUploadedVideo;
    NSMutableArray *arrFacility,*arrLocation;
    BOOL showFollowUpQ1,showFollowUpQ2,showFollowUpQ3,showFollowUpQ4;
    UILabel * disclaimer,*disclaimerNote;
     UIButton * tempBtn;

}
@property (weak, nonatomic) IBOutlet UILabel *lblCostOfParts;

@property (weak, nonatomic) IBOutlet UITextField *txtOtherNote;
@property (weak, nonatomic) IBOutlet UITextField *txtOtherNote2;
@property (weak, nonatomic) IBOutlet UIImageView *imgBGOtherNote2;
@property (weak, nonatomic) IBOutlet UIImageView *imgBGOtherNote;

@property (weak, nonatomic) IBOutlet UIButton *btnselectAllPositions;
@property (weak, nonatomic) IBOutlet UIButton *btnSelectAllUsers;

@property (weak, nonatomic) IBOutlet UIWebView *webViewVideoShow;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewPhotoVideo;
@property (weak, nonatomic) IBOutlet UIView *viewFullBGImageVideo;
@property (weak, nonatomic) IBOutlet UILabel *lblShowImageVideo;
@property (weak, nonatomic) IBOutlet UILabel *lblTitleGeneralActionTaken;
@property (weak, nonatomic) IBOutlet UILabel *lblHours;
@property (weak, nonatomic) IBOutlet UILabel *lblTotalCost;
@property (weak, nonatomic) IBOutlet UILabel *RepairHourlyRate;
@property (weak, nonatomic) IBOutlet UILabel *lblCostOfReplacement;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;

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
@property (weak, nonatomic) IBOutlet UILabel *lblAddImg;
@property (weak, nonatomic) IBOutlet UIButton *radioBtnImg;
@property (weak, nonatomic) IBOutlet UIButton *radioBtnVideo;
@property (weak, nonatomic) IBOutlet UITableView *tblVideoList;
@property (weak, nonatomic) IBOutlet UILabel *lblVideo;
@property (weak, nonatomic) IBOutlet UIButton *btnAttachVideoOrPhoto;
@property (weak, nonatomic) IBOutlet UILabel *lblAssignTo;
@property (weak, nonatomic) IBOutlet UILabel *lblPositions;
@property (weak, nonatomic) IBOutlet UILabel *lblUsers;
@property (weak, nonatomic) IBOutlet UILabel *lblWorkOrderType;
@property (weak, nonatomic) IBOutlet UILabel *lblIfRepair;
@property (weak, nonatomic) IBOutlet UITextField *txtSelectRepairTime;
@property (weak, nonatomic) IBOutlet UIImageView *imgSelectRepairTime;
@property (weak, nonatomic) IBOutlet UIImageView *imgBGSelectRepairTime;
@property (weak, nonatomic) IBOutlet UIImageView *imgBGInventoryTypes;
@property (weak, nonatomic) IBOutlet UITextField *txtInventoryTypes;
@property (weak, nonatomic) IBOutlet UIImageView *imgInventoryTypes;
@property (weak, nonatomic) IBOutlet UITextField *txtCostOfParts;
@property (weak, nonatomic) IBOutlet UIImageView *imgBGCostOfParts;
@property (weak, nonatomic) IBOutlet UILabel *lblCostOfLabor;
@property (weak, nonatomic) IBOutlet UITextField *txtHourlyRate;
@property (weak, nonatomic) IBOutlet UIImageView *imgBGHourlyRate;
@property (weak, nonatomic) IBOutlet UITextField *txtRepairLaborHour;
@property (weak, nonatomic) IBOutlet UIImageView *imgBGRepairLaborHour;
@property (weak, nonatomic) IBOutlet UITextField *txtRepairTotalCost;
@property (weak, nonatomic) IBOutlet UIImageView *imgBGRepairTotalCost;
@property (weak, nonatomic) IBOutlet UILabel *lblIfReplacement;
@property (weak, nonatomic) IBOutlet UIImageView *imgBGCostOfReplacement;
@property (weak, nonatomic) IBOutlet UITextField *txtCostOfReplacement;
@property (weak, nonatomic) IBOutlet UILabel *lblEstimatedDate;
@property (weak, nonatomic) IBOutlet UILabel *lblComplitionDate;
@property (weak, nonatomic) IBOutlet UIImageView *imgBGEstimatedDate;
@property (weak, nonatomic) IBOutlet UIImageView *imgEstimatedDate;
@property (weak, nonatomic) IBOutlet UITextField *txtEstimatedDate;
@property (weak, nonatomic) IBOutlet UIImageView *imgBGComplitionDate;
@property (weak, nonatomic) IBOutlet UIImageView *imgComplitionDate;
@property (weak, nonatomic) IBOutlet UITextField *txtComplitionDate;
@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;
@property (weak, nonatomic) IBOutlet UIButton *btnSubmitLatter;

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
@property (weak, nonatomic) IBOutlet UIImageView *imgBgAddiInfo;
@property (weak, nonatomic) IBOutlet UILabel *lblAddiInfo;
@property (weak, nonatomic) IBOutlet UITextView *txtAddiInfo;
@property (weak, nonatomic) IBOutlet UIImageView *imgBgStatus;
@property (weak, nonatomic) IBOutlet UIImageView *imgStatus;
@property (weak, nonatomic) IBOutlet UITextField *txtStatus;
@property (weak, nonatomic) IBOutlet UITableView *tblInventoryPart;
@property (weak, nonatomic) IBOutlet UILabel *lblInventoryPartUsed;
@property (weak, nonatomic) IBOutlet UIButton *btnAddInventoryPart;
@property (weak, nonatomic) IBOutlet UITableView *tblPositons;
@property (weak, nonatomic) IBOutlet UITableView *tblUsers;
@property (weak, nonatomic) IBOutlet UILabel *lblStarDateofAccident;
@property (weak, nonatomic) IBOutlet UILabel *lblStarTimeofAccident;
@property (weak, nonatomic) IBOutlet UILabel *lblStarFacility;
@property (weak, nonatomic) IBOutlet UILabel *lblStarLocation;
@property (weak, nonatomic) IBOutlet UILabel *lblStarCategory;
@property (weak, nonatomic) IBOutlet UILabel *lblStarStatus;
@property (weak, nonatomic) IBOutlet UILabel *lblStarEstimatedDate;
@property (weak, nonatomic) IBOutlet UILabel *lblStarCompletionDate;
@property (weak, nonatomic) IBOutlet UILabel *lblStarAssignedTo;
@property (weak, nonatomic) IBOutlet UIView *viewBGFollowUp;
@property (weak, nonatomic) IBOutlet UILabel *lblF_UpQue1;
@property (weak, nonatomic) IBOutlet UILabel *lblF_UpQue2;
@property (weak, nonatomic) IBOutlet UILabel *lblF_UpQue3;
@property (weak, nonatomic) IBOutlet UILabel *lblF_UpQue4;
@property (weak, nonatomic) IBOutlet UIButton *radioBtnF_Up_Q1_Y;
@property (weak, nonatomic) IBOutlet UIButton *radioBtnF_Up_Q1_N;
@property (weak, nonatomic) IBOutlet UIButton *radioBtnF_Up_Q1_NA;
@property (weak, nonatomic) IBOutlet UIButton *radioBtnF_Up_Q2_Y;
@property (weak, nonatomic) IBOutlet UIButton *radioBtnF_Up_Q2_N;
@property (weak, nonatomic) IBOutlet UIButton *radioBtnF_Up_Q2_NA;
@property (weak, nonatomic) IBOutlet UIButton *radioBtnF_Up_Q3_Y;
@property (weak, nonatomic) IBOutlet UIButton *radioBtnF_Up_Q3_N;
@property (weak, nonatomic) IBOutlet UIButton *radioBtnF_Up_Q3_NA;
@property (weak, nonatomic) IBOutlet UIButton *radioBtnF_Up_Q4_Y;
@property (weak, nonatomic) IBOutlet UIButton *radioBtnF_Up_Q4_N;
@property (weak, nonatomic) IBOutlet UIButton *radioBtnF_Up_Q4_NA;
@property (weak, nonatomic) IBOutlet UIButton *btnClearFollow_UpQuestions;
@property (weak, nonatomic) IBOutlet UITableView *tblFollowUp;
@property (weak, nonatomic) IBOutlet UIView *viewBgHeaderTblFollowUp;
@property (weak, nonatomic) IBOutlet UILabel *lblF_UStatus;
@property (weak, nonatomic) IBOutlet UIImageView *imgBgF_UStatus;
@property (weak, nonatomic) IBOutlet UIImageView *imgF_UStatus;
@property (weak, nonatomic) IBOutlet UITextField *txtF_UStatus;
@property (weak, nonatomic) IBOutlet UIImageView *imgBgF_UName;
@property (weak, nonatomic) IBOutlet UITextField *txtF_UName;
@property (weak, nonatomic) IBOutlet UIImageView *imgBgF_UEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtF_UEmail;
@property (weak, nonatomic) IBOutlet UIImageView *imgBgF_UPhone;
@property (weak, nonatomic) IBOutlet UITextField *txtF_UPhone;
@property (weak, nonatomic) IBOutlet UIImageView *imgBgF_UCell;
@property (weak, nonatomic) IBOutlet UITextField *txtF_UCell;
@property (weak, nonatomic) IBOutlet UIImageView *imgBgF_UAddInfo;
@property (weak, nonatomic) IBOutlet UILabel *lblF_UAddInfo;
@property (weak, nonatomic) IBOutlet UITextView *txtF_UAddInfo;
@property (weak, nonatomic) IBOutlet UIButton *btnAddFollowUp;
@property (weak, nonatomic) IBOutlet UIButton *btnF_USave;
@property (weak, nonatomic) IBOutlet UIButton *btnF_UCancel;

@property (weak, nonatomic) IBOutlet UITableView *tblF_UQuestionREsponce;
@property (weak, nonatomic) IBOutlet UIView *viewBgF_UQuestion;
@property (weak, nonatomic) IBOutlet UILabel *lblF_ULogEntries;
@property (weak, nonatomic) IBOutlet UILabel *lblF_UQueEntries;
@property (weak, nonatomic) IBOutlet UILabel *lblF_UQuestions;
@property (weak, nonatomic) IBOutlet UIButton *btnF_UQSave;
@property (weak, nonatomic) IBOutlet UIButton *btnF_UQCancel;
@property (weak, nonatomic) IBOutlet UIButton *btnDeleteWorkOrder;
@property (weak, nonatomic) IBOutlet UITableView *tblNotes;

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
@property (weak, nonatomic) IBOutlet UILabel *lblReviewNotes;
@property (weak, nonatomic) IBOutlet UILabel *lblStarF_UStatus;

@end


@implementation EditWithFollowUpViewController
{
    AVCaptureSession *captureSession;
    AVCaptureVideoPreviewLayer *captureLayer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(didTapOutSideOfDropDown:)];
    [self.view addGestureRecognizer:tapGesture];
    tapGesture.delegate = self;
    
    _isUpdate = NO;
    
    _txtOtherNote.text = @"";
    _txtOtherNote2.text = @"";
    showFollowUpQ1 = YES;
    showFollowUpQ2 = YES;
    showFollowUpQ3 = YES;
    showFollowUpQ4 = YES;
    
    _txtOtherNote.hidden = true;
    _imgBGOtherNote.hidden = true;
    _txtOtherNote2.hidden = true;
    _imgBGOtherNote2.hidden = true;
    
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
    selectedFacilityId = @"";
    selectedF_UQNumber=@"";
    _btnBackground.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    flagServiseCall = @"YES";
    _viewBGVideoImage.hidden = YES;
    _viewFullBGImageVideo.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    _viewBgHeaderTblFollowUp.hidden = YES;
    //_viewBgHeaderAddInventoryPart.hidden = YES;
    flagReloadHeader = @"YES";
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    _viewBgBarcode.hidden = YES;
    _txtDateOfWorkOrder.text = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:[NSDate date]]];
    [dateFormatter setDateFormat:@"hh:mm a"];
    _txtTimeWorkOrder.text = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:[NSDate date]]];
    
    [_tblInventoryPart sizeToFit];
    [_tblVideoList sizeToFit];
    [_tblF_UQuestionREsponce sizeToFit];
    [_tblFollowUp sizeToFit];
    [_tblNotes sizeToFit];
    [_tblScrollBG sizeToFit];
  //  self.automaticallyAdjustsScrollViewInsets = NO;
    
    _tblInventoryPart.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, _tblInventoryPart.bounds.size.width, 0.01f)];
    _tblVideoList.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, _tblVideoList.bounds.size.width, 0.01f)];
    _tblF_UQuestionREsponce.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, _tblF_UQuestionREsponce.bounds.size.width, 0.01f)];
    _tblFollowUp.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, _tblFollowUp.bounds.size.width, 0.01f)];
    _tblNotes.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, _tblNotes.bounds.size.width, 0.01f)];
    _tblScrollBG.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, _tblScrollBG.bounds.size.width, 0.01f)];
    
    _tblInventoryPart.frame = CGRectMake(_tblInventoryPart.frame.origin.x, _tblInventoryPart.frame.origin.y, _tblInventoryPart.frame.size.width, 150);
    _tblVideoList.frame = CGRectMake(_tblVideoList.frame.origin.x, _tblVideoList.frame.origin.y, _tblVideoList.frame.size.width, 200);
    _tblF_UQuestionREsponce.frame = CGRectMake(_tblF_UQuestionREsponce.frame.origin.x, _tblF_UQuestionREsponce.frame.origin.y, _tblF_UQuestionREsponce.frame.size.width, 200);
    _tblFollowUp.frame = CGRectMake(_tblFollowUp.frame.origin.x, _tblFollowUp.frame.origin.y, _tblFollowUp.frame.size.width, 166);
    _tblNotes.frame = CGRectMake(_tblNotes.frame.origin.x, _tblNotes.frame.origin.y, _tblNotes.frame.size.width, 171);
    
    _tblScrollBG.frame = CGRectMake(0, 89, 768, 900);
    
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    arrOfLoadedMedia = [[NSMutableArray alloc]init];
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
    arrSortedUser = [[NSMutableArray alloc]init];
    arrNotification = [[NSMutableArray alloc]init];
    arrVideo = [[NSMutableArray alloc]init];
     arrImage = [[NSMutableArray alloc]init];
    arrInventoryPartUsed = [[NSMutableArray alloc]init];
    arrManufactur = [[NSMutableArray alloc]init];
    arrEquipmentType = [[NSMutableArray alloc]init];
    arrModel = [[NSMutableArray alloc]init];
    arrBrand = [[NSMutableArray alloc]init];
    selectedUserArr = [[NSMutableArray alloc]init];
    selectedPositionArr = [[NSMutableArray alloc]init];
    submitDic =[[NSMutableDictionary alloc]init];
    arrAddFollowUpLog = [[NSMutableArray alloc]init];
    arrF_UStatus = [[NSMutableArray alloc]init];
    arrAddFollowUpQuestions = [[NSMutableArray alloc]init];
    arrEquipmentId = [[NSMutableArray alloc]init];
    arrNotes = [[NSMutableArray alloc]init];
    arrEmployeeReq = [[NSMutableArray alloc]init];
    arrEquipmentReq = [[NSMutableArray alloc]init];
     arrGenReq = [[NSMutableArray alloc]init];
    arrViewImgVideo = [[NSMutableArray alloc]init];
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
      _lblStarCategory.hidden = YES;
    
    _lblStarMName.hidden = YES;
    _lblStarLName.hidden = YES;
    _lblStarEmail.hidden = YES;
    _lblStarFName.hidden = YES;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"UserFacility"];
    [request setPropertiesToFetch:@[@"name", @"value"]];
    NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    [request setSortDescriptors:@[sortByName]];
    NSArray * arr = [gblAppDelegate.managedObjectContext executeFetchRequest:request error:nil];
    arrFacility = [arr mutableCopy];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"editwithFollowUpWorkOrderRecponce"];
    
     [self viewSetUp];
    
    
            if (gblAppDelegate.isNetworkReachable) {
                [gblAppDelegate showActivityIndicator];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
    
    
    
    [[WebSerivceCall webServiceObject]callServiceForGetEditWithFollowUpWorkOrder:YES workOrderId:_orderId isInResponses:@"false" workOrderHistoryId:_workOrderHistoryId complition:^{
        
        
        NSData *dictionaryData = [[NSUserDefaults standardUserDefaults] objectForKey:@"editwithFollowUpWorkOrderRecponce"];
        NSDictionary* tempResponceDic = [NSKeyedUnarchiver unarchiveObjectWithData:dictionaryData];
        //        ErrorMessage = "<null>";
        //        ErrorStackTrace = "<null>";
        //        Id = 5051;
        //        IsFollowup = 1;
        //        IsFollowupQuestionsSet = 1;
        //        IsInResponses = 0;
        responceDic = [tempResponceDic valueForKey:@"WorkOrderResponseSelected"];
        
        NSLog(@"%@",responceDic);
        arrCategoty = [responceDic valueForKey:@"CategoryOptions"];
        
        arrEquipmentNature = [responceDic valueForKey:@"EquipmentNatureOptions"];
        arrEquipmentActionTaken = [responceDic  valueForKey:@"EquipmentActionOptions"];
        arrGenralNature = [responceDic valueForKey:@"GeneralNatureOptions"];
        arrGenralActionTaken = [responceDic valueForKey:@"GeneralActionOptions"];
        arrStatus = [responceDic valueForKey:@"StatusOptions"];
        arrInventoryPartUsed = [responceDic valueForKey:@"InventoryPartsUsed"];
        arrPositon = [responceDic valueForKey:@"PositionOptions"];
        arrNotification = [responceDic valueForKey:@"NotificationFieldOptions"];
        arrManufactur = [responceDic valueForKey:@"ManufactureOptions"];
        arrEquipmentType = [responceDic valueForKey:@"InventoryType"];
        arrModel = [responceDic valueForKey:@"ModelOptions"];
        arrBrand = [responceDic valueForKey:@"BrandOptions"];
        arrRepairType = [responceDic valueForKey:@"RepairTypeOptions"];
        arrEquipmentReq = [responceDic valueForKey:@"EquipmentRequiredFields"];
         arrGenReq = [responceDic valueForKey:@"GeneralMaintenanceRequiredFields"];
        arrEmployeeReq = [responceDic valueForKey:@"EmployeeRequiredFields"];
        _lblInstructions.text = [responceDic valueForKey:@"Instructions"];
        arrAddFollowUpQuestions = [responceDic valueForKey:@"Followups"];
         arrAddFollowUpLog = [responceDic valueForKey:@"FollowupLogs"];
        
        
        if ([_isOnlyView isEqualToString:@"YES"]) {
            _btnDeleteWorkOrder.hidden = YES;
            _btnSubmit.hidden = YES;
            _btnSubmitLatter.hidden = YES;
            [self editAllowSetup:NO editBellowAssingTO:NO];
        }
        else if ([_isEditAllow isEqualToString:@"YES"]) {
            [self editAllowSetup:YES editBellowAssingTO:YES];
            
        }
        else if ([_isF_EditAllow isEqualToString:@"YES"]) {
            
            [self editAllowSetup:NO editBellowAssingTO:YES];
            
        }
        else{
            [self editAllowSetup:NO editBellowAssingTO:NO];
        }
        
        
        if (![[responceDic valueForKey:@"AdditionalInformationLabel"]isKindOfClass:[NSNull class]]){
            if ( ![[responceDic valueForKey:@"AdditionalInformationLabel"] isEqualToString:@""]) {
                _lblAddiInfo.text = [responceDic valueForKey:@"AdditionalInformationLabel"];
                
            }
            
        }
        
        NSArray * arrTempUsers = [responceDic valueForKey:@"UserItems"];
        for (int i = 0; i<arrTempUsers.count; i++) {
            if ([arrUsers containsObject:[arrTempUsers objectAtIndex:i]]) {
            }
            else{
                [arrUsers addObject:[arrTempUsers objectAtIndex:i]];
                [arrSortedUser addObject:[arrTempUsers objectAtIndex:i]];
            }
            
        }
        
        
        int totatl = 0;
        for (int i=0; i<arrInventoryPartUsed.count; i++) {
            totatl = totatl + [[[arrInventoryPartUsed valueForKey:@"cost"] objectAtIndex:i] intValue];
        }
        _txtCostOfParts.text = [NSString stringWithFormat:@"%d",totatl];
//        if (![[responceDic valueForKey:@"ShowHourlyRate"] boolValue]) {
//            _txtRepairTotalCost.text = _txtCostOfParts.text;
//        }
         [self totalCost];
        for (int i = 0; i<arrUsers.count; i++) {
            if ([[[arrUsers valueForKey:@"Selected"] objectAtIndex:i] boolValue]) {
                [selectedUserArr addObject:[[arrUsers valueForKey:@"Id"] objectAtIndex:i]];
            }
            
        }
        
        
//        for (int i = 0; i<arrAddFollowUpQuestions.count; i++) {
//            
//            NSArray * tempArr = [[NSArray alloc] init];
//            tempArr = [[arrAddFollowUpQuestions valueForKey:@"FollowupLogs"] objectAtIndex:i];
//            for (int j = 0; j<tempArr.count; j++) {
//                [arrAddFollowUpLog addObject:[tempArr objectAtIndex:j]] ;
//            }
//        }
        
        
        
        if (![[responceDic valueForKey:@"Category"]isKindOfClass:[NSNull class]]){
            
            for (int i=0; i<arrCategoty.count; i++) {
                if ([[[arrCategoty valueForKey:@"Value"] objectAtIndex:i] isEqualToString:[NSString stringWithFormat:@"%@",[responceDic valueForKey:@"Category"]]]) {
                    _txtCategory.text = [[arrCategoty valueForKey:@"Text"] objectAtIndex:i];
                }
            }
        }
        
        
        if (![[responceDic valueForKey:@"WorkOrderNotes"]isKindOfClass:[NSNull class]]){
            arrNotes = [responceDic valueForKey:@"WorkOrderNotes"];
        }
        
        if (![[responceDic valueForKey:@"DateOfCompletion"]isKindOfClass:[NSNull class]]){
            
            _txtComplitionDate.text = [self dateFormatting:[responceDic valueForKey:@"DateOfCompletion"] dateFormate:@"yyyy-MM-dd'T'HH:mm:ss" time:NO];
        }
        if (![[responceDic valueForKey:@"EstimatedDateOfCompletion"]isKindOfClass:[NSNull class]]){
            
            _txtEstimatedDate.text =[self dateFormatting:[responceDic valueForKey:@"EstimatedDateOfCompletion"] dateFormate:@"yyyy-MM-dd'T'HH:mm:ss" time:NO] ;
        }
        if (![[responceDic valueForKey:@"DescriptionOfIssue"]isKindOfClass:[NSNull class]]){
            if (![[responceDic valueForKey:@"DescriptionOfIssue"] isEqualToString:@""]) {
                _txtDescriptionIssue.text = [responceDic valueForKey:@"DescriptionOfIssue"];
                _lblBgDescriptionIssue.hidden = YES;
            }
            
        }
        if (![[responceDic valueForKey:@"WorkOrderFollowUpLog"] isKindOfClass:[NSNull class]]){
            
            if (![[[responceDic valueForKey:@"WorkOrderFollowUpLog"] valueForKey:@"Name"]isKindOfClass:[NSNull class]]){
                _txtF_UName.text = [[responceDic valueForKey:@"WorkOrderFollowUpLog"] valueForKey:@"Name"];
                
            }
            if (![[[responceDic valueForKey:@"WorkOrderFollowUpLog"] valueForKey:@"Email"]isKindOfClass:[NSNull class]]){
                _txtF_UEmail.text = [[responceDic valueForKey:@"WorkOrderFollowUpLog"] valueForKey:@"Email"];            }
            if (![[[responceDic valueForKey:@"WorkOrderFollowUpLog"] valueForKey:@"CellNumber"]isKindOfClass:[NSNull class]]){
                _txtF_UCell.text = [[responceDic valueForKey:@"WorkOrderFollowUpLog"] valueForKey:@"CellNumber"];
            }
            if (![[[responceDic valueForKey:@"WorkOrderFollowUpLog"] valueForKey:@"PhoneNumber"]isKindOfClass:[NSNull class]]){
                _txtF_UPhone.text = [[responceDic valueForKey:@"WorkOrderFollowUpLog"] valueForKey:@"PhoneNumber"];
            }
        }
        //        if (![[responceDic valueForKey:@"EmployeeComplitingReportAdditionalInfor"]isKindOfClass:[NSNull class]] ){
        //            if (![[responceDic valueForKey:@"EmployeeComplitingReportAdditionalInfor"] isEqualToString:@""]) {
        //                _txtAddiInfo.text = [responceDic valueForKey:@"EmployeeComplitingReportAdditionalInfor"];
        //                _lblAddiInfo.hidden = YES;
        //            }
        //                    }
        if (![[responceDic valueForKey:@"EmployeeComplitingReportAdditionalInfor"]isKindOfClass:[NSNull class]]){
            if ( ![[responceDic valueForKey:@"EmployeeComplitingReportAdditionalInfor"] isEqualToString:@""]) {
                _txtAddiInfo.text = [responceDic valueForKey:@"EmployeeComplitingReportAdditionalInfor"];
                _lblAddiInfo.hidden = YES;
                
            }
            
        }
        if (![[responceDic valueForKey:@"EmployeeComplitingReportEmailId"]isKindOfClass:[NSNull class]]){
            
            _txtEmail.text = [responceDic valueForKey:@"EmployeeComplitingReportEmailId"];
        }
        if (![[responceDic valueForKey:@"EmployeeComplitingReportFirstName"]isKindOfClass:[NSNull class]]){
            _txtFname.text = [responceDic valueForKey:@"EmployeeComplitingReportFirstName"];
            
        }
        if (![[responceDic valueForKey:@"EmployeeComplitingReportLastName"]isKindOfClass:[NSNull class]]){
            
            _txtLname.text = [responceDic valueForKey:@"EmployeeComplitingReportLastName"];
        }
        if (![[responceDic valueForKey:@"EmployeeComplitingReportMiddleName"]isKindOfClass:[NSNull class]]){
            _txtMname.text = [responceDic valueForKey:@"EmployeeComplitingReportMiddleName"];
        }
        
        if (![[responceDic valueForKey:@"EquipmentBarCode"]isKindOfClass:[NSNull class]] ){
            if (![ [responceDic valueForKey:@"EquipmentBarCode"] isEqualToString:@""]) {
                _txtQRCode.text = [responceDic valueForKey:@"EquipmentBarCode"];
                
            }
        }
        if (![[responceDic valueForKey:@"EquipmentQRCode"]isKindOfClass:[NSNull class]] ){
            if (![ [responceDic valueForKey:@"EquipmentQRCode"] isEqualToString:@""]) {
                _txtQRCode.text = [responceDic valueForKey:@"EquipmentQRCode"];
            }
            
        }
        if (![[responceDic valueForKey:@"EquipmentId"]isKindOfClass:[NSNull class]]){
            _txtEquipmentId.text = [responceDic valueForKey:@"EquipmentId"];
        }
        if (![[responceDic valueForKey:@"EquipmentName"]isKindOfClass:[NSNull class]]){
            _txtEquipmentName.text = [responceDic valueForKey:@"EquipmentName"];
            _txtEquipmentName.userInteractionEnabled = NO;
            
        }
        NSDictionary * tempEquipmentData = [responceDic valueForKey:@"EquipmentData"];
        if (![[tempEquipmentData valueForKey:@"InventoryType"]isKindOfClass:[NSNull class]]){
            
            for (int i = 0; i<arrEquipmentType.count; i++) {
                if ([[NSString stringWithFormat:@"%@",[tempEquipmentData valueForKey:@"InventoryType"]] isEqualToString:[[arrEquipmentType valueForKey:@"Value"] objectAtIndex:i]]) {
                    _txtType.text = [[arrEquipmentType valueForKey:@"Text"] objectAtIndex:i];
                    _txtType.userInteractionEnabled = NO;
                }
            }
        }
        if (![[tempEquipmentData valueForKey:@"InventoryModel"]isKindOfClass:[NSNull class]]){
            
            for (int i = 0; i<arrModel.count; i++) {
                if ([[NSString stringWithFormat:@"%@",[tempEquipmentData valueForKey:@"InventoryModel"]] isEqualToString:[[arrModel valueForKey:@"Value"] objectAtIndex:i]]) {
                    _txtMode.text = [[arrModel valueForKey:@"Text"] objectAtIndex:i];
                    _txtMode.userInteractionEnabled = NO;
                }
            }
        }
        //        EquipmentData = "<null>";
        if (![[responceDic valueForKey:@"FacilityId"]isKindOfClass:[NSNull class]]){
            NSString * strFacilityId =[NSString stringWithFormat:@"%@",[responceDic valueForKey:@"FacilityId"]];
            
            NSFetchRequest *requestLoc = [[NSFetchRequest alloc] initWithEntityName:@"UserInventoryLocation"];
            NSPredicate *predicateLoc = [NSPredicate predicateWithFormat:@"%K MATCHES[cd] %@", @"facility.value", strFacilityId];
            [requestLoc setPredicate:predicateLoc];
            NSSortDescriptor *sortByName2 = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
            [requestLoc setSortDescriptors:@[sortByName2]];
            [requestLoc setPropertiesToFetch:@[@"name", @"value"]];
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

            
            
            
            for (int i=0; i<arrFacility.count; i++) {
                if ([strFacilityId isEqualToString:[[arrFacility valueForKey:@"value"] objectAtIndex:i]]) {
                    _txtFacilityRelatedToWorkOrder.text = [[arrFacility valueForKey:@"name"] objectAtIndex:i];
                    selectedFacilityId = [[arrFacility valueForKey:@"value"] objectAtIndex:i];
                }
            }
            if (![[responceDic valueForKey:@"Location"]isKindOfClass:[NSNull class]]){
                selectedLocationId = [NSString stringWithFormat:@"%@",[responceDic valueForKey:@"Location"]];
                for (int i=0; i<arrLocation.count; i++) {
                    if ([[NSString stringWithFormat:@"%@",[responceDic valueForKey:@"Location"]] isEqualToString:[[arrLocation valueForKey:@"value"] objectAtIndex:i]]) {
                        _txtLocation.text = [[arrLocation valueForKey:@"name"] objectAtIndex:i];
                        selectedLocationId = [[arrLocation valueForKey:@"value"] objectAtIndex:i];
                    }
                }
            }
        }
        
        
        if (![[responceDic valueForKey:@"InventoryManufacturerId"]isKindOfClass:[NSNull class]]){
            
            for (int i = 0; i<arrManufactur.count; i++) {
                if ([[NSString stringWithFormat:@"%@",[responceDic valueForKey:@"InventoryManufacturerId"]] isEqualToString:[[arrManufactur valueForKey:@"Value"] objectAtIndex:i]]) {
                    _txtManufacture.text = [[arrManufactur valueForKey:@"Text"] objectAtIndex:i];
                    _txtManufacture.userInteractionEnabled = NO;
                }
            }
        }
        if (![[responceDic valueForKey:@"InventoryBrandId"]isKindOfClass:[NSNull class]]){
            
            for (int i = 0; i<arrBrand.count; i++) {
                if ([[NSString stringWithFormat:@"%@",[responceDic valueForKey:@"InventoryBrandId"]] isEqualToString:[[arrBrand valueForKey:@"Value"] objectAtIndex:i]]) {
                    _txtBrand.text = [[arrBrand valueForKey:@"Text"] objectAtIndex:i];
                    _txtBrand.userInteractionEnabled = NO;
                }
            }
        }

        
        
     
        if (![[responceDic valueForKey:@"RepairLabourHour"]isKindOfClass:[NSNull class]]){
            _txtRepairLaborHour.text = [NSString stringWithFormat:@"%@",[responceDic valueForKey:@"RepairLabourHour"]];
        }
        if (![[responceDic valueForKey:@"RepairLabourHourlyCost"]isKindOfClass:[NSNull class]]){
            _txtHourlyRate.text = [NSString stringWithFormat:@"%@",[responceDic valueForKey:@"RepairLabourHourlyCost"]];
        }
        if (![[responceDic valueForKey:@"RepairTotalCost"]isKindOfClass:[NSNull class]]){
            _txtRepairTotalCost.text = [NSString stringWithFormat:@"%@",[responceDic valueForKey:@"RepairTotalCost"]] ;
        }
        if (![[responceDic valueForKey:@"ReplacementCost"]isKindOfClass:[NSNull class]]){
            _txtCostOfReplacement.text = [NSString stringWithFormat:@"%@",[responceDic valueForKey:@"ReplacementCost"]];
        }
        if (![[responceDic valueForKey:@"SerialId"]isKindOfClass:[NSNull class]]){
            _txtSerialId.text = [responceDic valueForKey:@"SerialId"];
             _txtSerialId.userInteractionEnabled = NO;
        }
        if (![[responceDic valueForKey:@"RepairCostOfParts"]isKindOfClass:[NSNull class]]){
            _txtCostOfParts.text = [NSString stringWithFormat:@"%@",[responceDic valueForKey:@"RepairCostOfParts"]];
//            if (![[responceDic valueForKey:@"ShowHourlyRate"] boolValue]) {
//                _txtRepairTotalCost.text = [NSString stringWithFormat:@"%@",[responceDic valueForKey:@"RepairCostOfParts"]];
//            }
        }
        
        if (![[responceDic valueForKey:@"FollowUpQuestionText1"]isKindOfClass:[NSNull class]]){
            _lblF_UpQue1.text = [responceDic valueForKey:@"FollowUpQuestionText1"];
        }
        if (![[responceDic valueForKey:@"FollowUpQuestionText2"]isKindOfClass:[NSNull class]]){
            _lblF_UpQue2.text = [responceDic valueForKey:@"FollowUpQuestionText2"];
            
        }
        if (![[responceDic valueForKey:@"FollowUpQuestionText3"]isKindOfClass:[NSNull class]]){
            _lblF_UpQue3.text = [responceDic valueForKey:@"FollowUpQuestionText3"];
            
        }
        if (![[responceDic valueForKey:@"FollowUpQuestionText4"]isKindOfClass:[NSNull class]]){
            _lblF_UpQue4.text = [responceDic valueForKey:@"FollowUpQuestionText4"];
            
        }
        if (![[responceDic valueForKey:@"FollowupCallOptions"]isKindOfClass:[NSNull class]]){
            arrF_UStatus = [responceDic valueForKey:@"FollowupCallOptions"];
        }
        //        ShowFollowUpStatus = 1;
        BOOL showFollowUp = [[responceDic valueForKey:@"ShowFollowUp"] boolValue];
        if (showFollowUp) {
            
            showFollowUpQ1 = [[responceDic valueForKey:@"ShowFollowUpQuestion1"] boolValue];
            showFollowUpQ2 = [[responceDic valueForKey:@"ShowFollowUpQuestion2"] boolValue];
            showFollowUpQ3 = [[responceDic valueForKey:@"ShowFollowUpQuestion3"] boolValue];
            showFollowUpQ4 = [[responceDic valueForKey:@"ShowFollowUpQuestion4"] boolValue];
            BOOL showFollowUpStatus = [[responceDic valueForKey:@"ShowFollowUpStatus"] boolValue];
            if (showFollowUpQ1) {
                if (![[responceDic valueForKey:@"FollowUpQuestionText1"]isKindOfClass:[NSNull class]]){
                    _lblF_UpQue1.text = [NSString stringWithFormat:@"%@",[responceDic valueForKey:@"FollowUpQuestionText1"]];
                    
                }
            }
            else{
                CGRect frame = _lblF_UpQue1.frame;
                frame.size.height = 0.1f;
                _lblF_UpQue1.frame = frame;
                
                frame = _radioBtnF_Up_Q1_Y.frame;
                frame.size.height = 0.1f;
                _radioBtnF_Up_Q1_Y.frame = frame;
                
                frame = _radioBtnF_Up_Q1_N.frame;
                frame.size.height = 0.1f;
                _radioBtnF_Up_Q1_N.frame = frame;
                
                frame = _radioBtnF_Up_Q1_NA.frame;
                frame.size.height = 0.1f;
                _radioBtnF_Up_Q1_NA.frame = frame;
                
                _radioBtnF_Up_Q1_Y.hidden = YES;
                _radioBtnF_Up_Q1_N.hidden = YES;
                _radioBtnF_Up_Q1_NA.hidden = YES;
                
            }
            if (showFollowUpQ2) {
                
                if (![[responceDic valueForKey:@"FollowUpQuestionText2"]isKindOfClass:[NSNull class]]){
                    _lblF_UpQue2.text = [NSString stringWithFormat:@"%@",[responceDic valueForKey:@"FollowUpQuestionText2"]];
                    
                }
            }
            else{
                CGRect frame = _lblF_UpQue2.frame;
                frame.size.height = 0.1f;
                _lblF_UpQue2.frame = frame;
                
                frame = _radioBtnF_Up_Q2_Y.frame;
                frame.size.height = 0.1f;
                _radioBtnF_Up_Q2_Y.frame = frame;
                
                frame = _radioBtnF_Up_Q2_N.frame;
                frame.size.height = 0.1f;
                _radioBtnF_Up_Q2_N.frame = frame;
                
                frame = _radioBtnF_Up_Q2_NA.frame;
                frame.size.height = 0.1f;
                _radioBtnF_Up_Q2_NA.frame = frame;
                
                _radioBtnF_Up_Q2_Y.hidden = YES;
                _radioBtnF_Up_Q2_N.hidden = YES;
                _radioBtnF_Up_Q2_NA.hidden = YES;
            }
            
            if (showFollowUpQ3) {
                
                if (![[responceDic valueForKey:@"FollowUpQuestionText3"]isKindOfClass:[NSNull class]]){
                    _lblF_UpQue3.text = [NSString stringWithFormat:@"%@",[responceDic valueForKey:@"FollowUpQuestionText3"]];
                    
                }
            }
            else{
                CGRect frame = _lblF_UpQue3.frame;
                frame.size.height = 0.1f;
                _lblF_UpQue3.frame = frame;
                
                frame = _radioBtnF_Up_Q3_Y.frame;
                frame.size.height = 0.1f;
                _radioBtnF_Up_Q3_Y.frame = frame;
                
                frame = _radioBtnF_Up_Q3_N.frame;
                frame.size.height = 0.1f;
                _radioBtnF_Up_Q3_N.frame = frame;
                
                frame = _radioBtnF_Up_Q3_NA.frame;
                frame.size.height = 0.1f;
                _radioBtnF_Up_Q3_NA.frame = frame;
                
                _radioBtnF_Up_Q3_Y.hidden = YES;
                _radioBtnF_Up_Q3_N.hidden = YES;
                _radioBtnF_Up_Q3_NA.hidden = YES;
                
            }
            
            if (showFollowUpQ4) {
                
                if (![[responceDic valueForKey:@"FollowUpQuestionText4"]isKindOfClass:[NSNull class]]){
                    _lblF_UpQue4.text =[NSString stringWithFormat:@"%@",[responceDic valueForKey:@"FollowUpQuestionText4"]] ;
                    
                }
            }
            else{
                CGRect frame = _lblF_UpQue4.frame;
                frame.size.height = 0.1f;
                _lblF_UpQue4.frame = frame;
                
                frame = _radioBtnF_Up_Q4_Y.frame;
                frame.size.height = 0.1f;
                _radioBtnF_Up_Q4_Y.frame = frame;
                
                frame = _radioBtnF_Up_Q4_N.frame;
                frame.size.height = 0.1f;
                _radioBtnF_Up_Q4_N.frame = frame;
                
                frame = _radioBtnF_Up_Q4_NA.frame;
                frame.size.height = 0.1f;
                _radioBtnF_Up_Q4_NA.frame = frame;
                
                _radioBtnF_Up_Q4_Y.hidden = YES;
                _radioBtnF_Up_Q4_N.hidden = YES;
                _radioBtnF_Up_Q4_NA.hidden = YES;
            }
            if (showFollowUpStatus) {
                //                 _txtF_UStatus.text = [[arrF_UStatus valueForKey:@"Text"] objectAtIndex:1];
                //                if (![[responceDic valueForKey:@"InventoryManufacturerId"]isKindOfClass:[NSNull class]]){
                //
                //                    for (int i = 0; i<arrF_UStatus.count; i++) {
                //                        if ([[NSString stringWithFormat:@"%@",[responceDic valueForKey:@"ShowFollowUpStatus"]] isEqualToString:[[arrF_UStatus valueForKey:@"Value"] objectAtIndex:i]]) {
                //                            _txtF_UStatus.text = [[arrF_UStatus valueForKey:@"Text"] objectAtIndex:i];
                //                        }
                //                    }
                //                }
            }
            
            else{
                CGRect frame = _txtF_UStatus.frame;
                frame.size.height = 0.1f;
                _txtF_UStatus.frame = frame;
                
            }
            
        }
        else{
            CGRect frame = _viewBGFollowUp.frame;
            frame.size.height = 0.1f;
            _viewBGFollowUp.frame =frame;
        }
        if (![[responceDic valueForKey:@"Status"]isKindOfClass:[NSNull class]]){
            
            for (int i = 0; i<arrStatus.count; i++) {
                if ([[NSString stringWithFormat:@"%@",[responceDic valueForKey:@"Status"]] isEqualToString:[[arrStatus valueForKey:@"Value"] objectAtIndex:i]]) {
                    _txtStatus.text = [[arrStatus valueForKey:@"Text"] objectAtIndex:i];
                }
            }
        }
        if (![[responceDic valueForKey:@"WorkOrderDate"]isKindOfClass:[NSNull class]]){
            _txtDateOfWorkOrder.text = [self dateFormatting:[responceDic valueForKey:@"WorkOrderDate"] dateFormate:@"yyyy-MM-dd'T'HH:mm:ss" time:NO] ;
            
        }
        if (![[responceDic valueForKey:@"WorkOrderTime"]isKindOfClass:[NSNull class]]){
            _txtTimeWorkOrder.text = [self dateFormatting:[responceDic valueForKey:@"WorkOrderTime"] dateFormate:@"yyyy-MM-dd'T'HH:mm:ss" time:YES];
        }
        if (![[responceDic valueForKey:@"WorkOrderEquipmentMaintenanceActionTakenId"]isKindOfClass:[NSNull class]]){
            
            for (int i = 0; i<arrEquipmentActionTaken.count; i++) {
                if ([[NSString stringWithFormat:@"%@",[responceDic valueForKey:@"WorkOrderEquipmentMaintenanceActionTakenId"]] isEqualToString:[[arrEquipmentActionTaken valueForKey:@"Value"] objectAtIndex:i]]) {
                    _txtActionTaken2.text = [[arrEquipmentActionTaken valueForKey:@"Text"] objectAtIndex:i];
                }
            }
        }
        
        
        if (![[responceDic valueForKey:@"WorkOrderEquipmentMaintenanceNatureId"]isKindOfClass:[NSNull class]]){
            
            for (int i = 0; i<arrEquipmentNature.count; i++) {
                if ([[NSString stringWithFormat:@"%@",[responceDic valueForKey:@"WorkOrderEquipmentMaintenanceNatureId"]] isEqualToString:[[arrEquipmentNature valueForKey:@"Value"] objectAtIndex:i]]) {
                    _txtNature2.text = [[arrEquipmentNature valueForKey:@"Text"] objectAtIndex:i];
                    if ([[[[arrEquipmentNature valueForKey:@"Text"] objectAtIndex:i]uppercaseString] isEqualToString:@"OTHER"]) {
                        
                        _txtOtherNote2.hidden = false;
                        _imgBGOtherNote2.hidden = false;
                         if (![[responceDic valueForKey:@"OtherEquipmentNature"]isKindOfClass:[NSNull class]]){
                        _txtOtherNote2.text = [responceDic valueForKey:@"OtherEquipmentNature"];
                         }
                         else{
                             _txtOtherNote2.text = @"";
                         }
                    }
                    else{
                        _txtOtherNote2.hidden = true;
                        _imgBGOtherNote2.hidden = true;
                      
                    }
                }
            }
        }
        if (![[responceDic valueForKey:@"WorkOrderGeneralMaintenanceActionTakenId"]isKindOfClass:[NSNull class]]){
            
            for (int i = 0; i<arrGenralActionTaken.count; i++) {
                if ([[NSString stringWithFormat:@"%@",[responceDic valueForKey:@"WorkOrderGeneralMaintenanceActionTakenId"]] isEqualToString:[[arrGenralActionTaken valueForKey:@"Value"] objectAtIndex:i]]) {
                    _txtActionTaken.text = [[arrGenralActionTaken valueForKey:@"Text"] objectAtIndex:i];
                }
            }
        }
        if (![[responceDic valueForKey:@"WorkOrderGeneralMaintenanceNatureId"]isKindOfClass:[NSNull class]]){
            
            for (int i = 0; i<arrGenralNature.count; i++) {
                if ([[NSString stringWithFormat:@"%@",[responceDic valueForKey:@"WorkOrderGeneralMaintenanceNatureId"]] isEqualToString:[[arrGenralNature valueForKey:@"Value"] objectAtIndex:i]]) {
                    _txtNature.text = [[arrGenralNature valueForKey:@"Text"] objectAtIndex:i];
                    if ([[[[arrGenralNature valueForKey:@"Text"] objectAtIndex:i]uppercaseString] isEqualToString:@"OTHER"]) {
                        
                        _txtOtherNote.hidden = false;
                        _imgBGOtherNote.hidden = false;
                        if (![[responceDic valueForKey:@"OtherGeneralNature"]isKindOfClass:[NSNull class]]){
                            _txtOtherNote.text = [responceDic valueForKey:@"OtherGeneralNature"];
                        }
                        else{
                            _txtOtherNote.text = @"";
                        }
                        
                    }
                    else{
                        _txtOtherNote.hidden = true;
                        _imgBGOtherNote.hidden = true;
                    }
                }
            }
        }
        if (![[responceDic valueForKey:@"WorkOrderRepairTypeId"]isKindOfClass:[NSNull class]]){
            
            for (int i = 0; i<arrRepairType.count; i++) {
                if ([[NSString stringWithFormat:@"%@",[responceDic valueForKey:@"WorkOrderRepairTypeId"]] isEqualToString:[[arrRepairType valueForKey:@"Value"] objectAtIndex:i]]) {
                    _txtSelectRepairTime.text = [[arrRepairType valueForKey:@"Text"] objectAtIndex:i];
                }
            }
        }

        if (![[responceDic valueForKey:@"MaintenanceType"]isKindOfClass:[NSNull class]]){
            if ([[NSString stringWithFormat:@"%@",[responceDic valueForKey:@"MaintenanceType"]] isEqualToString:@"1"]) {
                [_radioBtnMaintenanceType2 setSelected:YES];
            }else
            {
                [_radioBtnMaintenanceType1 setSelected:YES];
            }
        }
        BOOL isPhotoExists = [[responceDic valueForKey:@"IsPhotoExists"] boolValue];
        BOOL isVideoExist = [[responceDic valueForKey:@"IsVideoExist"] boolValue];
        if (isPhotoExists){
            if (![[responceDic valueForKey:@"Photos"]isKindOfClass:[NSNull class]]) {
                arrImage = [responceDic valueForKey:@"Photos"];
                [_radioBtnImg setSelected:YES];
                _lblVideo.text = @"Image";
                [_btnAttachVideoOrPhoto setTitle:@"Attach image" forState:UIControlStateNormal];

            }
            
        }
        else if (isVideoExist){
               if (![[responceDic valueForKey:@"Videos"]isKindOfClass:[NSNull class]]) {
                   
            arrVideo = [responceDic valueForKey:@"Videos"];
            [_radioBtnVideo setSelected:YES];
            _lblVideo.text = @"Video";
            [_btnAttachVideoOrPhoto setTitle:@"Attach video" forState:UIControlStateNormal];
               }
        }
        else{
            [_radioBtnImg setSelected:YES];
            _lblVideo.text = @"Image";
            [_btnAttachVideoOrPhoto setTitle:@"Attach image" forState:UIControlStateNormal];
            
        }

  


        
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
        

        

        
        
        if (![[responceDic valueForKey:@"SeverityValue"]isKindOfClass:[NSNull class]]){
            for (int i=0; i<arrNotification.count; i++) {
                if ([[NSString stringWithFormat:@"%@",[responceDic valueForKey:@"SeverityValue"]] isEqualToString:[[arrNotification valueForKey:@"Value"] objectAtIndex:i]]) {
                    if (i == 0) {
                        [_radioBtnServity1 setSelected:YES];
                        if ([[NSString stringWithFormat:@"%@ (A)",[[arrNotification valueForKey:@"Text"] objectAtIndex:i]] isEqualToString:_radioBtnServity1.titleLabel.text]) {
                            disclaimerNote.hidden =NO;
                            disclaimer.hidden = NO;
                        }
                    }else if (i == 1) {
                        [_radioBtnServity2 setSelected:YES];
                        if ([[NSString stringWithFormat:@"%@ (A)",[[arrNotification valueForKey:@"Text"] objectAtIndex:i]] isEqualToString:_radioBtnServity2.titleLabel.text]) {
                            disclaimerNote.hidden =NO;
                            disclaimer.hidden = NO;
                        }
                    }
                    else if (i == 2) {
                        [_radioBtnServity3 setSelected:YES];
                        if ([[NSString stringWithFormat:@"%@ (A)",[[arrNotification valueForKey:@"Text"] objectAtIndex:i]] isEqualToString:_radioBtnServity3.titleLabel.text]) {
                            disclaimerNote.hidden =NO;
                            disclaimer.hidden = NO;
                        }
                    }
                    else if (i == 3) {
                        [_radioBtnServity4 setSelected:YES];
                        if ([[NSString stringWithFormat:@"%@ (A)",[[arrNotification valueForKey:@"Text"] objectAtIndex:i]] isEqualToString:_radioBtnServity4.titleLabel.text]) {
                            disclaimerNote.hidden =NO;
                            disclaimer.hidden = NO;
                        }
                    }
                }
            }
        }
        
        if (![[[arrNotification valueForKey:@"Color"] objectAtIndex:0] isKindOfClass:[NSNull class]]) {
            [_radioBtnServity1 setTitleColor:[UIColor colorWithHexCodeString:[[arrNotification valueForKey:@"Color"] objectAtIndex:0]] forState:UIControlStateNormal];
        }
        if (![[[arrNotification valueForKey:@"Color"] objectAtIndex:1] isKindOfClass:[NSNull class]]) {
            [_radioBtnServity2 setTitleColor:[UIColor colorWithHexCodeString:[[arrNotification valueForKey:@"Color"] objectAtIndex:1]] forState:UIControlStateNormal];
        }
        if (![[[arrNotification valueForKey:@"Color"] objectAtIndex:2] isKindOfClass:[NSNull class]]) {
            [_radioBtnServity3 setTitleColor:[UIColor colorWithHexCodeString:[[arrNotification valueForKey:@"Color"] objectAtIndex:2]] forState:UIControlStateNormal];
        }
        if (![[[arrNotification valueForKey:@"Color"] objectAtIndex:3] isKindOfClass:[NSNull class]]) {
            [_radioBtnServity4 setTitleColor:[UIColor colorWithHexCodeString:[[arrNotification valueForKey:@"Color"] objectAtIndex:3]] forState:UIControlStateNormal];
        }
        
        if (_radioBtnMaintenanceType1.isSelected) {
            
            for (int i =0; i<arrEquipmentReq.count; i++) {
                if ([[NSString stringWithFormat:@"%@",[[arrEquipmentReq valueForKey:@"Id"] objectAtIndex:i]] isEqualToString:@"16"]) {
                    if ([[[arrEquipmentReq valueForKey:@"Selected"] objectAtIndex:i] boolValue]) {
                        _lblStarCategory.hidden = NO;
                    }
                }
                else if ([[NSString stringWithFormat:@"%@",[[arrEquipmentReq valueForKey:@"Id"] objectAtIndex:i]] isEqualToString:@"13"]) {
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
   
        arrVideo = [[NSMutableArray alloc]init];
        arrImage = [[NSMutableArray alloc]init];
    arrViewImgVideo = [NSMutableArray new];
        [_tblVideoList reloadData];
        

       
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            BOOL isPhotoExists1 = [[responceDic valueForKey:@"IsPhotoExists"] boolValue];
            BOOL isVideoExist1 = [[responceDic valueForKey:@"IsVideoExist"] boolValue];
               [gblAppDelegate showActivityIndicator];
           // dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
 
            if (isPhotoExists1){
                [self getPhotoVideo:@"photo"];
            }
            else if (isVideoExist1){
                [self getPhotoVideo:@"video"];
            }
       //       });
        });
        dispatch_async(dispatch_get_main_queue(), ^{
            if (![[responceDic valueForKey:@"ShowAdditionalInformation"] boolValue]) {
                _txtAddiInfo.hidden = YES;
                _lblAddiInfo.hidden = YES;
                _imgBgAddiInfo.hidden = YES;
            }
            if (![[responceDic valueForKey:@"ShowInstruction"] boolValue]) {
                _lblInstructions.hidden = YES;
            }
            if (![[responceDic valueForKey:@"AllowDataCapture"] boolValue]) {
                _txtQRCode.hidden = YES;
                _imgBgQRCode.hidden = YES;
                _btnScanCode.hidden = YES;
            }
            
                        if (![[responceDic valueForKey:@"ShowEstimatedDateOfCompletion"] boolValue]) {
                            _txtEstimatedDate.hidden = YES;
                            _imgEstimatedDate.hidden = YES;
                            _imgBGEstimatedDate.hidden = YES;
                             _lblStarEstimatedDate.hidden = YES;
                            _lblEstimatedDate.hidden = YES;
                        }
                        if (![[responceDic valueForKey:@"ShowDateOfCompletion"] boolValue]) {
                            _txtComplitionDate.hidden = YES;
                            _imgComplitionDate.hidden = YES;
                            _imgBGComplitionDate.hidden = YES;
                            _lblStarCompletionDate.hidden = YES;
                            _lblComplitionDate.hidden = YES;
                        }
            
                        if (![[responceDic valueForKey:@"IsShowWorkOrderTypeRepair"] boolValue]) {
                            _lblIfRepair.hidden = YES;
                            _txtInventoryTypes.hidden = YES;
                            _imgInventoryTypes.hidden = YES;
                            _imgBGInventoryTypes.hidden = YES;
                            _txtSelectRepairTime.hidden = YES;
                            _imgSelectRepairTime.hidden = YES;
                            _imgBGSelectRepairTime.hidden = YES;
                            _lblInventoryPartUsed.hidden = YES;
                            _tblInventoryPart.hidden = YES;
                            _btnAddInventoryPart.hidden = YES;
                            _txtCostOfParts.hidden = YES;
                             _imgBGCostOfParts.hidden = YES;
                            
                     
                            _lblCostOfLabor.hidden = YES;
                            _lblHours.hidden = YES;
                            _RepairHourlyRate.hidden = YES;
                            _lblTotalCost.hidden = YES;
                            _txtHourlyRate.hidden = YES;
                            _txtRepairLaborHour.hidden = YES;
                            _txtRepairTotalCost.hidden = YES;
                            _imgBGHourlyRate.hidden = YES;
                            _imgBGRepairLaborHour.hidden = YES;
                            _imgBGRepairTotalCost.hidden = YES;
                            
                            
                            
                        }
            
            if (![[responceDic valueForKey:@"ShowHourlyRate"] boolValue]) {
                
//                _lblCostOfLabor.hidden = YES;
//                _lblHours.hidden = YES;
//                _lblTotalCost.hidden = YES;
//                _txtHourlyRate.hidden = YES;
//                _txtRepairTotalCost.hidden = YES;
//                _imgBGHourlyRate.hidden = YES;
//                _imgBGRepairTotalCost.hidden = YES;
                
                _RepairHourlyRate.hidden = YES;
                _txtRepairLaborHour.hidden = YES;
                _imgBGRepairLaborHour.hidden = YES;
                
            }
            
                        if (![[responceDic valueForKey:@"IsShowWorkOrderTypeReplacement"] boolValue]) {
                            _lblIfReplacement.hidden = YES;
                            _lblCostOfReplacement.hidden = YES;
                            _txtCostOfReplacement.hidden = YES;
                            _imgBGCostOfReplacement.hidden = YES;
                        }
            
            [_tblF_UQuestionREsponce reloadData];
            [_tblFollowUp reloadData];
            [_tblNotes reloadData];
              [self followUpviewSetup];
            [self viewSetUp];
            [_tblPositons reloadData];
            [_tblUsers reloadData];
            [_tblInventoryPart reloadData];
        });
        
       
    }];
       });
}
else{
    alert(@"", @"We're sorry. C2IT is not currently available offline");
}
}
-(void)viewWillAppear:(BOOL)animated{

    
//    BOOL isPhotoExists = [[responceDic valueForKey:@"IsPhotoExists"] boolValue];
//    BOOL isVideoExist = [[responceDic valueForKey:@"IsVideoExist"] boolValue];
//    
//    if (isPhotoExists){
//        [self getPhotoVideo:@"photo"];
//    }
//    else if (isVideoExist){
//        [self getPhotoVideo:@"video"];
//    }
    
    [_tblF_UQuestionREsponce reloadData];
    [_tblFollowUp reloadData];
    [_tblNotes reloadData];
 
    [self followUpviewSetup];
    [self viewSetUp];
    
    if ([_isOnlyView isEqualToString:@"YES"]) {
        [self viewOnlyModeSetup];
           dispatch_async(dispatch_get_main_queue(), ^{
        alert(@"", @"Please note, you are in View Only mode.");
           });
    }
    
}
-(void)editAllowSetup:(BOOL)editALL editBellowAssingTO:(BOOL)editBellowAssingTO{
    
    _btnScanCode.userInteractionEnabled = editBellowAssingTO;//
    _btnBackground.userInteractionEnabled = editBellowAssingTO;
    _txtDateOfWorkOrder.userInteractionEnabled = editBellowAssingTO;
    _txtFacilityRelatedToWorkOrder.userInteractionEnabled = editBellowAssingTO;
    _txtTimeWorkOrder.userInteractionEnabled = editBellowAssingTO;
    _txtLocation.userInteractionEnabled = editBellowAssingTO;
    _txtCategory.userInteractionEnabled = editBellowAssingTO;
    _txtDescriptionIssue.userInteractionEnabled = editBellowAssingTO;
    _radioBtnServity1.userInteractionEnabled = editBellowAssingTO;//
    _radioBtnServity2.userInteractionEnabled = editBellowAssingTO;//
    _radioBtnServity3.userInteractionEnabled = editBellowAssingTO;//
    _radioBtnServity4.userInteractionEnabled = editBellowAssingTO;//
    _radioBtnMaintenanceType1.userInteractionEnabled = editBellowAssingTO;//
    _radioBtnMaintenanceType2.userInteractionEnabled = editBellowAssingTO;//
    _txtNature.userInteractionEnabled = editBellowAssingTO;
    _txtActionTaken.userInteractionEnabled = editBellowAssingTO;
    _txtOtherNote.userInteractionEnabled = editBellowAssingTO;
    _radioBtnImg.userInteractionEnabled = editBellowAssingTO;//
    _radioBtnVideo.userInteractionEnabled = editBellowAssingTO;//
    _btnAttachVideoOrPhoto.userInteractionEnabled = editBellowAssingTO;//
    _txtQRCode.userInteractionEnabled = editBellowAssingTO;
    _txtEquipmentId.userInteractionEnabled = editBellowAssingTO;
    _txtSerialId.userInteractionEnabled = editBellowAssingTO;
    _txtEquipmentName.userInteractionEnabled = editBellowAssingTO;
    _txtManufacture.userInteractionEnabled = editBellowAssingTO;
    _txtType.userInteractionEnabled = editBellowAssingTO;
    _txtMode.userInteractionEnabled = editBellowAssingTO;
    _txtBrand.userInteractionEnabled = editBellowAssingTO;
    _txtNature2.userInteractionEnabled = editBellowAssingTO;
    _txtActionTaken2.userInteractionEnabled = editBellowAssingTO;
     _txtOtherNote2.userInteractionEnabled = editBellowAssingTO;
    _btnFill.userInteractionEnabled = editBellowAssingTO;//
    _txtFname.userInteractionEnabled = editBellowAssingTO;
    _txtMname.userInteractionEnabled = editBellowAssingTO;
    _txtLname.userInteractionEnabled = editBellowAssingTO;
    _txtEmail.userInteractionEnabled = editBellowAssingTO;
    _txtAddiInfo.userInteractionEnabled = editBellowAssingTO;
    _txtStatus.userInteractionEnabled = editBellowAssingTO;
    
    _txtSelectRepairTime.userInteractionEnabled = editBellowAssingTO;
    _txtInventoryTypes.userInteractionEnabled = editBellowAssingTO;
    _txtCostOfParts.userInteractionEnabled = editBellowAssingTO;
    _txtHourlyRate.userInteractionEnabled = editBellowAssingTO;
    _txtRepairLaborHour.userInteractionEnabled = editBellowAssingTO;
    _txtRepairTotalCost.userInteractionEnabled = editBellowAssingTO;
    _txtCostOfReplacement.userInteractionEnabled = editBellowAssingTO;
    _txtEstimatedDate.userInteractionEnabled = editBellowAssingTO;
    _txtComplitionDate.userInteractionEnabled = editBellowAssingTO;
    _btnSubmit.userInteractionEnabled = editBellowAssingTO;
    _btnSubmitLatter.userInteractionEnabled = editBellowAssingTO;
    _btnAddInventoryPart.userInteractionEnabled = editBellowAssingTO;
    _radioBtnF_Up_Q1_Y.userInteractionEnabled = editBellowAssingTO;
    _radioBtnF_Up_Q1_N.userInteractionEnabled = editBellowAssingTO;
    _radioBtnF_Up_Q1_NA.userInteractionEnabled = editBellowAssingTO;
    _radioBtnF_Up_Q2_Y.userInteractionEnabled = editBellowAssingTO;
    _radioBtnF_Up_Q2_N.userInteractionEnabled = editBellowAssingTO;
    _radioBtnF_Up_Q2_NA.userInteractionEnabled = editBellowAssingTO;
    _radioBtnF_Up_Q3_Y.userInteractionEnabled = editBellowAssingTO;
    _radioBtnF_Up_Q3_N.userInteractionEnabled = editBellowAssingTO;
    _radioBtnF_Up_Q3_NA.userInteractionEnabled = editBellowAssingTO;
    _radioBtnF_Up_Q4_Y.userInteractionEnabled = editBellowAssingTO;
    _radioBtnF_Up_Q4_N.userInteractionEnabled = editBellowAssingTO;
    _radioBtnF_Up_Q4_NA.userInteractionEnabled = editBellowAssingTO;
    _btnClearFollow_UpQuestions.userInteractionEnabled = editBellowAssingTO;
    _txtF_UStatus.userInteractionEnabled = editBellowAssingTO;
    _txtF_UName.userInteractionEnabled = editBellowAssingTO;
    _txtF_UEmail.userInteractionEnabled = editBellowAssingTO;
    _txtF_UPhone.userInteractionEnabled = editBellowAssingTO;
    _txtF_UCell.userInteractionEnabled = editBellowAssingTO;
    _txtF_UAddInfo.userInteractionEnabled = editBellowAssingTO;
    _btnAddFollowUp.userInteractionEnabled = editBellowAssingTO;
    _btnF_USave.userInteractionEnabled = editBellowAssingTO;
    //_btnF_UCancel.userInteractionEnabled = editBellowAssingTO;
    _btnF_UQSave.userInteractionEnabled = editBellowAssingTO;
    _btnF_UQCancel.userInteractionEnabled = editBellowAssingTO;
    
}
-(void)viewOnlyModeSetup{
 
    _btnDeleteWorkOrder.hidden = YES;
    _btnSubmit.hidden = YES;
    _btnSubmitLatter.hidden = YES;
    
    [self editAllowSetup:NO editBellowAssingTO:NO];

}
-(void)getPhotoVideo:(NSString*)photoVideo{
   NSString * strId = [NSString stringWithFormat:@"%@",_orderId];
   // if ([strId isEqualToString:@"0"]) {
   //     strId = _orderId;
  //  }
            if (gblAppDelegate.isNetworkReachable) {
    [gblAppDelegate showActivityIndicator];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
 
         [[WebSerivceCall webServiceObject]callServiceForGetPhotoVideoWorkOrder:YES workOrderHistoryId:strId complition:^{
        NSData *dictionaryData = [[NSUserDefaults standardUserDefaults] objectForKey:@"photoVideoWorkOrderRecponce"];
        responcePhotoVideoDic = [NSKeyedUnarchiver unarchiveObjectWithData:dictionaryData];
        //nslog(@"%@",responcePhotoVideoDic);
           if ([photoVideo isEqualToString:@"photo"]) {
        arrImage = [responcePhotoVideoDic valueForKey:@"Media"];
               for (int i = 0; i < arrImage.count; i++) {
                   [arrOfLoadedMedia insertObject:@"a" atIndex:i];
               }
           }
           else{
               arrVideo = [responcePhotoVideoDic valueForKey:@"Media"];
               for (int i = 0; i < arrVideo.count; i++) {
                   [arrOfLoadedMedia insertObject:@"a" atIndex:i];

               }
           }
             
             
        if ([photoVideo isEqualToString:@"photo"]) {
            
            [_radioBtnImg setSelected:YES];
            _lblVideo.text = @"Image";
            [_btnAttachVideoOrPhoto setTitle:@"Attach image" forState:UIControlStateNormal];
            
        }
        else{
            
            [_radioBtnVideo setSelected:YES];
            _lblVideo.text = @"Video";
            [_btnAttachVideoOrPhoto setTitle:@"Attach video" forState:UIControlStateNormal];
            
        }
        
//        CGRect frame1 =  _tblVideoList.frame;
//        frame1.size.height = (arrVideoOrImage.count * 50) +50;
//        _tblVideoList.frame = frame1;
        //    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [_tblVideoList reloadData];
        // });
        
   
        
    }];
       });
            }
            else{
                alert(@"", @"We're sorry. C2IT is not currently available offline");
            }

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

-(void)viewSetUp
{

    CGSize boundingSize = CGSizeMake(_lblInstructions.frame.size.width, FLT_MAX);
    
    float height =[_lblInstructions.text boundingRectWithSize:boundingSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:_lblInstructions.font} context:nil].size.height;
    
    CGRect frame =  _lblInstructions.frame;
    frame.size.height = height;
    _lblInstructions.frame = frame;
    
     frame =  _lblDate.frame;
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
    
//    frame =  _imgBgCategory.frame;
//    frame.origin.y = _imgBGFacility.frame.origin.y + _imgBGFacility.frame.size.height + 20;
//    _imgBgCategory.frame = frame;
//    
//    frame =  _imgCategory.frame;
//    frame.origin.y = _imgBGFacility.frame.origin.y + _imgBGFacility.frame.size.height + 25;
//    _imgCategory.frame = frame;
//    
//    frame =  _lblStarCategory.frame;
//    frame.origin.y = _imgBgCategory.frame.origin.y + (_imgBgCategory.frame.size.height/2) -5;
//    _lblStarCategory.frame = frame;
//    
//    frame =  _txtCategory.frame;
//    frame.origin.y = _imgBGFacility.frame.origin.y + _imgBGFacility.frame.size.height + 25;
//    _txtCategory.frame = frame;
    
    frame =  _imgBGDescriptionIssue.frame;
    frame.origin.y = _imgBGLocationWorkOrder.frame.origin.y + _imgBGLocationWorkOrder.frame.size.height + 20;
    _imgBGDescriptionIssue.frame = frame;
    
    frame =  _lblStarDescriptionIssue.frame;
    frame.origin.y = _imgBGLocationWorkOrder.frame.origin.y + _imgBGLocationWorkOrder.frame.size.height + 50;
    _lblStarDescriptionIssue.frame = frame;
    
    frame =  _lblBgDescriptionIssue.frame;
    frame.origin.y = _imgBGLocationWorkOrder.frame.origin.y + _imgBGLocationWorkOrder.frame.size.height + 50;
    _lblBgDescriptionIssue.frame = frame;
    
    frame =  _txtDescriptionIssue.frame;
    frame.origin.y = _imgBGLocationWorkOrder.frame.origin.y + _imgBGLocationWorkOrder.frame.size.height + 30;
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
    
    frame =  _lblTitleGeneralActionTaken.frame;
    frame.origin.y = _radioBtnMaintenanceType2.frame.origin.y + _radioBtnMaintenanceType2.frame.size.height + 20;
    _lblTitleGeneralActionTaken.frame = frame;
    
    
    frame =  _imgBgNature.frame;
    frame.origin.y = _lblTitleGeneralActionTaken.frame.origin.y + _lblTitleGeneralActionTaken.frame.size.height + 20;
    _imgBgNature.frame = frame;
    
    frame =  _imgNature.frame;
    frame.origin.y = _lblTitleGeneralActionTaken.frame.origin.y + _lblTitleGeneralActionTaken.frame.size.height + 25;
    _imgNature.frame = frame;
    
    frame =  _txtNature.frame;
    frame.origin.y = _lblTitleGeneralActionTaken.frame.origin.y + _lblTitleGeneralActionTaken.frame.size.height + 25;
    _txtNature.frame = frame;
    
    frame =  _imgBgActionTaken.frame;
    frame.origin.y = _lblTitleGeneralActionTaken.frame.origin.y + _lblTitleGeneralActionTaken.frame.size.height + 20;
    _imgBgActionTaken.frame = frame;
    
    frame =  _imgActionTaken.frame;
    frame.origin.y = _lblTitleGeneralActionTaken.frame.origin.y + _lblTitleGeneralActionTaken.frame.size.height + 25;
    _imgActionTaken.frame = frame;
    
    frame =  _txtActionTaken.frame;
    frame.origin.y = _lblTitleGeneralActionTaken.frame.origin.y + _lblTitleGeneralActionTaken.frame.size.height + 25;
    _txtActionTaken.frame = frame;
    
    frame =  _txtOtherNote.frame;
    frame.origin.y = _imgBgActionTaken.frame.origin.y + _imgBgActionTaken.frame.size.height + 25;
    _txtOtherNote.frame = frame;
    
    frame =  _imgBGOtherNote.frame;
    frame.origin.y = _imgBgActionTaken.frame.origin.y + _imgBgActionTaken.frame.size.height + 20;
    _imgBGOtherNote.frame = frame;
    
    frame =  _viewBgBarcode.frame;
    frame.origin.y = _radioBtnMaintenanceType1.frame.origin.y + _radioBtnMaintenanceType1.frame.size.height + 20;
    
    
    if (_radioBtnMaintenanceType1.selected) {
        if (_txtOtherNote2.isHidden) {
            frame.size.height = 560;
        }else{
            frame.size.height = 623;
        }
        
    }else{
        frame.size.height = 560;
    }
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
       // frame.origin.y = _imgBgNature.frame.origin.y + _imgBgNature.frame.size.height + 20;
       
        if (_txtOtherNote.isHidden) {
            frame.origin.y = _imgBgNature.frame.origin.y + _imgBgNature.frame.size.height + 20;
            
        }else{
            frame.origin.y = _imgBgNature.frame.origin.y + _imgBgNature.frame.size.height + 20 + 83;
            
        }
        
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
  //  _tblVideoList.contentSize = CGSizeMake(_tblVideoList.frame.size.width, (arrVideoOrImage.count*50)+50);
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
    
    frame =  _txtFname.frame;
    frame.origin.y = _lblEmployeeReprt.frame.origin.y + _lblEmployeeReprt.frame.size.height + 25;
    _txtFname.frame = frame;
    
    frame =  _imgBgMname.frame;
    frame.origin.y = _lblEmployeeReprt.frame.origin.y + _lblEmployeeReprt.frame.size.height + 20;
    _imgBgMname.frame = frame;
    
    frame =  _txtMname.frame;
    frame.origin.y = _lblEmployeeReprt.frame.origin.y + _lblEmployeeReprt.frame.size.height + 25;
    _txtMname.frame = frame;
    
    frame =  _imgBgLname.frame;
    frame.origin.y = _lblEmployeeReprt.frame.origin.y + _lblEmployeeReprt.frame.size.height + 20;
    _imgBgLname.frame = frame;
    
    frame =  _txtLname.frame;
    frame.origin.y = _lblEmployeeReprt.frame.origin.y + _lblEmployeeReprt.frame.size.height + 25;
    _txtLname.frame = frame;
    
    frame =  _imgBgEmail.frame;
    frame.origin.y = _imgBgFname.frame.origin.y + _imgBgFname.frame.size.height + 20;
    _imgBgEmail.frame = frame;
    
    frame =  _txtEmail.frame;
    frame.origin.y = _imgBgFname.frame.origin.y + _imgBgFname.frame.size.height + 25;
    _txtEmail.frame = frame;
    
    //    frame =  _imgBgAlertBriefDesc.frame;
    //    frame.origin.y = _imgBgEmail.frame.origin.y + _imgBgEmail.frame.size.height + 20;
    //    _imgBgAlertBriefDesc.frame = frame;
    //
    //    frame =  _lblAlertBriefDesc.frame;
    //    frame.origin.y = _imgBgEmail.frame.origin.y + _imgBgEmail.frame.size.height + 40;
    //    _lblAlertBriefDesc.frame = frame;
    //
    //    frame =  _txtAlertBriefDesc.frame;
    //    frame.origin.y = _imgBgEmail.frame.origin.y + _imgBgEmail.frame.size.height + 30;
    //    _txtAlertBriefDesc.frame = frame;
    
    frame =  _imgBgAddiInfo.frame;
    if (_imgBgAddiInfo.hidden) {
        frame.size.height = 0;
    }
    frame.origin.y = _imgBgEmail.frame.origin.y + _imgBgEmail.frame.size.height + 20;
    _imgBgAddiInfo.frame = frame;
    
    frame =  _lblAddiInfo.frame;
//    if (_lblAddiInfo.hidden) {
//        frame.size.height = 0;
//    }
    frame.origin.y = _imgBgEmail.frame.origin.y + _imgBgEmail.frame.size.height + 40;
    _lblAddiInfo.frame = frame;
    
    frame =  _txtAddiInfo.frame;
    if (_txtAddiInfo.hidden) {
        frame.size.height = 0;
    }
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
    frame.origin.y = _lblStatus.frame.origin.y + _lblStatus.frame.size.height + 25;
    _imgStatus.frame = frame;
    
    frame =  _txtStatus.frame;
    frame.origin.y = _lblStatus.frame.origin.y + _lblStatus.frame.size.height + 25;
    _txtStatus.frame = frame;
    
    frame =  _lblAssignTo.frame;
    frame.origin.y = _imgBgStatus.frame.origin.y + _imgBgStatus.frame.size.height + 20;
    _lblAssignTo.frame = frame;
    
    frame =  _lblPositions.frame;
    frame.origin.y = _lblAssignTo.frame.origin.y + _lblAssignTo.frame.size.height + 20;
    _lblPositions.frame = frame;
    
    frame =  _btnselectAllPositions.frame;
    frame.origin.y = _lblAssignTo.frame.origin.y + _lblAssignTo.frame.size.height + 20;
      // frame.origin.x = _lblPositions.frame.origin.x + _lblPositions.frame.size.width + 20;
    _btnselectAllPositions.frame = frame;
    
    frame =  _lblUsers.frame;
    frame.origin.y = _lblAssignTo.frame.origin.y + _lblAssignTo.frame.size.height + 20;
    _lblUsers.frame = frame;
    
    frame =  _btnSelectAllUsers.frame;
    frame.origin.y = _lblAssignTo.frame.origin.y + _lblAssignTo.frame.size.height + 20;
    // frame.origin.x = _lblUsers.frame.origin.x + _lblUsers.frame.size.width + 20;
    _btnSelectAllUsers.frame = frame;
    
    frame =  _lblStarAssignedTo.frame;
    frame.origin.y = _lblUsers.frame.origin.y + 10;
    _lblStarAssignedTo.frame = frame;
    
    frame =  _tblPositons.frame;
    frame.origin.y = _lblPositions.frame.origin.y + _lblPositions.frame.size.height + 20;
    _tblPositons.frame = frame;
    
    frame =  _tblUsers.frame;
    frame.origin.y = _lblPositions.frame.origin.y + _lblPositions.frame.size.height + 20;
    _tblUsers.frame = frame;
    
    frame =  _lblWorkOrderType.frame;
    frame.origin.y = _tblPositons.frame.origin.y + _tblPositons.frame.size.height + 20;
    _lblWorkOrderType.frame = frame;
    
    frame =  _lblIfRepair.frame;
    frame.origin.y = _lblWorkOrderType.frame.origin.y + _lblWorkOrderType.frame.size.height + 20;
    _lblIfRepair.frame = frame;
    
    frame =  _lblInventoryPartUsed.frame;
    frame.origin.y = _lblWorkOrderType.frame.origin.y + _lblWorkOrderType.frame.size.height + 20;
    _lblInventoryPartUsed.frame = frame;
    
    //   _viewBgHeaderAddInventoryPart.frame = CGRectMake(0, 0, _viewBgHeaderAddInventoryPart.frame.size.width,35);
    _tblInventoryPart.contentSize = CGSizeMake(_tblInventoryPart.frame.size.width, (arrInventoryPartUsed.count*45)+35);
    frame =  _tblInventoryPart.frame;
    frame.origin.y = _lblInventoryPartUsed.frame.origin.y + _lblInventoryPartUsed.frame.size.height + 20;
    _tblInventoryPart.frame = frame;
    
    frame =  _imgBGSelectRepairTime.frame;
    frame.origin.y = _lblIfRepair.frame.origin.y + _lblIfRepair.frame.size.height + 20;
    _imgBGSelectRepairTime.frame = frame;
    
    frame =  _imgSelectRepairTime.frame;
    frame.origin.y = _lblIfRepair.frame.origin.y + _lblIfRepair.frame.size.height + 25;
    _imgSelectRepairTime.frame = frame;
    
    frame =  _txtSelectRepairTime.frame;
    frame.origin.y = _lblIfRepair.frame.origin.y + _lblIfRepair.frame.size.height + 25;
    _txtSelectRepairTime.frame = frame;
    
    frame =  _imgBGInventoryTypes.frame;
    frame.origin.y = _imgBGSelectRepairTime.frame.origin.y + _imgBGSelectRepairTime.frame.size.height + 20;
    _imgBGInventoryTypes.frame = frame;
    
    frame =  _imgInventoryTypes.frame;
    frame.origin.y = _imgBGSelectRepairTime.frame.origin.y + _imgBGSelectRepairTime.frame.size.height + 25;
    _imgInventoryTypes.frame = frame;
    
    frame =  _txtInventoryTypes.frame;
    frame.origin.y = _imgBGSelectRepairTime.frame.origin.y + _imgBGSelectRepairTime.frame.size.height + 25;
    _txtInventoryTypes.frame = frame;
    
    frame =  _btnAddInventoryPart.frame;
    frame.origin.y = _imgBGInventoryTypes.frame.origin.y + _imgBGInventoryTypes.frame.size.height + 15;
    _btnAddInventoryPart.frame = frame;
    
    frame =  _lblCostOfParts.frame;
    frame.origin.y = _btnAddInventoryPart.frame.origin.y + _btnAddInventoryPart.frame.size.height + 20;
    _lblCostOfParts.frame = frame;
    
    frame =  _imgBGCostOfParts.frame;
    frame.origin.y = _lblCostOfParts.frame.origin.y + _lblCostOfParts.frame.size.height + 20;
    _imgBGCostOfParts.frame = frame;
    
    frame =  _txtCostOfParts.frame;
    frame.origin.y = _lblCostOfParts.frame.origin.y + _lblCostOfParts.frame.size.height + 25;
    _txtCostOfParts.frame = frame;
    
    frame =  _lblCostOfLabor.frame;
    if (_lblIfRepair.hidden) {
        
         frame.origin.y = _lblWorkOrderType.frame.origin.y + _lblWorkOrderType.frame.size.height + 20;
    }
    else{
        frame.origin.y = _imgBGCostOfParts.frame.origin.y + _imgBGCostOfParts.frame.size.height + 20;
    }
    _lblCostOfLabor.frame = frame;
    
    frame =  _lblHours.frame;
    frame.origin.y = _lblCostOfLabor.frame.origin.y + _lblCostOfLabor.frame.size.height + 20;
    _lblHours.frame = frame;
    
    frame =  _imgBGHourlyRate.frame;
    frame.origin.y = _lblHours.frame.origin.y + _lblHours.frame.size.height + 20;
    _imgBGHourlyRate.frame = frame;
    
    frame =  _txtHourlyRate.frame;
    frame.origin.y = _lblHours.frame.origin.y + _lblHours.frame.size.height + 25;
    _txtHourlyRate.frame = frame;
    
    frame =  _RepairHourlyRate.frame;
    frame.origin.y = _lblCostOfLabor.frame.origin.y + _lblCostOfLabor.frame.size.height + 20;
    _RepairHourlyRate.frame = frame;
    
    frame =  _imgBGRepairLaborHour.frame;
    frame.origin.y = _RepairHourlyRate.frame.origin.y + _RepairHourlyRate.frame.size.height + 20;
    _imgBGRepairLaborHour.frame = frame;
    
    frame =  _txtRepairLaborHour.frame;
    frame.origin.y = _RepairHourlyRate.frame.origin.y + _RepairHourlyRate.frame.size.height + 25;
    _txtRepairLaborHour.frame = frame;
    
    frame =  _lblTotalCost.frame;
    frame.origin.y = _imgBGRepairLaborHour.frame.origin.y + _imgBGRepairLaborHour.frame.size.height + 20;
    _lblTotalCost.frame = frame;
    
    frame =  _imgBGRepairTotalCost.frame;
    frame.origin.y = _lblTotalCost.frame.origin.y + _lblTotalCost.frame.size.height + 20;
    _imgBGRepairTotalCost.frame = frame;
    
    frame =  _txtRepairTotalCost.frame;
    frame.origin.y = _lblTotalCost.frame.origin.y + _lblTotalCost.frame.size.height + 25;
    _txtRepairTotalCost.frame = frame;
    
    frame =  _lblIfReplacement.frame;
    
    if (_lblIfRepair.hidden && _lblCostOfLabor.hidden) {
        
        frame.origin.y = _lblWorkOrderType.frame.origin.y + _lblWorkOrderType.frame.size.height + 20;
    }
    else if (_lblCostOfLabor.hidden){
        
        frame.origin.y = _imgBGCostOfParts.frame.origin.y + _imgBGCostOfParts.frame.size.height + 20;

    }
    else{
        frame.origin.y = _txtRepairTotalCost.frame.origin.y + _txtRepairTotalCost.frame.size.height + 20;
    }
    
    _lblIfReplacement.frame = frame;
    
    frame =  _lblCostOfReplacement.frame;
    frame.origin.y = _lblIfReplacement.frame.origin.y + _lblIfReplacement.frame.size.height + 20;
    _lblCostOfReplacement.frame = frame;
    
    frame =  _imgBGCostOfReplacement.frame;
    frame.origin.y = _lblCostOfReplacement.frame.origin.y + _lblCostOfReplacement.frame.size.height + 20;
    _imgBGCostOfReplacement.frame = frame;
    
    frame =  _txtCostOfReplacement.frame;
    frame.origin.y = _lblCostOfReplacement.frame.origin.y + _lblCostOfReplacement.frame.size.height + 25;
    _txtCostOfReplacement.frame = frame;
    
    frame =  _lblEstimatedDate.frame;
    if (_lblIfReplacement.hidden) {
        
        frame.origin.y = _txtRepairTotalCost.frame.origin.y + _txtRepairTotalCost.frame.size.height + 20;
    }
    else{
    frame.origin.y = _imgBGCostOfReplacement.frame.origin.y + _imgBGCostOfReplacement.frame.size.height + 20;
    }
    _lblEstimatedDate.frame = frame;
    
    frame =  _lblComplitionDate.frame;
    if (_lblIfReplacement.hidden) {
        
        frame.origin.y = _txtRepairTotalCost.frame.origin.y + _txtRepairTotalCost.frame.size.height + 20;
    }
    else{
        frame.origin.y = _imgBGCostOfReplacement.frame.origin.y + _imgBGCostOfReplacement.frame.size.height + 20;
    }
    _lblComplitionDate.frame = frame;
    
    frame =  _imgBGEstimatedDate.frame;
    frame.origin.y = _lblComplitionDate.frame.origin.y + _lblComplitionDate.frame.size.height + 20;
    _imgBGEstimatedDate.frame = frame;
    
    frame =  _lblStarEstimatedDate.frame;
    frame.origin.y = _imgBGEstimatedDate.frame.origin.y + (_imgBGEstimatedDate.frame.size.height/2) -5;
    _lblStarEstimatedDate.frame = frame;
    
    frame =  _imgEstimatedDate.frame;
    frame.origin.y = _lblComplitionDate.frame.origin.y + _lblComplitionDate.frame.size.height + 25;
    _imgEstimatedDate.frame = frame;
    
    frame =  _txtEstimatedDate.frame;
    frame.origin.y = _lblComplitionDate.frame.origin.y + _lblComplitionDate.frame.size.height + 25;
    _txtEstimatedDate.frame = frame;
    
    frame =  _imgBGComplitionDate.frame;
    frame.origin.y = _lblComplitionDate.frame.origin.y + _lblComplitionDate.frame.size.height + 20;
    _imgBGComplitionDate.frame = frame;
    
    frame =  _lblStarCompletionDate.frame;
    frame.origin.y = _imgBGComplitionDate.frame.origin.y + (_imgBGComplitionDate.frame.size.height/2) -5;
    _lblStarCompletionDate.frame = frame;
    
    frame =  _imgComplitionDate.frame;
    frame.origin.y = _lblComplitionDate.frame.origin.y + _lblComplitionDate.frame.size.height + 25;
    _imgComplitionDate.frame = frame;
    
    frame =  _txtComplitionDate.frame;
    frame.origin.y = _lblComplitionDate.frame.origin.y + _lblComplitionDate.frame.size.height + 25;
    _txtComplitionDate.frame = frame;
    
    frame =  _viewBGFollowUp.frame;
    if (_imgBGComplitionDate.hidden && _imgBGEstimatedDate.hidden) {
          frame.origin.y = _imgBGCostOfReplacement.frame.origin.y + _imgBGCostOfReplacement.frame.size.height + 20;
    }
    else{
    frame.origin.y = _imgBGComplitionDate.frame.origin.y + _imgBGComplitionDate.frame.size.height + 20;
    }
    _viewBGFollowUp.frame = frame;
    
    
    frame =  _lblReviewNotes.frame;
    frame.origin.y = _viewBGFollowUp.frame.origin.y + _viewBGFollowUp.frame.size.height + 20;
    _lblReviewNotes.frame = frame;
    
    frame =  _tblNotes.frame;
    frame.origin.y = _lblReviewNotes.frame.origin.y + _lblReviewNotes.frame.size.height + 20;
    _tblNotes.frame = frame;
    
    frame =  _lblStarGNature.frame;
    frame.origin.y = _lblTitleGeneralActionTaken.frame.origin.y + _lblTitleGeneralActionTaken.frame.size.height + 50;
    frame.origin.x = _imgBgNature.frame.origin.x + _imgBgNature.frame.size.width -10;
    _lblStarGNature.frame = frame;
  
    frame =  _lblStarGAction.frame;
    frame.origin.y = _lblTitleGeneralActionTaken.frame.origin.y + _lblTitleGeneralActionTaken.frame.size.height + 50;
    frame.origin.x = _imgBgActionTaken.frame.origin.x + _imgBgActionTaken.frame.size.width -10;
    _lblStarGAction.frame = frame;
 
    frame =  _lblStarFName.frame;
    frame.origin.y = _lblEmployeeReprt.frame.origin.y + _lblEmployeeReprt.frame.size.height + 40;
    frame.origin.x = _imgBgFname.frame.origin.x + _imgBgFname.frame.size.width -15;
    _lblStarFName.frame = frame;
    
    frame =  _lblStarMName.frame;
    frame.origin.y = _lblEmployeeReprt.frame.origin.y + _lblEmployeeReprt.frame.size.height + 40;
    frame.origin.x = _imgBgMname.frame.origin.x + _imgBgMname.frame.size.width -15;
    _lblStarMName.frame = frame;
    
    frame =  _lblStarLName.frame;
    frame.origin.y = _lblEmployeeReprt.frame.origin.y + _lblEmployeeReprt.frame.size.height + 40;
    frame.origin.x = _imgBgLname.frame.origin.x + _imgBgLname.frame.size.width -15;
    _lblStarLName.frame = frame;
    
    frame =  _lblStarEmail.frame;
    frame.origin.y = _imgBgFname.frame.origin.y + _imgBgFname.frame.size.height + 40;
    frame.origin.x = _imgBgEmail.frame.origin.x + _imgBgEmail.frame.size.width -15;
    _lblStarEmail.frame = frame;
    
    
    
    frame =  _btnSubmit.frame;
    frame.origin.y = _tblNotes.frame.origin.y + _tblNotes.frame.size.height + 20;
    _btnSubmit.frame = frame;
    
    frame =  _btnSubmitLatter.frame;
    frame.origin.y = _tblNotes.frame.origin.y + _tblNotes.frame.size.height + 20;
    _btnSubmitLatter.frame = frame;
    
    _viewTblHeader.frame = CGRectMake(0, 0, 768,_btnSubmitLatter.frame.origin.y + _btnSubmitLatter.frame.size.height +380);
    _tblScrollBG.contentSize = CGSizeMake(_tblScrollBG.frame.size.width, _viewTblHeader.frame.size.height);
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if ([tableView isEqual:_tblScrollBG]) {
        return _viewTblHeader;
    }
    else if ([tableView isEqual:_tblVideoList]){
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
    else if ([tableView isEqual:_tblInventoryPart]){
        UIView * viewHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0,349, 35)];
        viewHeader.backgroundColor = [UIColor lightGrayColor];
        UILabel * lbl1 = [[UILabel alloc] initWithFrame:CGRectMake(1, 1, 197, viewHeader.frame.size.height - 3)];
        lbl1.backgroundColor = [UIColor colorWithHexCodeString:@"#A52A2A"];
        lbl1.text = @"Part Name";
        lbl1.textColor = [UIColor whiteColor];
        //[lbl1 setTextAlignment:NSTextAlignmentCenter];
        [viewHeader addSubview:lbl1];
        
        UILabel * lbl2 = [[UILabel alloc] initWithFrame:CGRectMake(199, 1, viewHeader.frame.size.width - 199, viewHeader.frame.size.height - 3)];
        lbl2.backgroundColor = [UIColor colorWithHexCodeString:@"#A52A2A"];
        lbl2.text = @"Cost";
        lbl2.textColor = [UIColor whiteColor];
        //   [lbl2 setTextAlignment:NSTextAlignmentCenter];
        [viewHeader addSubview:lbl2];
        
        return viewHeader;
        
    }
    else if ([tableView isEqual:_tblFollowUp]){
        // arrAddFollowUp
        UIView * viewHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-40, 50)];
        viewHeader.backgroundColor = [UIColor lightGrayColor];
        UILabel * lbl1 = [[UILabel alloc] initWithFrame:CGRectMake(1, 1, 100, viewHeader.frame.size.height - 3)];
        lbl1.backgroundColor = [UIColor colorWithHexCodeString:@"#A52A2A"];
        lbl1.numberOfLines = 0;
        lbl1.lineBreakMode = UILineBreakModeWordWrap;
        lbl1.text = @"Follow-Up Log #";
        lbl1.textColor = [UIColor whiteColor];
        [lbl1 setTextAlignment:NSTextAlignmentCenter];
        [viewHeader addSubview:lbl1];
        
        UILabel * lbl2 = [[UILabel alloc] initWithFrame:CGRectMake((lbl1.frame.origin.x+lbl1.frame.size.width+1), 1, 100, viewHeader.frame.size.height - 3)];
        lbl2.backgroundColor = [UIColor colorWithHexCodeString:@"#A52A2A"];
        lbl2.numberOfLines = 0;
        lbl2.lineBreakMode = UILineBreakModeWordWrap;
        lbl2.text = @"Follow-Up Status";
        lbl2.textColor = [UIColor whiteColor];
        [lbl2 setTextAlignment:NSTextAlignmentCenter];
        [viewHeader addSubview:lbl2];
        
        UILabel * lbl3 = [[UILabel alloc] initWithFrame:CGRectMake((lbl2.frame.origin.x+lbl2.frame.size.width+1), 1, 100, viewHeader.frame.size.height - 3)];
        lbl3.backgroundColor = [UIColor colorWithHexCodeString:@"#A52A2A"];
        lbl3.numberOfLines = 0;
        lbl3.lineBreakMode = UILineBreakModeWordWrap;
        lbl3.text = @"Name";
        lbl3.textColor = [UIColor whiteColor];
        [lbl3 setTextAlignment:NSTextAlignmentCenter];
        [viewHeader addSubview:lbl3];
        
        UILabel * lbl4 = [[UILabel alloc] initWithFrame:CGRectMake((lbl3.frame.origin.x+lbl3.frame.size.width+1), 1, (viewHeader.frame.size.width-345)/2, viewHeader.frame.size.height - 3)];
        lbl4.backgroundColor = [UIColor colorWithHexCodeString:@"#A52A2A"];
        lbl4.text = @"Information";
        lbl4.textColor = [UIColor whiteColor];
        lbl4.numberOfLines = 0;
        lbl4.lineBreakMode = UILineBreakModeWordWrap;
        [lbl4 setTextAlignment:NSTextAlignmentCenter];
        [viewHeader addSubview:lbl4];
        
        UILabel * lbl5 = [[UILabel alloc] initWithFrame:CGRectMake((lbl4.frame.origin.x+lbl4.frame.size.width+1), 1, (viewHeader.frame.size.width-345)/2, viewHeader.frame.size.height - 3)];
        lbl5.backgroundColor = [UIColor colorWithHexCodeString:@"#A52A2A"];
        lbl5.numberOfLines = 0;
        lbl5.lineBreakMode = UILineBreakModeWordWrap;
        lbl5.text = @"Date & Time";
        lbl5.textColor = [UIColor whiteColor];
        [lbl5 setTextAlignment:NSTextAlignmentCenter];
        [viewHeader addSubview:lbl5];
        
        UILabel * lbl6 = [[UILabel alloc] initWithFrame:CGRectMake((lbl5.frame.origin.x+lbl5.frame.size.width+1), 1, 37, viewHeader.frame.size.height - 3)];
        lbl6.backgroundColor = [UIColor colorWithHexCodeString:@"#A52A2A"];
        lbl6.numberOfLines = 0;
        lbl6.lineBreakMode = UILineBreakModeWordWrap;
        lbl6.text = @"";
        lbl6.textColor = [UIColor whiteColor];
        [lbl6 setTextAlignment:NSTextAlignmentCenter];
        [viewHeader addSubview:lbl6];
        return viewHeader;
        
        
    }
    else if ([tableView isEqual:_tblF_UQuestionREsponce]){
        // arrAddFollowUp
        UIView * viewHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-40, 50)];
        viewHeader.backgroundColor = [UIColor lightGrayColor];
        UILabel * lbl1 = [[UILabel alloc] initWithFrame:CGRectMake(1, 1, 120, viewHeader.frame.size.height - 3)];
        lbl1.backgroundColor = [UIColor colorWithHexCodeString:@"#A52A2A"];
        lbl1.numberOfLines = 0;
        lbl1.lineBreakMode = UILineBreakModeWordWrap;
        lbl1.text = @"Follow-Up Log #";
        lbl1.textColor = [UIColor whiteColor];
        [lbl1 setTextAlignment:NSTextAlignmentCenter];
        [viewHeader addSubview:lbl1];
        
        UILabel * lbl2 = [[UILabel alloc] initWithFrame:CGRectMake((lbl1.frame.origin.x+lbl1.frame.size.width+1), 1, (viewHeader.frame.size.width-(lbl1.frame.origin.x+lbl1.frame.size.width+1)), viewHeader.frame.size.height - 2)];
        lbl2.backgroundColor = [UIColor colorWithHexCodeString:@"#A52A2A"];
        lbl2.numberOfLines = 0;
        lbl2.lineBreakMode = UILineBreakModeWordWrap;
        lbl2.text = @"   Follow-Up Questions and Answers";
        lbl2.textColor = [UIColor whiteColor];
        [lbl2 setTextAlignment:NSTextAlignmentLeft];
        [viewHeader addSubview:lbl2];
        
//        UILabel * lbl3 = [[UILabel alloc] initWithFrame:CGRectMake((lbl2.frame.origin.x+lbl2.frame.size.width+1), 1,  (viewHeader.frame.size.width-124)/2, viewHeader.frame.size.height - 3)];
//        lbl3.backgroundColor = [UIColor colorWithHexCodeString:@"#A52A2A"];
//        lbl3.numberOfLines = 0;
//        lbl3.lineBreakMode = UILineBreakModeWordWrap;
//        lbl3.text = @"";
//        lbl3.textColor = [UIColor whiteColor];
//        [lbl3 setTextAlignment:NSTextAlignmentCenter];
//        [viewHeader addSubview:lbl3];
        
        return viewHeader;
        
    }
    
    else if ([tableView isEqual:_tblNotes]){
        // arrAddFollowUp
        UIView * viewHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-40, 50)];
        viewHeader.backgroundColor = [UIColor lightGrayColor];
        UILabel * lbl1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 1, 130, viewHeader.frame.size.height - 3)];
        lbl1.backgroundColor = [UIColor colorWithHexCodeString:@"#A52A2A"];
        lbl1.numberOfLines = 0;
        lbl1.lineBreakMode = UILineBreakModeWordWrap;
        lbl1.text = @"Date";
        lbl1.textColor = [UIColor whiteColor];
        [lbl1 setTextAlignment:NSTextAlignmentCenter];
        [viewHeader addSubview:lbl1];
        
        UILabel * lbl2 = [[UILabel alloc] initWithFrame:CGRectMake(131, 1, 130, viewHeader.frame.size.height - 3)];
        lbl2.backgroundColor = [UIColor colorWithHexCodeString:@"#A52A2A"];
        lbl2.numberOfLines = 0;
        lbl2.lineBreakMode = UILineBreakModeWordWrap;
        lbl2.text = @"Status";
        lbl2.textColor = [UIColor whiteColor];
        [lbl2 setTextAlignment:NSTextAlignmentCenter];
        [viewHeader addSubview:lbl2];
        
        UILabel * lbl3 = [[UILabel alloc] initWithFrame:CGRectMake(262, 1, viewHeader.frame.size.width-262, viewHeader.frame.size.height - 3)];
        lbl3.backgroundColor = [UIColor colorWithHexCodeString:@"#A52A2A"];
        lbl3.numberOfLines = 0;
        lbl3.lineBreakMode = UILineBreakModeWordWrap;
        lbl3.text = @"Note";
        lbl3.textColor = [UIColor whiteColor];
        [lbl3 setTextAlignment:NSTextAlignmentCenter];
        [viewHeader addSubview:lbl3];
        
        return viewHeader;
        
    }
    
    else
        return nil;
}
//3349)2926
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:_tblScrollBG]) {
        return 1;
    }
    else if ([tableView isEqual:_tblVideoList]) {
        if (_radioBtnVideo.isSelected) {
            return arrVideo.count;
        }
        else{
            return arrImage.count;
            
        }
    }
    else if ([tableView isEqual:_tblPositons]) {
        return arrPositon.count;
    }
    else if ([tableView isEqual:_tblUsers]) {
        return arrUsers.count;
    }
    else if ([tableView isEqual:_tblFollowUp]){
        return arrAddFollowUpLog.count;
    }
    else if ([tableView isEqual:_tblF_UQuestionREsponce]){
        return arrAddFollowUpQuestions.count;
    }
    else if ([tableView isEqual:_tblNotes]){
        return arrNotes.count;
    }
    else{
        return arrInventoryPartUsed.count;
    }
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    EditWorkOrderTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    if ([tableView isEqual:_tblScrollBG]) {
        
    }
    else if ([tableView isEqual:_tblVideoList]) {
        
        cell.lblId.text = [NSString stringWithFormat:@"%ld",indexPath.row+1];
        if (_radioBtnImg.selected) {
            cell.lblFileName.text = [[arrImage valueForKey:@"Key"] objectAtIndex:indexPath.row];

            cell.lblFileType.text = @"Image";
        }else {
            cell.lblFileName.text = [[arrVideo valueForKey:@"Key"] objectAtIndex:indexPath.row];

            cell.lblFileType.text = @"Video";
            
        }
        
        [cell.btnViewImageVideo addTarget:self action:@selector(btnViewImageVideoTapped:) forControlEvents:UIControlEventTouchUpInside];
        cell.btnViewImageVideo.tag = indexPath.row;
        [cell.btnDeleteImageVideo addTarget:self action:@selector(btnDeleteImageVideoTapped:) forControlEvents:UIControlEventTouchUpInside];
        cell.btnDeleteImageVideo.tag = indexPath.row;
        

        if ([_isOnlyView isEqualToString:@"YES"]) {
            cell.btnDeleteImageVideo.hidden = YES;

        }
        else if ([_isEditAllow isEqualToString:@"YES"]){
            
            cell.btnDeleteImageVideo.hidden = NO;

        }
        else if ([_isF_EditAllow isEqualToString:@"YES"]){
            cell.btnDeleteImageVideo.hidden = YES;

        }
        else{
            cell.btnDeleteImageVideo.hidden = YES;

        }

    }
    else if ([tableView isEqual:_tblPositons]) {
        
        cell.lblItemTitle.text = [[arrPositon valueForKey:@"Text"] objectAtIndex:indexPath.row];
        
        if ([selectedPositionArr containsObject:[[arrPositon valueForKey:@"Value"] objectAtIndex:indexPath.row]]) {
            
            cell.imgCheckBox.image = [UIImage imageNamed:@"selected_check_box@2x.png"];
            
        }
        else{
            cell.imgCheckBox.image = [UIImage imageNamed:@"check_box@2x.png"];
            
        }
        if (arrPositon.count == selectedPositionArr.count) {
            _btnselectAllPositions.selected = true;
        }
        else{
            _btnselectAllPositions.selected = false;
        }
        
    }
    else if ([tableView isEqual:_tblUsers]) {
        
        cell.lblItemTitle.text = [[arrUsers valueForKey:@"Text"] objectAtIndex:indexPath.row];
        if ([selectedUserArr containsObject:[[arrUsers valueForKey:@"Id"] objectAtIndex:indexPath.row]]) {
            
            cell.imgCheckBox.image = [UIImage imageNamed:@"selected_check_box@2x.png"];
            
        }
        else{
            cell.imgCheckBox.image = [UIImage imageNamed:@"check_box@2x.png"];
            
        }
        if (arrUsers.count == selectedUserArr.count) {
            _btnSelectAllUsers.selected = true;
        }
        else{
            _btnSelectAllUsers.selected = false;
        }
    }
    else if ([tableView isEqual:_tblFollowUp]) {
        
        
        if (![[[arrAddFollowUpLog valueForKey:@"FFollowupId"] objectAtIndex:indexPath.row] isKindOfClass:[NSNull class]]) {
            cell.lblF_ULogNum.text = [[arrAddFollowUpLog valueForKey:@"FFollowupId"] objectAtIndex:indexPath.row];
        }
        
        if (![[[arrAddFollowUpLog valueForKey:@"Name"] objectAtIndex:indexPath.row] isKindOfClass:[NSNull class]]) {
            cell.lblF_UName.text = [[arrAddFollowUpLog valueForKey:@"Name"] objectAtIndex:indexPath.row];
        }
        
        if (![[[arrAddFollowUpLog valueForKey:@"FollowupCall"] objectAtIndex:indexPath.row] isKindOfClass:[NSNull class]]) {
            cell.lblF_UStatus.text = [[arrAddFollowUpLog valueForKey:@"FollowupCall"] objectAtIndex:indexPath.row];
        }
        
        if (![[[arrAddFollowUpLog valueForKey:@"Information"] objectAtIndex:indexPath.row] isKindOfClass:[NSNull class]]) {
            cell.lblF_UInfo.text = [[arrAddFollowUpLog valueForKey:@"Information"] objectAtIndex:indexPath.row];
            
        }
        if (![[[arrAddFollowUpLog valueForKey:@"DisplayDate"] objectAtIndex:indexPath.row] isKindOfClass:[NSNull class]]) {
            cell.lblF_UDateTime.text = [[arrAddFollowUpLog valueForKey:@"DisplayDate"] objectAtIndex:indexPath.row];
        }
        
        [cell.btnF_UDelete addTarget:self action:@selector(btnF_UDeleteTapped:) forControlEvents:UIControlEventTouchUpInside];
        cell.btnF_UDelete.tag = indexPath.row;
        [cell.btnF_UEdit addTarget:self action:@selector(btnF_UEditTapped:) forControlEvents:UIControlEventTouchUpInside];
        cell.btnF_UEdit.tag = indexPath.row;
        [cell.btnF_UView addTarget:self action:@selector(btnF_UViewTapped:) forControlEvents:UIControlEventTouchUpInside];
        cell.btnF_UView.tag = indexPath.row;
        
        
        if (![[[arrAddFollowUpLog valueForKey:@"IsAllowEditing"] objectAtIndex:indexPath.row] boolValue]) {
            cell.btnF_UDelete.hidden = YES;
            cell.btnF_UEdit.hidden = YES;
        }
        else{
            cell.btnF_UDelete.hidden = NO;
            cell.btnF_UEdit.hidden = NO;
        }
        
    }
    else if ([tableView isEqual:_tblF_UQuestionREsponce]) {
        
        cell.lblF_ULogNum.text = [[arrAddFollowUpQuestions valueForKey:@"FFollowupId"] objectAtIndex:indexPath.row];
        cell.lblF_UDateTime.text = [NSString stringWithFormat:@"Date and Time - %@",[self dateFormatting:[[arrAddFollowUpQuestions valueForKey:@"UpdatedOn"] objectAtIndex:indexPath.row] dateFormate:@"yyyy-MM-dd'T'HH:mm:ss.SSS" time:NO]];
        [cell.btnF_UDelete addTarget:self action:@selector(btnF_UQDeleteTapped:) forControlEvents:UIControlEventTouchUpInside];
        cell.btnF_UDelete.tag = indexPath.row;
        [cell.btnF_UEdit addTarget:self action:@selector(btnF_UQEditTapped:) forControlEvents:UIControlEventTouchUpInside];
        cell.btnF_UEdit.tag = indexPath.row;
        [cell.btnF_UView addTarget:self action:@selector(btnF_UQViewTapped:) forControlEvents:UIControlEventTouchUpInside];
        cell.btnF_UView.tag = indexPath.row;
        
        if (!showFollowUpQ1) {
            cell.lblF_UQ1.hidden = YES;
        }
        else{
            cell.lblF_UQ1.hidden = NO;
        }
        if (!showFollowUpQ2) {
            cell.lblF_UQ2.hidden = YES;
        }
        else{
            cell.lblF_UQ2.hidden = NO;
        }
        if (!showFollowUpQ3) {
            cell.lblF_UQ3.hidden = YES;
        }
        else{
            cell.lblF_UQ3.hidden = NO;
        }
        if (!showFollowUpQ4) {
            cell.lblF_UQ4.hidden = YES;
        }
        else{
            cell.lblF_UQ4.hidden = NO;
        }
        cell.lblF_UQ1.text = [NSString stringWithFormat:@"%@ - %@",_lblF_UpQue1.text,[[arrAddFollowUpQuestions valueForKey:@"QuestionYesNoText1"] objectAtIndex:indexPath.row]];
        cell.lblF_UQ2.text = [NSString stringWithFormat:@"%@ - %@",_lblF_UpQue2.text,[[arrAddFollowUpQuestions valueForKey:@"QuestionYesNoText2"] objectAtIndex:indexPath.row]];
        
        cell.lblF_UQ3.text = [NSString stringWithFormat:@"%@ - %@",_lblF_UpQue3.text,[[arrAddFollowUpQuestions valueForKey:@"QuestionYesNoText3"] objectAtIndex:indexPath.row]];
        
        cell.lblF_UQ4.text = [NSString stringWithFormat:@"%@ - %@",_lblF_UpQue4.text,[[arrAddFollowUpQuestions valueForKey:@"QuestionYesNoText4"] objectAtIndex:indexPath.row]];
        
        if (![[responceDic valueForKey:@"IsAllowEdit"] boolValue]) {
            cell.btnF_UDelete.hidden = YES;
            cell.btnF_UEdit.hidden = YES;
        }
        else{
            cell.btnF_UDelete.hidden = NO;
            cell.btnF_UEdit.hidden = NO;
        }
    }
    else if ([tableView isEqual:_tblNotes]){
        
        if (![[[arrNotes valueForKey:@"Date"] objectAtIndex:indexPath.row] isKindOfClass:[NSNull class]]) {
            cell.lblNoteDate.text = [[arrNotes valueForKey:@"Date"] objectAtIndex:indexPath.row];

        }
        if (![[[arrNotes valueForKey:@"WorkOrderStatus"] objectAtIndex:indexPath.row] isKindOfClass:[NSNull class]]) {

        cell.lblNoteStatus.text = [[arrNotes valueForKey:@"WorkOrderStatus"] objectAtIndex:indexPath.row];
        }
        if (![[[arrNotes valueForKey:@"Note"] objectAtIndex:indexPath.row] isKindOfClass:[NSNull class]]) {

        cell.lblNoteDesc.text = [[arrNotes valueForKey:@"Note"] objectAtIndex:indexPath.row];
        }
    }
    
    else{

        cell.lblPartName.text = [[arrInventoryPartUsed valueForKey:@"name"] objectAtIndex:indexPath.row];
        cell.lblCost.text = [[arrInventoryPartUsed valueForKey:@"cost"] objectAtIndex:indexPath.row];
        
        [cell.btnDelete addTarget:self action:@selector(btnDeleteInventoryTapped:) forControlEvents:UIControlEventTouchUpInside];
        cell.btnDelete.tag = indexPath.row;
    }
    return cell;
}

-(void)btnViewImageVideoTapped:(UIButton*)sender{
    if ([[arrOfLoadedMedia objectAtIndex:sender.tag]  isEqual: @"a"]) {

  NSString * strId = [NSString stringWithFormat:@"%@",_orderId];
         if (gblAppDelegate.isNetworkReachable) {
    [gblAppDelegate showActivityIndicator];
    int index = sender.tag;
        NSString * fileName = @"";
        if (_radioBtnVideo.isSelected) {
            fileName = [[arrVideo valueForKey:@"Key"]objectAtIndex:index];
        }
        else{
             fileName = [[arrImage valueForKey:@"Key"]objectAtIndex:index];
        }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [[WebSerivceCall webServiceObject]callServiceForGetPhotoVideoDataWorkOrder:YES workOrderHistoryId:strId fileName:fileName complition:^{
        
        NSData *dictionaryData = [[NSUserDefaults standardUserDefaults] objectForKey:@"photoVideoWorkOrderData"];
        responcePhotoVideoData = [NSKeyedUnarchiver unarchiveObjectWithData:dictionaryData];
  [gblAppDelegate hideActivityIndicator];
            
            _viewFullBGImageVideo.hidden = NO;
        //    NSArray * tempArr = [[NSArray alloc]init];
            [arrOfLoadedMedia replaceObjectAtIndex:sender.tag withObject:[[responcePhotoVideoData valueForKey:@"Media"] objectAtIndex:0]];
            [arrViewImgVideo addObject:[[[responcePhotoVideoData valueForKey:@"Media"]valueForKey:@"Key"] objectAtIndex:0]];

            if (arrOfLoadedMedia.count != 0 || ![arrOfLoadedMedia isKindOfClass:[NSNull class]]) {
                
                NSDictionary * tempDic = [[NSDictionary alloc]init];
                tempDic = [arrOfLoadedMedia objectAtIndex:sender.tag];
                
            NSData* data = [[NSData alloc] initWithBase64EncodedString:[tempDic valueForKey:@"Value"] options:0];


            BOOL isPhotoExists1 = [[responceDic valueForKey:@"IsPhotoExists"] boolValue];
            BOOL isVideoExist1 = [[responceDic valueForKey:@"IsVideoExist"] boolValue];

            if (isPhotoExists1){
                [arrImage replaceObjectAtIndex:sender.tag withObject:[[responcePhotoVideoData valueForKey:@"Media"] objectAtIndex:0]];

                _imgViewPhotoVideo.hidden = NO;
                _webViewVideoShow.hidden = YES;
                UIImage* image = [UIImage imageWithData:data];
                _imgViewPhotoVideo.image = image;

            }
            else if (isVideoExist1){
                [arrVideo replaceObjectAtIndex:sender.tag withObject:[[responcePhotoVideoData valueForKey:@"Media"] objectAtIndex:0]];

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

             }else
             {
                 alert(@"", @"Please note, There is some issue for loading media please try again later.");
             }
            
    }];
    
});
    
    }
    else{
        alert(@"", @"We're sorry. C2IT is not currently available offline");
    }

            }
    else{
        
         _viewFullBGImageVideo.hidden = NO;
        
        NSDictionary * tempDic = [[NSDictionary alloc]init];
        tempDic = [arrOfLoadedMedia objectAtIndex:sender.tag];

        NSData* data = [[NSData alloc] initWithBase64EncodedString:[tempDic valueForKey:@"Value"] options:0];
        
        
        BOOL isPhotoExists1 = [[responceDic valueForKey:@"IsPhotoExists"] boolValue];
        BOOL isVideoExist1 = [[responceDic valueForKey:@"IsVideoExist"] boolValue];
        
        if (arrImage.count > 0){
            
            _imgViewPhotoVideo.hidden = NO;
            _webViewVideoShow.hidden = YES;
            UIImage* image = [UIImage imageWithData:data];
            _imgViewPhotoVideo.image = image;
            
        }
        else if (arrVideo.count > 0){
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
    
    
    
    
  

}
-(void)btnDeleteImageVideoTapped:(UIButton*)sender{
    if (![_isEditAllow isEqualToString:@"YES"] && [_isF_EditAllow isEqualToString:@"YES"]) {
        alert(@"", @"Please note you do not have permission to edit this field.");

        return;
    }
    _isUpdate = YES;
        
        if (_radioBtnImg.isSelected) {

        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"Are you sure you want to delete this image?" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                             {
                                 //BUTTON OK CLICK EVENT
                                 [arrImage removeObjectAtIndex:sender.tag];
                                 [arrOfLoadedMedia removeObjectAtIndex:sender.tag];
                                 [_tblVideoList reloadData];
                             }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancel];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
        }
        else{
            
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"Are you sure you want to delete this video?" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                                 {
                                     //BUTTON OK CLICK EVENT
                                     [arrVideo removeObjectAtIndex:sender.tag];
                                     [arrOfLoadedMedia removeObjectAtIndex:sender.tag];
                                     [_tblVideoList reloadData];
                                 }];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:cancel];
            [alert addAction:ok];
            [self presentViewController:alert animated:YES completion:nil];
        }

}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if ([tableView isEqual:_tblScrollBG]) {
        return   _viewTblHeader.frame.size.height;
    }
    else if ([tableView isEqual:_tblVideoList] || [tableView isEqual:_tblFollowUp] || [tableView isEqual:_tblF_UQuestionREsponce] || [tableView isEqual:_tblNotes]){
        return   50;
    }
    else if ([tableView isEqual:_tblInventoryPart]){
        return 35;
    }
    
    else return 1.0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:_tblInventoryPart]){
        return   45;
    }
    else if ([tableView isEqual:_tblNotes] || [tableView isEqual:_tblVideoList]){
        return   41;
    }
    else if ([tableView isEqual:_tblFollowUp]){
        return   82;
    }
    else if ([tableView isEqual:_tblF_UQuestionREsponce]){
        return 163;
    }
    else {
        return  50;
    }
}
//-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if ([tableView isEqual:_tblInventoryPart]){
//        return   45;
//    }
//    else if ([tableView isEqual:_tblNotes]){
//        return   41;
//    }
//    else if ([tableView isEqual:_tblFollowUp]){
//        return   82;
//    }
//    else if ([tableView isEqual:_tblF_UQuestionREsponce]){
//        return 163;
//    }
//    else {
//        return  50;
//    }
//}

- (IBAction)btnSelectAllPositionsTapped:(UIButton *)sender {
    if (![_isEditAllow isEqualToString:@"YES"] && [_isF_EditAllow isEqualToString:@"YES"]) {
        alert(@"", @"Please note you do not have permission to edit this field.");

        return;
    }
    if ([_isOnlyView isEqualToString:@"YES"]) {
          return;
    }
    else if ([_isEditAllow isEqualToString:@"YES"]){
          [self selectAllPositions];
    }
    else{
        return;
    }

}
-(void)selectAllPositions{
     _isUpdate = YES;
    _btnSelectAllUsers.selected = false;
    selectedPositionArr = [NSMutableArray new];
    if (_btnselectAllPositions.isSelected) {
        _btnselectAllPositions.selected = false;
        
        selectedUserArr = [NSMutableArray new];
        arrUsers = [NSMutableArray new];
        for (int k = 0;  k < arrSortedUser.count; k++) {
            if ([[NSString stringWithFormat:@"%@",[[arrSortedUser valueForKey:@"Group"] objectAtIndex:k]] isEqualToString:@"ServiceProvider"]) {
                
                if (![arrUsers containsObject:[arrSortedUser objectAtIndex:k]]) {
                    [arrUsers addObject:[arrSortedUser objectAtIndex:k]];
                }
                
            }
        }
        selectedUserArr =  [[NSMutableArray alloc]init];
        for (int i = 0; i<arrUsers.count; i++) {
            if ([[[arrUsers valueForKey:@"Selected"] objectAtIndex:i] boolValue]) {
                [selectedUserArr addObject:[[arrUsers valueForKey:@"Id"] objectAtIndex:i]];
            }
            
        }

        
        [_tblPositons reloadData];
        [_tblUsers reloadData];
    }
    else{
        _btnselectAllPositions.selected = true;
        
        for (int i = 0; i<arrPositon.count; i++) {
            [selectedPositionArr addObject:[[arrPositon valueForKey:@"Value"] objectAtIndex:i]];
        }
        arrUsers = [[NSMutableArray alloc]init];
        for (int i = 0 ; i < selectedPositionArr.count; i++) {
            for (int j = 0 ; j<arrSortedUser.count; j++) {
                if ([[NSString stringWithFormat:@"%@",[[arrSortedUser valueForKey:@"Value"]objectAtIndex:j]] containsString:[selectedPositionArr objectAtIndex:i]] ) {
                    if (![arrUsers containsObject:[arrSortedUser objectAtIndex:j]]) {
                        [arrUsers addObject:[arrSortedUser objectAtIndex:j]];
                    }
                }
            }
        }
                for (int k = 0;  k < arrSortedUser.count; k++) {
                    if ([[NSString stringWithFormat:@"%@",[[arrSortedUser valueForKey:@"Group"] objectAtIndex:k]] isEqualToString:@"ServiceProvider"]) {
        
                        if (![arrUsers containsObject:[arrSortedUser objectAtIndex:k]]) {
                            [arrUsers addObject:[arrSortedUser objectAtIndex:k]];
                        }
        
                    }
                }
        selectedUserArr =  [[NSMutableArray alloc]init];
        for (int i = 0; i<arrUsers.count; i++) {
            if ([[[arrUsers valueForKey:@"Selected"] objectAtIndex:i] boolValue]) {
                [selectedUserArr addObject:[[arrUsers valueForKey:@"Id"] objectAtIndex:i]];
            }
            
        }
        


        
        
        [_tblPositons reloadData];
        [_tblUsers reloadData];
        
    }
}
- (IBAction)btnSelectAllUsersTapped:(UIButton *)sender {
    if (![_isEditAllow isEqualToString:@"YES"] && [_isF_EditAllow isEqualToString:@"YES"]) {
        alert(@"", @"Please note you do not have permission to edit this field.");

        return;
    }
    if ([_isOnlyView isEqualToString:@"YES"]) {
         return;
    }
    else if ([_isEditAllow isEqualToString:@"YES"]){
          [self selectAllUsers];
    }
    else{
        return;
    }
    
}
-(void)selectAllUsers{
     _isUpdate = YES;
    selectedUserArr = [NSMutableArray new];
    if (_btnSelectAllUsers.isSelected) {
        _btnSelectAllUsers.selected = false;
        
        [_tblUsers reloadData];
    }
    else{
        _btnSelectAllUsers.selected = true;
        for (int i = 0; i<arrUsers.count; i++) {
            [selectedUserArr addObject:[[arrUsers valueForKey:@"Id"] objectAtIndex:i]];
        }
        [_tblUsers reloadData];
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
      if ([_isOnlyView isEqualToString:@"YES"]) {
          
      }
    else  if (![_isEditAllow isEqualToString:@"YES"]) {
        if ([_isF_EditAllow isEqualToString:@"YES"]) {
            
        if ([tableView isEqual:_tblF_UQuestionREsponce]) {
            if ([selectedF_UQNumber isEqualToString:[NSString stringWithFormat:@"%ld",(long)indexPath.row]]) {
                selectedF_UQNumber = @"";
                
            }else{
                selectedF_UQNumber = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
            }
            [_tblF_UQuestionREsponce reloadData];
            
        }
        else{
            
            alert(@"", @"Please note you do not have permission to edit this field.");
        }

        }
        
    }
      else if ([_isEditAllow isEqualToString:@"YES"]){
        
    _isUpdate = YES;
    if (tableView == _tblPositons) {
        if ([selectedPositionArr containsObject:[[arrPositon valueForKey:@"Value"] objectAtIndex:indexPath.row]]) {
            [selectedPositionArr removeObject:[[arrPositon valueForKey:@"Value"] objectAtIndex:indexPath.row]];
        }else{
            [selectedPositionArr addObject:[[arrPositon valueForKey:@"Value"] objectAtIndex:indexPath.row]];
        }
        
        arrUsers = [[NSMutableArray alloc]init];
        for (int i = 0 ; i < selectedPositionArr.count; i++) {
            for (int j = 0 ; j<arrSortedUser.count; j++) {
                if ([[NSString stringWithFormat:@"%@",[[arrSortedUser valueForKey:@"Value"]objectAtIndex:j]] containsString:[selectedPositionArr objectAtIndex:i]]  ) {
                    if (![arrUsers containsObject:[arrSortedUser objectAtIndex:j]]) {
                        [arrUsers addObject:[arrSortedUser objectAtIndex:j]];
                    }
                }
            }
        }
        
        for (int k = 0;  k < arrSortedUser.count; k++) {
            if ([[NSString stringWithFormat:@"%@",[[arrSortedUser valueForKey:@"Group"] objectAtIndex:k]] isEqualToString:@"ServiceProvider"]) {
                
                if (![arrUsers containsObject:[arrSortedUser objectAtIndex:k]]) {
                    [arrUsers addObject:[arrSortedUser objectAtIndex:k]];
                }
                
            }
        }
        
        selectedUserArr =  [[NSMutableArray alloc]init];
        for (int i = 0; i<arrUsers.count; i++) {
            if ([[[arrUsers valueForKey:@"Selected"] objectAtIndex:i] boolValue]) {
                [selectedUserArr addObject:[[arrUsers valueForKey:@"Id"] objectAtIndex:i]];
            }
            
        }

        [_tblPositons reloadData];
           [_tblUsers reloadData];
        
    }     else if (tableView == _tblUsers) {
        if ([selectedUserArr containsObject:[[arrUsers valueForKey:@"Id"] objectAtIndex:indexPath.row]]) {
            [selectedUserArr removeObject:[[arrUsers valueForKey:@"Id"] objectAtIndex:indexPath.row]];
        }
        else{
            [selectedUserArr addObject:[[arrUsers valueForKey:@"Id"] objectAtIndex:indexPath.row]];
        }
        
        [_tblUsers reloadData];
    }
    else if ([tableView isEqual:_tblF_UQuestionREsponce]) {
        if ([selectedF_UQNumber isEqualToString:[NSString stringWithFormat:@"%ld",(long)indexPath.row]]) {
            selectedF_UQNumber = @"";
            
        }else{
            selectedF_UQNumber = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
        }
        [_tblF_UQuestionREsponce reloadData];
        
    }
    
    else if ([tableView isEqual:_tblVideoList]) {
        selectedImgVidIndex = indexPath.row;
    }
      }
    
}
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if ([textView isEqual:_txtDescriptionIssue] || [textView isEqual:_txtAddiInfo]) {
        if (![_isEditAllow isEqualToString:@"YES"] && [_isF_EditAllow isEqualToString:@"YES"]) {
            alert(@"", @"Please note you do not have permission to edit this field.");
            [textView resignFirstResponder];
            return NO;
        }
    }
    return YES;
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
    else if ([textView isEqual:_txtF_UAddInfo]) {
        _lblF_UAddInfo.hidden =YES;
    }
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
        else if ([textView isEqual:_txtF_UAddInfo]) {
            _lblF_UAddInfo.hidden =NO;
        }
    }
    
    
    
}
-(void)totalCost{
//:(NSString*)strPartCost labourHour:(NSString*)strLabourHour labourCost:(NSString*)strLabourCost{
   
    if ([_txtRepairLaborHour.text isEqualToString:@""]) {
        int total = [_txtHourlyRate.text intValue] * 0;
        total = total + [_txtCostOfParts.text intValue];
        _txtRepairTotalCost.text = [NSString stringWithFormat:@"%d",total];
    }
    else if ([_txtHourlyRate.text isEqualToString:@""]) {
        int total = [_txtRepairLaborHour.text intValue] * 0;
        total = total + [_txtCostOfParts.text intValue];
        _txtRepairTotalCost.text = [NSString stringWithFormat:@"%d",total];
    }
    else{
        if (_txtRepairLaborHour.isHidden) {
            int total = [_txtCostOfParts.text intValue];
            _txtRepairTotalCost.text = [NSString stringWithFormat:@"%d",total];
        }
        else{
            int total = [_txtHourlyRate.text intValue] * [_txtRepairLaborHour.text intValue];
            total = total + [_txtCostOfParts.text intValue];
            _txtRepairTotalCost.text = [NSString stringWithFormat:@"%d",total];
        }
    }
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    _isUpdate = YES;
    if ([textField isEqual:_txtHourlyRate]){
        [self totalCost];

    }
    else if ([textField isEqual:_txtRepairLaborHour]){
         [self totalCost];
    }
    else if ([textField isEqual:_txtCostOfParts]){
        [self totalCost];
    }
    else if ([textField isEqual:_txtEquipmentId]) {
            NSLog(@"check in dropdownarry %@",_txtEquipmentId.text);
            if (_isEqInventoryAddToDb) {
                // check dropdown arr and call btnfill
                if ([arrEquipmentId containsObject:_txtEquipmentId.text]) {
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                        _isEqInventoryAddToDb = NO;
                        [tempBtn setTitle:@"Fill" forState:UIControlStateNormal];
                        [self btnFillTapped:tempBtn];
                    });
                }
            }else{
                //chk userinteraction
                //then check in dropdownarr and call btnfill
                if (_txtCategory.userInteractionEnabled) {
                    if ([[arrEquipmentId valueForKey:@"Text"] containsObject:_txtEquipmentId.text]) {
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                            _isEqInventoryAddToDb = NO;
                            [tempBtn setTitle:@"Fill" forState:UIControlStateNormal];
                            [self btnFillTapped:tempBtn];
                        });
                    }
                    else{
                        _isEqInventoryAddToDb = YES;
                    }
                }
            }
        }
    
}
-(BOOL)textViewShouldEndEditing:(UITextView *)textView{
    [textView resignFirstResponder];
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
    
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    _isUpdate = YES;
    if ([textField isEqual:_txtEquipmentId]){
       
        _isEqInventoryAddToDb = YES;

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
          _txtCategory.userInteractionEnabled = YES;
        
        if ([_txtEquipmentId.text length] >1) 
        {
            popOver = nil;
            NSString * strTemp = _txtEquipmentId.text;
             if (gblAppDelegate.isNetworkReachable) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                
                [[WebSerivceCall webServiceObject]callServiceForGetInventoryPartsUsedWorkOrder:YES equipmentId:strTemp checkFilter:@"true" complition:^{
                    _isEqInventoryAddToDb = NO;
                    NSData *dictionaryData = [[NSUserDefaults standardUserDefaults] objectForKey:@"inventoryPartsUsedRecponce"];
                    responceEquipmentIdDic = [NSKeyedUnarchiver unarchiveObjectWithData:dictionaryData];
                    //     //NSLog(@"%@",responceEquipmentIdDic);
                    if (![[responceEquipmentIdDic valueForKey:@"Success"] boolValue]) {
                          _isEqInventoryAddToDb = YES;
                        return ;
                    }
                    
                    arrEquipmentId = [[NSMutableArray alloc]init];
                    arrEquipmentId= [responceEquipmentIdDic valueForKey:@"InventoryParts"];
                    if (arrEquipmentId.count != 0) {
                        _isEqInventoryAddToDb = NO;
                        DropDownPopOver *dropDown = (DropDownPopOver*)[[[NSBundle mainBundle] loadNibNamed:@"DropDownPopOver" owner:self options:nil] firstObject];
                        dropDown.delegate = self;
                        [dropDown showDropDownWith:arrEquipmentId view:textField key:@"Text"];
                    }
                    else{
                          _isEqInventoryAddToDb = YES;
                    }
                    
                    
                    
                }];
            });
             }
             else{
               //  alert(@"", @"We're sorry. C2IT is not currently available offline");
             }
        }
        
        else{
            popOver = nil;
            
        }
    }
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {

    if ([textField isEqual:_txtDateOfWorkOrder] || [textField isEqual:_txtFacilityRelatedToWorkOrder] || [textField isEqual:_txtTimeWorkOrder] || [textField isEqual:_txtLocation] || [textField isEqual:_txtCategory] || [textField isEqual:_txtDescriptionIssue] || [textField isEqual:_txtNature] || [textField isEqual:_txtActionTaken] || [textField isEqual:_txtOtherNote] || [textField isEqual:_txtQRCode] || [textField isEqual:_txtEquipmentId] || [textField isEqual:_txtSerialId] || [textField isEqual:_txtEquipmentName] || [textField isEqual:_txtManufacture] || [textField isEqual:_txtType] || [textField isEqual:_txtMode] || [textField isEqual:_txtBrand] || [textField isEqual:_txtNature2] || [textField isEqual:_txtActionTaken2] || [textField isEqual:_txtFname] || [textField isEqual:_txtMname] || [textField isEqual:_txtLname] || [textField isEqual:_txtEmail] || [textField isEqual:_txtAddiInfo] || [textField isEqual:_txtStatus]) {
//        if ([_isF_EditAllow isEqualToString:@"YES"]) {
//            return NO;
//        }
        if (![_isEditAllow isEqualToString:@"YES"] && [_isF_EditAllow isEqualToString:@"YES"]) {
            alert(@"", @"Please note you do not have permission to edit this field.");
            [textField resignFirstResponder];
            return NO;
        }
    }
    if (_txtEquipmentId.isEditing) {
        [_txtEquipmentId resignFirstResponder];
        if (_isEqInventoryAddToDb) {
            return NO;
        }
        else{
            if (_txtCategory.userInteractionEnabled) {
                if ([[arrEquipmentId valueForKey:@"Text"] containsObject:_txtEquipmentId.text]) {
                    return NO;
                }
            }
        }
    }
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
    else if ([textField isEqual:_txtEstimatedDate]) {
        DatePopOverView *datePopOver = (DatePopOverView *)[[[NSBundle mainBundle] loadNibNamed:@"DatePopOverView" owner:self options:nil] firstObject];
        [datePopOver showInPopOverFor:textField limit:DATE_LIMIT_ALL_DATE option:DATE_SELECTION_DATE_ONLY updateField:textField];
        allowEditing = NO;
        
    }
    else if ([textField isEqual:_txtComplitionDate]) {
        DatePopOverView *datePopOver = (DatePopOverView *)[[[NSBundle mainBundle] loadNibNamed:@"DatePopOverView" owner:self options:nil] firstObject];
        [datePopOver showInPopOverFor:textField limit:DATE_LIMIT_ALL_DATE option:DATE_SELECTION_DATE_ONLY updateField:textField];
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
    else if ([textField isEqual:_txtActionTaken2]){
        DropDownPopOver *dropDown = (DropDownPopOver*)[[[NSBundle mainBundle] loadNibNamed:@"DropDownPopOver" owner:self options:nil] firstObject];
        dropDown.delegate = self;
        
        [dropDown showDropDownWith:arrEquipmentActionTaken view:textField key:@"Text"];
        
        allowEditing = NO;
    }
    
    else if ([textField isEqual:_txtSelectRepairTime]){
        DropDownPopOver *dropDown = (DropDownPopOver*)[[[NSBundle mainBundle] loadNibNamed:@"DropDownPopOver" owner:self options:nil] firstObject];
        dropDown.delegate = self;
        [dropDown showDropDownWith:arrRepairType view:textField key:@"Text"];
        allowEditing = NO;
    }
    else if ([textField isEqual:_txtInventoryTypes]){
        
        if ([flagServiseCall isEqualToString:@"YES"]) {
            if (gblAppDelegate.isNetworkReachable) {

            [[WebSerivceCall webServiceObject]callServiceForGetInventoryPartsUsedWorkOrder:YES equipmentId:@"a" checkFilter:@"false" complition:^{
                
                NSData *dictionaryData = [[NSUserDefaults standardUserDefaults] objectForKey:@"inventoryPartsUsedRecponce"];
                responceInventoryDic = [NSKeyedUnarchiver unarchiveObjectWithData:dictionaryData];
                //nslog(@"%@",responceInventoryDic);
                
                arrInventoryPartsUsed = [responceInventoryDic valueForKey:@"InventoryParts"];
                DropDownPopOver *dropDown = (DropDownPopOver*)[[[NSBundle mainBundle] loadNibNamed:@"DropDownPopOver" owner:self options:nil] firstObject];
                dropDown.delegate = self;
                [dropDown showDropDownWith:arrInventoryPartsUsed view:textField key:@"Text"];
                
                flagServiseCall = @"NO";
            }];
        }
        else{
            alert(@"", @"We're sorry. C2IT is not currently available offline");
        }
        }
        else{
            DropDownPopOver *dropDown = (DropDownPopOver*)[[[NSBundle mainBundle] loadNibNamed:@"DropDownPopOver" owner:self options:nil] firstObject];
            dropDown.delegate = self;
            [dropDown showDropDownWith:arrInventoryPartsUsed view:textField key:@"Text"];
            
        }
    
        allowEditing = NO;
        
    }
    
    else if ([textField isEqual:_txtStatus]){
        DropDownPopOver *dropDown = (DropDownPopOver*)[[[NSBundle mainBundle] loadNibNamed:@"DropDownPopOver" owner:self options:nil] firstObject];
        dropDown.delegate = self;
        [dropDown showDropDownWith:arrStatus view:textField key:@"Text"];
        allowEditing = NO;
    }
    else if ([textField isEqual:_txtF_UStatus]){
        DropDownPopOver *dropDown = (DropDownPopOver*)[[[NSBundle mainBundle] loadNibNamed:@"DropDownPopOver" owner:self options:nil] firstObject];
        dropDown.delegate = self;
        [dropDown showDropDownWith:arrF_UStatus view:textField key:@"Text"];
        allowEditing = NO;
    }
    else if ([textField isEqual:_txtBrand]){
        DropDownPopOver *dropDown = (DropDownPopOver*)[[[NSBundle mainBundle] loadNibNamed:@"DropDownPopOver" owner:self options:nil] firstObject];
        dropDown.delegate = self;
        [dropDown showDropDownWith:arrBrand view:textField key:@"Text"];
        allowEditing = NO;
    }
    else if ([textField isEqual:_txtRepairTotalCost]){
//        if (_txtRepairLaborHour.isHidden) {
//            allowEditing = YES;
//        }
//        else{
        allowEditing = NO;
//        }
    }
    else if ([textField isEqual:_txtCostOfParts]){
        allowEditing = YES;
    }
    
    if ([textField isEqual:_txtHourlyRate]){
        
        _txtHourlyRate.text = [NSString stringWithFormat:@"%ld",[textField.text integerValue]];
        
    }
    else if ([textField isEqual:_txtRepairLaborHour]){
        
        _txtRepairLaborHour.text = [NSString stringWithFormat:@"%ld",[textField.text integerValue]];
        
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
      //  arrLocation = [gblAppDelegate.managedObjectContext executeFetchRequest:requestLoc error:nil];
        
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
        _isEqInventoryAddToDb = NO;
        [sender setText:[value valueForKey:@"Text"]];
    
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            [tempBtn setTitle:@"Fill" forState:UIControlStateNormal];
            [self btnFillTapped:tempBtn];
        });
        
        
    }
    else if ([sender isEqual:_txtNature]){
        [sender setText:[value valueForKey:@"Text"]];
        
        if ([[[value valueForKey:@"Text"]uppercaseString] isEqualToString:@"OTHER"]) {
            
            _txtOtherNote.hidden = false;
            _imgBGOtherNote.hidden = false;
            
            
        }
        else{
            _txtOtherNote.hidden = true;
            _imgBGOtherNote.hidden = true;
        }
        [self viewSetUp];
    }
    else if ([sender isEqual:_txtNature2]){
        [sender setText:[value valueForKey:@"Text"]];
        if ([[[value valueForKey:@"Text"]uppercaseString] isEqualToString:@"OTHER"]) {
            
            _txtOtherNote2.hidden = false;
            _imgBGOtherNote2.hidden = false;
        }
        else{
            _txtOtherNote2.hidden = true;
            _imgBGOtherNote2.hidden = true;
        }
        [self viewSetUp];
    }
    else
        [sender setText:[value valueForKey:@"Text"]];
}

- (IBAction)servityRadioBtnTapped:(UIButton *)sender {
    if (![_isEditAllow isEqualToString:@"YES"] && [_isF_EditAllow isEqualToString:@"YES"]) {
        alert(@"", @"Please note you do not have permission to edit this field.");

        return;
    }
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
    if (![_isEditAllow isEqualToString:@"YES"] && [_isF_EditAllow isEqualToString:@"YES"]) {
        alert(@"", @"Please note you do not have permission to edit this field.");

        return;
    }
    _isEqInventoryAddToDb = NO;

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
    
    [self viewSetUp];
    
    if(_radioBtnMaintenanceType1.isSelected) {
        _txtOtherNote.hidden = YES;
        _imgBGOtherNote.hidden = YES;
        
        _lblStarGAction.hidden = YES;
  _lblStarGNature.hidden = YES;
        for (int i =0; i<arrEquipmentReq.count; i++) {
            if ([[NSString stringWithFormat:@"%@",[[arrEquipmentReq valueForKey:@"Id"] objectAtIndex:i]] isEqualToString:@"16"]) {
                if ([[[arrEquipmentReq valueForKey:@"Selected"] objectAtIndex:i] boolValue]) {
                    _lblStarCategory.hidden = NO;
                }
            }
           else if ([[NSString stringWithFormat:@"%@",[[arrEquipmentReq valueForKey:@"Id"] objectAtIndex:i]] isEqualToString:@"13"]) {
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
        _txtOtherNote2.hidden = YES;
        _imgBGOtherNote2.hidden = YES;
        
        _lblStarEqipId.hidden = YES;
        _lblStarSerialId.hidden = YES;
        _lblStarEqipName.hidden = YES;
        _lblStarManufact.hidden = YES;
        _lblStarEqType.hidden = YES;
        _lblStarEqMode.hidden = YES;
        _lblStarEqBrand.hidden = YES;
        _lblStarEqNature.hidden = YES;
        _lblStarFName.hidden = YES;
      
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
    
    
  
    // [_tblScrollBG reloadData];
    
}
- (IBAction)imageOrVideoRadioBtnTapped:(UIButton *)sender {
    if (![_isEditAllow isEqualToString:@"YES"] && [_isF_EditAllow isEqualToString:@"YES"]) {
        alert(@"", @"Please note you do not have permission to edit this field.");

        return;
    }
    _isUpdate = YES;
    [_radioBtnImg setSelected:NO];
    [_radioBtnVideo setSelected:NO];
    [sender setSelected:YES];
    
    if ([_radioBtnImg isSelected]) {
        _lblVideo.text = @"Image";
        [_btnAttachVideoOrPhoto setTitle:@"Attach image" forState:UIControlStateNormal];
       // arrVideoOrImage = [NSMutableArray new];
    }
    else
    {
        _lblVideo.text = @"Video";
        [_btnAttachVideoOrPhoto setTitle:@"Attach video" forState:UIControlStateNormal];
     //   arrVideoOrImage = [NSMutableArray new];
        
    }
    [_tblVideoList reloadData];
    
}
- (IBAction)btnAttachVideoOrPhotoTapped:(UIButton *)sender {
    if (![_isEditAllow isEqualToString:@"YES"] && [_isF_EditAllow isEqualToString:@"YES"]) {
        alert(@"", @"Please note you do not have permission to edit this field.");

        return;
    }
    _isUpdate = YES;
    if ([_radioBtnVideo isSelected]) {
        if (!(arrVideo.count < 1)) {
            alert(@"", @"Sorry! You cannot attach more than 1 video.");
            return;
        }
        if (arrImage.count != 0) {
            UIAlertController * alertAddNew = [[UIAlertController alloc]init];
            alertAddNew=[UIAlertController alertControllerWithTitle:@"" message:@"If you upload new video file, you will lose previously uploaded image. Do you want to upload new file?"preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* yesButton = [UIAlertAction
                                        actionWithTitle:@"Yes"
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction * action)
                                        {
                                            arrImage = [NSMutableArray new];
                                            arrVideo = [NSMutableArray new];
                                             arrOfLoadedMedia = [NSMutableArray new];
                                                arrViewImgVideo = [NSMutableArray new];
                                            [self actionSheetCall:sender];
                                        }];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
            
            [alertAddNew addAction:yesButton];
            [alertAddNew addAction:cancel];
            [self presentViewController:alertAddNew animated:YES completion:nil];
            
            
        }
        
    }
    else if ([_radioBtnImg isSelected]) {
        if (!(arrImage.count < 3)) {
            alert(@"", @"Sorry! You cannot attach more than 3 images.");
            return;
        }
        if (arrVideo.count != 0) {
            
            UIAlertController * alertAddNew = [[UIAlertController alloc]init];
            alertAddNew=[UIAlertController alertControllerWithTitle:@"" message:@"If you upload new image file, you will lose previously uploaded video. Do you want to upload new file?"preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* yesButton = [UIAlertAction
                                        actionWithTitle:@"Yes"
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction * action)
                                        {
                                            arrVideo = [NSMutableArray new];
                                            arrImage = [NSMutableArray new];
                                             arrOfLoadedMedia = [NSMutableArray new];
                                                arrViewImgVideo = [NSMutableArray new];
                                            [self actionSheetCall:sender];
                                        }];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
            [alertAddNew addAction:yesButton];
            [alertAddNew addAction:cancel];
            [self presentViewController:alertAddNew animated:YES completion:nil];
        }
        
        
    }
    
    [self actionSheetCall:sender];
    
    

    
}
-(void)actionSheetCall:(UIButton *)sender{
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
        //nslog(@"%@",info);
        strEncoded = [UIImageJPEGRepresentation(_imgBodilyFluid, 1.0) base64EncodedStringWithOptions:0];
        tempstrDataType=@"data:image/gif;base64,";
        
        NSMutableDictionary * tempDic = [[NSMutableDictionary alloc] init];
        //        [tempDic setValue:[[info objectForKey:UIImagePickerControllerReferenceURL] lastPathComponent] forKey:@"fileName"];
        //          [tempDic setValue:[[info objectForKey:UIImagePickerControllerReferenceURL] pathExtension] forKey:@"fileType"];
        [tempDic setValue:@"image" forKey:@"Key"];
        [tempDic setValue:strEncoded forKey:@"Value"];
        
        [arrImage addObject:tempDic];
         [arrOfLoadedMedia addObject:tempDic];
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
            
            //      NSString * validationSize=@"4000096"; //in byte limit for 4Mb
            NSString * validationSize=@"15000000";//in byte limit for 15Mb
            //nslog(@"%ld %ld", (long)[properties fileSize],(long)[validationSize integerValue]);
            NSInteger  tempVideoSize=[[NSString stringWithFormat:@"%llu",[properties fileSize]] integerValue];
            totalSizeOFUploadedVideo = totalSizeOFUploadedVideo + tempVideoSize;
            //nslog(@">> %ld >> %ld",(long)tempVideoSize,(long)totalSizeOFUploadedVideo);
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
                    
                    alert(@"WARNING", @"Please upload file size less than 15 MB.")
                    
                });
                
            }
            else{
                tempstrDataType=@"data:video/mp4;base64,";
                NSMutableDictionary * tempDic = [[NSMutableDictionary alloc] init];
                //        [tempDic setValue:[[info objectForKey:UIImagePickerControllerReferenceURL] lastPathComponent] forKey:@"fileName"];
                //          [tempDic setValue:[[info objectForKey:UIImagePickerControllerReferenceURL] pathExtension] forKey:@"fileType"];
                [tempDic setValue:@"video" forKey:@"Key"];
                [tempDic setValue:strEncoded forKey:@"Value"];
                [arrVideo addObject:tempDic];
                 [arrOfLoadedMedia addObject:tempDic];
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
                //nslog(@"error: %@", [error description]);
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
    [self viewSetUp];
    
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
    //    if ([self validation]) {
    //        NSDictionary *aDictParams = [self sendData];
    //    //    //nslog(@"%@",aDictParams);
    //
    // [[WebSerivceCall webServiceObject]callServiceForSubmitWithFollowupEditWorkOrder:YES paraDic:aDictParams isFollowPresent:@"true" isSubmit:@"true" historyReportId:[NSString stringWithFormat:@"%@",[responceDic valueForKey:@"HistoryId"]] revisionId:[NSString stringWithFormat:@"%@",[responceDic valueForKey:@"RevisionId"]] sequence:[NSString stringWithFormat:@"%@",[responceDic valueForKey:@"Sequence"]] complition:^{
    //            //  alert(@"", @"Work Order created successfully");
    //        }];
    //    }
    
}
-(void)saveInventoryToDatabase
{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"This item was not found in the inventory. Do you want to add this item to inventory?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *yes = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                          {
                              [gblAppDelegate showActivityIndicator];

                              if (![_txtF_UStatus.text isEqualToString:@""]){
                                  [self btnAddFollowUpEntryTapped:_btnAddFollowUp];
                              }
                              else if (![_txtF_UAddInfo.text isEqualToString:@""]){
                                  if ([_txtF_UStatus.text isEqualToString:@""]){
                                      alert(@"", @"Please add follow-up status");
                                      return;
                                  }else{
                                      [self btnAddFollowUpEntryTapped:_btnAddFollowUp];
                                      
                                  }
                              }
                              
                              NSMutableArray * tempNewF_ULogArr = [[NSMutableArray alloc] init];
                              for (int k=0; k<arrAddFollowUpLog.count; k++) {
                                  if ([[NSString stringWithFormat:@"%@",[[arrAddFollowUpLog valueForKey:@"FFollowupId"] objectAtIndex:k]] isEqualToString:@"New"]) {
                                      [tempNewF_ULogArr addObject:[arrAddFollowUpLog objectAtIndex:k]];
                                  }
                              }
                              
                              NSDictionary *aDictParams = [self sendInventoryData:tempNewF_ULogArr];
                              NSDictionary *aDictParams2 = [self sendData:tempNewF_ULogArr];
                              if (gblAppDelegate.isNetworkReachable) {
                                  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                                      
                                      [[WebSerivceCall webServiceObject]callServiceForAddNewEquipmentInventoryToDatabase:YES paraDic:aDictParams complition:^(NSDictionary *response){
                                          if ([[response valueForKey:@"Success"] boolValue]) {
                                              [self finalSubmit:aDictParams2];
                                              
                                          }
                                          else{
                                              [gblAppDelegate hideActivityIndicator];
                                              
                                          }
                                          
                                      }];
                                  });
                              }  else{
                                      [self saveInventoryDataToSync:aDictParams];
                                  [self finalSubmit:aDictParams2];
                                  [gblAppDelegate hideActivityIndicator];
                                      alert(@"", MSG_ADDED_TO_SYNC);
                                  }
                          
                          }];
    UIAlertAction *no = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:yes];
    [alert addAction:no];
    [self presentViewController:alert animated:YES completion:nil];
    
    }
-(void)saveInventoryDataToSync:(NSDictionary*)saveDataDic{
    
    WorkOrderNewEquipmentInventory * workOrder = [NSEntityDescription insertNewObjectForEntityForName:@"WorkOrderNewEquipmentInventory" inManagedObjectContext:gblAppDelegate.managedObjectContext];
    
    workOrder.serialId = [saveDataDic objectForKey:@"SerialId"];
    workOrder.inventorySetupId = [saveDataDic objectForKey:@"InventorySetupId"];
    workOrder.inventoryManufactureId = [saveDataDic objectForKey:@"InventoryManufactureId"];
    workOrder.inventoryBrandId = [saveDataDic objectForKey:@"InventoryBrandId"];
    workOrder.inventoryModelId = [saveDataDic objectForKey:@"InventoryModelId"];
    workOrder.inventoryTypeId = [saveDataDic objectForKey:@"InventoryTypeId"];
    workOrder.inventoryCategoryId = [saveDataDic objectForKey:@"InventoryCategoryId"];
    workOrder.equipmentId = [saveDataDic objectForKey:@"EquipmentId"];
    workOrder.equipmentName = [saveDataDic objectForKey:@"EquipmentName"];
    workOrder.unitQuantity = [saveDataDic objectForKey:@"UnitQuantity"];
    workOrder.itemPerUnit = [saveDataDic objectForKey:@"ItemPerUnit"];
    workOrder.itemPerUnitCost = [saveDataDic objectForKey:@"ItemPerUnitCost"];
    workOrder.totalQuantity = [saveDataDic objectForKey:@"TotalQuantity"];
    workOrder.isCompleted = [NSNumber numberWithBool:YES];
    workOrder.userId = [[User currentUser] userId];
    
    [gblAppDelegate.managedObjectContext insertObject:workOrder];
    [gblAppDelegate.managedObjectContext save:nil];
    
}
-(void)finalSubmit:(NSDictionary*)aDictParams{
    [gblAppDelegate showActivityIndicator];

  //  NSLog(@"Log submit ::: %@",aDictParams);
    if (gblAppDelegate.isNetworkReachable) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{

        [[WebSerivceCall webServiceObject]callServiceForSubmitWithFollowupEditWorkOrder:YES paraDic:aDictParams isFollowPresent:@"true" isSubmit:@"false" historyReportId:[NSString stringWithFormat:@"%@",[responceDic valueForKey:@"HistoryId"]] revisionId:[NSString stringWithFormat:@"%@",[responceDic valueForKey:@"RevisionId"]] isImage:[self isPgotoVideoExist:arrImage index:0 strImageOrVideo:@"img"] isVideo:[self isPgotoVideoExist:arrVideo index:0 strImageOrVideo:@"vid"] sequence:[NSString stringWithFormat:@"%@",[responceDic valueForKey:@"Sequence"]] complition:^{
            [self.navigationController popViewControllerAnimated:YES];
            alert(@"", @"Work Order updated successfully");
            [gblAppDelegate hideActivityIndicator];

        }];
        });
    }
    else{
        [self saveDataToSync:aDictParams isSubmitLatter:@"false"];
        [self.navigationController popViewControllerAnimated:YES];
        [gblAppDelegate hideActivityIndicator];
        alert(@"", MSG_ADDED_TO_SYNC);
    }
}

-(void)saveDataToSync:(NSDictionary*)saveDataDic isSubmitLatter:(NSString*)isSubmitLatter{
    
    WorkOrderWithFollowupSubmit * workOrder = [NSEntityDescription insertNewObjectForEntityForName:@"WorkOrderWithFollowupSubmit" inManagedObjectContext:gblAppDelegate.managedObjectContext];
 
    

    workOrder.woId = @"0";
    workOrder.workOrderSetUpId = @"0";
    workOrder.serialId = [saveDataDic objectForKey:@"SerialId"];
    workOrder.workOrderDate = [saveDataDic objectForKey:@"WorkOrderDate"];
    workOrder.workOrderTime = [saveDataDic objectForKey:@"WorkOrderTime"];
    workOrder.descriptionOfIssue = [saveDataDic objectForKey:@"DescriptionOfIssue"];
    workOrder.additionalInformation = [saveDataDic objectForKey:@"AdditionalInformation"];
    workOrder.statusId = [saveDataDic objectForKey:@"WorkOrderStatusId"];
    workOrder.equipmentActionId = [saveDataDic objectForKey:@"EquipmentActionId"];
    workOrder.equipmentNatureId = [saveDataDic objectForKey:@"EquipmentNatureId"];
    workOrder.generalActionId = [saveDataDic objectForKey:@"GeneralActionId"];
    workOrder.generalNatureId = [saveDataDic objectForKey:@"GeneralNatureId"];
    workOrder.otherGeneralNature = [saveDataDic objectForKey:@"OtherGeneralNature"];
    workOrder.otherEquipmentNature = [saveDataDic objectForKey:@"OtherEquipmentNature"];
    workOrder.maintenanceType = [saveDataDic objectForKey:@"MaintenanceType"];
    workOrder.inventorySetupId = [saveDataDic objectForKey:@"InventorySetupId"];
    workOrder.inventoryManufactureId = [saveDataDic objectForKey:@"InventoryManufactureId"];
    workOrder.inventoryBrandId = [saveDataDic objectForKey:@"InventoryBrandId"];
    workOrder.inventoryModelId = [saveDataDic objectForKey:@"InventoryModelId"];
    workOrder.inventoryLocationId = [saveDataDic objectForKey:@"InventoryLocationId"];
    workOrder.inventoryTypeId = [saveDataDic objectForKey:@"InventoryTypeId"];
    workOrder.inventoryCategoryId = [saveDataDic objectForKey:@"InventoryCategoryId"];
    workOrder.isNotificationField1Selected = [saveDataDic objectForKey:@"IsNotificationField1Selected"];
    workOrder.isNotificationField2Selected = [saveDataDic objectForKey:@"IsNotificationField2Selected"];
    workOrder.isNotificationField3Selected = [saveDataDic objectForKey:@"IsNotificationField3Selected"];
    workOrder.isNotificationField4Selected = [saveDataDic objectForKey:@"IsNotificationField4Selected"];
    workOrder.equipmentId = [saveDataDic objectForKey:@"EquipmentId"];
    workOrder.equipmentName = [saveDataDic objectForKey:@"EquipmentName"];
    workOrder.isPhotoExists = [saveDataDic objectForKey:@"IsPhotoExists"];
    workOrder.isVideoExist = [saveDataDic objectForKey:@"IsVideoExist"];
    workOrder.photo1 = [saveDataDic objectForKey:@"Photo1"];
    workOrder.photo2 = [saveDataDic objectForKey:@"Photo2"];
    workOrder.photo3 = [saveDataDic objectForKey:@"Photo3"];
    workOrder.video1 = [saveDataDic objectForKey:@"Video1"];
    workOrder.personFirstName = [saveDataDic objectForKey:@"PersonFirstName"];
    workOrder.personMiddleInitial = [saveDataDic objectForKey:@"PersonMiddleInitial"];
    workOrder.personLastName = [saveDataDic objectForKey:@"PersonLastName"];
    workOrder.personHomePhone = [saveDataDic objectForKey:@"PersonHomePhone"];
    workOrder.personAlternatePhone = [saveDataDic objectForKey:@"PersonAlternatePhone"];
    workOrder.personEmail = [saveDataDic objectForKey:@"PersonEmail"];
       workOrder.previousHistoryId = [saveDataDic objectForKey:@"PreviousHistoryId"];
    workOrder.isMedia = [saveDataDic objectForKey:@"IsMedia"];
    workOrder.isInProgress = [saveDataDic objectForKey:@"IsInProgress"];
    workOrder.isEquipmentMaintenance = [saveDataDic objectForKey:@"IsEquipmentMaintenance"];
    workOrder.repairTypeId = [saveDataDic objectForKey:@"RepairTypeId"];
    workOrder.dateOfCompletion = [saveDataDic objectForKey:@"DateOfCompletion"];
    workOrder.estimatedDateOfCompletion = [saveDataDic objectForKey:@"EstimatedDateOfCompletion"];
    workOrder.facilityId = [saveDataDic objectForKey:@"FacilityId"];
    workOrder.assignedToUserIds = [saveDataDic objectForKey:@"AssignedToUserIds"];
    workOrder.itemId = [saveDataDic objectForKey:@"ItemId"];
    workOrder.itemName = [saveDataDic objectForKey:@"ItemName"];
    workOrder.employeeEmail = [saveDataDic objectForKey:@"EmployeeEmail"];
    workOrder.employeeFirstName = [saveDataDic objectForKey:@"EmployeeFirstName"];
    workOrder.employeeLastName = [saveDataDic objectForKey:@"EmployeeLastName"];
    workOrder.employeeMiddleName = [saveDataDic objectForKey:@"EmployeeMiddleName"];
    workOrder.equipmentQRCode = [saveDataDic objectForKey:@"EquipmentQRCode"];
    workOrder.equipmentBarCode = [saveDataDic objectForKey:@"EquipmentBarCode"];
    workOrder.repairCostOfParts = [saveDataDic objectForKey:@"RepairCostOfParts"];
    workOrder.repairLabourHourlyCost = [saveDataDic objectForKey:@"RepairLabourHourlyCost"];
    workOrder.repairLabourHour = [saveDataDic objectForKey:@"RepairLabourHour"];
    workOrder.repairTotalCost = [saveDataDic objectForKey:@"RepairTotalCost"];
    workOrder.replacementCost = [saveDataDic objectForKey:@"ReplacementCost"];
    workOrder.isShowWorkOrderTypeRepair = [saveDataDic objectForKey:@"IsShowWorkOrderTypeRepair"];
    workOrder.isShowWorkOrderTypeReplacement = [saveDataDic objectForKey:@"IsShowWorkOrderTypeReplacement"];
    
    workOrder.inventoryPartsUsed = @"";//[saveDataDic objectForKey:@"InventoryPartsUsed"];
    workOrder.followups = @"";//[saveDataDic objectForKey:@"Followups"];
    workOrder.followupsLogsNew = @"";//[saveDataDic objectForKey:@"FollowupsLogsNew"];
   

    NSArray * arrPartsUsed = [[NSArray alloc]init];
    arrPartsUsed = [saveDataDic objectForKey:@"InventoryPartsUsed"];
    
    for (NSDictionary *aDict in arrPartsUsed) {
          WorkOrderInventoryPartsUsed * partsUsed = [NSEntityDescription insertNewObjectForEntityForName:@"WorkOrderInventoryPartsUsed" inManagedObjectContext:gblAppDelegate.managedObjectContext];
        partsUsed.cost = [aDict valueForKey:@"cost"];
        partsUsed.name = [aDict valueForKey:@"name"];
        partsUsed.partId = [NSString stringWithFormat:@"%@",[aDict valueForKey:@"id"]];
        partsUsed.inventorydetailsId = [NSString stringWithFormat:@"%@",[aDict valueForKey:@"inventorydetailsId"]];
          partsUsed.woId = [NSString stringWithFormat:@"%@",[responceDic valueForKey:@"HistoryId"]];
        [gblAppDelegate.managedObjectContext insertObject:partsUsed];
        [gblAppDelegate.managedObjectContext save:nil];
    }
    
 
    
    
    
    NSArray * arrFollowups = [[NSArray alloc]init];
    arrFollowups = [saveDataDic objectForKey:@"Followups"];
    
    for (NSDictionary *aDict in arrFollowups) {
        WorkOrderFollowup * followup = [NSEntityDescription insertNewObjectForEntityForName:@"WorkOrderFollowup" inManagedObjectContext:gblAppDelegate.managedObjectContext];

        followup.date = [aDict valueForKey:@"Date"];
        followup.displayDate = [aDict valueForKey:@"DisplayDate"];
        followup.fFollowupId =[NSString stringWithFormat:@"%@",[aDict valueForKey:@"FFollowupId"]] ;
        followup.followupId = [NSString stringWithFormat:@"%@",[aDict valueForKey:@"FollowupId"]];
        if ([[aDict valueForKey:@"FollowupLogs"]isKindOfClass:[NSNull class]]) {
            followup.followupLogs = @"";
        }
        else{
            followup.followupLogs = [aDict valueForKey:@"FollowupLogs"];
        }
        followup.historyId = [NSString stringWithFormat:@"%@",[aDict valueForKey:@"HistoryId"]];
        if ([[aDict valueForKey:@"IsAllowEditing"]boolValue]) {
            followup.isAllowEditing = @"1";
        }
        else{
            followup.isAllowEditing = @"0";

        }
        if ([[aDict valueForKey:@"IsEmployeeReport"]boolValue]) {
            followup.isEmployeeReport = @"1";

        }
        else{
            followup.isEmployeeReport = @"0";

 }
        if ([[aDict valueForKey:@"IsNewFollowup"]boolValue]) {
            followup.isNewFollowup = @"1";
        }
        else{
            followup.isNewFollowup = @"0";
 }
       followup.fId = [NSString stringWithFormat:@"%@",[aDict valueForKey:@"Id"]];
        
              if ([[aDict valueForKey:@"QuestionResponse1"]isKindOfClass:[NSNull class]]) {
                  followup.questionResponse1 = @"";

              }
              else{
                  if ([[aDict valueForKey:@"QuestionResponse1"] isKindOfClass:[NSNumber class]]) {
                     followup.questionResponse1 = [NSString stringWithFormat:@"%@",[aDict valueForKey:@"QuestionResponse1"]];
                  }
                  else if ([[aDict valueForKey:@"QuestionResponse1"] isEqualToString:@"true"]) {
                      followup.questionResponse1 = @"true";
                  }
                  else if ([[aDict valueForKey:@"QuestionResponse1"] isEqualToString:@"false"]) {
                      followup.questionResponse1 = @"false";
                  }
                  else{
                        followup.questionResponse1 = @"";
                     
                  }

              }
        if ([[aDict valueForKey:@"QuestionResponse2"]isKindOfClass:[NSNull class]]) {
            followup.questionResponse2 = @"";

        }
        else{
          
            if ([[aDict valueForKey:@"QuestionResponse2"]  isKindOfClass:[NSNumber class]]) {
                followup.questionResponse2 = [NSString stringWithFormat:@"%@",[aDict valueForKey:@"QuestionResponse2"]];
            }
            else if ([[aDict valueForKey:@"QuestionResponse2"] isEqualToString:@"true"]) {
                followup.questionResponse2 = @"true";
            }
            else if ([[aDict valueForKey:@"QuestionResponse2"] isEqualToString:@"false"]) {
                followup.questionResponse2 = @"false";
            }
            else{
                followup.questionResponse2 = @"";
            }
        }
        if ([[aDict valueForKey:@"QuestionResponse3"]isKindOfClass:[NSNull class]]) {
            followup.questionResponse3 = @"";

        }
        else{
           
            if ([[aDict valueForKey:@"QuestionResponse3"] isKindOfClass:[NSNumber class]]) {
                followup.questionResponse3 = [NSString stringWithFormat:@"%@",[aDict valueForKey:@"QuestionResponse3"]];
            }
            else if ([[aDict valueForKey:@"QuestionResponse3"] isEqualToString:@"true"]) {
                followup.questionResponse3 = @"true";
            }
            else if ([[aDict valueForKey:@"QuestionResponse3"] isEqualToString:@"false"]) {
                followup.questionResponse3 = @"false";
            }
            else{
                followup.questionResponse3 = @"";
            }
        }
        if ([[aDict valueForKey:@"QuestionResponse4"]isKindOfClass:[NSNull class]]) {
            followup.questionResponse4 = @"";

        }
        else{
         
            if ([[aDict valueForKey:@"QuestionResponse4"] isKindOfClass:[NSNumber class]]) {
                followup.questionResponse4 = [NSString stringWithFormat:@"%@",[aDict valueForKey:@"QuestionResponse4"]];
            }
            else if ([[aDict valueForKey:@"QuestionResponse4"] isEqualToString:@"true"]) {
                followup.questionResponse4 = @"true";
            }
            else if ([[aDict valueForKey:@"QuestionResponse4"] isEqualToString:@"false"]) {
                followup.questionResponse4 = @"false";
            }
            else{
                   followup.questionResponse4 = @"";
            }
        }
     
        followup.questionYesNoText1 = [aDict valueForKey:@"QuestionYesNoText1"];
        followup.questionYesNoText2 = [aDict valueForKey:@"QuestionYesNoText2"];
        followup.questionYesNoText3 = [aDict valueForKey:@"QuestionYesNoText3"];
        followup.questionYesNoText4 = [aDict valueForKey:@"QuestionYesNoText4"];
        followup.updatedOn = [aDict valueForKey:@"UpdatedOn"];
        followup.woId = [NSString stringWithFormat:@"%@",[responceDic valueForKey:@"HistoryId"]];
        
        
        [gblAppDelegate.managedObjectContext insertObject:followup];
        [gblAppDelegate.managedObjectContext save:nil];
    }
    
    
  
    NSArray * arrFollowupsLogsNew = [[NSArray alloc]init];
    arrFollowupsLogsNew = [saveDataDic objectForKey:@"FollowupsLogsNew"];
    
    for (NSDictionary *aDict in arrFollowupsLogsNew) {
        WorkOrderFollowupLogsNew * followupLogsNew = [NSEntityDescription insertNewObjectForEntityForName:@"WorkOrderFollowupLogsNew" inManagedObjectContext:gblAppDelegate.managedObjectContext];
   

        
        followupLogsNew.date = [aDict valueForKey:@"Date"];
        followupLogsNew.displayDate = [aDict valueForKey:@"DisplayDate"];
        followupLogsNew.fFollowupId = [aDict valueForKey:@"FFollowupId"];
        followupLogsNew.followupId = [aDict valueForKey:@"FollowupId"];
        followupLogsNew.email = [aDict valueForKey:@"Email"];
        followupLogsNew.cellNumber = [aDict valueForKey:@"CellNumber"];
        followupLogsNew.isAllowEditing = [aDict valueForKey:@"IsAllowEditing"];
        followupLogsNew.followupCall = [aDict valueForKey:@"FollowupCall"];
        followupLogsNew.followupLogId = [aDict valueForKey:@"FollowupLogId"];
        followupLogsNew.information = [aDict valueForKey:@"Information"];
        followupLogsNew.informationShowLess = [aDict valueForKey:@"InformationShowLess"];
        followupLogsNew.name = [aDict valueForKey:@"Name"];
        followupLogsNew.phoneNumber = [aDict valueForKey:@"PhoneNumber"];
        followupLogsNew.workOrderFollowupHistoryId = [aDict valueForKey:@"WorkOrderFollowupHistoryId"];
        followupLogsNew.updatedOn = [aDict valueForKey:@"UpdatedOn"];
     
        followupLogsNew.woId = [NSString stringWithFormat:@"%@",[responceDic valueForKey:@"HistoryId"]];
        
        
        [gblAppDelegate.managedObjectContext insertObject:followupLogsNew];
        [gblAppDelegate.managedObjectContext save:nil];
        
    }
    
    
    
    workOrder.existingImages = [saveDataDic objectForKey:@"ExistingImages"];
    workOrder.existingVideo = [saveDataDic objectForKey:@"ExistingVideo"];


    workOrder.isReadyForFollowupcomplition = isSubmitLatter;
    workOrder.isCompleted = [NSNumber numberWithBool:YES];
    workOrder.userId = [[User currentUser] userId];
    
    
    workOrder.historyReportId = [NSString stringWithFormat:@"%@",[responceDic valueForKey:@"HistoryId"]];
    workOrder.revisionId = [NSString stringWithFormat:@"%@",[responceDic valueForKey:@"RevisionId"]];
    workOrder.sequence = [NSString stringWithFormat:@"%@",[responceDic valueForKey:@"Sequence"]];
    
    
    [gblAppDelegate.managedObjectContext insertObject:workOrder];
    [gblAppDelegate.managedObjectContext save:nil];
    
    
}
- (IBAction)btnSubmitLatterTapped:(UIButton *)sender {

    if (_txtEquipmentId.isEditing) {
        [_txtEquipmentId resignFirstResponder];
    }
    
    if ([self validation]) {
   if (_isEqInventoryAddToDb) {
       [self saveInventoryToDatabase];
        }
   else{
       if (![_txtF_UStatus.text isEqualToString:@""]){
           [self btnAddFollowUpEntryTapped:_btnAddFollowUp];
       }
       else if (![_txtF_UAddInfo.text isEqualToString:@""]){
           if ([_txtF_UStatus.text isEqualToString:@""]){
               alert(@"", @"Please add follow-up status");
               return;
           }else{
               [self btnAddFollowUpEntryTapped:_btnAddFollowUp];
               
           }
       }
       
       NSMutableArray * tempNewF_ULogArr = [[NSMutableArray alloc] init];
       for (int k=0; k<arrAddFollowUpLog.count; k++) {
           if ([[NSString stringWithFormat:@"%@",[[arrAddFollowUpLog valueForKey:@"FFollowupId"] objectAtIndex:k]] isEqualToString:@"New"]) {
               [tempNewF_ULogArr addObject:[arrAddFollowUpLog objectAtIndex:k]];
           }
       }
       
       NSDictionary *aDictParams = [self sendData:tempNewF_ULogArr];
       [self finalSubmit:aDictParams];

   }
    }
}
-(NSDictionary*)sendInventoryData:(NSMutableArray *)tempNewF_ULogArr{
    
    
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
    
    NSString * OtherGeneralNature = @"", *OtherEquipmentNature = @"";
    
    if (_radioBtnMaintenanceType1.selected) {
        
        maintenanceType = @"2";
        OtherEquipmentNature = _txtOtherNote2.text;
        
    }
    else if (_radioBtnMaintenanceType2.selected)
    {
        
        maintenanceType = @"1";
        OtherGeneralNature = _txtOtherNote.text;
    }
    
    
    NSDictionary *aDict = @{
                            @"SerialId":[NSString stringWithFormat:@"%@",_txtSerialId.text],
                            @"InventorySetupId":[NSString stringWithFormat:@"%@",[responceDic valueForKey:@"InventorySetupId"]],
                            @"InventoryManufactureId":[self returnSelectedId:arrManufactur selectedStr:_txtManufacture.text],
                            @"InventoryBrandId":[self returnSelectedId:arrBrand selectedStr:_txtBrand.text],
                            @"InventoryModelId":[self returnSelectedId:arrModel selectedStr:_txtMode.text],
                            @"InventoryCategoryId":[self returnSelectedId:arrCategoty selectedStr:_txtCategory.text],
                            @"InventoryTypeId":[self returnSelectedId:arrEquipmentType selectedStr:_txtType.text],
                            @"EquipmentId":[NSString stringWithFormat:@"%@",_txtEquipmentId.text ],
                            @"EquipmentName":[NSString stringWithFormat:@"%@",_txtEquipmentName.text ],
                            @"UnitQuantity":@"1",
                            @"ItemPerUnit":@"1",
                            @"ItemPerUnitCost":@"0",
                            @"TotalQuantity":@"1"
                            };
    
    return aDict;
}
-(NSDictionary*)sendData:(NSMutableArray *)tempNewF_ULogArr{
    
    NSString* date,* time ,* estDate,*complDate,*strAssingTo,*maintenanceType,*isShowWorkOrderTypeRepair,*isShowWorkOrderTypeReplacement = @"";
    
    NSDateFormatter * dateformatter = [[NSDateFormatter alloc]init];
    [dateformatter setDateFormat:@"MM/dd/yyyy"];
    NSDate *from = [dateformatter dateFromString:_txtDateOfWorkOrder.text];
    [dateformatter setDateFormat:@"yyyy/MM/dd"];
    date = [dateformatter stringFromDate:from];
    
    [dateformatter setDateFormat:@"hh:mm a"];
    NSDate *to = [dateformatter dateFromString:_txtTimeWorkOrder.text];
    [dateformatter setDateFormat:@"yyyy/MM/dd HH:mm"];
    time = [dateformatter stringFromDate:to];
    
    if (![_txtComplitionDate.text isEqualToString:@""]) {
        [dateformatter setDateFormat:@"MM/dd/yyyy"];
        NSDate *compfrom = [dateformatter dateFromString:_txtComplitionDate.text];
        [dateformatter setDateFormat:@"yyyy/MM/dd"];
        complDate = [dateformatter stringFromDate:compfrom];
    }
    else{
        complDate = @"";
    }
    
    if (![_txtEstimatedDate.text isEqualToString:@""]) {
        [dateformatter setDateFormat:@"MM/dd/yyyy"];
        NSDate *estfrom = [dateformatter dateFromString:_txtEstimatedDate.text];
        [dateformatter setDateFormat:@"yyyy/MM/dd"];
        estDate = [dateformatter stringFromDate:estfrom];
    }
    else{
        estDate = @"";
    }
    
    
    strAssingTo = @"";
    for (int i = 0; i<selectedUserArr.count; i++) {
        if ([strAssingTo isEqualToString:@""]) {
            strAssingTo = [NSString stringWithFormat:@"%@",[selectedUserArr objectAtIndex:i]];
        }else{
            strAssingTo = [NSString stringWithFormat:@"%@,%@",strAssingTo,[selectedUserArr objectAtIndex:i]];
        }
    }
    NSString * OtherGeneralNature = @"", *OtherEquipmentNature = @"";
   
    if (_radioBtnMaintenanceType1.selected) {
        
        maintenanceType = @"2";
         OtherEquipmentNature = _txtOtherNote2.text;
    }
    else if (_radioBtnMaintenanceType2.selected)
    {
        
        maintenanceType = @"1";
        OtherGeneralNature = _txtOtherNote.text;

    }
    
    if ([[responceDic valueForKey:@"IsShowWorkOrderTypeRepair"] boolValue]) {
        isShowWorkOrderTypeRepair =@"true";
    }
    else{
        isShowWorkOrderTypeRepair =@"false";
    }
    if ([[responceDic valueForKey:@"IsShowWorkOrderTypeReplacement"] boolValue]) {
        isShowWorkOrderTypeReplacement =@"true";
    }
    else{
        isShowWorkOrderTypeReplacement =@"false";
    }
    
    
    
    NSString * strQ1,* strQ2,* strQ3,* strQ4,* bQ1, *bQ2,*bQ3, *bQ4 = @"";
    
    if (_radioBtnF_Up_Q1_Y.selected) {
        strQ1 = @"Yes";
        bQ1 = @"true";
    }else if (_radioBtnF_Up_Q1_N.selected) {
        strQ1 = @"No";
        bQ1 = @"false";
    }
    else {
        strQ1 = @"NA";
        bQ1 = @"";
    }
    
    if (_radioBtnF_Up_Q2_Y.selected) {
        strQ2 = @"Yes";
        bQ2 = @"true";
    }else if (_radioBtnF_Up_Q2_N.selected) {
        strQ2 = @"No";
        bQ2 = @"false";
    }
    else  {
        strQ2 = @"NA";
        bQ2 = @"";
    }
    
    if (_radioBtnF_Up_Q3_Y.selected) {
        strQ3 = @"Yes";
        bQ3 = @"true";
    }else if (_radioBtnF_Up_Q3_N.selected) {
        strQ3 = @"No";
        bQ3 = @"false";
    }
    else  {
        strQ3 = @"NA";
        bQ3 = @"";
    }
    
    if (_radioBtnF_Up_Q4_Y.selected) {
        strQ4 = @"Yes";
        bQ4 = @"true";
    }else if (_radioBtnF_Up_Q4_N.selected) {
        strQ4 = @"No";
        bQ4 = @"false";
    }
    else{
        strQ4 = @"NA";
        bQ4 = @"";
    }
    
    if (!showFollowUpQ1) {
        strQ1 = @"NA";
        bQ1 = @"";
        
    }
    if (!showFollowUpQ2) {
        strQ2 = @"NA";
        bQ2 = @"";
        
    }
    
    if (!showFollowUpQ3) {
        strQ3 = @"NA";
        bQ3 = @"";
        
    }
    
    if (!showFollowUpQ4) {
        strQ4 = @"NA";
        bQ4 = @"";
    }
    
    
    [dateformatter setDateFormat:@"MM/dd/yyyy hh:mm:ss a"];
    NSString * displayDate = [dateformatter stringFromDate:[NSDate date]];
    
    [dateformatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
    NSString * updatedOn = [dateformatter stringFromDate:[NSDate date]];
    
    NSString * existingImageName = @"",* existingVideoName = @"";
    if (arrImage.count > 0) {
        
 
    for (int i=0; i<arrImage.count; i++) {
        if (![[[arrImage valueForKey:@"Key"] objectAtIndex:i] isEqualToString:@"image"]) {
            if ([arrViewImgVideo containsObject:[[arrImage valueForKey:@"Key"] objectAtIndex:i]]) {
                
            }
            else{
        if ([existingImageName isEqualToString:@""]) {
            existingImageName = [NSString stringWithFormat:@"%@",[[arrImage valueForKey:@"Key"] objectAtIndex:i]];
        }
        else{
            existingImageName = [NSString stringWithFormat:@"%@,%@",existingImageName,[[arrImage valueForKey:@"Key"] objectAtIndex:i]];

        }
            }
             }
    }
    }
    else if (arrVideo.count > 0){
       
        for (int i=0; i<arrVideo.count; i++) {
             if (![[[arrVideo valueForKey:@"Key"] objectAtIndex:i] isEqualToString:@"video"]) {
                 if ([arrViewImgVideo containsObject:[[arrVideo valueForKey:@"Key"] objectAtIndex:i]]) {
                     
                 }
                 else{
                existingVideoName = [NSString stringWithFormat:@"%@",[[arrVideo valueForKey:@"Key"] objectAtIndex:i]];
                 }
                 }
        }
    }
    
//    if (tempNewF_ULogArr.count != 0 && ![tempNewF_ULogArr isKindOfClass:[NSNull class]] ) {
         if (_radioBtnF_Up_Q1_Y.selected || _radioBtnF_Up_Q1_N.selected || _radioBtnF_Up_Q1_NA.selected || _radioBtnF_Up_Q2_Y.selected || _radioBtnF_Up_Q2_N.selected || _radioBtnF_Up_Q2_NA.selected || _radioBtnF_Up_Q3_Y.selected || _radioBtnF_Up_Q3_N.selected || _radioBtnF_Up_Q3_NA.selected || _radioBtnF_Up_Q4_Y.selected || _radioBtnF_Up_Q4_N.selected || _radioBtnF_Up_Q4_NA.selected) {

    NSDictionary * tempNewF_UDic = @{
                                     @"Date":updatedOn,
                                     @"DisplayDate":displayDate,
                                     @"FFollowupId":@"New",
                                     @"FollowupId":@"0",
                                     @"FollowupLogs":@"",
                                    @"HistoryId":@"0",
                                     @"Id":@"0",
                                     @"IsAllowEditing":@"true",
                                     @"IsEmployeeReport":@"false",
                                     @"IsNewFollowup":@"true",
                                     @"QuestionResponse1":bQ1,
                                     @"QuestionResponse2":bQ2,
                                     @"QuestionResponse3":bQ3,
                                     @"QuestionResponse4":bQ4,
                                     @"QuestionYesNoText1":strQ1,
                                     @"QuestionYesNoText2":strQ2,
                                     @"QuestionYesNoText3":strQ3,
                                     @"QuestionYesNoText4":strQ4,
                                     @"UpdatedOn":updatedOn
                                     };
    
    
    [arrAddFollowUpQuestions addObject:tempNewF_UDic];
        }

    
    NSDictionary *aDictParams = @{
                                  @"Id":@"0",
                                  @"PreviousHistoryId":[NSString stringWithFormat:@"%@",[responceDic valueForKey:@"HistoryId"]],
                                  @"WorkOrderSetUpId":@"0",
                                  @"IsMedia":@"false",
                                  @"IsInProgress":@"false",
                                  @"IsEquipmentMaintenance":@"false",
                                  @"RepairTypeId":[self returnSelectedId:arrRepairType selectedStr:_txtSelectRepairTime.text],
                                  @"WorkOrderDate":date,
                                  @"WorkOrderTime":time,
                                  @"DateOfCompletion":complDate,
                                  @"EstimatedDateOfCompletion":estDate,
                                  @"FacilityId":selectedFacilityId,
                                  @"DescriptionOfIssue":[NSString stringWithFormat:@"%@",_txtDescriptionIssue.text],
                                  @"AdditionalInformation":[NSString stringWithFormat:@"%@",_txtAddiInfo.text],
                                  @"WorkOrderStatusId":[self returnSelectedId:arrStatus selectedStr:_txtStatus.text],
                                  @"AssignedToUserIds":strAssingTo,
                                  @"EquipmentActionId":[self returnSelectedId:arrEquipmentActionTaken selectedStr:_txtActionTaken2.text],
                                  @"GeneralActionId":[self returnSelectedId:arrGenralActionTaken selectedStr:_txtActionTaken.text],
                                  @"EquipmentNatureId":[self returnSelectedId:arrEquipmentNature selectedStr:_txtNature2.text],
                                  @"GeneralNatureId":[self returnSelectedId:arrGenralNature selectedStr:_txtNature.text],
                                  @"OtherGeneralNature":OtherGeneralNature,
                                  @"OtherEquipmentNature":OtherEquipmentNature,
                                  @"MaintenanceType":maintenanceType,
                                  @"InventorySetupId":[NSString stringWithFormat:@"%@",[responceDic valueForKey:@"InventorySetupId"]],
                                  @"SerialId":[NSString stringWithFormat:@"%@",_txtSerialId.text],
                                  @"ItemId":[NSString stringWithFormat:@"%@",_txtSerialId.text],
                                  @"ItemName":[NSString stringWithFormat:@"%@",_txtEquipmentName.text],
                                  @"InventoryLocationId":selectedLocationId,
                                  @"InventoryManufactureId":[self returnSelectedId:arrManufactur selectedStr:_txtManufacture.text],
                                  @"InventoryBrandId":[self returnSelectedId:arrBrand selectedStr:_txtBrand.text],
                                  @"InventoryModelId":[self returnSelectedId:arrModel selectedStr:_txtMode.text],
                                  @"InventoryCategoryId":[self returnSelectedId:arrCategoty selectedStr:_txtCategory.text],
                                  @"InventoryTypeId":[self returnSelectedId:arrEquipmentType selectedStr:_txtType.text],
                                  @"EmployeeEmail":[NSString stringWithFormat:@"%@",_txtEmail.text],
                                  @"EmployeeFirstName":[NSString stringWithFormat:@"%@",_txtFname.text],
                                  @"EmployeeLastName":[NSString stringWithFormat:@"%@",_txtLname.text],
                                  @"EmployeeMiddleName":[NSString stringWithFormat:@"%@",_txtMname.text],
                                  @"IsNotificationField1Selected":[self radioBtnSelected:_radioBtnServity1],
                                  @"IsNotificationField2Selected":[self radioBtnSelected:_radioBtnServity2],
                                  @"IsNotificationField3Selected":[self radioBtnSelected:_radioBtnServity3],
                                  @"IsNotificationField4Selected":[self radioBtnSelected:_radioBtnServity4],
                                  @"EquipmentQRCode":[NSString stringWithFormat:@"%@",_txtQRCode.text ],
                                  @"EquipmentBarCode":[NSString stringWithFormat:@"%@",_txtQRCode.text ],
                                  @"EquipmentId":[NSString stringWithFormat:@"%@",_txtEquipmentId.text ],
                                  @"EquipmentName":[NSString stringWithFormat:@"%@",_txtEquipmentName.text ],
                                  @"RepairCostOfParts":[NSString stringWithFormat:@"%@",_txtCostOfParts.text ],
                                  @"RepairLabourHourlyCost":[NSString stringWithFormat:@"%@",_txtHourlyRate.text ],
                                  @"RepairLabourHour":[NSString stringWithFormat:@"%@",_txtRepairLaborHour.text ],
                                  @"RepairTotalCost":[NSString stringWithFormat:@"%@",_txtRepairTotalCost.text ],
                                  @"ReplacementCost":[NSString stringWithFormat:@"%@",_txtCostOfReplacement.text ],
                                  @"IsShowWorkOrderTypeRepair":isShowWorkOrderTypeRepair,
                                  @"IsShowWorkOrderTypeReplacement":isShowWorkOrderTypeReplacement,
                                  @"IsVideoExist":[self isPgotoVideoExist:arrVideo index:0 strImageOrVideo:@"vid"],
                                  @"IsPhotoExists":[self isPgotoVideoExist:arrImage index:0 strImageOrVideo:@"img"],
                                  @"InventoryPartsUsed":arrInventoryPartUsed,
                                  @"Followups":arrAddFollowUpQuestions,
                                  @"FollowupsLogsNew":tempNewF_ULogArr,
                                  
                                  @"Photo1":[self returnBase64String:arrImage index:0 strImageOrVideo:@"img"],
                                  @"Photo2":[self returnBase64String:arrImage index:1 strImageOrVideo:@"img"],
                                  @"Photo3":[self returnBase64String:arrImage index:2 strImageOrVideo:@"img"],
                                  @"Video1":[self returnBase64String:arrVideo index:0 strImageOrVideo:@"vid"],
                                  @"ExistingImages":existingImageName,
                                  @"ExistingVideo":existingVideoName,
                                  @"PersonFirstName":[NSString stringWithFormat:@"%@",_txtFname.text],
                                  @"PersonMiddleInitial":[NSString stringWithFormat:@"%@",_txtMname.text],
                                  @"PersonLastName":[NSString stringWithFormat:@"%@",_txtLname.text],
                                  @"PersonHomePhone":@"",//[NSString stringWithFormat:@"%@",_txtDescriptionIssue.text],
                                  @"PersonAlternatePhone":@"",//[NSString stringWithFormat:@"%@",_txtDescriptionIssue.text],
                                  @"PersonEmail":[NSString stringWithFormat:@"%@",_txtEmail.text]
                                  };
    
    //nslog(@"%@",aDictParams);
    
    return aDictParams;
}

-(NSString*)isPgotoVideoExist:(NSMutableArray*)arr index:(int)index strImageOrVideo:(NSString*)strImageOrVideo{
    
    {
        
        if ([strImageOrVideo isEqualToString:@"img"]) {
            if (arrImage.count > 0) {
                return @"true";
                
            }
            else{
                return @"false";
                
            }
        }
        else{
            if (arrVideo.count > 0) {
                return @"true";
                
            }
            else{
                return @"false";
                
            }
            
        }
        
        return @"false";
    }
}
-(NSString*)returnBase64String:(NSMutableArray*)arr index:(int)index strImageOrVideo:(NSString*)strImageOrVideo{
    
    
    if ([strImageOrVideo isEqualToString:@"vid"]) {
        if (arrVideo.count > index) {
            return [[arrVideo valueForKey:@"Value"] objectAtIndex:index];
        }
        else{
            return @"";
        }
    }
    else{
        if (arrImage.count > index) {
            return [[arrImage valueForKey:@"Value"] objectAtIndex:index];
        }
        else{
            return @"";
        }
    }
    return @"";
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
-(BOOL)validation{
    
    
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
//    else if ([_txtCategory.text isEqualToString:@""]) {
//        alert(@"", @"Please select Work Order category");
//        return NO;
//    }
    else if ([_txtDescriptionIssue.text isEqualToString:@""]) {
        alert(@"", @"Please write some Work Order issue description");
        return NO;
    }
    else if ([_txtStatus.text isEqualToString:@""]) {
        alert(@"", @"Please select Work Order status");
        return NO;
    }
    //    else if (selectedUserArr.count == 0) {
    //        alert(@"", @"Please select atleast one user for assign Work Order");
    //        return NO;
    //    }
    //    else if ([_txtEstimatedDate.text isEqualToString:@""]) {
    //        alert(@"", @"Please select Work Order estimated date");
    //        return NO;
    //    }
    //    else if ([_txtComplitionDate.text isEqualToString:@""]) {
    //        alert(@"", @"Please select Work Order complition date");
    //        return NO;
    //    }else if (arrAddFollowUpLog.count >0){
    //        if (_radioBtnF_Up_Q1_Y.isSelected || _radioBtnF_Up_Q1_N.isSelected || _radioBtnF_Up_Q1_NA.isSelected || _radioBtnF_Up_Q2_Y.isSelected || _radioBtnF_Up_Q2_N.isSelected || _radioBtnF_Up_Q2_NA.isSelected || _radioBtnF_Up_Q3_Y.isSelected || _radioBtnF_Up_Q3_N.isSelected || _radioBtnF_Up_Q3_NA.isSelected || _radioBtnF_Up_Q4_Y.isSelected || _radioBtnF_Up_Q4_N.isSelected || _radioBtnF_Up_Q4_NA.isSelected) {
    //        }
    //        else{
    //            alert(@"", @"Please complete Follow-Up Questions.");
    //            return NO;
    //        }
    //    }
    //
    

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
        if (!_lblStarCategory.isHidden) {
            if ([_txtCategory.text isEqualToString:@""]) {
                alert(@"", @"Please select Work Order category");
                return NO;
            }
        }
        if (!_lblStarEqipId.isHidden) {
            if ([_txtEquipmentId.text isEqualToString:@""]) {
                alert(@"", @"Please enter equipment id");
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
                alert(@"", @"Please enter equipment name");
                return NO;
            }
        }
          if (!_lblStarManufact.isHidden) {
            if ([_txtManufacture.text isEqualToString:@""]) {
                alert(@"", @"Please enter equipment manufacture");
                return NO;
            }
        }
          if (!_lblStarEqType.isHidden) {
            if ([_txtType.text isEqualToString:@""]) {
                alert(@"", @"Please enter equipment type");
                return NO;
            }
        }
          if (!_lblStarEqMode.isHidden) {
            if ([_txtMode.text isEqualToString:@""]) {
                alert(@"", @"Please enter equipment model");
                return NO;
            }
        }
          if (!_lblStarEqBrand.isHidden) {
            if ([_txtBrand.text isEqualToString:@""]) {
                alert(@"", @"Please enter equipment brand");
                return NO;
            }
        }
          if (!_lblStarEqAction.isHidden) {
            if ([_txtActionTaken2.text isEqualToString:@""]) {
                alert(@"", @"Please enter equipment action taken");
                return NO;
            }
        }
          if (!_lblStarEqNature.isHidden) {
            if ([_txtNature2.text isEqualToString:@""]) {
                alert(@"", @"Please enter equipment nature");
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
    //nslog(@"%@",sender.titleLabel.text);
    if ([sender.titleLabel.text isEqualToString:@"Fill"]) {
        strIsBarCode = @"false";
        strBarcode = _txtEquipmentId.text;
    }
    else
    {
        strIsBarCode = @"true";
        strBarcode = sender.titleLabel.text;
    }
      if (gblAppDelegate.isNetworkReachable) {
    [[WebSerivceCall webServiceObject]callServiceForGetEquipmentDetailsWorkOrder:YES strBarcode:strBarcode strIsBarCode:strIsBarCode complition:^{
        
        NSData *dictionaryData = [[NSUserDefaults standardUserDefaults] objectForKey:@"equipmentWorkOrderRecponce"];
        equipmentResponceDic = [[NSDictionary alloc]init];
        equipmentResponceDic = [NSKeyedUnarchiver unarchiveObjectWithData:dictionaryData];
        //nslog(@"%@",equipmentResponceDic);
        
        if ([[equipmentResponceDic valueForKey:@"Success"] boolValue]) {
        
        

            _txtSerialId.text = [equipmentResponceDic valueForKey:@"SerialId"];
            _txtEquipmentName.text = [equipmentResponceDic valueForKey:@"ItemName"];
            _txtManufacture.text = [equipmentResponceDic valueForKey:@"InventoryManufactureName"];
            _txtType.text = [equipmentResponceDic valueForKey:@"InventoryTypeName"];
            _txtMode.text = [equipmentResponceDic valueForKey:@"InventoryModelName"];
            _txtBrand.text = [equipmentResponceDic valueForKey:@"InventoryBrandName"];
            _txtEquipmentId.text = [equipmentResponceDic valueForKey:@"ItemId"];
            //            _lblInventoryNotFound.hidden = YES;

            if ((![[equipmentResponceDic valueForKey:@"InventoryCategoryId"] isKindOfClass:[NSNull class]])) {
                
                _txtCategory.userInteractionEnabled = NO;
                
                for (int i = 0; i< arrCategoty.count; i++) {
                    
                    if ([[NSString stringWithFormat:@"%@",[[arrCategoty valueForKey:@"Value"]objectAtIndex:i]] isEqualToString:[NSString stringWithFormat:@"%@",[equipmentResponceDic valueForKey:@"InventoryCategoryId"]]]) {
                        _txtCategory.text = [[arrCategoty valueForKey:@"Text"]objectAtIndex:i];
                    }
                }
                
            }
            
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
              _txtCategory.text = @"";
            //  _lblInventoryNotFound.hidden = NO;
        }

        
    }];
}
else{
    [gblAppDelegate hideActivityIndicator];
    alert(@"", @"We're sorry. C2IT is not currently available offline");
}


}
- (IBAction)btnAddInventoryPartTapped:(UIButton *)sender {

    _isUpdate = YES;
    //        {
    //            cost = 1;
    //            id = 27;
    //            name = "kk_0";
    //        }
    if (![_txtInventoryTypes.text isEqualToString:@""]) {
        
        for (int i=0; i<arrInventoryPartsUsed.count; i++) {
            NSMutableDictionary * temp = [[NSMutableDictionary alloc]init];
            if ([[[arrInventoryPartsUsed valueForKey:@"Text"] objectAtIndex:i] isEqualToString:_txtInventoryTypes.text]) {
                if (![[arrInventoryPartUsed valueForKey:@"id"] containsObject:[[arrInventoryPartsUsed valueForKey:@"Value"] objectAtIndex:i]]) {
                    [temp setValue:[[arrInventoryPartsUsed valueForKey:@"Custom"] objectAtIndex:i] forKey:@"cost"];
                    [temp setValue:[[arrInventoryPartsUsed valueForKey:@"Value"] objectAtIndex:i] forKey:@"id"];
                    [temp setValue:[[arrInventoryPartsUsed valueForKey:@"Text"] objectAtIndex:i] forKey:@"name"];
                    [arrInventoryPartUsed addObject:temp];
                }
                
            }
        }
        _txtInventoryTypes.text = @"";
        CGRect frame1 =  _tblInventoryPart.frame;
        if (arrInventoryPartUsed.count > 3) {
            frame1.size.height = 170;
        }
        else{
            frame1.size.height = (arrInventoryPartUsed.count * 45) + 35;
        }
        _tblInventoryPart.frame = frame1;
        [_tblInventoryPart reloadData];
        
        int totatl = 0;
        for (int i=0; i<arrInventoryPartUsed.count; i++) {
            totatl = totatl + [[[arrInventoryPartUsed valueForKey:@"cost"] objectAtIndex:i] intValue];
        }
        _txtCostOfParts.text = [NSString stringWithFormat:@"%d",totatl];
//        if (![[responceDic valueForKey:@"ShowHourlyRate"] boolValue]) {
//            _txtRepairTotalCost.text = _txtCostOfParts.text;
//        }
         [self totalCost];
        [self viewSetUp];
    }
}
-(void)btnDeleteInventoryTapped:(UIButton*)sender{
  
    _isUpdate = YES;
    [arrInventoryPartUsed removeObjectAtIndex:sender.tag];
    CGRect frame1 =  _tblInventoryPart.frame;
    if (arrInventoryPartUsed.count > 3) {
        frame1.size.height = 170;
    }
    else{
        frame1.size.height = (arrInventoryPartUsed.count * 45) + 35;
    }
    _tblInventoryPart.frame = frame1;
    [_tblInventoryPart reloadData];
    int totatl = 0;
    for (int i=0; i<arrInventoryPartUsed.count; i++) {
        totatl = totatl + [[[arrInventoryPartUsed valueForKey:@"cost"] objectAtIndex:i] intValue];
    }
    _txtCostOfParts.text = [NSString stringWithFormat:@"%d",totatl];
//    if (![[responceDic valueForKey:@"ShowHourlyRate"] boolValue]) {
//        _txtRepairTotalCost.text = _txtCostOfParts.text;
//    }
     [self totalCost];
    [self viewSetUp];
}
- (IBAction)btnScanBarcodeTapped:(id)sender {
    if (![_isEditAllow isEqualToString:@"YES"] && [_isF_EditAllow isEqualToString:@"YES"]) {
        alert(@"", @"Please note you do not have permission to edit this field.");

        return;
    }
    if ([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo] == AVAuthorizationStatusDenied)
    {
        //access denide
        return;
    }
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
    //nslog(@"%@",metadataObjects);
    //nslog(@"%@",supportedBarcodeTypes);
    for (AVMetadataObject *barcodeMetadata in metadataObjects) {
        // ..check if it is a suported barcode
        //nslog(@"%@",barcodeMetadata);
        for (NSString *supportedBarcode in supportedBarcodeTypes) {
            //nslog(@"%@",supportedBarcode);
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
                    //nslog(capturedBarcode);
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

- (IBAction)radioBtnFollowUpQuestionsTapped:(UIButton *)sender {
    _isUpdate = YES;
    if (sender == _radioBtnF_Up_Q1_Y || sender == _radioBtnF_Up_Q1_N || sender == _radioBtnF_Up_Q1_NA) {
        if (sender == _radioBtnF_Up_Q1_Y) {
            [_radioBtnF_Up_Q1_Y setSelected:YES];
            [_radioBtnF_Up_Q1_N setSelected:NO];
            [_radioBtnF_Up_Q1_NA setSelected:NO];
        }
        else if (sender == _radioBtnF_Up_Q1_N) {
            [_radioBtnF_Up_Q1_Y setSelected:NO];
            [_radioBtnF_Up_Q1_N setSelected:YES];
            [_radioBtnF_Up_Q1_NA setSelected:NO];
        }
        else{
            [_radioBtnF_Up_Q1_Y setSelected:NO];
            [_radioBtnF_Up_Q1_N setSelected:NO];
            [_radioBtnF_Up_Q1_NA setSelected:YES];
            
        }
        
    }
    else if (sender == _radioBtnF_Up_Q2_Y || sender == _radioBtnF_Up_Q2_N || sender == _radioBtnF_Up_Q2_NA) {
        if (sender == _radioBtnF_Up_Q2_Y) {
            [_radioBtnF_Up_Q2_Y setSelected:YES];
            [_radioBtnF_Up_Q2_N setSelected:NO];
            [_radioBtnF_Up_Q2_NA setSelected:NO];
        }
        else if (sender == _radioBtnF_Up_Q2_N) {
            [_radioBtnF_Up_Q2_Y setSelected:NO];
            [_radioBtnF_Up_Q2_N setSelected:YES];
            [_radioBtnF_Up_Q2_NA setSelected:NO];
        }
        else{
            [_radioBtnF_Up_Q2_Y setSelected:NO];
            [_radioBtnF_Up_Q2_N setSelected:NO];
            [_radioBtnF_Up_Q2_NA setSelected:YES];
            
        }
        
    }
    else if (sender == _radioBtnF_Up_Q3_Y || sender == _radioBtnF_Up_Q3_N || sender == _radioBtnF_Up_Q3_NA) {
        if (sender == _radioBtnF_Up_Q3_Y) {
            [_radioBtnF_Up_Q3_Y setSelected:YES];
            [_radioBtnF_Up_Q3_N setSelected:NO];
            [_radioBtnF_Up_Q3_NA setSelected:NO];
        }
        else if (sender == _radioBtnF_Up_Q3_N) {
            [_radioBtnF_Up_Q3_Y setSelected:NO];
            [_radioBtnF_Up_Q3_N setSelected:YES];
            [_radioBtnF_Up_Q3_NA setSelected:NO];
        }
        else{
            [_radioBtnF_Up_Q3_Y setSelected:NO];
            [_radioBtnF_Up_Q3_N setSelected:NO];
            [_radioBtnF_Up_Q3_NA setSelected:YES];
            
        }
        
    }
    else if (sender == _radioBtnF_Up_Q4_Y || sender == _radioBtnF_Up_Q4_N || sender == _radioBtnF_Up_Q4_NA) {
        if (sender == _radioBtnF_Up_Q4_Y) {
            [_radioBtnF_Up_Q4_Y setSelected:YES];
            [_radioBtnF_Up_Q4_N setSelected:NO];
            [_radioBtnF_Up_Q4_NA setSelected:NO];
        }
        else if (sender == _radioBtnF_Up_Q4_N) {
            [_radioBtnF_Up_Q4_Y setSelected:NO];
            [_radioBtnF_Up_Q4_N setSelected:YES];
            [_radioBtnF_Up_Q4_NA setSelected:NO];
        }
        else{
            [_radioBtnF_Up_Q4_Y setSelected:NO];
            [_radioBtnF_Up_Q4_N setSelected:NO];
            [_radioBtnF_Up_Q4_NA setSelected:YES];
            
        }
        
    }
    else{
        [_radioBtnF_Up_Q1_Y setSelected:NO];
        [_radioBtnF_Up_Q1_N setSelected:NO];
        [_radioBtnF_Up_Q1_NA setSelected:NO];
        [_radioBtnF_Up_Q2_Y setSelected:NO];
        [_radioBtnF_Up_Q2_N setSelected:NO];
        [_radioBtnF_Up_Q2_NA setSelected:NO];
        [_radioBtnF_Up_Q3_Y setSelected:NO];
        [_radioBtnF_Up_Q3_N setSelected:NO];
        [_radioBtnF_Up_Q3_NA setSelected:NO];
        [_radioBtnF_Up_Q4_Y setSelected:NO];
        [_radioBtnF_Up_Q4_N setSelected:NO];
        [_radioBtnF_Up_Q4_NA setSelected:NO];
        
    }
    
    
    
    
}

- (IBAction)btnAddFollowUpEntryTapped:(UIButton *)sender {
    if (![_txtF_UPhone.text isEqualToString:@""]) {
        if (![_txtF_UPhone.text isValidPhoneNumber]) {
            alert(@"", @"Please add valied Phone number");
            return;
        }
    }
   if (![_txtF_UCell.text isEqualToString:@""]){
        if (![_txtF_UCell.text isValidPhoneNumber]) {
            alert(@"", @"Please add valied Cell number");
            return;
        }
    }
    if (![_txtF_UEmail.text isEqualToString:@""]){
        if (![gblAppDelegate validateEmail:[_txtF_UEmail text]]) {
            alert(@"", @"Please add valied email");
            return;
        }
    }
    
    _isUpdate = YES;
//    if (arrAddFollowUpQuestions.count != 0) {
//        if (_radioBtnF_Up_Q1_Y.isSelected || _radioBtnF_Up_Q1_N.isSelected || _radioBtnF_Up_Q1_NA.isSelected || _radioBtnF_Up_Q2_Y.isSelected || _radioBtnF_Up_Q2_N.isSelected || _radioBtnF_Up_Q2_NA.isSelected || _radioBtnF_Up_Q3_Y.isSelected || _radioBtnF_Up_Q3_N.isSelected || _radioBtnF_Up_Q3_NA.isSelected || _radioBtnF_Up_Q4_Y.isSelected || _radioBtnF_Up_Q4_N.isSelected || _radioBtnF_Up_Q4_NA.isSelected) {
//
//
//            if ([_txtF_UStatus.text isEqualToString: @""]) {
//                alert(@"", @"Please select follow up log status");
//            }
//            else{
//
//                NSMutableDictionary * tempDic = [[NSMutableDictionary alloc] init];
//                NSDateFormatter * dateformatter = [[NSDateFormatter alloc]init];
//                [dateformatter setDateFormat:@"MM/dd/yyyy hh:mm:ss a"];
//                NSString * date = [dateformatter stringFromDate:[NSDate date]];
//                [dateformatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
//                NSString * updatedOn = [dateformatter stringFromDate:[NSDate date]];
//                int f_uLogId = 1;
//                if (arrAddFollowUpLog.count != 0) {
//
//                    for (int i = 0; i < arrAddFollowUpLog.count; i++) {
//                        if ([[[arrAddFollowUpLog valueForKey:@"FFollowupId"] objectAtIndex:i] isEqualToString:@"New"]) {
//                            f_uLogId = f_uLogId + 1;
//                        }
//                    }
//                   }
//                [tempDic setValue:_txtF_UName.text forKey:@"Name"];
//                [tempDic setValue:_txtF_UStatus.text forKey:@"FollowupCall"];
//                [tempDic setValue:_txtF_UAddInfo.text forKey:@"Information"];
//                [tempDic setValue:_txtF_UEmail.text forKey:@"Email"];
//                [tempDic setValue:_txtF_UPhone.text forKey:@"PhoneNumber"];
//                [tempDic setValue:_txtF_UCell.text forKey:@"CellNumber"];
//                [tempDic setValue:@"New" forKey:@"FFollowupId"];
//                [tempDic setValue:date forKey:@"DisplayDate"];
//                [tempDic setValue:updatedOn forKey:@"Date"];
//                [tempDic setValue:updatedOn forKey:@"UpdatedOn"];
//                [tempDic setValue:@"0" forKey:@"FollowupId"];
//                [tempDic setValue:[NSString stringWithFormat:@"%d",f_uLogId] forKey:@"FollowupLogId"];
//                [tempDic setValue:_txtF_UAddInfo.text forKey:@"InformationShowLess"];
//                [tempDic setValue:@"1" forKey:@"IsAllowEditing"];
//                [tempDic setValue:@"0" forKey:@"WorkOrderFollowupHistoryId"];
//                //      [tempDic setValue:@"true" forKey:@"IsNewFollowup"];
//
//                _txtF_UStatus.text = @"";
//                //                _txtF_UName.text = @"";
//                //                _txtF_UEmail.text = @"";
//                //                _txtF_UPhone.text = @"";
//                //                _txtF_UCell.text = @"";
//                _txtF_UAddInfo.text = @"";
//                _lblF_UAddInfo.hidden =NO;
//
//                [arrAddFollowUpLog addObject:tempDic];
//                //   [self followUpviewSetup];
//                [_tblFollowUp reloadData];
//                      }
//
//        }else{
//
//            if ([_txtF_UStatus.text isEqualToString: @""]) {
//                alert(@"", @"Please select follow up log status");
//            }
//            else{
//
//                NSMutableDictionary * tempDic = [[NSMutableDictionary alloc] init];
//                NSDateFormatter * dateformatter = [[NSDateFormatter alloc]init];
//                [dateformatter setDateFormat:@"MM/dd/yyyy hh:mm:ss a"];
//                NSString * date = [dateformatter stringFromDate:[NSDate date]];
//                [dateformatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
//                NSString * updatedOn = [dateformatter stringFromDate:[NSDate date]];
//                int f_uLogId = 1;
//                if (arrAddFollowUpLog.count != 0) {
//
//                    for (int i = 0; i < arrAddFollowUpLog.count; i++) {
//                        if ([[[arrAddFollowUpLog valueForKey:@"FFollowupId"] objectAtIndex:i] isEqualToString:@"New"]) {
//                            f_uLogId = f_uLogId + 1;
//                        }
//                    }
//                }
//                [tempDic setValue:_txtF_UName.text forKey:@"Name"];
//                [tempDic setValue:_txtF_UStatus.text forKey:@"FollowupCall"];
//                [tempDic setValue:_txtF_UAddInfo.text forKey:@"Information"];
//                [tempDic setValue:_txtF_UEmail.text forKey:@"Email"];
//                [tempDic setValue:_txtF_UPhone.text forKey:@"PhoneNumber"];
//                [tempDic setValue:_txtF_UCell.text forKey:@"CellNumber"];
//                [tempDic setValue:@"New" forKey:@"FFollowupId"];
//                [tempDic setValue:date forKey:@"DisplayDate"];
//                [tempDic setValue:updatedOn forKey:@"Date"];
//                [tempDic setValue:updatedOn forKey:@"UpdatedOn"];
//                [tempDic setValue:[[arrAddFollowUpQuestions valueForKey:@"Id"] objectAtIndex:arrAddFollowUpQuestions.count-1] forKey:@"FollowupId"];
//                [tempDic setValue:[NSString stringWithFormat:@"%d",f_uLogId] forKey:@"FollowupLogId"];
//                [tempDic setValue:_txtF_UAddInfo.text forKey:@"InformationShowLess"];
//                [tempDic setValue:@"1" forKey:@"IsAllowEditing"];
//                [tempDic setValue:@"0" forKey:@"WorkOrderFollowupHistoryId"];
//                //      [tempDic setValue:@"true" forKey:@"IsNewFollowup"];
//
//                _txtF_UStatus.text = @"";
//                //                _txtF_UName.text = @"";
//                //                _txtF_UEmail.text = @"";
//                //                _txtF_UPhone.text = @"";
//                //                _txtF_UCell.text = @"";
//                _txtF_UAddInfo.text = @"";
//                _lblF_UAddInfo.hidden =NO;
//
//                [arrAddFollowUpLog addObject:tempDic];
//                //   [self followUpviewSetup];
//                [_tblFollowUp reloadData];
//            }
//        }
//
//    }
//    else {
  //      if (_radioBtnF_Up_Q1_Y.isSelected || _radioBtnF_Up_Q1_N.isSelected || _radioBtnF_Up_Q1_NA.isSelected || _radioBtnF_Up_Q2_Y.isSelected || _radioBtnF_Up_Q2_N.isSelected || _radioBtnF_Up_Q2_NA.isSelected || _radioBtnF_Up_Q3_Y.isSelected || _radioBtnF_Up_Q3_N.isSelected || _radioBtnF_Up_Q3_NA.isSelected || _radioBtnF_Up_Q4_Y.isSelected || _radioBtnF_Up_Q4_N.isSelected || _radioBtnF_Up_Q4_NA.isSelected) {
            
            
            if ([_txtF_UStatus.text isEqualToString: @""]) {
                alert(@"", @"Please select follow up log status");
                return;
            }
            else{
                
                NSMutableDictionary * tempDic = [[NSMutableDictionary alloc] init];
                NSDateFormatter * dateformatter = [[NSDateFormatter alloc]init];
                [dateformatter setDateFormat:@"MM/dd/yyyy hh:mm:ss a"];
                NSString * date = [dateformatter stringFromDate:[NSDate date]];
                [dateformatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
                NSString * updatedOn = [dateformatter stringFromDate:[NSDate date]];
                int f_uLogId = 1;
                if (arrAddFollowUpLog.count != 0) {
                    
                    for (int i = 0; i < arrAddFollowUpLog.count; i++) {
                        if ([[[arrAddFollowUpLog valueForKey:@"FFollowupId"] objectAtIndex:i] isEqualToString:@"New"]) {
                            f_uLogId = f_uLogId + 1;
                        }
                    }
                }
                [tempDic setValue:_txtF_UName.text forKey:@"Name"];
                [tempDic setValue:_txtF_UStatus.text forKey:@"FollowupCall"];
                [tempDic setValue:_txtF_UAddInfo.text forKey:@"Information"];
                [tempDic setValue:_txtF_UEmail.text forKey:@"Email"];
                [tempDic setValue:_txtF_UPhone.text forKey:@"PhoneNumber"];
                [tempDic setValue:_txtF_UCell.text forKey:@"CellNumber"];
                [tempDic setValue:@"New" forKey:@"FFollowupId"];
                [tempDic setValue:date forKey:@"DisplayDate"];
                [tempDic setValue:updatedOn forKey:@"Date"];
                [tempDic setValue:updatedOn forKey:@"UpdatedOn"];
                [tempDic setValue:@"0" forKey:@"FollowupId"];
                [tempDic setValue:[NSString stringWithFormat:@"%d",f_uLogId] forKey:@"FollowupLogId"];
                [tempDic setValue:_txtF_UAddInfo.text forKey:@"InformationShowLess"];
                [tempDic setValue:@"1" forKey:@"IsAllowEditing"];
                [tempDic setValue:@"0" forKey:@"WorkOrderFollowupHistoryId"];
                //      [tempDic setValue:@"true" forKey:@"IsNewFollowup"];
                
                _txtF_UStatus.text = @"";
                //                _txtF_UName.text = @"";
                //                _txtF_UEmail.text = @"";
                //                _txtF_UPhone.text = @"";
                //                _txtF_UCell.text = @"";
                _txtF_UAddInfo.text = @"";
                _lblF_UAddInfo.hidden =NO;
                
                [arrAddFollowUpLog addObject:tempDic];
                //   [self followUpviewSetup];
                [_tblFollowUp reloadData];
            }
            
//        }else{
//               alert(@"", @"Please select follow-up questions");
//        }
        
  //  }
//    WorkOrderFollowUpLog =     {
//        CellNumber = "(911) 234-9849";
//        Date = "<null>";
//        DisplayDate = "<null>";
//        Email = "epdev2be@gmail.com";
//        FFollowupId = "<null>";
//        FollowupCall = "<null>";
//        FollowupId = 0;
//        FollowupLogId = 0;
//        Information = "<null>";
//        InformationShowLess = "<null>";
//        IsAllowEditing = 0;
//        Name = "Sanyukta Thakur";
//        PhoneNumber = "(911) 234-9849";
//        UpdatedOn = "<null>";
//        WorkOrderFollowupHistoryId = 0;
//    };
    if (![[responceDic valueForKey:@"WorkOrderFollowUpLog"] isKindOfClass:[NSNull class]]){
        
        if (![[[responceDic valueForKey:@"WorkOrderFollowUpLog"] valueForKey:@"Name"]isKindOfClass:[NSNull class]]){
            _txtF_UName.text = [[responceDic valueForKey:@"WorkOrderFollowUpLog"] valueForKey:@"Name"];
            
        }
        if (![[[responceDic valueForKey:@"WorkOrderFollowUpLog"] valueForKey:@"Email"]isKindOfClass:[NSNull class]]){
            _txtF_UEmail.text = [[responceDic valueForKey:@"WorkOrderFollowUpLog"] valueForKey:@"Email"];            }
        if (![[[responceDic valueForKey:@"WorkOrderFollowUpLog"] valueForKey:@"CellNumber"]isKindOfClass:[NSNull class]]){
            _txtF_UCell.text = [[responceDic valueForKey:@"WorkOrderFollowUpLog"] valueForKey:@"CellNumber"];
        }
        if (![[[responceDic valueForKey:@"WorkOrderFollowUpLog"] valueForKey:@"PhoneNumber"]isKindOfClass:[NSNull class]]){
            _txtF_UPhone.text = [[responceDic valueForKey:@"WorkOrderFollowUpLog"] valueForKey:@"PhoneNumber"];
        }
        _txtF_UStatus.text = @"";
        _txtF_UAddInfo.text = @"";
        _lblF_UAddInfo.hidden = NO;
 }
}
-(void)btnF_UQDeleteTapped:(UIButton*)sender{
      if (![_isOnlyView isEqualToString:@"YES"]) {
    _isUpdate = YES;
    [self deleteF_U:NO f_uId:[[arrAddFollowUpQuestions valueForKey:@"Id"] objectAtIndex:sender.tag] index:sender.tag];
      }
}
-(void)btnF_UQEditTapped:(UIButton*)sender{
      if (![_isOnlyView isEqualToString:@"YES"]) {
    _isUpdate = YES;
    _btnF_UQSave.hidden = NO;
    _btnF_UQCancel.hidden = NO;
    _btnClearFollow_UpQuestions.hidden = YES;
    
    NSMutableDictionary* tempDic = [arrAddFollowUpQuestions objectAtIndex:sender.tag];
    //nslog(@"%@",tempDic);
    [_radioBtnF_Up_Q1_Y setSelected:NO];
    [_radioBtnF_Up_Q1_N setSelected:NO];
    [_radioBtnF_Up_Q1_NA setSelected:NO];
    [_radioBtnF_Up_Q2_Y setSelected:NO];
    [_radioBtnF_Up_Q2_N setSelected:NO];
    [_radioBtnF_Up_Q2_NA setSelected:NO];
    [_radioBtnF_Up_Q3_Y setSelected:NO];
    [_radioBtnF_Up_Q3_N setSelected:NO];
    [_radioBtnF_Up_Q3_NA setSelected:NO];
    [_radioBtnF_Up_Q4_Y setSelected:NO];
    [_radioBtnF_Up_Q4_N setSelected:NO];
    [_radioBtnF_Up_Q4_NA setSelected:NO];
    
    if ([[tempDic valueForKey:@"QuestionYesNoText1"] isEqualToString:@"Yes"]) {
        [_radioBtnF_Up_Q1_Y setSelected:YES];
    }else if ([[tempDic valueForKey:@"QuestionYesNoText1"] isEqualToString:@"No"]) {
        [_radioBtnF_Up_Q1_N setSelected:YES];
    }else if ([[tempDic valueForKey:@"QuestionYesNoText1"] isEqualToString:@"NA"]) {
        [_radioBtnF_Up_Q1_NA setSelected:YES];
    }
    
    if ([[tempDic valueForKey:@"QuestionYesNoText2"] isEqualToString:@"Yes"]) {
        [_radioBtnF_Up_Q2_Y setSelected:YES];
    }else if ([[tempDic valueForKey:@"QuestionYesNoText2"] isEqualToString:@"No"]) {
        [_radioBtnF_Up_Q2_N setSelected:YES];
    }else if ([[tempDic valueForKey:@"QuestionYesNoText2"] isEqualToString:@"NA"]) {
        [_radioBtnF_Up_Q2_NA setSelected:YES];
    }
    
    if ([[tempDic valueForKey:@"QuestionYesNoText3"] isEqualToString:@"Yes"]) {
        [_radioBtnF_Up_Q3_Y setSelected:YES];
    }else if ([[tempDic valueForKey:@"QuestionYesNoText3"] isEqualToString:@"No"]) {
        [_radioBtnF_Up_Q3_N setSelected:YES];
    }else if ([[tempDic valueForKey:@"QuestionYesNoText3"] isEqualToString:@"NA"]) {
        [_radioBtnF_Up_Q3_NA setSelected:YES];
    }
    
    if ([[tempDic valueForKey:@"QuestionYesNoText4"] isEqualToString:@"Yes"]) {
        [_radioBtnF_Up_Q4_Y setSelected:YES];
    }else if ([[tempDic valueForKey:@"QuestionYesNoText4"] isEqualToString:@"No"]) {
        [_radioBtnF_Up_Q4_N setSelected:YES];
    }else if ([[tempDic valueForKey:@"QuestionYesNoText4"] isEqualToString:@"NA"]) {
        [_radioBtnF_Up_Q4_NA setSelected:YES];
    }
    
    strEditSaveIndex = sender.tag;
}
}
-(void)btnF_UQViewTapped:(UIButton*)sender{
    _btnF_UQSave.hidden = YES;
    _btnF_UQCancel.hidden = NO;
    _btnClearFollow_UpQuestions.hidden = YES;
    
    NSMutableDictionary* tempDic = [arrAddFollowUpQuestions objectAtIndex:sender.tag];
    //nslog(@"%@",tempDic);
    
    _radioBtnF_Up_Q1_Y.userInteractionEnabled=NO;
    _radioBtnF_Up_Q1_N.userInteractionEnabled=NO;
    _radioBtnF_Up_Q1_NA.userInteractionEnabled=NO;
    _radioBtnF_Up_Q2_Y.userInteractionEnabled=NO;
    _radioBtnF_Up_Q2_N.userInteractionEnabled=NO;
    _radioBtnF_Up_Q2_NA.userInteractionEnabled=NO;
    _radioBtnF_Up_Q3_Y.userInteractionEnabled=NO;
    _radioBtnF_Up_Q3_N.userInteractionEnabled=NO;
    _radioBtnF_Up_Q3_NA.userInteractionEnabled=NO;
    _radioBtnF_Up_Q4_Y.userInteractionEnabled=NO;
    _radioBtnF_Up_Q4_N.userInteractionEnabled=NO;
    _radioBtnF_Up_Q4_NA.userInteractionEnabled=NO;
    
    [_radioBtnF_Up_Q1_Y setSelected:NO];
    [_radioBtnF_Up_Q1_N setSelected:NO];
    [_radioBtnF_Up_Q1_NA setSelected:NO];
    [_radioBtnF_Up_Q2_Y setSelected:NO];
    [_radioBtnF_Up_Q2_N setSelected:NO];
    [_radioBtnF_Up_Q2_NA setSelected:NO];
    [_radioBtnF_Up_Q3_Y setSelected:NO];
    [_radioBtnF_Up_Q3_N setSelected:NO];
    [_radioBtnF_Up_Q3_NA setSelected:NO];
    [_radioBtnF_Up_Q4_Y setSelected:NO];
    [_radioBtnF_Up_Q4_N setSelected:NO];
    [_radioBtnF_Up_Q4_NA setSelected:NO];
    
    if ([[tempDic valueForKey:@"QuestionYesNoText1"] isEqualToString:@"Yes"]) {
        [_radioBtnF_Up_Q1_Y setSelected:YES];
    }else if ([[tempDic valueForKey:@"QuestionYesNoText1"] isEqualToString:@"No"]) {
        [_radioBtnF_Up_Q1_N setSelected:YES];
    }else if ([[tempDic valueForKey:@"QuestionYesNoText1"] isEqualToString:@"NA"]) {
        [_radioBtnF_Up_Q1_NA setSelected:YES];
    }
    
    if ([[tempDic valueForKey:@"QuestionYesNoText2"] isEqualToString:@"Yes"]) {
        [_radioBtnF_Up_Q2_Y setSelected:YES];
    }else if ([[tempDic valueForKey:@"QuestionYesNoText2"] isEqualToString:@"No"]) {
        [_radioBtnF_Up_Q2_N setSelected:YES];
    }else if ([[tempDic valueForKey:@"QuestionYesNoText2"] isEqualToString:@"NA"]) {
        [_radioBtnF_Up_Q2_NA setSelected:YES];
    }
    
    if ([[tempDic valueForKey:@"QuestionYesNoText3"] isEqualToString:@"Yes"]) {
        [_radioBtnF_Up_Q3_Y setSelected:YES];
    }else if ([[tempDic valueForKey:@"QuestionYesNoText3"] isEqualToString:@"No"]) {
        [_radioBtnF_Up_Q3_N setSelected:YES];
    }else if ([[tempDic valueForKey:@"QuestionYesNoText3"] isEqualToString:@"NA"]) {
        [_radioBtnF_Up_Q3_NA setSelected:YES];
    }
    
    if ([[tempDic valueForKey:@"QuestionYesNoText4"] isEqualToString:@"Yes"]) {
        [_radioBtnF_Up_Q4_Y setSelected:YES];
    }else if ([[tempDic valueForKey:@"QuestionYesNoText4"] isEqualToString:@"No"]) {
        [_radioBtnF_Up_Q4_N setSelected:YES];
    }else if ([[tempDic valueForKey:@"QuestionYesNoText4"] isEqualToString:@"NA"]) {
        [_radioBtnF_Up_Q4_NA setSelected:YES];
    }
    
}
-(void)btnF_UDeleteTapped:(UIButton*)sender{
    if (![_isOnlyView isEqualToString:@"YES"]) {
    _isUpdate = YES;
    [self deleteF_U:YES f_uId:[[arrAddFollowUpLog valueForKey:@"FollowupLogId"] objectAtIndex:sender.tag] index:sender.tag];
          }
}
-(void)deleteF_U:(BOOL)log f_uId:(NSString*)f_uId index:(NSInteger)index{
    _isUpdate = YES;
    UIAlertController * alertDeleteWorkOrder = [[UIAlertController alloc]init];
    alertDeleteWorkOrder=[UIAlertController alertControllerWithTitle:@"" message:@"You will not be able to recover this record once it is deleted. Are you sure you want to delete this record?"preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"YES"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action)
                                {
                                      if (gblAppDelegate.isNetworkReachable) {
                                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                                        [[WebSerivceCall webServiceObject]callServiceForDeleteFollowupWorkOrder:YES workOrderId:f_uId sequence:[responceDic valueForKey:@"Sequence"] isFollowupLog:log complition:^{
                                            
                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                
                                                UIAlertController * alertDeleteWorkOrder = [[UIAlertController alloc]init];
                                                alertDeleteWorkOrder=[UIAlertController alertControllerWithTitle:@"" message:@"Follow-up deleted successfully."preferredStyle:UIAlertControllerStyleAlert];
                                                UIAlertAction* yesButton = [UIAlertAction
                                                                            actionWithTitle:@"OK"
                                                                            style:UIAlertActionStyleDefault
                                                                            handler:^(UIAlertAction * action)
                                                                            {
                                                                                if (log) {
                                                                                    [arrAddFollowUpLog removeObjectAtIndex:index];
                                                                                    //        [self followUpviewSetup];
                                                                                    [_tblFollowUp reloadData];
                                                                                }
                                                                                else{
                                                                                    [arrAddFollowUpQuestions removeObjectAtIndex:index];
                                                                                    
//                                                                                    arrAddFollowUpLog = [[NSMutableArray alloc]init];
//                                                                                    
//                                                                                    for (int i = 0; i<arrAddFollowUpQuestions.count; i++) {
//                                                                                        
//                                                                                        NSArray * tempArr = [[NSArray alloc] init];
//                                                                                        tempArr = [[arrAddFollowUpQuestions valueForKey:@"FollowupLogs"] objectAtIndex:i];
//                                                                                        for (int j = 0; j<tempArr.count; j++) {
//                                                                                            [arrAddFollowUpLog addObject:[tempArr objectAtIndex:j]] ;
//                                                                                        }
//                                                                                    }
                                                                                    //      [self followUpviewSetup];
                                                                                    [_tblF_UQuestionREsponce reloadData];
                                                                               //     [_tblFollowUp reloadData];
                                                                                    
                                                                                }
                                                                                
                                                                                
                                                                                
                                                                            }];
                                                [alertDeleteWorkOrder addAction:yesButton];
                                                [self presentViewController:alertDeleteWorkOrder animated:YES completion:nil];
                                            });
                                        }];
                                        
                                        
                                    });
                                      }
                                      else{
                                          [gblAppDelegate hideActivityIndicator];
                                          alert(@"", @"We're sorry. C2IT is not currently available offline");
                                      }
                                    
                                    
                                }];
    UIAlertAction* noButton = [UIAlertAction
                               actionWithTitle:@"NO"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action)
                               {
                                   return;
                               }];
    
    
    
    [alertDeleteWorkOrder addAction:yesButton];
    [alertDeleteWorkOrder addAction:noButton];
    [self presentViewController:alertDeleteWorkOrder animated:YES completion:nil];
    
    
    
    
}
-(void)btnF_UEditTapped:(UIButton*)sender{
      if (![_isOnlyView isEqualToString:@"YES"]) {
    _isUpdate = YES;
    _btnF_USave.hidden = NO;
    _btnF_UCancel.hidden = NO;
    _btnAddFollowUp.hidden = YES;
          _lblF_UAddInfo.hidden = YES;
    NSMutableDictionary * tempDic = [[NSMutableDictionary alloc] init];
    tempDic = [arrAddFollowUpLog objectAtIndex:sender.tag];
    [tempDic setValue:@"YES" forKey:@"isEdit"];
    
    [arrAddFollowUpLog replaceObjectAtIndex:sender.tag withObject:tempDic];
    if (![[[arrAddFollowUpLog valueForKey:@"FollowupCall"] objectAtIndex:sender.tag] isKindOfClass:[NSNull class]]) {
        _txtF_UStatus.text = [[arrAddFollowUpLog valueForKey:@"FollowupCall"] objectAtIndex:sender.tag];
    }
    if (![[[arrAddFollowUpLog valueForKey:@"Name"] objectAtIndex:sender.tag] isKindOfClass:[NSNull class]]) {
        _txtF_UName.text = [[arrAddFollowUpLog valueForKey:@"Name"] objectAtIndex:sender.tag];
        
    }
    if (![[[arrAddFollowUpLog valueForKey:@"Email"] objectAtIndex:sender.tag] isKindOfClass:[NSNull class]]) {
        _txtF_UEmail.text = [[arrAddFollowUpLog valueForKey:@"Email"] objectAtIndex:sender.tag];
        
    }
    if (![[[arrAddFollowUpLog valueForKey:@"PhoneNumber"] objectAtIndex:sender.tag] isKindOfClass:[NSNull class]]) {
        _txtF_UPhone.text = [[arrAddFollowUpLog valueForKey:@"PhoneNumber"] objectAtIndex:sender.tag];
    }
    if (![[[arrAddFollowUpLog valueForKey:@"CellNumber"] objectAtIndex:sender.tag] isKindOfClass:[NSNull class]]) {
        _txtF_UCell.text = [[arrAddFollowUpLog valueForKey:@"CellNumber"] objectAtIndex:sender.tag];
        
    }
    if (![[[arrAddFollowUpLog valueForKey:@"Information"] objectAtIndex:sender.tag] isKindOfClass:[NSNull class]]) {
        _txtF_UAddInfo.text = [[arrAddFollowUpLog valueForKey:@"Information"] objectAtIndex:sender.tag];
        _lblF_UAddInfo.hidden =YES;
    }
    
    strEditSaveIndex = sender.tag;
}
}
-(void)btnF_UViewTapped:(UIButton*)sender{
    _btnF_USave.hidden = YES;
    _btnF_UCancel.hidden = NO;
    _btnAddFollowUp.hidden = YES;
    
    NSMutableDictionary * tempDic = [[NSMutableDictionary alloc] init];
    tempDic = [arrAddFollowUpLog objectAtIndex:sender.tag];
    [tempDic setValue:@"YES" forKey:@"isEdit"];
    
    [arrAddFollowUpLog replaceObjectAtIndex:sender.tag withObject:tempDic];
    if (![[[arrAddFollowUpLog valueForKey:@"FollowupCall"] objectAtIndex:sender.tag] isKindOfClass:[NSNull class]]) {
        _txtF_UStatus.text = [[arrAddFollowUpLog valueForKey:@"FollowupCall"] objectAtIndex:sender.tag];
    }
    if (![[[arrAddFollowUpLog valueForKey:@"Name"] objectAtIndex:sender.tag] isKindOfClass:[NSNull class]]) {
        _txtF_UName.text = [[arrAddFollowUpLog valueForKey:@"Name"] objectAtIndex:sender.tag];
        
    }
    if (![[[arrAddFollowUpLog valueForKey:@"Email"] objectAtIndex:sender.tag] isKindOfClass:[NSNull class]]) {
        _txtF_UEmail.text = [[arrAddFollowUpLog valueForKey:@"Email"] objectAtIndex:sender.tag];
        
    }
    if (![[[arrAddFollowUpLog valueForKey:@"PhoneNumber"] objectAtIndex:sender.tag] isKindOfClass:[NSNull class]]) {
        _txtF_UPhone.text = [[arrAddFollowUpLog valueForKey:@"PhoneNumber"] objectAtIndex:sender.tag];
    }
    if (![[[arrAddFollowUpLog valueForKey:@"CellNumber"] objectAtIndex:sender.tag] isKindOfClass:[NSNull class]]) {
        _txtF_UCell.text = [[arrAddFollowUpLog valueForKey:@"CellNumber"] objectAtIndex:sender.tag];
        
    }
    if (![[[arrAddFollowUpLog valueForKey:@"Information"] objectAtIndex:sender.tag] isKindOfClass:[NSNull class]]) {
        _txtF_UAddInfo.text = [[arrAddFollowUpLog valueForKey:@"Information"] objectAtIndex:sender.tag];
        _lblF_UAddInfo.hidden =YES;
    }
    
    
    _txtF_UStatus.userInteractionEnabled = NO;
    _txtF_UName.userInteractionEnabled = NO;
    _txtF_UEmail.userInteractionEnabled = NO;
    _txtF_UPhone.userInteractionEnabled = NO;
    _txtF_UCell.userInteractionEnabled = NO;
    _txtF_UAddInfo.userInteractionEnabled = NO;
    
}


- (IBAction)btnF_UQSaveTapped:(UIButton *)sender {
    _isUpdate = YES;
    
    NSString * strQ1,* strQ2,* strQ3,* strQ4,* strA1,* strA2,* strA3,* strA4;
    if (_radioBtnF_Up_Q1_Y.selected) {
        strQ1 = @"Yes";
        strA1 = @"true";
    }else if (_radioBtnF_Up_Q1_N.selected) {
        strQ1 = @"No";
        strA1 = @"false";
    }
    else if (_radioBtnF_Up_Q1_NA.selected) {
        strQ1 = @"NA";
        strA1 = @"";
    }
    
    if (_radioBtnF_Up_Q2_Y.selected) {
        strQ2 = @"Yes";
        strA2 = @"true";
    }else if (_radioBtnF_Up_Q2_N.selected) {
        strQ2 = @"No";
        strA2 = @"false";
    }
    else if (_radioBtnF_Up_Q2_NA.selected) {
        strQ2 = @"NA";
        strA2 = @"";
    }
    
    if (_radioBtnF_Up_Q3_Y.selected) {
        strQ3 = @"Yes";
        strA3 = @"true";
    }else if (_radioBtnF_Up_Q3_N.selected) {
        strQ3 = @"No";
        strA3 = @"false";
    }
    else if (_radioBtnF_Up_Q3_NA.selected) {
        strQ3 = @"NA";
        strA3 = @"";
    }
    
    if (_radioBtnF_Up_Q4_Y.selected) {
        strQ4 = @"Yes";
        strA4 = @"true";
    }else if (_radioBtnF_Up_Q4_N.selected) {
        strQ4 = @"No";
        strA4 = @"false";
    }
    else if (_radioBtnF_Up_Q4_NA.selected) {
        strQ4 = @"NA";
        strA4 = @"";
    }
    
    if (!showFollowUpQ1) {
        strQ1 = @"NA";
        strA1 = @"";
    }
    if (!showFollowUpQ2) {
        strQ2 = @"NA";
        strA2 = @"";
    }
    
    if (!showFollowUpQ3) {
        strQ3 = @"NA";
        strA3 = @"";
    }
    
    if (!showFollowUpQ4) {
        strQ4 = @"NA";
        strA4 = @"";
    }

    NSMutableDictionary* tempDic = [arrAddFollowUpQuestions objectAtIndex:strEditSaveIndex];
    //nslog(@"%@",tempDic);
    
    [tempDic setValue:strQ1 forKey:@"QuestionYesNoText1"];
    [tempDic setValue:strQ2 forKey:@"QuestionYesNoText2"];
    [tempDic setValue:strQ3 forKey:@"QuestionYesNoText3"];
    [tempDic setValue:strQ4 forKey:@"QuestionYesNoText4"];
       if (gblAppDelegate.isNetworkReachable) {
    [[WebSerivceCall webServiceObject]callServiceForSaveFollowupQWorkOrder:YES  questionResponse1:strA1 questionResponse2:strA2 questionResponse3:strA3 questionResponse4:strA4 followupId:[[arrAddFollowUpQuestions valueForKey:@"Id"] objectAtIndex:strEditSaveIndex] complition:^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            UIAlertController * alertDeleteWorkOrder = [[UIAlertController alloc]init];
            alertDeleteWorkOrder=[UIAlertController alertControllerWithTitle:@"" message:@"Follow-up updated successfully."preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* yesButton = [UIAlertAction
                                        actionWithTitle:@"OK"
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction * action)
                                        {
                                            
                                            _btnF_UQSave.hidden = YES;
                                            _btnF_UQCancel.hidden = YES;
                                            _btnClearFollow_UpQuestions.hidden = NO;
                                            
                                            NSLog(@"%@",tempDic);
                                            [arrAddFollowUpQuestions replaceObjectAtIndex:strEditSaveIndex withObject:tempDic];
                                            [_radioBtnF_Up_Q1_Y setSelected:NO];
                                            [_radioBtnF_Up_Q1_N setSelected:NO];
                                            [_radioBtnF_Up_Q1_NA setSelected:NO];
                                            [_radioBtnF_Up_Q2_Y setSelected:NO];
                                            [_radioBtnF_Up_Q2_N setSelected:NO];
                                            [_radioBtnF_Up_Q2_NA setSelected:NO];
                                            [_radioBtnF_Up_Q3_Y setSelected:NO];
                                            [_radioBtnF_Up_Q3_N setSelected:NO];
                                            [_radioBtnF_Up_Q3_NA setSelected:NO];
                                            [_radioBtnF_Up_Q4_Y setSelected:NO];
                                            [_radioBtnF_Up_Q4_N setSelected:NO];
                                            [_radioBtnF_Up_Q4_NA setSelected:NO];
                                            
                                            [_tblF_UQuestionREsponce reloadData];
                                            
                                            
                                            
                                        }];
            [alertDeleteWorkOrder addAction:yesButton];
            [self presentViewController:alertDeleteWorkOrder animated:YES completion:nil];
        });
    }];
    
}
else{
    [gblAppDelegate hideActivityIndicator];
    alert(@"", @"We're sorry. C2IT is not currently available offline");
}

}

- (IBAction)btnF_UQCancelTapped:(UIButton *)sender {
    _btnF_UQSave.hidden = YES;
    _btnF_UQCancel.hidden = YES;
    _btnClearFollow_UpQuestions.hidden = NO;
    
    _radioBtnF_Up_Q1_Y.userInteractionEnabled=YES;
    _radioBtnF_Up_Q1_N.userInteractionEnabled=YES;
    _radioBtnF_Up_Q1_NA.userInteractionEnabled=YES;
    _radioBtnF_Up_Q2_Y.userInteractionEnabled=YES;
    _radioBtnF_Up_Q2_N.userInteractionEnabled=YES;
    _radioBtnF_Up_Q2_NA.userInteractionEnabled=YES;
    _radioBtnF_Up_Q3_Y.userInteractionEnabled=YES;
    _radioBtnF_Up_Q3_N.userInteractionEnabled=YES;
    _radioBtnF_Up_Q3_NA.userInteractionEnabled=YES;
    _radioBtnF_Up_Q4_Y.userInteractionEnabled=YES;
    _radioBtnF_Up_Q4_N.userInteractionEnabled=YES;
    _radioBtnF_Up_Q4_NA.userInteractionEnabled=YES;
    
    [_radioBtnF_Up_Q1_Y setSelected:NO];
    [_radioBtnF_Up_Q1_N setSelected:NO];
    [_radioBtnF_Up_Q1_NA setSelected:NO];
    [_radioBtnF_Up_Q2_Y setSelected:NO];
    [_radioBtnF_Up_Q2_N setSelected:NO];
    [_radioBtnF_Up_Q2_NA setSelected:NO];
    [_radioBtnF_Up_Q3_Y setSelected:NO];
    [_radioBtnF_Up_Q3_N setSelected:NO];
    [_radioBtnF_Up_Q3_NA setSelected:NO];
    [_radioBtnF_Up_Q4_Y setSelected:NO];
    [_radioBtnF_Up_Q4_N setSelected:NO];
    [_radioBtnF_Up_Q4_NA setSelected:NO];
}

- (IBAction)btnF_USaveTapped:(UIButton *)sender {
    _isUpdate = YES;
    {
           if (gblAppDelegate.isNetworkReachable) {
        [[WebSerivceCall webServiceObject]callServiceForSaveFollowupLogWorkOrder:YES strCell:_txtF_UCell.text strName:_txtF_UName.text strMail:_txtF_UEmail.text strPhn:_txtF_UPhone.text strInfo:_txtF_UAddInfo.text strCall:_txtF_UStatus.text strId:[[arrAddFollowUpLog valueForKey:@"FollowupLogId"] objectAtIndex:strEditSaveIndex]  complition:^{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                UIAlertController * alertDeleteWorkOrder = [[UIAlertController alloc]init];
                alertDeleteWorkOrder=[UIAlertController alertControllerWithTitle:@"" message:@"Follow-up Log updated successfully."preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* yesButton = [UIAlertAction
                                            actionWithTitle:@"OK"
                                            style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * action)
                                            {
                                                
                                                _btnF_USave.hidden = YES;
                                                _btnF_UCancel.hidden = YES;
                                                _btnAddFollowUp.hidden = NO;
                                                
                                                
                                                NSMutableDictionary * tempDic = [arrAddFollowUpLog objectAtIndex:strEditSaveIndex];
                                                
                                                NSDateFormatter * dateformatter = [[NSDateFormatter alloc]init];
                                                [dateformatter setDateFormat:@"MM/dd/yyyy hh:mm:ss a"];
                                                NSString * date = [dateformatter stringFromDate:[NSDate date]];
                                                [dateformatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
                                                NSString * updatedOn = [dateformatter stringFromDate:[NSDate date]];
                                                
                                                [tempDic setValue:_txtF_UName.text forKey:@"Name"];
                                                [tempDic setValue:_txtF_UStatus.text forKey:@"FollowupCall"];
                                                [tempDic setValue:_txtF_UAddInfo.text forKey:@"Information"];
                                                [tempDic setValue:_txtF_UEmail.text forKey:@"Email"];
                                                [tempDic setValue:_txtF_UPhone.text forKey:@"PhoneNumber"];
                                                [tempDic setValue:_txtF_UCell.text forKey:@"CellNumber"];
                                                [tempDic setValue:date forKey:@"DisplayDate"];
                                                [tempDic setValue:updatedOn forKey:@"Date"];
                                                [tempDic setValue:updatedOn forKey:@"UpdatedOn"];
                                                
                                                [arrAddFollowUpLog replaceObjectAtIndex:strEditSaveIndex withObject:tempDic];
                                                
                                                
                                                
//                                                for (int i =0; i<arrAddFollowUpQuestions.count; i++) {
//                                                    
//                                                    NSMutableArray * tempArr = [[arrAddFollowUpQuestions valueForKey:@"FollowupLogs"]objectAtIndex:i];
//                                                    for (int j=0; j<tempArr.count; j++) {
//                                                        if ([[NSString stringWithFormat:@"%@",[[tempArr valueForKey:@"FollowupLogId"] objectAtIndex:j]] isEqualToString:[NSString stringWithFormat:@"%@",[tempDic valueForKey:@"FollowupLogId"]]]) {
//                                                            
//                                                            [tempArr replaceObjectAtIndex:j withObject:tempDic];
//                                                            [arrAddFollowUpQuestions replaceObjectAtIndex:i withObject:tempArr];
//                                                        }
//                                                        
//                                                    }
//                                                    
//                                                }
                                                
                                                _txtF_UStatus.text = @"";
                                                _txtF_UName.text = @"";
                                                _txtF_UEmail.text = @"";
                                                _txtF_UPhone.text = @"";
                                                _txtF_UCell.text = @"";
                                                _txtF_UAddInfo.text = @"";
                                                _lblF_UAddInfo.hidden =NO;
                                                //    [self followUpviewSetup];
                                                [_tblFollowUp reloadData];
                                                
                                                
                                            }];
                [alertDeleteWorkOrder addAction:yesButton];
                [self presentViewController:alertDeleteWorkOrder animated:YES completion:nil];
            });
        }];
        
           }
           else{
               [gblAppDelegate hideActivityIndicator];
               alert(@"", @"We're sorry. C2IT is not currently available offline");
           }

    }
    
    
}

- (IBAction)btnF_UCancelTapped:(UIButton *)sender {
    
    _btnF_USave.hidden = YES;
    _btnF_UCancel.hidden = YES;
    _btnAddFollowUp.hidden = NO;
    
    _txtF_UStatus.text = @"";
    _txtF_UName.text = @"";
    _txtF_UEmail.text = @"";
    _txtF_UPhone.text = @"";
    _txtF_UCell.text = @"";
    _txtF_UAddInfo.text = @"";
    _lblF_UAddInfo.hidden =NO;
    

    
    if ([_isOnlyView isEqualToString:@"YES"]) {
        
    }
    else{
        _txtF_UStatus.userInteractionEnabled = YES;
        _txtF_UName.userInteractionEnabled = YES;
        _txtF_UEmail.userInteractionEnabled = YES;
        _txtF_UPhone.userInteractionEnabled = YES;
        _txtF_UCell.userInteractionEnabled = YES;
        _txtF_UAddInfo.userInteractionEnabled = YES;
    }
}

-(void)followUpviewSetup{
    CGRect frame  =  _lblF_UQueEntries.frame;
    if (!showFollowUpQ1 && !showFollowUpQ2 && !showFollowUpQ3 && !showFollowUpQ4) {
        frame.size.height = 0;
        _lblF_UQueEntries.hidden = YES;
    }
    _lblF_UQueEntries.frame = frame;
    
     frame  = _tblF_UQuestionREsponce.frame;
    frame.origin.y = _lblF_UQueEntries.frame.origin.y + _lblF_UQueEntries.frame.size.height + 20;
    frame.size.height = 200+50;
    if (!showFollowUpQ1 && !showFollowUpQ2 && !showFollowUpQ3 && !showFollowUpQ4) {
        frame.size.height = 0;
        frame.origin.y = _lblF_UQueEntries.frame.origin.y + _lblF_UQueEntries.frame.size.height ;
    }
    _tblF_UQuestionREsponce.frame = frame;

    
    frame = _lblF_UQuestions.frame;
    frame.origin.y = _tblF_UQuestionREsponce.frame.origin.y + _tblF_UQuestionREsponce.frame.size.height + 20;
    if (!showFollowUpQ1 && !showFollowUpQ2 && !showFollowUpQ3 && !showFollowUpQ4) {
        _lblF_UQuestions.hidden = YES;
        frame.size.height = 0;
          frame.origin.y = _tblF_UQuestionREsponce.frame.origin.y + _tblF_UQuestionREsponce.frame.size.height;
    }
    _lblF_UQuestions.frame = frame;
    
    frame = _lblF_UpQue1.frame;
    frame.origin.y = _lblF_UQuestions.frame.origin.y + _lblF_UQuestions.frame.size.height + 20;
    if (!showFollowUpQ1) {
        frame.size.height = 0;
        frame.origin.y = _lblF_UQuestions.frame.origin.y + _lblF_UQuestions.frame.size.height;

    }
    _lblF_UpQue1.frame = frame;
    
    frame = _radioBtnF_Up_Q1_Y.frame;
    frame.origin.y = _lblF_UpQue1.frame.origin.y + _lblF_UpQue1.frame.size.height + 20;
    if (!showFollowUpQ1) {
        frame.size.height = 0;
        frame.origin.y = _lblF_UpQue1.frame.origin.y + _lblF_UpQue1.frame.size.height ;

    }
    _radioBtnF_Up_Q1_Y.frame = frame;
    
    frame = _radioBtnF_Up_Q1_N.frame;
    frame.origin.y = _lblF_UpQue1.frame.origin.y + _lblF_UpQue1.frame.size.height + 20;
    if (!showFollowUpQ1) {
        frame.size.height = 0;
        frame.origin.y = _lblF_UpQue1.frame.origin.y + _lblF_UpQue1.frame.size.height ;

    }
    _radioBtnF_Up_Q1_N.frame = frame;
    
    frame = _radioBtnF_Up_Q1_NA.frame;
    frame.origin.y = _lblF_UpQue1.frame.origin.y + _lblF_UpQue1.frame.size.height + 20;
    if (!showFollowUpQ1) {
        frame.size.height = 0;
        frame.origin.y = _lblF_UpQue1.frame.origin.y + _lblF_UpQue1.frame.size.height;

    }
    _radioBtnF_Up_Q1_NA.frame = frame;
    
    frame = _lblF_UpQue2.frame;
    frame.origin.y = _radioBtnF_Up_Q1_NA.frame.origin.y + _radioBtnF_Up_Q1_NA.frame.size.height + 20;
    if (!showFollowUpQ2) {
        frame.size.height = 0;
        frame.origin.y = _radioBtnF_Up_Q1_NA.frame.origin.y + _radioBtnF_Up_Q1_NA.frame.size.height ;

    }
    _lblF_UpQue2.frame = frame;
    
    frame = _radioBtnF_Up_Q2_Y.frame;
    frame.origin.y = _lblF_UpQue2.frame.origin.y + _lblF_UpQue2.frame.size.height + 20;
    if (!showFollowUpQ2) {
        frame.size.height = 0;
        frame.origin.y = _lblF_UpQue2.frame.origin.y + _lblF_UpQue2.frame.size.height;

    }
    _radioBtnF_Up_Q2_Y.frame = frame;
    
    frame = _radioBtnF_Up_Q2_N.frame;
    frame.origin.y = _lblF_UpQue2.frame.origin.y + _lblF_UpQue2.frame.size.height + 20;
    if (!showFollowUpQ2) {
        frame.size.height = 0;
        frame.origin.y = _lblF_UpQue2.frame.origin.y + _lblF_UpQue2.frame.size.height ;

    }
    _radioBtnF_Up_Q2_N.frame = frame;
    
    frame = _radioBtnF_Up_Q2_NA.frame;
    frame.origin.y = _lblF_UpQue2.frame.origin.y + _lblF_UpQue2.frame.size.height + 20;
    if (!showFollowUpQ2) {
        frame.size.height = 0;
        frame.origin.y = _lblF_UpQue2.frame.origin.y + _lblF_UpQue2.frame.size.height ;

    }
    _radioBtnF_Up_Q2_NA.frame = frame;
    
    frame = _lblF_UpQue3.frame;
    frame.origin.y = _radioBtnF_Up_Q2_NA.frame.origin.y + _radioBtnF_Up_Q2_NA.frame.size.height + 20;
    if (!showFollowUpQ3) {
        frame.size.height = 0;
        frame.origin.y = _radioBtnF_Up_Q2_NA.frame.origin.y + _radioBtnF_Up_Q2_NA.frame.size.height;

    }
    _lblF_UpQue3.frame = frame;
    
    frame = _radioBtnF_Up_Q3_Y.frame;
    frame.origin.y = _lblF_UpQue3.frame.origin.y + _lblF_UpQue3.frame.size.height + 20;
    if (!showFollowUpQ3) {
        frame.size.height = 1;
        frame.origin.y = _lblF_UpQue3.frame.origin.y + _lblF_UpQue3.frame.size.height;

    }
    _radioBtnF_Up_Q3_Y.frame = frame;
    
    frame = _radioBtnF_Up_Q3_N.frame;
    frame.origin.y = _lblF_UpQue3.frame.origin.y + _lblF_UpQue3.frame.size.height + 20;
    if (!showFollowUpQ3) {
        frame.size.height = 0;
        frame.origin.y = _lblF_UpQue3.frame.origin.y + _lblF_UpQue3.frame.size.height;

    }
    _radioBtnF_Up_Q3_N.frame = frame;
    
    frame = _radioBtnF_Up_Q3_NA.frame;
    frame.origin.y = _lblF_UpQue3.frame.origin.y + _lblF_UpQue3.frame.size.height + 20;
    if (!showFollowUpQ3) {
        frame.size.height = 0;
        frame.origin.y = _lblF_UpQue3.frame.origin.y + _lblF_UpQue3.frame.size.height;

    }
    _radioBtnF_Up_Q3_NA.frame = frame;
    
    frame = _lblF_UpQue4.frame;
    frame.origin.y = _radioBtnF_Up_Q3_NA.frame.origin.y + _radioBtnF_Up_Q3_NA.frame.size.height + 20;
    if (!showFollowUpQ4) {
        frame.size.height = 0;
        frame.origin.y = _radioBtnF_Up_Q3_NA.frame.origin.y + _radioBtnF_Up_Q3_NA.frame.size.height;

    }
    _lblF_UpQue4.frame = frame;
    
    frame = _radioBtnF_Up_Q4_Y.frame;
    frame.origin.y = _lblF_UpQue4.frame.origin.y + _lblF_UpQue4.frame.size.height + 20;
    if (!showFollowUpQ4) {
        frame.size.height = 0;
        frame.origin.y = _lblF_UpQue4.frame.origin.y + _lblF_UpQue4.frame.size.height ;

    }
    _radioBtnF_Up_Q4_Y.frame = frame;
    
    frame = _radioBtnF_Up_Q4_N.frame;
    frame.origin.y = _lblF_UpQue4.frame.origin.y + _lblF_UpQue4.frame.size.height + 20;
    if (!showFollowUpQ4) {
        frame.size.height = 1;
        frame.origin.y = _lblF_UpQue4.frame.origin.y + _lblF_UpQue4.frame.size.height ;

    }
    _radioBtnF_Up_Q4_N.frame = frame;
    
    frame = _radioBtnF_Up_Q4_NA.frame;
    frame.origin.y = _lblF_UpQue4.frame.origin.y + _lblF_UpQue4.frame.size.height + 20;
    if (!showFollowUpQ4) {
        frame.size.height = 0;
        frame.origin.y = _lblF_UpQue4.frame.origin.y + _lblF_UpQue4.frame.size.height ;

    }
    _radioBtnF_Up_Q4_NA.frame = frame;
    
    frame = _btnClearFollow_UpQuestions.frame;
    frame.origin.y = _radioBtnF_Up_Q4_NA.frame.origin.y + _radioBtnF_Up_Q4_NA.frame.size.height + 20;
    if (!showFollowUpQ1 && !showFollowUpQ2 && !showFollowUpQ3 && !showFollowUpQ4) {
        _btnClearFollow_UpQuestions.hidden = YES;
        frame.size.height = 0;
        frame.origin.y = _radioBtnF_Up_Q4_NA.frame.origin.y + _radioBtnF_Up_Q4_NA.frame.size.height ;

    }
    _btnClearFollow_UpQuestions.frame = frame;
    
    frame = _btnF_UQSave.frame;
    frame.origin.y = _radioBtnF_Up_Q4_NA.frame.origin.y + _radioBtnF_Up_Q4_NA.frame.size.height + 20;
    _btnF_UQSave.frame = frame;
    
    frame = _btnF_UQCancel.frame;
    frame.origin.y = _radioBtnF_Up_Q4_NA.frame.origin.y + _radioBtnF_Up_Q4_NA.frame.size.height + 20;
    _btnF_UQCancel.frame = frame;
    
    frame = _lblF_ULogEntries.frame;
    frame.origin.y = _btnClearFollow_UpQuestions.frame.origin.y + _btnClearFollow_UpQuestions.frame.size.height + 20;
    _lblF_ULogEntries.frame = frame;
    
    frame  = _tblFollowUp.frame;
    frame.origin.y = _lblF_ULogEntries.frame.origin.y + _lblF_ULogEntries.frame.size.height + 20;
    frame.size.height = 166+50;
    _tblFollowUp.frame = frame;
    
    frame = _lblF_UStatus.frame;
    frame.origin.y = _tblFollowUp.frame.origin.y + _tblFollowUp.frame.size.height + 20;
    _lblF_UStatus.frame = frame;
    
    frame = _imgBgF_UStatus.frame;
    frame.origin.y = _lblF_UStatus.frame.origin.y + _lblF_UStatus.frame.size.height + 20;
    _imgBgF_UStatus.frame = frame;
    
    frame = _imgF_UStatus.frame;
    frame.origin.y = _lblF_UStatus.frame.origin.y + _lblF_UStatus.frame.size.height + 25;
    _imgF_UStatus.frame = frame;
    
    frame = _txtF_UStatus.frame;
    frame.origin.y = _lblF_UStatus.frame.origin.y + _lblF_UStatus.frame.size.height + 25;
    _txtF_UStatus.frame = frame;
    
    frame = _lblStarF_UStatus.frame;
    frame.origin.y = _imgBgF_UStatus.frame.origin.y + (_imgBgF_UStatus.frame.size.height /2) -10;
    _lblStarF_UStatus.frame = frame;
    
    frame = _imgBgF_UName.frame;
    frame.origin.y = _imgF_UStatus.frame.origin.y + _imgF_UStatus.frame.size.height + 20;
    _imgBgF_UName.frame = frame;
    
    frame = _txtF_UName.frame;
    frame.origin.y = _imgF_UStatus.frame.origin.y + _imgF_UStatus.frame.size.height + 30;
    _txtF_UName.frame = frame;
    
    frame = _imgBgF_UEmail.frame;
    frame.origin.y = _imgF_UStatus.frame.origin.y + _imgF_UStatus.frame.size.height + 20;
    _imgBgF_UEmail.frame = frame;
    
    frame = _txtF_UEmail.frame;
    frame.origin.y = _imgF_UStatus.frame.origin.y + _imgF_UStatus.frame.size.height + 30;
    _txtF_UEmail.frame = frame;
    
    frame = _imgBgF_UPhone.frame;
    frame.origin.y = _imgBgF_UEmail.frame.origin.y + _imgBgF_UEmail.frame.size.height + 20;
    _imgBgF_UPhone.frame = frame;
    
    frame = _txtF_UPhone.frame;
    frame.origin.y = _imgBgF_UEmail.frame.origin.y + _imgBgF_UEmail.frame.size.height + 30;
    _txtF_UPhone.frame = frame;
    
    frame = _imgBgF_UCell.frame;
    frame.origin.y = _imgBgF_UEmail.frame.origin.y + _imgBgF_UEmail.frame.size.height + 20;
    _imgBgF_UCell.frame = frame;
    
    frame = _txtF_UCell.frame;
    frame.origin.y = _imgBgF_UEmail.frame.origin.y + _imgBgF_UEmail.frame.size.height + 30;
    _txtF_UCell.frame = frame;
    
    frame = _imgBgF_UAddInfo.frame;
    frame.origin.y = _imgBgF_UCell.frame.origin.y + _imgBgF_UCell.frame.size.height + 20;
    _imgBgF_UAddInfo.frame = frame;
    
    frame = _lblF_UAddInfo.frame;
    frame.origin.y = _imgBgF_UCell.frame.origin.y + _imgBgF_UCell.frame.size.height + 30;
    _lblF_UAddInfo.frame = frame;
    
    frame = _txtF_UAddInfo.frame;
    frame.origin.y = _imgBgF_UCell.frame.origin.y + _imgBgF_UCell.frame.size.height + 20;
    _txtF_UAddInfo.frame = frame;
    
    frame = _btnAddFollowUp.frame;
    frame.origin.y = _imgBgF_UAddInfo.frame.origin.y + _imgBgF_UAddInfo.frame.size.height + 20;
    _btnAddFollowUp.frame = frame;
    
    frame = _btnF_USave.frame;
    frame.origin.y = _imgBgF_UAddInfo.frame.origin.y + _imgBgF_UAddInfo.frame.size.height + 20;
    _btnF_USave.frame = frame;
    
    frame = _btnF_UCancel.frame;
    frame.origin.y = _imgBgF_UAddInfo.frame.origin.y + _imgBgF_UAddInfo.frame.size.height + 20;
    _btnF_UCancel.frame = frame;
    
    frame = _viewBGFollowUp.frame;
    frame.size.height = _btnAddFollowUp.frame.origin.y + _btnAddFollowUp.frame.size.height + 20;
    _viewBGFollowUp.frame = frame;
    
    [self viewSetUp];
    
}
-(NSString*)dateFormatting:(NSString*)dateString dateFormate:(NSString*)dateFormate time:(BOOL)time{
    NSDateFormatter * dateformatter = [[NSDateFormatter alloc]init];
    [dateformatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]]; // Prevent adjustment to user's local time zone.
    [dateformatter setDateFormat:dateFormate];
    NSDate *date = [dateformatter dateFromString:dateString];
    if (time) {
        [dateformatter setDateFormat:@"hh:mm a"];
    }
    else    [dateformatter setDateFormat:@"MM/dd/yyyy"];
    
    return [NSString stringWithFormat:@"%@",[dateformatter stringFromDate:date]];
    
}
- (IBAction)btnHideImageViewTapped:(UIButton *)sender {
    _viewFullBGImageVideo.hidden = YES;
}
- (IBAction)btnDeleteImageVideo:(UIButton *)sender {
    if (![_isEditAllow isEqualToString:@"YES"] && [_isF_EditAllow isEqualToString:@"YES"]) {
        alert(@"", @"Please note you do not have permission to edit this field.");

        return;
    }
    _isUpdate = YES;
            if (_radioBtnImg.isSelected) {
                
          
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"Are you sure you want to delete this image?" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                                 {
                                     //BUTTON OK CLICK EVENT
                                     _viewFullBGImageVideo.hidden = YES;
                                     [arrImage removeObjectAtIndex:selectedImgVidIndex];
                                     [_tblVideoList reloadData];
                                 }];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:cancel];
            [alert addAction:ok];
            [self presentViewController:alert animated:YES completion:nil];
   
            }else{
                
                
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"Are you sure you want to delete this video?" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                                     {
                                         //BUTTON OK CLICK EVENT
                                         _viewFullBGImageVideo.hidden = YES;
                                         [arrVideo removeObjectAtIndex:selectedImgVidIndex];
                                         [_tblVideoList reloadData];
                                     }];
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
                [alert addAction:cancel];
                [alert addAction:ok];
                [self presentViewController:alert animated:YES completion:nil];
                
            }
            
}
- (IBAction)btnDeleteWorkOrderTapped:(UIButton *)sender {
    _isUpdate = YES;
    
    if ([[responceDic valueForKey:@"IsAllowDelete"] boolValue]) {
        
        UIAlertController * alertDeleteWorkOrder = [[UIAlertController alloc]init];
        alertDeleteWorkOrder=[UIAlertController alertControllerWithTitle:@"" message:@"You WILL NOT be able to recover this record once it is deleted. Are you sure you want to delete this record?"preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"YES"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action)
                                    {
                                         if (gblAppDelegate.isNetworkReachable) {
                                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                                            
                                            [[WebSerivceCall webServiceObject]callServiceForDeleteWorkOrder:YES workOrderId:_orderId sequence:[NSString stringWithFormat:@"%@",[responceDic valueForKey:@"Sequence"]] complition:^{
                                                
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                    
                                                    UIAlertController * alertDeleteWorkOrder = [[UIAlertController alloc]init];
                                                    alertDeleteWorkOrder=[UIAlertController alertControllerWithTitle:@"" message:@"Work order deleted successfully."preferredStyle:UIAlertControllerStyleAlert];
                                                    UIAlertAction* yesButton = [UIAlertAction
                                                                                actionWithTitle:@"OK"
                                                                                style:UIAlertActionStyleDefault
                                                                                handler:^(UIAlertAction * action)
                                                                                {
                                                                                    [self.navigationController popViewControllerAnimated:YES];
                                                                                    
                                                                                }];
                                                    [alertDeleteWorkOrder addAction:yesButton];
                                                    [self presentViewController:alertDeleteWorkOrder animated:YES completion:nil];
                                                });
                                            }];
                                            
                                            
                                        });
                                        
                                    }
                                    else{
                                        [gblAppDelegate hideActivityIndicator];
                                        alert(@"", @"We're sorry. C2IT is not currently available offline");
                                    }

                                    }];
        UIAlertAction* noButton = [UIAlertAction
                                   actionWithTitle:@"NO"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action)
                                   {
                                       return;
                                   }];
        
        
        
        [alertDeleteWorkOrder addAction:yesButton];
        [alertDeleteWorkOrder addAction:noButton];
        [self presentViewController:alertDeleteWorkOrder animated:YES completion:nil];
        
    }
    else{
        alert(@"", @"Please note, you do not have permission to delete this work order");
    }
}

- (void)didTapOutSideOfDropDown:(UITapGestureRecognizer *)tapGesture {
    if (_txtEquipmentId.isEditing) {
        [_txtEquipmentId resignFirstResponder];
    }
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isDescendantOfView:_tblPositons] || [touch.view isDescendantOfView:_tblUsers]) {
        return NO;
    }
    return YES;
}
@end
