//
//  MisconductIncidentViewController.m
//  GoBoardPro
//
//  Created by ind558 on 25/09/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import "IncidentDetailViewController.h"
#import "EmergencyPersonnelView.h"
#import "IncidentPersonalInformation.h"
#import "WitnessView.h"

@interface IncidentDetailViewController ()

@end

@implementation IncidentDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_vwEmergencyPersonnel setBackgroundColor:[UIColor clearColor]];
    [_vwAfterPersonalInfo setBackgroundColor:[UIColor clearColor]];
    mutArrIncidentPerson = [[NSMutableArray alloc] init];
    mutArrEmergencyPersonnel = [[NSMutableArray alloc] init];
    mutArrWitnessView = [[NSMutableArray alloc] init];
    [self addIncidentPersonalInformationViews];
    [self addEmergencyPersonnel];
    [self addWitnessView];
    [self addActionTakenView];
    [self btnNotificationTapped:_btnNone];
    if (_incidentType == 2) {
        _lblIncidentTitle.text = @"Customer Service Incident Report";
        [_imvIncidentIcon setImage:[UIImage imageNamed:@"customer_service.png"]];
    }
    else if (_incidentType == 3) {
        _lblIncidentTitle.text = @"Other Incident Report";
        [_imvIncidentIcon setImage:[UIImage imageNamed:@"other_incidents.png"]];
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
    for (IncidentPersonalInformation *vw in mutArrIncidentPerson) {
        [vw removeObserver:self forKeyPath:@"frame"];
    }
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([object isKindOfClass:[IncidentPersonalInformation class]]) {
        NSInteger index = [mutArrIncidentPerson indexOfObject:object];
        float previousMaxY = CGRectGetMaxY([object frame]);
        for (NSInteger i = index+1; i < [mutArrIncidentPerson count]; i++) {
            IncidentPersonalInformation *obj = mutArrIncidentPerson[i];
            CGRect frame = obj.frame;
            frame.origin.y = previousMaxY;
            obj.frame = frame;
            previousMaxY = CGRectGetMaxY(frame);
        }
        CGRect frame = _vwPersonalInfo.frame;
        frame.size.height = previousMaxY;
        _vwPersonalInfo.frame = frame;
        
        frame = _vwAfterPersonalInfo.frame;
        frame.origin.y = CGRectGetMaxY(_vwPersonalInfo.frame);
        _vwAfterPersonalInfo.frame = frame;
        
        frame = _vwEmergencyPersonnel.frame;
        frame.origin.y = CGRectGetMaxY(_vwAfterPersonalInfo.frame);
        _vwEmergencyPersonnel.frame = frame;
        frame = _vwWitnesses.frame;
        frame.origin.y = CGRectGetMaxY(_vwEmergencyPersonnel.frame);
        _vwWitnesses.frame = frame;
        frame = _vwEmployeeInfo.frame;
        frame.origin.y = CGRectGetMaxY(_vwWitnesses.frame);
        _vwEmployeeInfo.frame = frame;
        [_scrlMainView setContentSize:CGSizeMake(_scrlMainView.frame.size.width, CGRectGetMaxY(frame))];
    }
}

- (void)addIncidentPersonalInformationViews {
    IncidentPersonalInformation *personalInfoView = (IncidentPersonalInformation*)[[[NSBundle mainBundle] loadNibNamed:@"IncidentPersonalInformation" owner:self options:nil] firstObject];
    [personalInfoView setBackgroundColor:[UIColor clearColor]];
    CGRect frame = personalInfoView.frame;
    frame.origin.y = totalPersonCount * frame.size.height;
    personalInfoView.frame = frame;
    [personalInfoView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:NULL];
    [_vwPersonalInfo addSubview:personalInfoView];
    totalPersonCount ++;
    [mutArrIncidentPerson addObject:personalInfoView];
    
    frame = _vwPersonalInfo.frame;
    frame.size.height = CGRectGetMaxY(personalInfoView.frame);
    _vwPersonalInfo.frame = frame;
    
    frame = _vwAfterPersonalInfo.frame;
    frame.origin.y = CGRectGetMaxY(_vwPersonalInfo.frame);
    _vwAfterPersonalInfo.frame = frame;
    
    frame = _vwEmergencyPersonnel.frame;
    frame.origin.y = CGRectGetMaxY(_vwAfterPersonalInfo.frame);
    _vwEmergencyPersonnel.frame = frame;
    frame = _vwWitnesses.frame;
    frame.origin.y = CGRectGetMaxY(_vwEmergencyPersonnel.frame);
    _vwWitnesses.frame = frame;
    frame = _vwEmployeeInfo.frame;
    frame.origin.y = CGRectGetMaxY(_vwWitnesses.frame);
    _vwEmployeeInfo.frame = frame;
    [_scrlMainView setContentSize:CGSizeMake(_scrlMainView.frame.size.width, CGRectGetMaxY(frame))];
}

