//
//  AccidentFirstSection.m
//  GoBoardPro
//
//  Created by ind558 on 29/10/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import "AccidentFirstSection.h"
#import "AccidentReportViewController.h"
#import "InjuryDetail.h"
#import "CareProvidedType.h"
#import "EmergencyPersonnelView.h"
#import "GeneralInjuryType.h"
@implementation AccidentFirstSection

- (void)awakeFromNib {
    [_vwPersonalInfo setBackgroundColor:[UIColor clearColor]];
    [_vwPersonalInfo addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:NULL];
    
    [_vwBodyPartInjury setBackgroundColor:[UIColor clearColor]];
    [_vwBodyPartInjury manageData];
    
    [_vwBodyPartInjury addObserver:self forKeyPath:@"careProvided" options:NSKeyValueObservingOptionNew context:NULL];
    [_vwBodyPartInjury addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:NULL];
    [_vwBodilyFluid setBackgroundColor:[UIColor clearColor]];
    [_vwBodilyFluid addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:NULL];
    
}

- (void)setParentVC:(AccidentReportViewController *)parentVC {
    _parentVC = parentVC;
    _vwPersonalInfo.parentVC = _parentVC;
    _vwBodyPartInjury.parentVC = _parentVC;
    _vwBodilyFluid.parentVC = _parentVC;
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context { 
    if ([keyPath isEqualToString:@"frame"]) {
        if ([object isEqual:_vwPersonalInfo]) {
            CGRect frame = _vwBodyPartInjury.frame;
            frame.origin.y = CGRectGetMaxY(_vwPersonalInfo.frame);
            _vwBodyPartInjury.frame = frame;
            
            frame = _vwBodilyFluid.frame;
            frame.origin.y = CGRectGetMaxY(_vwBodyPartInjury.frame);
            _vwBodilyFluid.frame = frame;
        }
        else if ([object isEqual:_vwBodyPartInjury]) {
            CGRect frame = _vwBodilyFluid.frame;
            frame.origin.y = CGRectGetMaxY(_vwBodyPartInjury.frame);
            _vwBodilyFluid.frame = frame;
        }
    }
    else if ([keyPath isEqualToString:@"careProvided"]) {
        CGRect frame = CGRectZero;
        float nextY = 0.0;
        
        [_vwBodilyFluid setIsRefusedCareSelected:NO];
        [_vwBodilyFluid setIsSelfCareSelected:NO];
        [_vwBodilyFluid shouldShowParticipantsSignatureView:NO];
        [_vwBodilyFluid setIsEmergencyResponseSelected:NO];
        [_vwBodilyFluid setIsEmergencyPersonnelVisible:NO];
        
        if ([[_vwBodyPartInjury.careProvided lowercaseString] isEqualToString:[[change objectForKey:@"new"] lowercaseString]]) {
            NSMutableArray *aMutArr = [NSMutableArray arrayWithArray:_parentVC.reportSetupInfo.careProviderList.allObjects];
            NSLog(@"self.name = '%@'",[change objectForKey:@"new"]);
            NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"self.name = '%@'",[change objectForKey:@"new"]]];
            NSArray *aArrOfFilterData = [aMutArr filteredArrayUsingPredicate:predicate];
            
            if (aArrOfFilterData.count > 0) {
                for (CareProvidedType *careProvider in aArrOfFilterData){
                    nextY = [self showCareProvidedDetails:careProvider];
                }
            }
        }else {
            [_vwBodilyFluid setIsFirstAidVisible:NO];
            [_vwBodilyFluid.vwRefuseCare setHidden:YES];
            [_vwBodilyFluid.vwSelfCare setHidden:YES];
            _vwBodilyFluid.isRefuseCareStatementVisible = NO;
            _vwBodilyFluid.isSelfCareStatementVisible = NO;
            nextY = CGRectGetMinY(_vwBodilyFluid.vwRefuseCare.frame);
            if (_vwBodilyFluid.isParticipantSignatureVisible && (_vwBodilyFluid.isRefusedCareSelected || _vwBodilyFluid.isSelfCareSelected)) {
                frame = _vwBodilyFluid.vwParticipantSignature.frame;
                if (_vwBodilyFluid.isSelfCareSelected) {
                    frame.origin.y = CGRectGetMaxY(_vwBodilyFluid.vwSelfCare.frame);
                }else{
                    frame.origin.y = CGRectGetMinY(_vwBodilyFluid.vwRefuseCare.frame);
                }
                _vwBodilyFluid.vwParticipantSignature.frame = frame;
                nextY = CGRectGetMaxY(_vwBodilyFluid.vwParticipantSignature.frame);
            }
        }
       
        frame = _vwBodilyFluid.vwBloodbornePathogens.frame;
        frame.origin.y = nextY;
        _vwBodilyFluid.vwBloodbornePathogens.frame = frame;
        
        frame = _vwBodilyFluid.vwStaffMember.frame;
        
        if (_parentVC.reportSetupInfo.showBloodbornePathogens.boolValue) {
            frame.origin.y = CGRectGetMaxY(_vwBodilyFluid.vwBloodbornePathogens.frame);
        }else{
            frame.origin.y = CGRectGetMinY(_vwBodilyFluid.vwBloodbornePathogens.frame);
        }
        _vwBodilyFluid.vwStaffMember.frame = frame;
        
        frame = _vwBodilyFluid.frame;
        frame.size.height = CGRectGetMaxY(_vwBodilyFluid.vwStaffMember.frame);
        _vwBodilyFluid.frame = frame;
    }
    CGRect frame = _btnCaptureImage.frame;
    frame.origin.y = CGRectGetMaxY(_vwBodilyFluid.frame);
    _btnCaptureImage.frame = frame;
    
    frame = self.frame;
    frame.size.height = CGRectGetMaxY(_btnCaptureImage.frame);
    self.frame = frame;
    
}

