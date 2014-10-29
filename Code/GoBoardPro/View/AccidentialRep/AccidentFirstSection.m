//
//  AccidentFirstSection.m
//  GoBoardPro
//
//  Created by ind558 on 29/10/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import "AccidentFirstSection.h"


@implementation AccidentFirstSection

- (void)awakeFromNib {
    [_vwPersonalInfo setBackgroundColor:[UIColor clearColor]];
    [_vwPersonalInfo addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:NULL];
    [_vwBodyPartInjury setBackgroundColor:[UIColor clearColor]];
    [_vwBodyPartInjury manageData];
    [_vwBodyPartInjury addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:NULL];
    [_vwBodilyFluid setBackgroundColor:[UIColor clearColor]];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
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
    CGRect frame = self.frame;
    frame.size.height = CGRectGetMaxY(_vwBodilyFluid.frame);
    self.frame = frame;
}

@end