- (void)addEmergencyPersonnel {
    EmergencyPersonnelView *objEmergency = (EmergencyPersonnelView*)[[[NSBundle mainBundle] loadNibNamed:@"EmergencyPersonnelView" owner:self options:nil] firstObject];
    [objEmergency setBackgroundColor:[UIColor clearColor]];
    CGRect frame = objEmergency.frame;
    frame.origin.y = totalEmergencyPersonnelCount * frame.size.height;
    objEmergency.frame = frame;
    [_vwEmergencyPersonnel addSubview:objEmergency];
    totalEmergencyPersonnelCount ++;
    [mutArrEmergencyPersonnel addObject:objEmergency];
    frame = _btnAddEmergency.frame;
    frame.origin.y = CGRectGetMaxY(objEmergency.frame);
    _btnAddEmergency.frame = frame;
    
    frame = _vwEmergencyPersonnel.frame;
    frame.size.height = CGRectGetMaxY(_btnAddEmergency.frame);
    _vwEmergencyPersonnel.frame = frame;
    
    frame = _vwWitnesses.frame;
    frame.origin.y = CGRectGetMaxY(_vwEmergencyPersonnel.frame);
    _vwWitnesses.frame = frame;
    frame = _vwEmployeeInfo.frame;
    frame.origin.y = CGRectGetMaxY(_vwWitnesses.frame);
    _vwEmployeeInfo.frame = frame;
    [_scrlMainView setContentSize:CGSizeMake(_scrlMainView.frame.size.width, CGRectGetMaxY(frame))];
}

- (void)addWitnessView {
    WitnessView *aWitnessView = (WitnessView*)[[[NSBundle mainBundle] loadNibNamed:@"WitnessView" owner:self options:nil] firstObject];
    [aWitnessView setBackgroundColor:[UIColor clearColor]];
    CGRect frame = aWitnessView.frame;
    frame.origin.y = totalWitnessCount * frame.size.height;
    aWitnessView.frame = frame;
    [_vwWitnesses addSubview:aWitnessView];
    [mutArrWitnessView addObject:aWitnessView];
    totalWitnessCount ++;
    frame = _vwWitnesses.frame;
    frame.size.height = CGRectGetMaxY(aWitnessView.frame);
    _vwWitnesses.frame = frame;
    frame = _vwEmployeeInfo.frame;
    frame.origin.y = CGRectGetMaxY(_vwWitnesses.frame);
    _vwEmployeeInfo.frame = frame;
    [_scrlMainView setContentSize:CGSizeMake(_scrlMainView.frame.size.width, CGRectGetMaxY(frame))];
}

- (void)addActionTakenView {
    if (_incidentType == 1 || _incidentType == 3) {
        actionTaken = (IncidentActionTaken*)[[[NSBundle mainBundle] loadNibNamed:@"IncidentActionTaken" owner:self options:nil]firstObject];
        if (_incidentType == 3) {
            [actionTaken setShouldHideTextField:YES];
        }
        CGRect frame = actionTaken.frame;
        frame.origin.y = _vwSubmit.frame.origin.y;
        actionTaken.frame = frame;
        [_vwEmployeeInfo addSubview:actionTaken];
        frame = _vwSubmit.frame;
        frame.origin.y = CGRectGetMaxY(actionTaken.frame);
        _vwSubmit.frame = frame;
        
        frame = _vwEmployeeInfo.frame;
        frame.size.height = CGRectGetMaxY(_vwSubmit.frame);
        _vwEmployeeInfo.frame = frame;
        [_scrlMainView setContentSize:CGSizeMake(_scrlMainView.frame.size.width, CGRectGetMaxY(frame))];
    }
}

- (IBAction)btnAddEmergencyPersonnelTapped:(id)sender {
    [self addEmergencyPersonnel];
}

- (IBAction)btnAddPersonTapped:(id)sender {
    [self addIncidentPersonalInformationViews];
}

- (IBAction)btnAddWitnessTapped:(id)sender {
    [self addWitnessView];
}