-(float)showCareProvidedDetails:(CareProvidedType *)careProvider
{
    
    [_vwBodilyFluid setIsFirstAidVisible:careProvider.firstAid.boolValue];
    [_vwBodilyFluid setIsRefuseCareStatementVisible: careProvider.refusedCare.boolValue];
    [_vwBodilyFluid setIsSelfCareStatementVisible:careProvider.selfCare.boolValue];
    [_vwBodilyFluid shouldShowParticipantsSignatureView:_parentVC.reportSetupInfo.showParticipantSignature.boolValue];
    [_vwBodilyFluid setIsEmergencyResponseSelected:careProvider.emergencyResponse.boolValue];
    [_vwBodilyFluid setIsEmergencyPersonnelVisible:careProvider.emergencyPersonnel.boolValue];
    
     float nextY =CGRectGetMinY(_vwBodilyFluid.vwRefuseCare.frame);
    
    if (careProvider.refusedCare.boolValue == YES) {
        
        _vwBodilyFluid.lblRefuseCareText.text = _parentVC.reportSetupInfo.refusedCareStatement;
        
        NSDictionary *stringAttributes = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:15] forKey: NSFontAttributeName];
        
        float height = [_vwBodilyFluid.lblRefuseCareText.text boundingRectWithSize:CGSizeMake(_vwBodilyFluid.lblRefuseCareText.frame.size.width, 9999) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin  attributes:stringAttributes context:nil].size.height + 20;
       
        CGRect frameLblInstruction  =_vwBodilyFluid.lblRefuseCareText.frame;
        
        frameLblInstruction.origin.y = CGRectGetMaxY(_vwBodilyFluid.lblRefuseCareCaption.frame);
        frameLblInstruction.size.height = height;
        
        _vwBodilyFluid.lblRefuseCareText.frame = frameLblInstruction;
        _vwBodilyFluid.lblRefuseCareText.numberOfLines = 0;
        [_vwBodilyFluid.lblRefuseCareText setFont:[UIFont systemFontOfSize:15]];
        [_vwBodilyFluid.lblRefuseCareText setTextAlignment:NSTextAlignmentLeft];
        
        _vwBodilyFluid.lblRefuseCareCaption.text = @"Refused Care Statement";
        _vwBodilyFluid.isRefusedCareSelected = YES;
        
        CGRect frame = _vwBodilyFluid.vwRefuseCare.frame;
        
        frame.size.height = CGRectGetMaxY(_vwBodilyFluid.lblRefuseCareText.frame);
        
        _vwBodilyFluid.vwRefuseCare.frame = frame;
        
        //nextY = CGRectGetMaxY(_vwBodilyFluid.vwRefuseCare.frame);
        
        frame = _vwBodilyFluid.vwSelfCare.frame;
        
        frame.origin.y = CGRectGetMaxY(_vwBodilyFluid.vwRefuseCare.frame);
        
        _vwBodilyFluid.vwSelfCare.frame = frame;
        
        
        frame = _vwBodilyFluid.vwParticipantSignature.frame;
        
        frame.origin.y = CGRectGetMaxY(_vwBodilyFluid.vwSelfCare.frame);
        
        _vwBodilyFluid.vwParticipantSignature.frame = frame;
        
        nextY = CGRectGetMaxY(_vwBodilyFluid.vwParticipantSignature.frame);
        
        
    }
    
    if (careProvider.selfCare.boolValue == YES) {
        
        _vwBodilyFluid.lblSelfCareText.text = _parentVC.reportSetupInfo.selfCareStatement;
        
        NSDictionary *stringAttributes = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:15] forKey: NSFontAttributeName];
        
        float height = [_vwBodilyFluid.lblSelfCareText.text boundingRectWithSize:CGSizeMake(_vwBodilyFluid.lblSelfCareText.frame.size.width, 9999) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin  attributes:stringAttributes context:nil].size.height+20;
        CGRect frameLblInstruction  =_vwBodilyFluid.lblSelfCareText.frame;
        
        frameLblInstruction.origin.y = CGRectGetMaxY(_vwBodilyFluid.lblSelfCareCaption.frame);
       
        frameLblInstruction.size.height = height;
        
        _vwBodilyFluid.lblSelfCareText.frame = frameLblInstruction;
        _vwBodilyFluid.lblSelfCareText.numberOfLines = 0;
        [_vwBodilyFluid.lblSelfCareText setFont:[UIFont systemFontOfSize:15]];
        [_vwBodilyFluid.lblSelfCareText setTextAlignment:NSTextAlignmentLeft];
        
        _vwBodilyFluid.lblSelfCareCaption.text = @"Self Care Statement";
        _vwBodilyFluid.isSelfCareSelected = YES;
        
        CGRect frame = _vwBodilyFluid.vwSelfCare.frame;
        
        frame.size.height = CGRectGetMaxY(_vwBodilyFluid.lblSelfCareText.frame);
        
        _vwBodilyFluid.vwSelfCare.frame = frame;
        
        frame = _vwBodilyFluid.vwParticipantSignature.frame;
        
        frame.origin.y = CGRectGetMaxY(_vwBodilyFluid.vwSelfCare.frame);
        
        _vwBodilyFluid.vwParticipantSignature.frame = frame;
        
        nextY = CGRectGetMaxY(_vwBodilyFluid.vwParticipantSignature.frame);
    }
    
    if (_vwBodilyFluid.isParticipantSignatureVisible && (_vwBodilyFluid.isRefusedCareSelected || _vwBodilyFluid.isSelfCareSelected)) {
        CGRect frame = _vwBodilyFluid.vwParticipantSignature.frame;
        if (_vwBodilyFluid.isSelfCareSelected) {
            frame.origin.y = CGRectGetMaxY(_vwBodilyFluid.vwSelfCare.frame);
        }else{
            frame.origin.y = CGRectGetMaxY(_vwBodilyFluid.vwRefuseCare.frame);
        }
        _vwBodilyFluid.vwParticipantSignature.frame = frame;
        nextY = CGRectGetMaxY(_vwBodilyFluid.vwParticipantSignature.frame);
    }
    
    if (careProvider.emergencyPersonnel.boolValue == YES) {
    
        CGRect frame = _vwBodilyFluid.vwEmergencyPersonnel.frame;
        
        if (_vwBodilyFluid.isParticipantSignatureVisible && (_vwBodilyFluid.isRefusedCareSelected || _vwBodilyFluid.isSelfCareSelected)) {
            frame.origin.y = CGRectGetMaxY(_vwBodilyFluid.vwParticipantSignature.frame);
        }else{
            frame.origin.y = CGRectGetMinY(_vwBodilyFluid.vwParticipantSignature.frame);
        }
        _vwBodilyFluid.vwEmergencyPersonnel.frame = frame;
        
        nextY = CGRectGetMaxY(_vwBodilyFluid.vwEmergencyPersonnel.frame);
    }
    return nextY;
}

