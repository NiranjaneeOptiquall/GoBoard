//
//  DropDownPopOver.h
//  GoBoardPro
//
//  Created by ind558 on 02/10/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DropDownValueDelegate <NSObject>

@required
- (void)dropDownControllerDidSelectValue:(id)value atIndex:(NSInteger)index sender:(id)sender;

@end


@interface DropDownPopOver : UIView <UIPopoverControllerDelegate, UITableViewDataSource, UITableViewDelegate> {
    UIPopoverController *popOver;
    NSArray *aryDataSource;
    NSString *strKey;
    UIView *invokingView;
}

@property (weak, nonatomic) IBOutlet UITableView *tblDorpDownList;
@property (weak, nonatomic) id<DropDownValueDelegate> delegate;

- (void)showDropDownWith:(NSArray*)values view:(UIView*)sender key:(NSString*)keyOfDict;
@end
