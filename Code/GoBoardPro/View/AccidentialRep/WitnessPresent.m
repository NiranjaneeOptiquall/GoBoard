//
//  WitnessPresent.m
//  GoBoardPro
//
//  Created by ind726 on 03/02/15.
//  Copyright (c) 2015 IndiaNIC. All rights reserved.
//

#import "WitnessPresent.h"
#import "WitnessView.h"

@implementation WitnessPresent


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)btnWitnessPresenyYes:(UIButton *)sender {
    
    _btnWitnessPresentYes.selected = YES;
    _btnWitnessPresentNo.selected = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"adjustContentOffsetsToInsertWitnessView" object:nil];
}

- (IBAction)btnWitnessPresentNo:(UIButton *)sender {
    
    UIAlertView *alertWitnessPresent = [[UIAlertView alloc]initWithTitle:gblAppDelegate.appName message:@"All witnesses will be deleted. Are you sure that you want to proceed?" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Yes",@"No", nil];
    
    [alertWitnessPresent setTag:9898];
    
    [alertWitnessPresent show];
}

-(void)removeWitnessViewFromFinalSection:(UIView*)vwFinalSection
{
    BOOL isWitnessViewExist = NO;
    
    for (UIView *vwWitness in [vwFinalSection subviews]) {
        if ([vwWitness isKindOfClass:[WitnessView class]]) {
            
            isWitnessViewExist = YES;
        }
    }
    if (isWitnessViewExist) {
        
        _btnWitnessPresentNo.selected = YES;
        _btnWitnessPresentYes.selected = NO;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"adjustContentOffsetsToDeleteWitnessView" object:nil];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 9898) {
        
        if (buttonIndex == 0) {
            if(_parentVCAccident){
                for (UIView *vw in [_parentVCAccident.scrlMainView subviews]) {
                    if ([vw isKindOfClass:[FinalSection class]]) {
                        [self removeWitnessViewFromFinalSection:vw];
                    }
                }
            }else if (_parentVCIncident){
                for (UIView *vw in [_parentVCIncident.scrlMainView subviews]) {
                    if (vw.tag == 2121){
                        NSLog(@"Class Name : %@", [vw class]);
                        
                        [self removeWitnessViewFromFinalSection:vw];
                    }
                }
            }
        }
    }
}

@end