- (BOOL)validateAccidentFirstSectionWith:(NSArray*)firstAid {
    // ||![_vwBodyPartInjury isBodyPartInjuredInfoValidationSuccess]
    if (![_vwPersonalInfo isPersonalInfoValidationSuccess] || ![_vwBodilyFluid isBodilyFluidValidationSucceedWith:firstAid]) {
        return NO;
    }
    return YES;
}

- (NSDictionary*)getAccidentPerson {
    NSMutableArray *injuryList = [NSMutableArray array];
    for (NSDictionary *aDict in _vwBodyPartInjury.mutArrInjuryList) {
        NSMutableDictionary *aMutDict = [NSMutableDictionary dictionary];
        [aMutDict setObject:[aDict objectForKey:@"nature"] forKey:@"NatureId"];
        if ([[aDict objectForKey:@"GeneralInjuryType"]isKindOfClass:[GeneralInjuryType class]]) {
            [aMutDict setObject:[[aDict objectForKey:@"GeneralInjuryType"] valueForKey:@"typeId"] forKey:@"GeneralInjuryTypeId"];
            [aMutDict setObject:[aDict objectForKey:@"generalOther"] forKey:@"GeneralInjuryOther"];
        }
        else {
            [aMutDict setObject:@"" forKey:@"GeneralInjuryTypeId"];
            [aMutDict setObject:@"" forKey:@"GeneralInjuryOther"];
        }   
        if ([aDict objectForKey:@"BodyPartInjuryType"]) {
            [aMutDict setObject:[[aDict objectForKey:@"BodyPartInjuryType"] valueForKey:@"typeId"] forKey:@"BodyPartInjuryTypeId"];
            [aMutDict setObject:[aDict objectForKey:@"BodyPartInjuredLocation"] forKey:@"BodyPartInjuredLocation"];
            
            if ([aDict objectForKey:@"part"]) {
                [aMutDict setObject:[[aDict objectForKey:@"part"] valueForKey:@"value"] forKey:@"BodyPartInjuredId"];
            }
            else {
                [aMutDict setObject:@"" forKey:@"BodyPartInjuredId"];
            }
            
        }
        else {
            [aMutDict setObject:@"" forKey:@"BodyPartInjuryTypeId"];
            [aMutDict setObject:@"" forKey:@"BodyPartInjuredId"];
            [aMutDict setObject:@"" forKey:@"BodyPartInjuredLocation"];
        }
        if ([aDict objectForKey:@"action"]) {
            [aMutDict setObject:[[aDict objectForKey:@"action"] valueForKey:@"actionId"] forKey:@"ActionTakenId"];
        }
        else {
            [aMutDict setObject:@"" forKey:@"ActionTakenId"];
        }
        
        [injuryList addObject:aMutDict];
    }
    
    NSString *strDob = @"";
    if (_vwPersonalInfo.txtDob.text.length > 0) {
        NSDateFormatter *aFormatter = [[NSDateFormatter alloc] init];
        [aFormatter setDateFormat:@"MM/dd/yyyy"];
        NSDate *aDob = [aFormatter dateFromString:_vwPersonalInfo.txtDob.text];
        //[aFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
        [aFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        strDob = [aFormatter stringFromDate:aDob];
    }
    NSString *employeeId = @"", *memberId = @"", *guestId = @"";
    if (_vwPersonalInfo.intPersonInvolved == 3) {
        employeeId = _vwPersonalInfo.txtMemberId.text;
    }
    else if(_vwPersonalInfo.intPersonInvolved == 2){
        guestId = _vwPersonalInfo.txtMemberId.text;
    }else{
        memberId = _vwPersonalInfo.txtMemberId.text;
    }

    NSString *strPhoto = @"", *strSignature = @"";
    if (_imgBodilyFluid) {
        strPhoto = [UIImageJPEGRepresentation(_imgBodilyFluid, 1.0) base64EncodedStringWithOptions:0];
    }
    if (_vwBodilyFluid.signatureView.tempDrawImage.image) {
        strSignature = [UIImageJPEGRepresentation(_vwBodilyFluid.signatureView.tempDrawImage.image, 1.0) base64EncodedStringWithOptions:0];
    }
    
    NSString *careProvidedBy = @"", *activityTypeID = @"", *conditionTypeID = @"", *equipmentTypeID = @"";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K MATCHES[cd] %@", @"name", _vwBodyPartInjury.txtCareProvided.text];
    
    NSMutableArray *ary1 = [NSMutableArray arrayWithArray:[_parentVC.reportSetupInfo.careProviderList allObjects]];

    
    NSArray *ary = [ary1 filteredArrayUsingPredicate:predicate];
    if (ary.count > 0) careProvidedBy = [[ary firstObject] valueForKey:@"careProvidedID"];
    
    predicate = [NSPredicate predicateWithFormat:@"%K MATCHES[cd] %@", @"name", _vwPersonalInfo.txtActivity.text];
    ary = [[_parentVC.reportSetupInfo.activityList allObjects] filteredArrayUsingPredicate:predicate];
    if (ary.count > 0) activityTypeID = [[ary firstObject] valueForKey:@"activityId"];
    
    predicate = [NSPredicate predicateWithFormat:@"%K MATCHES[cd] %@", @"name", _vwPersonalInfo.txtWheather.text];
    ary = [[_parentVC.reportSetupInfo.conditionList allObjects] filteredArrayUsingPredicate:predicate];
    if (ary.count > 0) conditionTypeID = [[ary firstObject] valueForKey:@"conditionId"];
    
    predicate = [NSPredicate predicateWithFormat:@"%K MATCHES[cd] %@", @"name", _vwPersonalInfo.txtEquipment.text];
    ary = [[_parentVC.reportSetupInfo.equipmentList allObjects] filteredArrayUsingPredicate:predicate];
    if (ary.count > 0) equipmentTypeID = [[ary firstObject] valueForKey:@"equipmentId"];
    
    NSString *aSignatureName =  _vwBodilyFluid.signatureView.txtName.trimText;
    if (!aSignatureName) {
        aSignatureName = @"";
    }
    NSMutableArray *mutArrEmergency = [NSMutableArray array];
   
    for (EmergencyPersonnelView *vwEmergency in  _vwBodilyFluid.thirdSection.mutArrEmergencyViews) {
        id time911Called, timeArrival, timeDeparture;
        if ([vwEmergency.txtTime911Called.text isEqualToString:@""]) {
            time911Called = [NSNull null];
        }
        else {
            time911Called = vwEmergency.txtTime911Called.text;
        }
        
        if ([vwEmergency.txtTimeOfArrival.text isEqualToString:@""]) {
            timeArrival = [NSNull null];
        }
        else {
            timeArrival = vwEmergency.txtTimeOfArrival.text;
        }
        
        if ([vwEmergency.txtTimeOfDeparture.text isEqualToString:@""]) {
            timeDeparture = [NSNull null];
        }
        else {
            timeDeparture = vwEmergency.txtTimeOfDeparture.text;
        }
        NSDictionary *aDict = @{@"FirstName":vwEmergency.txtFirstName.trimText, @"MiddleInitial":vwEmergency.txtMI.trimText, @"LastName":vwEmergency.txtLastName.trimText, @"Phone":vwEmergency.txtPhone.text, @"AdditionalInformation":vwEmergency.txvAdditionalInfo.text, @"CaseNumber":vwEmergency.txtCaseNo.trimText, @"BadgeNumber":vwEmergency.txtBadge.trimText, @"Time911Called":time911Called, @"ArrivalTime":timeArrival, @"DepartureTime":timeDeparture};
        [mutArrEmergency addObject:aDict];
    }
    
    
    NSDictionary *aDict = @{@"FirstName":_vwPersonalInfo.txtFirstName.trimText, @"MiddleInitial":_vwPersonalInfo.txtMi.trimText, @"LastName":_vwPersonalInfo.txtLastName.trimText, @"PrimaryPhone":_vwPersonalInfo.txtHomePhone.text, @"AlternatePhone":_vwPersonalInfo.txtAlternatePhone.text, @"Email":_vwPersonalInfo.txtEmailAddress.text, @"Address1":_vwPersonalInfo.txtStreetAddress.trimText, @"Address2":_vwPersonalInfo.txtAppartment.trimText, @"City":_vwPersonalInfo.txtCity.trimText, @"State":_vwPersonalInfo.txtState.trimText, @"Zip":_vwPersonalInfo.txtZip.trimText, @"EmployeeTitle":_vwPersonalInfo.txtEmployeePosition.trimText, @"EmployeeId":employeeId, @"GuestId":guestId ,@"MemberId":memberId, @"DateOfBirth":strDob, @"FirstAidFirstName":_vwBodilyFluid.txtFName.text, @"FirstAidMiddleInitial":_vwBodilyFluid.txtMI.text, @"FirstAidLastName":_vwBodilyFluid.txtLName.text, @"FirstAidPosition":_vwBodilyFluid.txtPosition.text, @"AffiliationTypeId":[NSString stringWithFormat:@"%ld", (long)_vwPersonalInfo.intAffiliationType], @"GenderTypeId":[NSString stringWithFormat:@"%ld", (long)_vwPersonalInfo.intGenderType], @"PersonTypeId":[NSString stringWithFormat:@"%ld", (long)_vwPersonalInfo.intPersonInvolved], @"GuestOfFirstName":_vwPersonalInfo.txtGuestFName.text, @"GuestOfMiddleInitial":_vwPersonalInfo.txtGuestMI.text, @"GuestOfLastName":_vwPersonalInfo.txtguestLName.text, @"IsMinor":(_vwPersonalInfo.btnMinor.isSelected) ? @"true" : @"false", @"ActivityTypeId":activityTypeID, @"EquipmentTypeId":equipmentTypeID, @"ConditionId":conditionTypeID, @"CareProvidedById":careProvidedBy, @"PersonPhoto": strPhoto, @"PersonSignature": strSignature, @"PersonName": aSignatureName, @"BloodbornePathogenTypeId":[NSString stringWithFormat:@"%ld", (long)_vwBodilyFluid.intBloodBornePathogen], @"StaffMemberWrittenAccount": _vwBodilyFluid.txvStaffMemberAccount.text, @"WasBloodOrBodilyFluidPresent":(_vwBodilyFluid.btnBloodPresent.isSelected) ? @"true":@"false", @"WasBloodCleanupRequired":(_vwBodilyFluid.btnBloodCleanupRequired.isSelected) ? @"true":@"false", @"WasCaregiverExposedToBlood":(_vwBodilyFluid.btnExposedToBlood.isSelected) ? @"true":@"false", @"OccuredDuringBusinessHours":(_vwPersonalInfo.btnEmployeeOnWork.isSelected) ? @"true" : @"false", @"Injuries": injuryList, @"EmergencyPersonnel" : mutArrEmergency};
    return aDict;
    
//    aPerson.duringWorkHours = (_vwPersonalInfo.btnEmployeeOnWork.isSelected) ? @"true" : @"false";
}



- (IBAction)btnAttachPhotoTapped:(UIButton *)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Capture Image" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Photo Library", @"Camera", nil];
    CGRect rect = [self convertRect:sender.frame toView:self.superview];
    rect = [self.superview convertRect:rect toView:_parentVC.view];
    [actionSheet showFromRect:rect inView:_parentVC.view animated:YES];
}

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

