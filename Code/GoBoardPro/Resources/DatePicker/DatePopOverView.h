//
//  DatePopOverView.h
//  GoBoardPro
//
//  Created by ind558 on 01/10/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NSInteger DateSelectionOption;
typedef NSInteger DateLimitOption;

typedef enum : NSUInteger {
    DATE_LIMIT_FUTURE_ONLY = 1,
    DATE_LIMIT_PAST_ONLY,
    DATE_LIMIT_ALL_DATE,
    DATE_LIMIT_NONE
} DateLimits;

typedef enum : NSUInteger {
    DATE_SELECTION_DATE_ONLY = 1,
    DATE_SELECTION_TIME_ONLY,
    DATE_SELECTION_DATE_AND_TIME
} DateSelection;

@protocol DatePickerDelegate <NSObject>

@required
- (void)datePickerDidSelect:(NSDate*)date forObject:(id)field;

@end

@interface DatePopOverView : UIView<UIPopoverControllerDelegate> {
    UIPopoverController *popOver;
    UITextField *tempTextField;
    DateSelectionOption dateOption;
}
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) id <DatePickerDelegate>delegate;
@property (strong, nonatomic) NSString *desireDateFormat;

- (IBAction)btnDoneTapped:(id)sender;

- (void)allowAllDates;
- (void)allowFutureDateOnly;
- (void)allowPastDateOnly;
- (void)showInPopOverFor:(UIView*)sender limit:(DateLimitOption)dateLimit option:(DateSelectionOption)option updateField:(UITextField*)textField;
@end
