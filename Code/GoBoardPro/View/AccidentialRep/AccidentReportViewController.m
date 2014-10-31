//
//  AccidentReportViewController.m
//  GoBoardPro
//
//  Created by ind558 on 24/09/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import "AccidentReportViewController.h"
#import "AccidentFirstSection.h"

@interface AccidentReportViewController ()

@end

@implementation AccidentReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    mutArrAccidentViews = [[NSMutableArray alloc] init];
    [self btnNotificationTapped:_btnNone];
    [self addViews];
    _isUpdate = NO;
        
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


#pragma mark - Navigation



- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    _isUpdate = YES;
    if ([object isKindOfClass:[AccidentFirstSection class]]) {
        NSInteger index = [_vwFirstSection.subviews indexOfObject:object];
        CGRect frame = [object frame];
        for (NSInteger i = index + 1; i < [_vwFirstSection.subviews count]; i++) {
            UIView *view = [_vwFirstSection.subviews objectAtIndex:i];
            CGRect newFrame = view.frame;
            newFrame.origin.y = CGRectGetMaxY(frame);
            view.frame = newFrame;
            frame = newFrame;
        }
        CGRect newFrame = _vwFirstSection.frame;
        newFrame.size.height = CGRectGetMaxY(frame);
        _vwFirstSection.frame = newFrame;
        
        frame = thirdSection.frame;
        frame.origin.y = CGRectGetMaxY(_vwFirstSection.frame);
        thirdSection.frame = frame;
        
        frame = finalSection.frame;
        frame.origin.y = CGRectGetMaxY(thirdSection.frame);
        finalSection.frame = frame;
    }
    else if ([object isEqual:_vwFirstSection]) {
        CGRect frame = thirdSection.frame;
        frame.origin.y = CGRectGetMaxY(_vwFirstSection.frame);
        thirdSection.frame = frame;
        
        frame = finalSection.frame;
        frame.origin.y = CGRectGetMaxY(thirdSection.frame);
        finalSection.frame = frame;
    }
    else if ([object isEqual:thirdSection]) {
        CGRect frame = finalSection.frame;
        frame.origin.y = CGRectGetMaxY(thirdSection.frame);
        finalSection.frame = frame;
    }
    CGRect frame = finalSection.frame;
    [_scrlMainView setContentSize:CGSizeMake(_scrlMainView.frame.size.width, CGRectGetMaxY(frame))];
}

#pragma mark - IBActions & Selectors

- (IBAction)btnNotificationTapped:(UIButton *)sender {
    [_btn911Called setSelected:NO];
    [_btnPoliceCalled setSelected:NO];
    [_btnManager setSelected:NO];
    [_btnNone setSelected:NO];
    [sender setSelected:YES];
    _isUpdate = YES;
}

- (void)btnFinalSubmitTapped:(id)sender {
    if ([_txtDateOfIncident isTextFieldBlank] || [_txtTimeOfIncident isTextFieldBlank] || [_txtFacility isTextFieldBlank] || [_txtLocation isTextFieldBlank]) {
        alert(@"", @"Please completed all required fields.");
        return;
    }
//    if (![personalInfoView isPersonalInfoValidationSuccess]) {
//        return;
//    }
//    else if (![bodyPartView isBodyPartInjuredInfoValidationSuccess]) {
//        return;
//    }
    if (![self validateFirstSection]) {
        return;
    }
    else if (![thirdSection isThirdSectionValidationSuccess]) {
        return;
    }
    else if (![finalSection isFinalSectionValidationSuccess]) {
        return;
    }
}

- (BOOL)validateFirstSection {
    BOOL isSuccess = YES;
    for (AccidentFirstSection *view in _vwFirstSection.subviews) {
        if ([view isKindOfClass:[AccidentFirstSection class]]) {
            isSuccess = [view validateAccidentFirstSection];
            if (!isSuccess) {
                break;
            }
        }
    }
    return isSuccess;
}

- (IBAction)btnAddMoreBodilyFluidTapped:(id)sender {
    _isUpdate = YES;
    [self addAccidentView];
}

