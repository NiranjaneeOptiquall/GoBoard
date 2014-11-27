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
        if (_vwBodyPartInjury.careProvided == 5) {
            [_vwBodilyFluid.vwRefuseCare setHidden:YES];
            frame = _vwBodilyFluid.vwStaffMember.frame;
            frame.origin.y = _vwBodilyFluid.vwRefuseCare.frame.origin.y;
            _vwBodilyFluid.vwStaffMember.frame = frame;
            
        }
        else {
            [_vwBodilyFluid.vwRefuseCare setHidden:NO];
            frame = _vwBodilyFluid.vwStaffMember.frame;
            frame.origin.y = CGRectGetMaxY(_vwBodilyFluid.vwRefuseCare.frame);
            _vwBodilyFluid.vwStaffMember.frame = frame;
        }
        frame = _vwBodilyFluid.frame;
        frame.size.height = CGRectGetMaxY(_vwBodilyFluid.vwStaffMember.frame);
        _vwBodilyFluid.frame = frame;
    }
    CGRect frame = self.frame;
    frame.size.height = CGRectGetMaxY(_vwBodilyFluid.frame);
    self.frame = frame;
}

- (BOOL)validateAccidentFirstSectionWith:(NSArray *)personArray firstAidFields:(NSArray*)firstAid {
    if (![_vwPersonalInfo isPersonalInfoValidationSuccessWith:personArray] || ![_vwBodyPartInjury isBodyPartInjuredInfoValidationSuccess] || ![_vwBodilyFluid isBodilyFluidValidationSucceedWith:firstAid]) {
        return NO;
    }
    return YES;
}

