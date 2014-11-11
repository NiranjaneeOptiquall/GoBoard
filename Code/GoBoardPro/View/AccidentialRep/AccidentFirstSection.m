//
//  AccidentFirstSection.m
//  GoBoardPro
//
//  Created by ind558 on 29/10/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import "AccidentFirstSection.h"
#import "AccidentReportViewController.h"


@implementation AccidentFirstSection

- (void)awakeFromNib {
    [_vwPersonalInfo setBackgroundColor:[UIColor clearColor]];
    [_vwPersonalInfo addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:NULL];
    
    [_vwBodyPartInjury setBackgroundColor:[UIColor clearColor]];
    [_vwBodyPartInjury manageData];
    
    [_vwBodyPartInjury addObserver:self forKeyPath:@"careProvided" options:NSKeyValueObservingOptionNew context:NULL];
    [_vwBodyPartInjury addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:NULL];
    [_vwBodilyFluid setBackgroundColor:[UIColor clearColor]];
    
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

- (BOOL)validateAccidentFirstSection {
    if (![_vwPersonalInfo isPersonalInfoValidationSuccess] || ![_vwBodyPartInjury isBodyPartInjuredInfoValidationSuccess] || ![_vwBodilyFluid isBodilyFluidValidationSucceed]) {
        return NO;
    }
    return YES;
}

@end