#pragma mark - UIActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        if (buttonIndex == 0) {
            [self showPhotoLibrary];
        }
        else if (buttonIndex == 1)
        {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                [self showCamera];
            }
            else
            {
                alert(@"Error!!", @"Camera is not available");
            }
            
        }
    }];
}

 
#pragma mark - UIPopOverControllerDelegate

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    popOver = nil;
}

#pragma mark - UIImagePickerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    _imgBodilyFluid = [info objectForKey:UIImagePickerControllerEditedImage];
    
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        [library saveImage:_imgBodilyFluid toAlbum:@"Connect2" withCompletionBlock:^(NSError *error) {
            if (error!=nil)
            {
                NSLog(@"error: %@", [error description]);
            }
            [gblAppDelegate.navigationController dismissViewControllerAnimated:YES completion:^{
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
}

- (void)setIsCaptureCameraVisible:(BOOL)isCaptureCameraVisible {
    _isCaptureCameraVisible = isCaptureCameraVisible;
    if (!_isCaptureCameraVisible) {
        CGRect frame = _btnCaptureImage.frame;
        frame.size = CGSizeZero;
        _btnCaptureImage.frame = frame;
        
        frame = self.frame;
        frame.size.height = CGRectGetMaxY(_btnCaptureImage.frame);
        self.frame = frame;
    }
}
@end
