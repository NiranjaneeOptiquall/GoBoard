//
//  AddCertificateView.m
//  GoBoardPro
//
//  Created by ind558 on 24/09/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import "AddCertificateView.h"


@implementation AddCertificateView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
//- (void)awakeFromNib {
//    [_txtCertificateName setDelegate:self];
//}

- (IBAction)btnSelectExpDate:(UIButton*)sender {
    DatePopOverView *datePopOver = (DatePopOverView *)[[[NSBundle mainBundle] loadNibNamed:@"DatePopOverView" owner:self options:nil] firstObject];
    [datePopOver showInPopOverFor:sender limit:DATE_LIMIT_FETURE_ONLY option:DATE_SELECTION_DATE_ONLY updateField:_txtExpDate];
}

- (IBAction)btnCaptureCertificatieImageTapped:(UIButton*)sender {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Capture Image" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Photo Library", @"Camera", nil];
    
//    CGRect rect = [self getRectForPopOver:sender];
    CGRect rect = [self convertRect:sender.frame toView:self.superview];
//    rect = [self.superview convertRect:rect toView:_parentView.view];

    [actionSheet showFromRect:rect inView:self.superview animated:YES];
}

- (CGRect)getRectForPopOver:(UIView*)view {
    CGRect rect = CGRectZero;
    UIView *superView = view.superview;
    while (YES) {
        rect = [superView convertRect:rect toView:superView.superview];
        if ([superView isEqual:_parentView.view]) {
            break;
        }
        view = superView;
        superView = superView.superview;
    }
    return rect;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self showPhotoLibrary];
        });
    }
    else if (buttonIndex == 1) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                [self showCamera];
            }
            else
            {
                alert(@"Error!!", @"Camera is not available");
            }

        });
    }
}

- (void)showPhotoLibrary {
    UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
    [imgPicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [imgPicker setDelegate:self];
    [imgPicker setAllowsEditing:YES];
    popOver = [[UIPopoverController alloc] initWithContentViewController:imgPicker];
    [popOver setPopoverContentSize:CGSizeMake(320, 480)];
    [popOver setDelegate:self];
    CGRect rect = [self convertRect:_btnCaptureImage.frame toView:self.superview];
    [popOver presentPopoverFromRect:rect inView:self.superview permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void)showCamera {
    
    UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
    [imgPicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    [imgPicker setDelegate:self];
    [imgPicker setAllowsEditing:YES];
    [gblAppDelegate.navigationController presentViewController:imgPicker animated:YES completion:^{
        
    }];
}


- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    popOver = nil;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    _imgCertificate = [info objectForKey:UIImagePickerControllerEditedImage];
   
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        [library saveImage:_imgCertificate toAlbum:@"GoBoard Pro" withCompletionBlock:^(NSError *error) {
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

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    DropDownPopOver *dropDown = (DropDownPopOver*)[[[NSBundle mainBundle] loadNibNamed:@"DropDownPopOver" owner:self options:nil] firstObject];
    dropDown.delegate = self;
    [dropDown showDropDownWith:_parentView.aryCertificates view:textField key:@"Name"];
    return NO;
}

- (void)dropDownControllerDidSelectValue:(id)value atIndex:(NSInteger)index sender:(id)sender {
    [sender setText:[value objectForKey:@"Name"]];
    _strDropDownId = [[value objectForKey:@"Id"] stringValue];
}

@end
