//
//  BodyPartInjury.m
//  GoBoardPro
//
//  Created by ind558 on 29/09/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import "BodyPartInjury.h"
#import "TPKeyboardAvoidingScrollView.h"


@implementation BodyPartInjury

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [self btnInjuryTypeGeneralTapped:_btnGeneralInjury];
    [_txtOtherInjury setEnabled:NO];
    _mutArrInjuryList = [[NSMutableArray alloc] init];
    [_lblNoInjuryAdded.layer setBorderColor:[UIColor whiteColor].CGColor];
    [_lblNoInjuryAdded.layer setBorderWidth:1.0f];
}

- (IBAction)btnInjuryTypeGeneralTapped:(UIButton *)sender {
    if ([sender isSelected]) {
        return;
    }
    [_txtEnjuryType setText:@""];
    [_txtOtherInjury setEnabled:NO];
    [_tblInjuredBodyPartList setHidden:YES];
    [_lblBodyPart setHidden:YES];
    [_lblBodyPartNote setHidden:YES];
    [_vwHumanFigure setHidden:YES];
    [_imvOtherInjuryBG setHidden:NO];
    [_txtOtherInjury setHidden:NO];
    CGRect frame = _vwInjuryDetails.frame;
    frame.origin.y = _tblInjuredBodyPartList.frame.origin.y;
    _vwInjuryDetails.frame = frame;
    [_btnBodyPartInjury setSelected:NO];
    [sender setSelected:YES];
    frame = [self frame];
    frame.size.height = CGRectGetMaxY(_vwInjuryDetails.frame);
    [self setFrame:frame];
}

- (IBAction)btnInjuryTypeBodyPartTapped:(UIButton *)sender {
    if ([sender isSelected]) {
        return;
    }
    [_txtEnjuryType setText:@""];
    [_txtOtherInjury setEnabled:NO];
    [_tblInjuredBodyPartList setHidden:NO];
    [_lblBodyPart setHidden:NO];
    [_lblBodyPartNote setHidden:NO];
    [_vwHumanFigure setHidden:NO];
    [_imvOtherInjuryBG setHidden:YES];
    [_txtOtherInjury setHidden:YES];
    CGRect frame = _vwInjuryDetails.frame;
    frame.origin.y = CGRectGetMaxY(_tblInjuredBodyPartList.frame) + 12;
    _vwInjuryDetails.frame = frame;
    [_btnGeneralInjury setSelected:NO];
    [sender setSelected:YES];
    frame = [self frame];
    frame.size.height = CGRectGetMaxY(_vwInjuryDetails.frame);
    [self setFrame:frame];
}

- (IBAction)btnAddAnotherInjuryTapped:(id)sender {
    if ([_txtEnjuryType isTextFieldBlank]) {
        alert(@"", MSG_REQUIRED_FIELDS);
        return;
    }
    else if ([_txtActionTaken isTextFieldBlank]) {
        alert(@"", MSG_REQUIRED_FIELDS);
        return;
    }
    
    NSMutableDictionary *aDict = [NSMutableDictionary dictionary];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K MATCHES %@", @"name", _txtEnjuryType.text];
    if ([_btnGeneralInjury isSelected]) {
        [aDict setObject:[NSString stringWithFormat:@"%ld", (long)_btnGeneralInjury.tag] forKey:@"nature"];
        NSArray *ary = [[_parentVC.reportSetupInfo.generalInjuryType allObjects] filteredArrayUsingPredicate:predicate];
        if ([ary count] > 0) {
            [aDict setObject:[ary firstObject] forKey:@"GeneralInjuryType"];
        }
        
    }
    else {
        [aDict setObject:[NSString stringWithFormat:@"%ld", (long)_btnBodyPartInjury.tag] forKey:@"nature"];
        [aDict setObject:[mutArrBodyPart objectAtIndex:selectedBodyPart] forKey:@"part"];
        NSArray *ary = [[_parentVC.reportSetupInfo.bodypartInjuryType allObjects] filteredArrayUsingPredicate:predicate];
        if ([ary count] > 0) {
            [aDict setObject:[ary firstObject] forKey:@"BodyPartInjuryType"];
        }
    }
    
    if ([_txtOtherInjury isEnabled]) {
        [aDict setObject:_txtOtherInjury.trimText forKey:@"injury"];
        [aDict setObject:_txtOtherInjury.trimText forKey:@"generalOther"];
    }
    else {
        [aDict setObject:_txtEnjuryType.trimText forKey:@"injury"];
    }
    NSArray *ary = [[_parentVC.reportSetupInfo.actionList allObjects] filteredArrayUsingPredicate:predicate];
    if ([ary count] > 0) {
        [aDict setObject:[ary firstObject] forKey:@"action"];
    }
    
    [_mutArrInjuryList addObject:aDict];
    [_tblAddedInjuryList reloadData];
    _txtActionTaken.text = @"";
    _txtEnjuryType.text = @"";
    _txtOtherInjury.text = @"";
    selectedBodyPart = 0;
}

