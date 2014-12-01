//
//  DynamicFormsViewController.m
//  GoBoardPro
//
//  Created by ind558 on 29/11/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import "DynamicFormsViewController.h"
#import "SurveyQuestions.h"
#import "SurveyList.h"
#import "SurveyResponseTypeValues.h"
#import "DynamicFormCell.h"

@interface DynamicFormsViewController ()

@end

@implementation DynamicFormsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchQuestion];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetchQuestion {
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"sequence" ascending:YES];
    NSArray *array = [_survey.questionList sortedArrayUsingDescriptors:@[sort]];
    mutArrQuestions = [[NSMutableArray alloc] init];
    for (SurveyQuestions *question in array) {
        NSMutableDictionary *aDict = [NSMutableDictionary dictionary];
        [aDict setObject:[question valueForKey:@"question"] forKey:@"question"];
        [aDict setObject:[question valueForKey:@"questionId"] forKey:@"questionId"];
        [aDict setObject:[question valueForKey:@"responseType"] forKey:@"responseType"];
        [aDict setObject:[question valueForKey:@"sequence"] forKey:@"sequence"];
        NSMutableArray *mutArrResponseType = [NSMutableArray array];
        for (NSManagedObject *respType in [[question valueForKey:@"responseList"] allObjects]) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setObject:[respType valueForKey:@"value"] forKey:@"value"];
            [dict setObject:[respType valueForKey:@"name"] forKey:@"name"];
            [dict setObject:[NSNumber numberWithBool:NO] forKey:@"isSelected"];
            [mutArrResponseType addObject:dict];
        }
        [aDict setObject:mutArrResponseType forKey:@"responseList"];
        [mutArrQuestions addObject:aDict];
    }
    NSLog(@"%@", mutArrQuestions);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnBackTapped:(id)sender {
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [mutArrQuestions count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DynamicFormCell *aCell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (indexPath.row == 0 || indexPath.row % 2 == 0) {
        [aCell setBackgroundColor:[UIColor colorWithRed:228.0/255.0 green:228.0/255.0 blue:228.0/255.0 alpha:1.0]];
    }
    else {
        [aCell setBackgroundColor:[UIColor colorWithRed:241.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0]];
    }
    
    NSDictionary *aDict = [mutArrQuestions objectAtIndex:indexPath.row];
    [aCell.lblQuestion setText:[aDict objectForKey:@"question"]];
    [aCell.btnCheckMark setHidden:YES];
    [aCell.vwTextArea setHidden:YES];
    if ([[aDict objectForKey:@"responseType"] isEqualToString:@"checkboxList"] || [[aDict objectForKey:@"responseType"] isEqualToString:@"radioButtonList"]) {
        
    }
    else if (![[aDict objectForKey:@"responseType"] isEqualToString:@"checkbox"]) {
        [aCell.vwTextArea setHidden:NO];
        [aCell.txtField setDelegate:self];
        if ([[aDict objectForKey:@"responseType"] isEqualToString:@"textbox"]) {
            [aCell.imvTypeIcon setHidden:YES];
            [aCell.txtField setKeyboardType:UIKeyboardTypeAlphabet];
        }
        else if ([[aDict objectForKey:@"responseType"] isEqualToString:@"numeric"]) {
            [aCell.imvTypeIcon setHidden:YES];
            [aCell.txtField setKeyboardType:UIKeyboardTypeNumberPad];
        }
        else if ([[aDict objectForKey:@"responseType"] isEqualToString:@"time"]) {
            [aCell.imvTypeIcon setHidden:NO];
            [aCell.imvTypeIcon setImage:[UIImage imageNamed:@"time.png"]];
        }
        else if ([[aDict objectForKey:@"responseType"] isEqualToString:@"dropdown"]) {
            [aCell.imvTypeIcon setHidden:NO];
            [aCell.imvTypeIcon setImage:[UIImage imageNamed:@"arrow.png"]];
        }
        else if ([[aDict objectForKey:@"responseType"] isEqualToString:@"date"]) {
            [aCell.imvTypeIcon setHidden:NO];
            [aCell.imvTypeIcon setImage:[UIImage imageNamed:@"date.png"]];
        }
    }
    else {
        [aCell.btnCheckMark setHidden:NO];
    }
    
    
    
    
    
    UIView *aView = [aCell.contentView viewWithTag:4];
    CGRect frame = aView.frame;
    frame.origin.y = aCell.frame.size.height - 3;
    frame.size.height = 3;
    [aView setFrame:frame];
    return aCell;
}


- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 50;
    NSDictionary *aDict = [mutArrQuestions objectAtIndex:indexPath.row];
    CGRect frame = [[aDict objectForKey:@"question"] boundingRectWithSize:CGSizeMake(650,100) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20.0]} context:nil];
    height = frame.size.height + 26;
    
    if ([[aDict objectForKey:@"responseType"] isEqualToString:@"checkboxList"] || [[aDict objectForKey:@"responseType"] isEqualToString:@"radioButtonList"]) {
        NSInteger rows = [[aDict objectForKey:@"responseList"] count] / 2;
        if ([[aDict objectForKey:@"responseList"] count] % 2 == 1) {
            rows += 1;
        }
        height += 40*rows;
    }
    else if (![[aDict objectForKey:@"responseType"] isEqualToString:@"checkbox"]) {
        height += 75;
    }
    
    return height;
}

- (NSIndexPath *)indexPathForView:(UIView*)view {
    DynamicFormCell *aCell = (DynamicFormCell*)[view superview];
    while (![aCell isKindOfClass:[DynamicFormCell class]]) {
        aCell = (DynamicFormCell *)[aCell superview];
    }
    NSIndexPath *indexPath = [_tblForm indexPathForCell:aCell];
    return indexPath;
}

#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    NSIndexPath *indexPath = [self indexPathForView:textField];
    NSDictionary *aDict = [mutArrQuestions objectAtIndex:indexPath.row];
    if ([[aDict objectForKey:@"responseType"] isEqualToString:@"time"]) {
        DatePopOverView *datePopOver = (DatePopOverView *)[[[NSBundle mainBundle] loadNibNamed:@"DatePopOverView" owner:self options:nil] firstObject];
        [datePopOver showInPopOverFor:textField limit:DATE_LIMIT_NONE option:DATE_SELECTION_TIME_ONLY updateField:textField];
        return NO;
    }
    else if ([[aDict objectForKey:@"responseType"] isEqualToString:@"dropdown"]) {
        DropDownPopOver *dropDown = (DropDownPopOver*)[[[NSBundle mainBundle] loadNibNamed:@"DropDownPopOver" owner:self options:nil] firstObject];
        dropDown.delegate = self;
        [dropDown showDropDownWith:[aDict objectForKey:@"responseList"] view:textField key:@"name"];
        return NO;
    }
    else if ([[aDict objectForKey:@"responseType"] isEqualToString:@"date"]) {
        DatePopOverView *datePopOver = (DatePopOverView *)[[[NSBundle mainBundle] loadNibNamed:@"DatePopOverView" owner:self options:nil] firstObject];
        [datePopOver showInPopOverFor:textField limit:DATE_LIMIT_NONE option:DATE_SELECTION_DATE_ONLY updateField:textField];
        return NO;
    }
    return YES;
}

- (void)dropDownControllerDidSelectValue:(id)value atIndex:(NSInteger)index sender:(id)sender {
    [sender setText:[value valueForKey:@"name"]];
}

@end
