//
//  DropDownPopOver.m
//  GoBoardPro
//
//  Created by ind558 on 02/10/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import "DropDownPopOver.h"

@implementation DropDownPopOver

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)reframeDorpDown {
    CGRect frame = _tblDorpDownList.frame;
    float height = frame.size.height;
    float newHeight = [aryDataSource count] * 44;
    if (newHeight < height) {
        frame.size.height = newHeight;
    }
    _tblDorpDownList.frame = frame;
    
    CGRect vwFrame = self.bounds;
    vwFrame.size = frame.size;
    self.bounds = vwFrame;
}


//***********
// keyOfDict parameter is optional. If you pass this parameter than the class will assume that your array is a collection of NSDictionary and will display the object for the given key from the dictionary in tableView' Cell.
// If you don't pass this key than class will assume that your array is a collection of NSString to be displayed on tableview's cell directly.
- (void)showDropDownWith:(NSArray*)values view:(UIView*)sender key:(NSString*)keyOfDict {
    aryDataSource = values;
    strKey = keyOfDict;
    invokingView = sender;
    [self reframeDorpDown];
    [_tblDorpDownList reloadData];
    UIViewController *vc = [[UIViewController alloc] init];
    vc.view = self;
    popOver = [[UIPopoverController alloc] initWithContentViewController:vc];
    [popOver setPopoverContentSize:self.frame.size];
    [popOver setDelegate:self];
    [popOver presentPopoverFromRect:sender.frame inView:sender.superview permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    popOver = nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [aryDataSource count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *aCell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!aCell) {
        aCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    if (strKey) {
        aCell.textLabel.text = [[aryDataSource objectAtIndex:indexPath.row] valueForKey:strKey];
    }
    else {
        aCell.textLabel.text = [aryDataSource objectAtIndex:indexPath.row];
    }
    
    return aCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_delegate respondsToSelector:@selector(dropDownControllerDidSelectValue:atIndex:sender:)]) {
        [_delegate dropDownControllerDidSelectValue:[aryDataSource objectAtIndex:indexPath.row] atIndex:indexPath.row sender:invokingView];
    }
    [popOver dismissPopoverAnimated:YES];
}

@end