- (IBAction)btnInjureadBodyPartTapped:(UIButton *)sender {
    if ([sender isEqual:_btnHead]) {
        mutArrBodyPart = [_parentVC.reportSetupInfo.headInjuryList allObjects];
        [_imvBodyPart setImage:[UIImage imageNamed:@"figure_head.png"]];
    }
    else if ([sender isEqual:_btnMidBody]) {
        mutArrBodyPart = [_parentVC.reportSetupInfo.abdomenInjuryList allObjects];
        [_imvBodyPart setImage:[UIImage imageNamed:@"figure_midbody.png"]];
    }
    else if ([sender isEqual:_btnLeftHand]) {
        mutArrBodyPart = [_parentVC.reportSetupInfo.armInjuryList allObjects];
        [_imvBodyPart setImage:[UIImage imageNamed:@"figure_leftHand.png"]];
    }
    else if ([sender isEqual:_btnRightHand]) {
        mutArrBodyPart = [_parentVC.reportSetupInfo.armInjuryList allObjects];
        [_imvBodyPart setImage:[UIImage imageNamed:@"figure_rightHand.png"]];
    }
    else if ([sender isEqual:_btnLeftLeg]) {
        mutArrBodyPart = [_parentVC.reportSetupInfo.legInjuryList allObjects];
        [_imvBodyPart setImage:[UIImage imageNamed:@"figure_leftLeg.png"]];
    }
    else if ([sender isEqual:_btnRightLeg]) {
        mutArrBodyPart = [_parentVC.reportSetupInfo.legInjuryList allObjects];
        [_imvBodyPart setImage:[UIImage imageNamed:@"figure_rightLeg.png"]];
    }
    bodyPartIndex = [sender tag];
    [_tblInjuredBodyPartList reloadData];
}

- (void)manageData {
//    mutArrBodyPart = [[NSMutableArray alloc] init];
//    [mutArrBodyPart addObject:HEAD_INJURY];
//    [mutArrBodyPart addObject:CHEST_INJURY];
//    [mutArrBodyPart addObject:ARM_INJURY];
//    [mutArrBodyPart addObject:LEG_INJURY];
    [_tblInjuredBodyPartList registerNib:[UINib nibWithNibName:@"BodyInjuryBodyPartCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cell"];
    [_tblAddedInjuryList registerNib:[UINib nibWithNibName:@"InjuryListCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cell"];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rows = 0;
    if ([tableView isEqual:_tblInjuredBodyPartList]) {
        rows = [mutArrBodyPart count];
    }
    else {
        rows = [_mutArrInjuryList count];
        if (rows > 0) {
            [_vwInjuryListHeader setHidden:NO];
            [_lblNoInjuryAdded setHidden:YES];
        }
        else {
            [_vwInjuryListHeader setHidden:YES];
            [_lblNoInjuryAdded setHidden:NO];
        }
    }
    return rows;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *aCell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if ([tableView isEqual:_tblAddedInjuryList]) {
        if (indexPath.row == 0 || indexPath.row % 2 == 0) {
            [aCell.contentView setBackgroundColor:[UIColor colorWithRed:228.0/255.0 green:228.0/255.0 blue:228.0/255.0 alpha:1.0]];
        }
        else {
            [aCell.contentView setBackgroundColor:[UIColor colorWithRed:241.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0]];
        }
        UILabel *aLbl = (UILabel *)[aCell.contentView viewWithTag:2];
        [aLbl setText:[[_mutArrInjuryList objectAtIndex:indexPath.row] objectForKey:@"injury"]];
        UILabel *aLbl1 = (UILabel *)[aCell.contentView viewWithTag:3];
        if ([[_mutArrInjuryList objectAtIndex:indexPath.row] objectForKey:@"part"]) {
            
            [aLbl1 setText:[[[_mutArrInjuryList objectAtIndex:indexPath.row] objectForKey:@"part"] name]];
        }
        else {
            [aLbl1 setText:@""];
        }
        UILabel *aLbl2 = (UILabel *)[aCell.contentView viewWithTag:4];
        [aLbl2 setText:[[[_mutArrInjuryList objectAtIndex:indexPath.row] objectForKey:@"action"] name]];
        UIView *aView = [aCell.contentView viewWithTag:5];
        CGRect frame = aView.frame;
        frame.origin.y = aCell.frame.size.height - 3;
        [aView setFrame:frame];
    }
    else {
        if (indexPath.row == selectedBodyPart) {
            [(UIImageView*)[aCell.contentView viewWithTag:2] setImage:[UIImage imageNamed:@"checked_white_radiobutton.png"]];
        }
        else {
            [(UIImageView*)[aCell.contentView viewWithTag:2] setImage:[UIImage imageNamed:@"unchecked_white_radiobutton.png"]];
        }
        UILabel *aLbl = (UILabel *)[aCell.contentView viewWithTag:3];
        [aLbl setText:[[mutArrBodyPart objectAtIndex:indexPath.row] name]];
    }
    [aCell setBackgroundColor:[UIColor clearColor]];
    return aCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:_tblInjuredBodyPartList]) {
        if (selectedBodyPart != indexPath.row) {
            UITableViewCell *aCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectedBodyPart inSection:0]];
            [(UIImageView*)[aCell.contentView viewWithTag:2] setImage:[UIImage imageNamed:@"unchecked_white_radiobutton.png"]];
            
            UITableViewCell *aCellNew = [tableView cellForRowAtIndexPath:indexPath];
            [(UIImageView*)[aCellNew.contentView viewWithTag:2] setImage:[UIImage imageNamed:@"checked_white_radiobutton.png"]];
            selectedBodyPart = indexPath.row;
        }
    }
}


