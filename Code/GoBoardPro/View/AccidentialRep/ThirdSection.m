//
//  ThirdSection.m
//  GoBoardPro
//
//  Created by ind558 on 30/09/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import "ThirdSection.h"
#import "BodilyFluidView.h"
#import "EmergencyPersonnelView.h"
#import "AccidentReportViewController.h"

@implementation ThirdSection

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [self setBackgroundColor:[UIColor clearColor]];
}

#pragma mark - IBActions & Selectors
//
//- (IBAction)btnAddMoreBodilyFluidTapped:(id)sender {
//    [self addBodilyFluidView];
//    [self resetSelfFrame];
//}

- (IBAction)btnAddEmergencyPersonnel:(id)sender {
    [self addEmergencyPersonnel];
    [self resetSelfFrame];
}

- (IBAction)btnDeleteEmergencyPersonnel:(UIButton *)sender {
    UIAlertView *aAlertDeleteEmergencyPerson = [[UIAlertView alloc]initWithTitle:[gblAppDelegate appName] message:@"Are you sure you want to delete most recently added Emergency Personnel?" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Yes",@"No", nil];
    
    aAlertDeleteEmergencyPerson.tag = 1;
    
    [aAlertDeleteEmergencyPerson show];
}



#pragma mark - Methods

/*- (void)addBodilyFluidView {
    BodilyFluidView *objFluid = (BodilyFluidView*)[[[NSBundle mainBundle] loadNibNamed:@"BodilyFluidView" owner:self options:nil] firstObject];
    [objFluid setBackgroundColor:[UIColor clearColor]];
    CGRect frame = objFluid.frame;
    frame.origin.y = totalBodilyFluidCount * frame.size.height;
    objFluid.frame = frame;
    [self addSubview:objFluid];
    [mutArrBodilyFluidViews addObject:objFluid];
    totalBodilyFluidCount ++;
    frame = _vwFixedContent.frame;
    frame.origin.y = CGRectGetMaxY(objFluid.frame);
    _vwFixedContent.frame = frame;
    [_vwFixedContent setBackgroundColor:[UIColor clearColor]];
    [self bringSubviewToFront:_vwFixedContent];
    float nextY = CGRectGetMaxY(frame);
    for (UIView *vw in mutArrEmergencyViews) {
        CGRect frame = vw.frame;
        frame.origin.y = nextY;
        vw.frame = frame;
        nextY = CGRectGetMaxY(frame);
    }
    frame = _btnAddEmergencyPersonnel.frame;
    frame.origin.y = nextY;
    _btnAddEmergencyPersonnel.frame = frame;
}*/

- (void)addEmergencyPersonnel {
    EmergencyPersonnelView *objEmergency = (EmergencyPersonnelView*)[[[NSBundle mainBundle] loadNibNamed:@"EmergencyPersonnelView" owner:self options:nil] firstObject];
    
    [objEmergency setBackgroundColor:[UIColor clearColor]];
    [objEmergency.txtCaseNo setPlaceholder:@"Case / Accident #"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K MATCHES[cd] %@", @"type", REQUIRED_TYPE_EMERGENCY];
    NSArray *fields = [[_parentVC.reportSetupInfo.requiredFields allObjects] filteredArrayUsingPredicate:predicate];
    NSArray *aryFields = [fields valueForKeyPath:@"name"];
    [objEmergency setRequiredFields:aryFields];
    CGRect frame = objEmergency.frame;
    frame.origin.y = totalEmergencyPersonnelCount * frame.size.height;
    objEmergency.frame = frame;
    [self addSubview:objEmergency];
    totalEmergencyPersonnelCount ++;
    objEmergency.tag = totalEmergencyPersonnelCount+200;
    frame = _btnAddEmergencyPersonnel.frame;
    frame.origin.y = CGRectGetMaxY(objEmergency.frame);
    _btnAddEmergencyPersonnel.frame = frame;
    
    CGRect btnDeleteFrmae = _btnDeleteEmergencyPersonnel.frame;
    btnDeleteFrmae.origin.y = _btnAddEmergencyPersonnel.frame.origin.y;
    _btnDeleteEmergencyPersonnel.frame = btnDeleteFrmae;
    
    if (totalEmergencyPersonnelCount<=1) {
        _btnDeleteEmergencyPersonnel.hidden=YES;
    }else{
        _btnDeleteEmergencyPersonnel.hidden=NO;
    }
    
    [_mutArrEmergencyViews addObject:objEmergency];
    [self bringSubviewToFront:_btnAddEmergencyPersonnel];
}

- (void)resetSelfFrame {
    float maxHeight = 0;
    for (UIView *vw in self.subviews) {
        float newHeight = CGRectGetMaxY(vw.frame);
        if (newHeight > maxHeight) {
            maxHeight = newHeight;
        }
    }
    CGRect frame = self.frame;
    frame.size.height = maxHeight;
    self.frame = frame;
}

- (void)initialSetUp {
    _mutArrEmergencyViews = [[NSMutableArray alloc] init];
//    mutArrBodilyFluidViews = [[NSMutableArray alloc] init];
//    [self addBodilyFluidView];
    [self addEmergencyPersonnel];
    [self resetSelfFrame];
}

- (BOOL)isThirdSectionValidationSuccess {
    BOOL success = YES;
    for (EmergencyPersonnelView *view in _mutArrEmergencyViews) {
        if (![view isEmergencyPersonnelValidationSucceed]) {
            success = NO;
            break;
        }
    }
    return success;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1) {
        if (buttonIndex == 0) {
            
            EmergencyPersonnelView *objEmergency = (EmergencyPersonnelView*)[self viewWithTag:totalEmergencyPersonnelCount+200];
            
            if ([[self subviews] containsObject:objEmergency]) {

                
                totalEmergencyPersonnelCount --;
                
               CGRect frame = _btnAddEmergencyPersonnel.frame;
                int yPosition = frame.origin.y - objEmergency.frame.size.height;
                
                frame.origin.y = yPosition;
                _btnAddEmergencyPersonnel.frame = frame;
                
                CGRect btnDeleteFrmae = _btnDeleteEmergencyPersonnel.frame;
                btnDeleteFrmae.origin.y = _btnAddEmergencyPersonnel.frame.origin.y;
                _btnDeleteEmergencyPersonnel.frame = btnDeleteFrmae;
                
                if ([_mutArrEmergencyViews containsObject:objEmergency]) {
                    [_mutArrEmergencyViews removeObject:objEmergency];
                }
                [objEmergency removeFromSuperview];
                
                [self bringSubviewToFront:_btnAddEmergencyPersonnel];
                if (totalEmergencyPersonnelCount<=1) {
                    _btnDeleteEmergencyPersonnel.hidden=YES;
                }else{
                    _btnDeleteEmergencyPersonnel.hidden=NO;
                }
                
                [self resetSelfFrame];
            }
        }
    }
}

@end