- (IBAction)btnFollowUpCallTapped:(UIButton *)sender {
    [_btnYesCall setSelected:NO];
    [_btnNoCall setSelected:NO];
    [_btnCallNotReq setSelected:NO];
    [sender setSelected:YES];
}

- (IBAction)btnNotificationTapped:(UIButton *)sender {
    [_btn911Called setSelected:NO];
    [_btnPoliceCalled setSelected:NO];
    [_btnManager setSelected:NO];
    [_btnNone setSelected:NO];
    [sender setSelected:YES];
}

- (IBAction)btnSubmitTapped:(id)sender {
    if (![self checkValidation]) {
        return;
    }
}

- (IBAction)btnCapturePersonPic:(UIButton*)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Capture Image" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Photo Library", @"Camera", nil];
    CGRect rect = [_vwAfterPersonalInfo convertRect:sender.frame toView:self.view];
    [actionSheet showFromRect:rect inView:self.view animated:YES];
}


#pragma mark - Methods

- (BOOL)checkValidation {
    BOOL success = YES;
    if ([_txtDateOfIncident isTextFieldBlank]) {
        success = NO;
        alert(@"", @"Please choose date of incident");
    }
    else if ([_txtTimeOfIncident isTextFieldBlank]) {
        success = NO;
        alert(@"", @"Please choose time of incident");
    }
    else if ([_txtFacility isTextFieldBlank]) {
        success = NO;
        alert(@"", @"Please choose facility");
    }
    else if ([_txtLocation isTextFieldBlank]) {
        success = NO;
        alert(@"", @"Please choose location");
    }
    else if ([_txtActivity isTextFieldBlank]) {
        success = NO;
        alert(@"", @"Please choose activity");
    }
    else if ([_txtWeather isTextFieldBlank]) {
        success = NO;
        alert(@"", @"Please choose Wheather");
    }
    else if ([_txtEquipment isTextFieldBlank]) {
        success = NO;
        alert(@"", @"Please choose equipment");
    }
    else if (![self validateIncidentPersonal]) {
        return NO;
    }
    else if (![self validateEmergencyPersonnel]) {
        return NO;
    }
    else if (![self validateWitnessView]) {
        return NO;
    }
    
    return success;
}