#pragma mark - Methods

- (BOOL)isBodyPartInjuredInfoValidationSuccess {
    BOOL success = YES;
    if ([_txtEnjuryType isTextFieldBlank] || [_txtActionTaken isTextFieldBlank] || [_txtCareProvided isTextFieldBlank]) {
        success = NO;
        alert(@"", MSG_REQUIRED_FIELDS);
    }
    return success;
}

#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    BOOL allowEditing = YES;
    _parentVC.isUpdate = YES;
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    if ([textField isEqual:_txtEnjuryType]) {
        [self setKeepViewInFrame:textField];
        DropDownPopOver *dropDown = (DropDownPopOver*)[[[NSBundle mainBundle] loadNibNamed:@"DropDownPopOver" owner:self options:nil] firstObject];
        dropDown.delegate = self;
        NSArray *ary;
        if ([_btnGeneralInjury isSelected]) {
            ary = [[_parentVC.reportSetupInfo.generalInjuryType allObjects] sortedArrayUsingDescriptors:@[sort]];
        }
        else {
            ary = [[_parentVC.reportSetupInfo.bodypartInjuryType allObjects] sortedArrayUsingDescriptors:@[sort]];
        }
        [dropDown showDropDownWith:ary view:textField key:@"name"];
        allowEditing = NO;
    }
    else if ([textField isEqual:_txtActionTaken]) {
        [self setKeepViewInFrame:textField];
        DropDownPopOver *dropDown = (DropDownPopOver*)[[[NSBundle mainBundle] loadNibNamed:@"DropDownPopOver" owner:self options:nil] firstObject];
        dropDown.delegate = self;
        NSArray *ary = [[_parentVC.reportSetupInfo.actionList allObjects] sortedArrayUsingDescriptors:@[sort]];
        [dropDown showDropDownWith:ary view:textField key:@"name"];
        allowEditing = NO;
    }
    else if ([textField isEqual:_txtCareProvided]) {
        [self setKeepViewInFrame:textField];
        DropDownPopOver *dropDown = (DropDownPopOver*)[[[NSBundle mainBundle] loadNibNamed:@"DropDownPopOver" owner:self options:nil] firstObject];
        dropDown.delegate = self;
        NSArray *ary = [[_parentVC.reportSetupInfo.careProviderList allObjects] sortedArrayUsingDescriptors:@[sort]];
        [dropDown showDropDownWith:ary view:textField key:@"name"];
        allowEditing = NO;
    }
    
    return allowEditing;
}

- (void)setKeepViewInFrame:(UIView*)vw {
    TPKeyboardAvoidingScrollView *scrollView = (TPKeyboardAvoidingScrollView*)[self superview];
    while (![scrollView isKindOfClass:[TPKeyboardAvoidingScrollView class]]) {
        scrollView = (TPKeyboardAvoidingScrollView*)[scrollView superview];
    }
    CGPoint point = [vw.superview convertPoint:vw.frame.origin toView:scrollView];
    if (point.y <scrollView.contentOffset.y || point.y > scrollView.contentOffset.y + scrollView.frame.size.height) {
        [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, point.y - 50) animated:NO];
    }
}

- (void)dropDownControllerDidSelectValue:(id)value atIndex:(NSInteger)index sender:(id)sender {
    if ([sender isEqual:_txtEnjuryType]) {
        if ([[[value valueForKey:@"name"] lowercaseString] isEqualToString:@"other"]) {
            [_txtOtherInjury setEnabled:YES];
        }
        else {
            [_txtOtherInjury setEnabled:NO];
        }
    }
    else if ([sender isEqual:_txtCareProvided]) {
        self.careProvided = [[value valueForKey:@"name"] integerValue];
    }
    [sender setText:[value valueForKey:@"name"]];
}


@end