- (AccidentPerson*)getAccidentPerson {
    AccidentPerson *aPerson = [NSEntityDescription insertNewObjectForEntityForName:@"AccidentPerson" inManagedObjectContext:gblAppDelegate.managedObjectContext];
    
    aPerson.firstName = _vwPersonalInfo.txtFirstName.text;
    aPerson.memberId = _vwPersonalInfo.txtMemberId.text;
    aPerson.employeeTitle = _vwPersonalInfo.txtEmployeePosition.text;
    aPerson.personTypeID = [NSString stringWithFormat:@"%ld", (long)_vwPersonalInfo.intPersonInvolved];
    aPerson.affiliationTypeID = [NSString stringWithFormat:@"%ld", (long)_vwPersonalInfo.intAffiliationType];
    
    aPerson.middleInitial = _vwPersonalInfo.txtMi.text;
    aPerson.lastName = _vwPersonalInfo.txtLastName.text;
    aPerson.streetAddress = _vwPersonalInfo.txtStreetAddress.text;
    aPerson.apartmentNumber = _vwPersonalInfo.txtAppartment.text;
    aPerson.city = _vwPersonalInfo.txtCity.text;
    aPerson.state = _vwPersonalInfo.txtState.text;
    aPerson.zip = _vwPersonalInfo.txtZip.text;
    aPerson.primaryPhone = _vwPersonalInfo.txtHomePhone.text;
    aPerson.alternatePhone = _vwPersonalInfo.txtAlternatePhone.text;
    aPerson.email = _vwPersonalInfo.txtEmailAddress.text;
    aPerson.dateOfBirth = _vwPersonalInfo.txtDob.text;
    aPerson.guestOfFirstName = _vwPersonalInfo.txtGuestFName.text;
    aPerson.guestOfMiddleInitial = _vwPersonalInfo.txtGuestMI.text;
    aPerson.guestOfLastName = _vwPersonalInfo.txtguestLName.text;
    aPerson.genderTypeID = [NSString stringWithFormat:@"%ld", (long)_vwPersonalInfo.intGenderType];
    aPerson.minor = (_vwPersonalInfo.btnMinor.isSelected) ? @"true" : @"false";
    aPerson.duringWorkHours = (_vwPersonalInfo.btnEmployeeOnWork.isSelected) ? @"true" : @"false";
    
    aPerson.firstAidFirstName = _vwBodilyFluid.txtFName.text;
    aPerson.firstAidMiddleInitial = _vwBodilyFluid.txtMI.text;
    aPerson.firstAidLastName = _vwBodilyFluid.txtLName.text;
    aPerson.firstAidPosition = _vwBodilyFluid.txtPosition.text;
    aPerson.bloodBornePathogenType = _vwBodilyFluid.strBloodBornePathogen;
    aPerson.bloodCleanUpRequired = (_vwBodilyFluid.btnBloodCleanupRequired.isSelected) ? @"true":@"false";
    aPerson.wasExposedToBlood = (_vwBodilyFluid.btnExposedToBlood.isSelected) ? @"true":@"false";
    aPerson.participantSignature = UIImageJPEGRepresentation(_vwBodilyFluid.signatureView.tempDrawImage.image, 1.0);
    aPerson.staffMemberWrittenAccount = _vwBodilyFluid.txvStaffMemberAccount.text;
    aPerson.participantName = _vwBodilyFluid.signatureView.txtName.text;
    aPerson.wasBloodPresent = (_vwBodilyFluid.btnBloodPresent.isSelected) ? @"true":@"false";
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K MATCHES[cd] %@", @"name", _vwBodyPartInjury.txtCareProvided.text];
    NSArray *ary = [[_parentVC.reportSetupInfo.careProviderList allObjects] filteredArrayUsingPredicate:predicate];
    aPerson.careProvidedBy = [[ary firstObject] valueForKey:@"careProvidedID"];
    
    predicate = [NSPredicate predicateWithFormat:@"%K MATCHES[cd] %@", @"name", _vwPersonalInfo.txtActivity.text];
    ary = [[_parentVC.reportSetupInfo.activityList allObjects] filteredArrayUsingPredicate:predicate];
    aPerson.activityTypeID = [[ary firstObject] valueForKey:@"activityId"];
    
    predicate = [NSPredicate predicateWithFormat:@"%K MATCHES[cd] %@", @"name", _vwPersonalInfo.txtWheather.text];
    ary = [[_parentVC.reportSetupInfo.conditionList allObjects] filteredArrayUsingPredicate:predicate];
    aPerson.conditionTypeID = [[ary firstObject] valueForKey:@"conditionId"];
    
    predicate = [NSPredicate predicateWithFormat:@"%K MATCHES[cd] %@", @"name", _vwPersonalInfo.txtEquipment.text];
    ary = [[_parentVC.reportSetupInfo.equipmentList allObjects] filteredArrayUsingPredicate:predicate];
    aPerson.equipmentTypeID = [[ary firstObject] valueForKey:@"equipmentId"];
    NSMutableSet *injuryList = [NSMutableSet set];
    for (NSDictionary *aDict in _vwBodyPartInjury.mutArrInjuryList) {
        InjuryDetail *aInjury = [NSEntityDescription insertNewObjectForEntityForName:@"InjuryDetail" inManagedObjectContext:gblAppDelegate.managedObjectContext];
        aInjury.natureOfInjury = [aDict objectForKey:@"type"];
        aInjury.bodyPartInjury = [[aDict objectForKey:@"part"] name];

        
        if ([_vwBodyPartInjury.txtOtherInjury isEnabled]) {
            aInjury.otherInjuryText = [aDict objectForKey:@"injury"];
        }
        else {
            aInjury.otherInjuryText = @"";
        }
        
        predicate = [NSPredicate predicateWithFormat:@"%K MATCHES[cd] %@", @"name", [aDict objectForKey:@"injury"]];
        ary = [[_parentVC.reportSetupInfo.generalInjuryType allObjects] filteredArrayUsingPredicate:predicate];
        aInjury.injuryType = [aDict objectForKey:@"injury"];
        
        predicate = [NSPredicate predicateWithFormat:@"%K MATCHES[cd] %@", @"name", [aDict objectForKey:@"action"]];
        ary = [[_parentVC.reportSetupInfo.actionList allObjects] filteredArrayUsingPredicate:predicate];
        aInjury.actionTakenId = [[ary firstObject] valueForKey:@"actionId"];
        aInjury.accidentPerson = aPerson;
        [injuryList addObject:aInjury];
    }
    aPerson.injuryList = injuryList;
    return aPerson;
}

@end
