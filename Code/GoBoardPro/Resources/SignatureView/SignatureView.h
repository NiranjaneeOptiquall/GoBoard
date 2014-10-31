//
//  SignatureView.h
//  Soprema
//
//  Created by Harsh Savani on 1/21/13.
//
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Constants.h"
//#import "UAModalPanel.h"
@interface SignatureView : UIViewController<UIPopoverControllerDelegate>
{
    AppDelegate* appDelegate;
    CGPoint lastPoint;
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat brush;
    CGFloat opacity;
    BOOL mouseSwiped;
//    UIImageView *mainImage;
//    UIImageView *tempDrawImage;
    IBOutlet UIButton* btnClear;
    IBOutlet UIButton* btnSign;
    IBOutlet UIView* SignPopupView;
    UIPopoverController *popOver;

}
@property (weak, nonatomic) IBOutlet UIImageView *mainImage;
@property (weak, nonatomic) IBOutlet UIImageView *tempDrawImage;
@property (nonatomic, retain) IBOutlet UITextField *txtName;
@property (nonatomic, readwrite) CGPoint lastPoint;
@property (nonatomic, readwrite) CGFloat red;
@property (nonatomic, readwrite) CGFloat green;
@property (nonatomic, readwrite) CGFloat blue;
@property (nonatomic, readwrite) CGFloat brush;
@property (nonatomic, readwrite) CGFloat opacity;
- (IBAction)ClearSignature;
- (IBAction)DoneSigning:(id)sender;

- (void)showPopOverWithSender:(UIButton*)sender;
@end
