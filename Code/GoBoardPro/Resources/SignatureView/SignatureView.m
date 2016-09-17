//
//  SignatureView.m
//  Soprema
//
//  Created by Harsh Savani on 1/21/13.
//
//

#import "SignatureView.h"
@interface SignatureView ()

@end

@implementation SignatureView
@synthesize mainImage;
@synthesize tempDrawImage;
@synthesize lastPoint,red,green,blue,brush,opacity;
@synthesize txtName;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
//    if (!appDelegate.isSubmitted) {
        [btnClear setHidden:false];
        [btnSign setHidden:false];
//    }
//    else {
//        [btnClear setHidden:true];
//        [btnSign setHidden:true];
//    }
    
    if([[[NSUserDefaults standardUserDefaults]valueForKey:@"isForm"] isEqualToString:@"yes"])
    {
        
        txtName.hidden=YES;
    }
    
    txtName.text = _lastSavedName;
    red = 0.0/255.0;
    green = 0.0/255.0;
    blue = 0.0/255.0;
    brush = 5.0;
    opacity = 1.0;
    
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    if (!appDelegate.isSignatureUploaded) {
        mouseSwiped = NO;
        UITouch *touch = [touches anyObject];
        lastPoint = [touch locationInView:mainImage];

//    }
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
//    if (!appDelegate.isSignatureUploaded) {
        mouseSwiped = YES;
        UITouch *touch = [touches anyObject];
        CGPoint currentPoint = [touch locationInView:mainImage];
        UIGraphicsBeginImageContext(mainImage.frame.size);
        [self.tempDrawImage.image drawInRect:CGRectMake(0, 0, mainImage.frame.size.width, mainImage.frame.size.height)];
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), brush);
        
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, 1.0);
        CGContextSetBlendMode(UIGraphicsGetCurrentContext(),kCGBlendModeNormal);
        
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        self.tempDrawImage.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        lastPoint = currentPoint;

//    }
    
}

- (IBAction)ClearSignature
{

    self.mainImage.image = nil;
    self.tempDrawImage.image = nil;
    
    if([[[NSUserDefaults standardUserDefaults]valueForKey:@"isForm"] isEqualToString:@"yes"])
    {
        int indexNumber=[_btntag intValue];
        [_arrTempSignatureImage replaceObjectAtIndex:indexNumber withObject:@""];
        
    }
}

- (IBAction)DoneSigning:(id)sender
{
    if([[[NSUserDefaults standardUserDefaults]valueForKey:@"isForm"] isEqualToString:@"yes"])
    {
        NSLog(@"No Action");
    }
    else
    {
        if ([[txtName trimText] isEqualToString:@""]) {
            alert(@"", @"Please enter your name");
           
            return;
        }
    }
    if (_Completion) {
        _Completion();
    }
    [popOver dismissPopoverAnimated:YES];
  
}


- (void)showPopOverWithSender:(UIButton*)sender {
    
    if([[[NSUserDefaults standardUserDefaults]valueForKey:@"isForm"] isEqualToString:@"yes"])
    {
        txtName.hidden=YES;
        
        int indexNumber=[_btntag intValue];
        
        NSString *str=[NSString stringWithFormat:@"%@",[_arrTempSignatureImage objectAtIndex:indexNumber]];
       
       NSData *plainData = [[NSData alloc]initWithBase64EncodedString:str options:NSDataBase64DecodingIgnoreUnknownCharacters];
       tempDrawImage.image =[UIImage imageWithData:plainData];
    }

    popOver = nil;
    popOver = [[UIPopoverController alloc] initWithContentViewController:self];
    popOver.delegate = self;
    [popOver setPopoverContentSize:CGSizeMake(630, 255)];
    [popOver presentPopoverFromRect:sender.frame inView:[sender superview] permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    if (_Completion) {
        _Completion();
    }
    popOver = nil;
}

@end