- (BOOL)validateIncidentPersonal {
    for (IncidentPersonalInformation *person in mutArrIncidentPerson) {
        if (![person isPersonalInfoValidationSuccess]) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)validateEmergencyPersonnel {
    for (EmergencyPersonnelView *emergency in mutArrEmergencyPersonnel) {
        if (![emergency isEmergencyPersonnelValidationSucceed]) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)validateWitnessView {
    for (WitnessView *witness in mutArrWitnessView) {
        if (![witness isWitnessViewValidationSuccess]) {
            return NO;
        }
    }
    return YES;
}

- (void)showPhotoLibrary {
    UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
    [imgPicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [imgPicker setDelegate:self];
    [imgPicker setAllowsEditing:YES];
    popOver = [[UIPopoverController alloc] initWithContentViewController:imgPicker];
    [popOver setPopoverContentSize:CGSizeMake(320, 480)];
    [popOver setDelegate:self];
    CGRect rect = [_vwAfterPersonalInfo convertRect:_btnCapturePerson.frame toView:self.view];
    [popOver presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void)showCamera {
    UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
    [imgPicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    [imgPicker setDelegate:self];
    [imgPicker setAllowsEditing:YES];
    [gblAppDelegate.navigationController presentViewController:imgPicker animated:YES completion:^{
        
    }];
}

- (void)setKeepViewInFrame:(UIView*)vw {
    CGPoint point = [vw.superview convertPoint:vw.frame.origin toView:_scrlMainView];
    if (point.y <_scrlMainView.contentOffset.y || point.y > _scrlMainView.contentOffset.y + _scrlMainView.frame.size.height) {
        [_scrlMainView setContentOffset:CGPointMake(_scrlMainView.contentOffset.x, point.y - 50) animated:NO];
    }
}

#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    BOOL allowEditing = YES;
    if ([textField isEqual:_txtDateOfIncident]) {
        [self setKeepViewInFrame:textField];
        DatePopOverView *datePopOver = (DatePopOverView *)[[[NSBundle mainBundle] loadNibNamed:@"DatePopOverView" owner:self options:nil] firstObject];
        [datePopOver showInPopOverFor:textField limit:DATE_LIMIT_PAST_ONLY option:DATE_SELECTION_DATE_ONLY updateField:textField];
        allowEditing = NO;
    }
    else if ([textField isEqual:_txtTimeOfIncident]) {
        [self setKeepViewInFrame:textField];
        DatePopOverView *datePopOver = (DatePopOverView *)[[[NSBundle mainBundle] loadNibNamed:@"DatePopOverView" owner:self options:nil] firstObject];
        [datePopOver showInPopOverFor:textField limit:DATE_LIMIT_PAST_ONLY option:DATE_SELECTION_TIME_ONLY updateField:textField];
        allowEditing = NO;
    }
    else if ([textField isEqual:_txtFacility]) {
        [self setKeepViewInFrame:textField];
        DropDownPopOver *dropDown = (DropDownPopOver*)[[[NSBundle mainBundle] loadNibNamed:@"DropDownPopOver" owner:self options:nil] firstObject];
        dropDown.delegate = self;
        [dropDown showDropDownWith:FACILITY_VALUES view:textField key:@"title"];
        allowEditing = NO;
    }
    else if ([textField isEqual:_txtLocation]) {
        [self setKeepViewInFrame:textField];
        DropDownPopOver *dropDown = (DropDownPopOver*)[[[NSBundle mainBundle] loadNibNamed:@"DropDownPopOver" owner:self options:nil] firstObject];
        dropDown.delegate = self;
        [dropDown showDropDownWith:LOCATION_VALUES view:textField key:@"title"];
        allowEditing = NO;
    }
    else if ([textField isEqual:_txtActivity]) {
        [self setKeepViewInFrame:textField];
        DropDownPopOver *dropDown = (DropDownPopOver*)[[[NSBundle mainBundle] loadNibNamed:@"DropDownPopOver" owner:self options:nil] firstObject];
        dropDown.delegate = self;
        [dropDown showDropDownWith:LOCATION_VALUES view:textField key:@"title"];
        allowEditing = NO;
    }
    else if ([textField isEqual:_txtWeather]) {
        [self setKeepViewInFrame:textField];
        DropDownPopOver *dropDown = (DropDownPopOver*)[[[NSBundle mainBundle] loadNibNamed:@"DropDownPopOver" owner:self options:nil] firstObject];
        dropDown.delegate = self;
        [dropDown showDropDownWith:LOCATION_VALUES view:textField key:@"title"];
        allowEditing = NO;
    }
    else if ([textField isEqual:_txtEquipment]) {
        [self setKeepViewInFrame:textField];
        DropDownPopOver *dropDown = (DropDownPopOver*)[[[NSBundle mainBundle] loadNibNamed:@"DropDownPopOver" owner:self options:nil] firstObject];
        dropDown.delegate = self;
        [dropDown showDropDownWith:LOCATION_VALUES view:textField key:@"title"];
        allowEditing = NO;
    }
    return allowEditing;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    if ([string isEqualToString:@""]) {
        return YES;
    }
    if ([_txtEmpMI isEqual:textField]) {
        if ([textField.text stringByReplacingCharactersInRange:range withString:string].length > 5) {
            return NO;
        }
    }
    
    return YES;
}

#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    [_lblReportFilerPlaceHolder setHidden:YES];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([textView.text length] == 0) {
        [_lblReportFilerPlaceHolder setHidden:NO];
    }
}

//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
////    if ([text length] == 0 && textView.text.length <= 1) {
////        [_lblReportFilerPlaceHolder setHidden:NO];
////    }
////    else
//    if ([textView.text stringByReplacingCharactersInRange:range withString:text].length > 0) {
//        [_lblReportFilerPlaceHolder setHidden:YES];
//    }
//    else {
//        [_lblReportFilerPlaceHolder setHidden:NO];
//    }
//    
//    return YES;
//}

#pragma mark - DropDownValueDelegate

- (void)dropDownControllerDidSelectValue:(id)value atIndex:(NSInteger)index sender:(id)sender {
    [sender setText:[value objectForKey:@"title"]];
}

#pragma mark - UIActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        if (buttonIndex == 0) {
            [self showPhotoLibrary];
        }
        else if (buttonIndex == 1) {
            [self showCamera];
        }
    }];
}

#pragma mark - UIPopOverControllerDelegate

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    popOver = nil;
}

#pragma mark - UIImagePickerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
//    _imgBodilyFluid = [info objectForKey:UIImagePickerControllerEditedImage];
    if (popOver) {
        [popOver dismissPopoverAnimated:YES];
    }
    else {
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
        }];
    }
}

@end
