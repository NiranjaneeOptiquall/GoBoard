//
//  PhotoLibraryViewController.h
//  GoBoardPro
//
//  Created by Optiquall Solutions on 15/01/18.
//  Copyright © 2018 IndiaNIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Constants.h"
@interface PhotoLibraryViewController : UIViewController<UIPopoverControllerDelegate>
{
    AppDelegate* appDelegate;
    UIPopoverController *popOver;
    
}
@property (nonatomic, readwrite) CGPoint lastPoint;
@property (nonatomic, readwrite) CGFloat red;
@property (nonatomic, readwrite) CGFloat green;
@property (nonatomic, readwrite) CGFloat blue;
@property (nonatomic, readwrite) CGFloat brush;
@property (nonatomic, readwrite) CGFloat opacity;






- (IBAction)btnCancelTapped:(UIButton *)sender;
- (IBAction)btnUploadTapped:(UIButton *)sender;

- (void)showGPopOverWithSender:(UIButton*)sender;
- (void)showGPopOverWithSender:(UIButton*)sender base62String:(nullable NSString*)base63;

@end