- (IBAction)btnBackTapped:(id)sender {
    [self.view endEditing:YES];
    if (_isUpdate) {
        [[[UIAlertView alloc] initWithTitle:@"GoBoardPro" message:@"Do you want to save your information? If you press “Back” you will lose all entered information, do you want to proceed?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil] show];
    }
    else {
        for (AccidentFirstSection *vw in _vwFirstSection.subviews) {
            if ([vw isKindOfClass:[AccidentFirstSection class]]) {
                [vw removeObserver:self forKeyPath:@"frame"];
                [vw.vwBodyPartInjury removeObserver:vw forKeyPath:@"frame"];
                [vw.vwBodyPartInjury removeObserver:vw forKeyPath:@"careProvided"];
                [vw.vwPersonalInfo removeObserver:vw forKeyPath:@"frame"];
            }
        }
        [thirdSection removeObserver:self forKeyPath:@"frame"];
        [finalSection removeObserver:self forKeyPath:@"frame"];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (IBAction)btnAttachPhotoTapped:(UIButton *)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Capture Image" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Photo Library", @"Camera", nil];
    CGRect rect = [_vwAddMoreFirstSection convertRect:sender.frame toView:_vwFirstSection];
    rect = [_vwFirstSection convertRect:rect toView:self.view];
    [actionSheet showFromRect:rect inView:self.view animated:YES];
}

#pragma mark - Methods

- (void)showPhotoLibrary {
    UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
    [imgPicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [imgPicker setDelegate:self];
    [imgPicker setAllowsEditing:YES];
    popOver = [[UIPopoverController alloc] initWithContentViewController:imgPicker];
    [popOver setPopoverContentSize:CGSizeMake(320, 480)];
    [popOver setDelegate:self];
    [popOver presentPopoverFromRect:_btnCaptureImage.frame inView:_btnCaptureImage.superview permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void)showCamera {
    UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
    [imgPicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    [imgPicker setDelegate:self];
    [imgPicker setAllowsEditing:YES];
    [gblAppDelegate.navigationController presentViewController:imgPicker animated:YES completion:^{

    }];
}

- (void)addAccidentView {
    AccidentFirstSection *accidentView = (AccidentFirstSection*)[[[NSBundle mainBundle] loadNibNamed:@"AccidentFirstSection" owner:self options:nil] firstObject];
    accidentView.parentVC = self;
    CGRect frame = accidentView.frame;
    frame.origin.y = CGRectGetMaxY([[mutArrAccidentViews lastObject] frame]);
    totalAccidentFirstSectionCount++;
    accidentView.frame = frame;
    [accidentView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:NULL];
    [_vwFirstSection addSubview:accidentView];
    [mutArrAccidentViews addObject:accidentView];
    frame = _vwFirstSection.frame;
    frame.size.height = CGRectGetMaxY(accidentView.frame) + _vwAddMoreFirstSection.frame.size.height;
    _vwFirstSection.frame = frame;
    frame = _vwAddMoreFirstSection.frame;
    frame.origin.y = CGRectGetMaxY(accidentView.frame);
    _vwAddMoreFirstSection.frame = frame;
    [_vwFirstSection bringSubviewToFront:_vwAddMoreFirstSection];
    if (thirdSection) {
        frame = thirdSection.frame;
        frame.origin.y = CGRectGetMaxY(_vwFirstSection.frame);
        thirdSection.frame = frame;
        frame = finalSection.frame;
        frame.origin.y = CGRectGetMaxY(thirdSection.frame);
        finalSection.frame = frame;
        [_scrlMainView setContentSize:CGSizeMake(_scrlMainView.frame.size.width, CGRectGetMaxY(frame))];
    }
    
}

- (void)addViews {
    [self addAccidentView];
    thirdSection = (ThirdSection*)[[[NSBundle mainBundle] loadNibNamed:@"ThirdSection" owner:self options:nil] firstObject];
    CGRect frame = thirdSection.frame;
    frame.origin.y = CGRectGetMaxY(_vwFirstSection.frame);
    thirdSection.frame = frame;
    [_scrlMainView addSubview:thirdSection];
    [thirdSection addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:NULL];
    
    
    finalSection = (FinalSection*)[[[NSBundle mainBundle] loadNibNamed:@"FinalSection" owner:self options:nil] firstObject];
    [finalSection setBackgroundColor:[UIColor clearColor]];
    frame = finalSection.frame;
    frame.origin.y = CGRectGetMaxY(thirdSection.frame);
    finalSection.frame = frame;
    [_scrlMainView addSubview:finalSection];
    [finalSection addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:NULL];
    [finalSection.btnFinalSubmit addTarget:self action:@selector(btnFinalSubmitTapped:) forControlEvents:UIControlEventTouchUpInside];
    [finalSection PersonInvolved:_personInvolved];
    [_scrlMainView setContentSize:CGSizeMake(_scrlMainView.frame.size.width, CGRectGetMaxY(frame))];
}

- (void)setPersonInvolved:(NSInteger)personInvolved {
    _personInvolved = personInvolved;
    BOOL isAtleastOneEmployee = NO;
    for (AccidentFirstSection *vw in _vwFirstSection.subviews) {
        if ([vw isKindOfClass:[AccidentFirstSection class]]) {
            isAtleastOneEmployee = [vw.vwPersonalInfo.btnEmployee isSelected];
            if (isAtleastOneEmployee) {
                break;
            }
        }
    }
    if (isAtleastOneEmployee) {
        [finalSection PersonInvolved:PERSON_EMPLOYEE];
    }
    else {
        [finalSection PersonInvolved:_personInvolved];
    }
}


//#pragma mark - UITableViewDatasource
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return 5;
//}
//
//- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *aCell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
//    return aCell;
//}
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
    imgBodilyFluid = [info objectForKey:UIImagePickerControllerEditedImage];
    if (popOver) {
        [popOver dismissPopoverAnimated:YES];
    }
    else {
        [gblAppDelegate.navigationController dismissViewControllerAnimated:YES completion:^{
        }];
    }
}


#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    _isUpdate = YES;
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
    return allowEditing;
}

- (void)setKeepViewInFrame:(UIView*)vw {
    ;
    CGPoint point = [vw.superview convertPoint:vw.frame.origin toView:_scrlMainView];
    if (point.y <_scrlMainView.contentOffset.y || point.y > _scrlMainView.contentOffset.y + _scrlMainView.frame.size.height) {
        [_scrlMainView setContentOffset:CGPointMake(_scrlMainView.contentOffset.x, point.y - 50) animated:NO];
    }
    
}

- (void)dropDownControllerDidSelectValue:(id)value atIndex:(NSInteger)index sender:(id)sender {
    [sender setText:[value objectForKey:@"title"]];
}


#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    _isUpdate = YES;
    [_lblIncidentDesc setHidden:YES];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([textView.text length] == 0) {
        [_lblIncidentDesc setHidden:NO];
    }
}


#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
