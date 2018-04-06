//
//  BodyPartInjury.m
//  GoBoardPro
//
//  Created by ind558 on 29/09/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import "BodyPartInjury.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "GeneralInjuryType.h"


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
    [_txtOtherInjury setHidden:YES];
    [_imvOtherInjuryBG setHidden:YES];
    
    _mutArrInjuryList = [[NSMutableArray alloc] init];
        [_lblNoInjuryAdded.layer setBorderColor:[UIColor whiteColor].CGColor];
    [_lblNoInjuryAdded.layer setBorderWidth:1.0f];
    
}

- (IBAction)btnInjuryTypeGeneralTapped:(UIButton *)sender {
    if ([sender isSelected]) {
        return;
    }
    [_txtEnjuryType setText:@""];
    [_txtOtherInjury setHidden:YES];
    [_imvOtherInjuryBG setHidden:YES];
    [_imvOtherInjuryBG setHidden:YES];
    [_tblInjuredBodyPartList setHidden:YES];
    [_lblBodyPart setHidden:YES];
    [_lblBodyPartNote setHidden:YES];
    [_vwHumanFigure setHidden:YES];
    
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
    [_tblInjuredBodyPartList setHidden:NO];
    [_lblBodyPart setHidden:NO];
    [_lblBodyPartNote setHidden:NO];
    [_vwHumanFigure setHidden:NO];
    [_imvOtherInjuryBG setHidden:YES];
    [_txtOtherInjury setHidden:YES];
    [_imvOtherInjuryBG setHidden:YES];
    CGRect frame = _vwInjuryDetails.frame;
    frame.origin.y = CGRectGetMaxY(_tblInjuredBodyPartList.frame) + 12;
    _vwInjuryDetails.frame = frame;
    [_btnGeneralInjury setSelected:NO];
    [sender setSelected:YES];
    frame = [self frame];
    frame.size.height = CGRectGetMaxY(_vwInjuryDetails.frame);
    [self setFrame:frame];
    
    if (bodyPartIndex>0) {
        UIButton *aBtn = (UIButton*) [self viewWithTag:bodyPartIndex];
        [self btnInjureadBodyPartTapped:aBtn];
        selectedBodyPart = 0;
    }else{
        [self btnInjureadBodyPartTapped:_btnHead];
    }
    
    
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
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", @"name", _txtEnjuryType.text];
    if ([_btnGeneralInjury isSelected]) {
        [aDict setObject:[NSString stringWithFormat:@"%ld", (long)_btnGeneralInjury.tag] forKey:@"nature"];
        NSArray *ary = [[_parentVC.reportSetupInfo.generalInjuryType allObjects] filteredArrayUsingPredicate:predicate];
        if ([ary count] > 0) {
            [aDict setObject:[ary firstObject] forKey:@"GeneralInjuryType"];
        }else if ([ary count] == 0 && [_txtEnjuryType.text isEqualToString:@"Other"]){
            [aDict setObject:[NSDictionary dictionaryWithObjectsAndKeys:@"-1",@"typeId",@"Other",@"name", nil] forKey:@"GeneralInjuryType"];
        }else{
            [aDict setObject:@"" forKey:@"GeneralInjuryType"];
        }
        
    }
    else {
        [aDict setObject:[NSString stringWithFormat:@"%ld", (long)_btnBodyPartInjury.tag] forKey:@"nature"];
        if (selectedBodyPartLocation > 0) {
             [aDict setObject:[NSString stringWithFormat:@"%ld", (long)selectedBodyPartLocation] forKey:@"BodyPartInjuredLocation"];
        }else{
             [aDict setObject:[NSString stringWithFormat:@"%d",0] forKey:@"BodyPartInjuredLocation"];
        }
       
        
        if ([mutArrBodyPart objectAtIndex:selectedBodyPart]) {
            [aDict setObject:[mutArrBodyPart objectAtIndex:selectedBodyPart] forKey:@"part"];
        }
        NSArray *ary = [[_parentVC.reportSetupInfo.bodypartInjuryType allObjects] filteredArrayUsingPredicate:predicate];
        if ([ary count] > 0) {
            [aDict setObject:[ary firstObject] forKey:@"BodyPartInjuryType"];
        }
    }
    
    if (![_txtOtherInjury isHidden]) {
        [aDict setObject:_txtOtherInjury.trimText forKey:@"injury"];
        [aDict setObject:_txtOtherInjury.trimText forKey:@"generalOther"];
    }
    else {
        [aDict setObject:_txtEnjuryType.trimText forKey:@"injury"];
        [aDict setObject:@"" forKey:@"generalOther"];
    }
    predicate = [NSPredicate predicateWithFormat:@"%K MATCHES %@", @"name", _txtActionTaken.text];
    NSArray *ary = [[_parentVC.reportSetupInfo.actionList allObjects] filteredArrayUsingPredicate:predicate];
    if ([ary count] > 0) {
        [aDict setObject:[ary firstObject] forKey:@"action"];
    }
    
    [_mutArrInjuryList addObject:aDict];
    [_tblAddedInjuryList reloadData];
    selectedBodyPart = 0;
    [_tblInjuredBodyPartList reloadData];
    [[NSUserDefaults standardUserDefaults]setValue:@"YES" forKey:@"injuryAdded"];

    _txtActionTaken.text = @"";
    _txtEnjuryType.text = @"";
    _txtOtherInjury.text = @"";
    //selectedBodyPartLocation = 0;
    
}


- (IBAction)btnRemoveInjuryTapped:(id)sender {
    if (_mutArrInjuryList.count <= 1) {
        [[NSUserDefaults standardUserDefaults]setValue:@"NO" forKey:@"injuryAdded"];

    }
    
    UIButton *btnRemoveInjury = (UIButton *)sender;
    
    id getCell = btnRemoveInjury.superview;
    
    while (![getCell isKindOfClass:[UITableViewCell class]]) {
        getCell = [getCell superview];
    }
    
    UITableViewCell *cell = (UITableViewCell*) getCell;
    
    indexPathRemoveInjury = [_tblAddedInjuryList indexPathForCell:cell];
    
    UIAlertView *aAlertRemoveInjury = [[UIAlertView alloc]initWithTitle:[gblAppDelegate appName] message:@"Are you sure you want to delete recently added Injury?" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Yes",@"No", nil];
    
    aAlertRemoveInjury.tag = 1;
    
    [aAlertRemoveInjury show];
    
    
}
- (IBAction)btnInjureadBodyPartTapped:(UIButton *)sender {
    
    
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"sequence.intValue" ascending:YES];
    if ([sender isEqual:_btnHead]) {
        mutArrBodyPart =  [[_parentVC.reportSetupInfo.headInjuryList allObjects] sortedArrayUsingDescriptors:@[sort]];
        [_imvBodyPart setImage:[UIImage imageNamed:@"figure_head.png"]];
        selectedBodyPartLocation = Head;
    }
    else if ([sender isEqual:_btnMidBody]) {
        mutArrBodyPart = [[_parentVC.reportSetupInfo.abdomenInjuryList allObjects] sortedArrayUsingDescriptors:@[sort]];
        //mutArrBodyPart = [_parentVC.reportSetupInfo.abdomenInjuryList allObjects];
        [_imvBodyPart setImage:[UIImage imageNamed:@"figure_midbody.png"]];
        selectedBodyPartLocation = Abdomen;
    }
    else if ([sender isEqual:_btnLeftHand]) {
        mutArrBodyPart = [[_parentVC.reportSetupInfo.rightArmInjuryList allObjects] sortedArrayUsingDescriptors:@[sort]];
        //mutArrBodyPart = [_parentVC.reportSetupInfo.leftArmInjuryList allObjects];
        [_imvBodyPart setImage:[UIImage imageNamed:@"figure_leftHand.png"]];
        selectedBodyPartLocation = LeftArm;
    }
    else if ([sender isEqual:_btnRightHand]) {
        mutArrBodyPart = [[_parentVC.reportSetupInfo.leftArmInjuryList allObjects] sortedArrayUsingDescriptors:@[sort]];
        //mutArrBodyPart = [_parentVC.reportSetupInfo.rightArmInjuryList allObjects];
        [_imvBodyPart setImage:[UIImage imageNamed:@"figure_rightHand.png"]];
        selectedBodyPartLocation = RightArm;
    }
    else if ([sender isEqual:_btnLeftLeg]) {
        mutArrBodyPart = [[_parentVC.reportSetupInfo.rightLegInjuryList allObjects] sortedArrayUsingDescriptors:@[sort]];
        //mutArrBodyPart = [_parentVC.reportSetupInfo.leftLegInjuryList allObjects];
        [_imvBodyPart setImage:[UIImage imageNamed:@"figure_leftLeg.png"]];
        selectedBodyPartLocation = LeftLeg;
    }
    else if ([sender isEqual:_btnRightLeg]) {
        mutArrBodyPart = [[_parentVC.reportSetupInfo.leftLegInjuryList allObjects] sortedArrayUsingDescriptors:@[sort]];
        //mutArrBodyPart = [_parentVC.reportSetupInfo.rightArmInjuryList allObjects];
        [_imvBodyPart setImage:[UIImage imageNamed:@"figure_rightLeg.png"]];
        selectedBodyPartLocation = RightLeg;
    }
    bodyPartIndex = [sender tag];
    
    selectedBodyPart = 0;
    [_tblInjuredBodyPartList reloadData];
    
}

- (void)manageData {

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
        
        UIButton *btnRemoveInjury = (UIButton *) [aCell.contentView viewWithTag:6];
        
        [btnRemoveInjury addTarget:self action:@selector(btnRemoveInjuryTapped:) forControlEvents:UIControlEventTouchUpInside];
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
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"sequence.intValue" ascending:YES];
    if ([textField isEqual:_txtEnjuryType]) {
        [self setKeepViewInFrame:textField];
        DropDownPopOver *dropDown = (DropDownPopOver*)[[[NSBundle mainBundle] loadNibNamed:@"DropDownPopOver" owner:self options:nil] firstObject];
        dropDown.delegate = self;
        NSMutableArray *ary;
        if ([_btnGeneralInjury isSelected]) {
            ary = [NSMutableArray arrayWithArray:[[_parentVC.reportSetupInfo.generalInjuryType allObjects] sortedArrayUsingDescriptors:@[sort]]];
            NSMutableDictionary *aInjury = [NSMutableDictionary dictionary];
            [aInjury setValue:@"Other" forKey:@"name"];
            [aInjury setValue:@"-1" forKey:@"typeId"];
            [ary addObject:aInjury];
            
        }
        else {
            ary = [NSMutableArray arrayWithArray:[[_parentVC.reportSetupInfo.bodypartInjuryType allObjects] sortedArrayUsingDescriptors:@[sort]]];
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
        NSMutableArray *ary = [NSMutableArray arrayWithArray:[[_parentVC.reportSetupInfo.careProviderList allObjects] sortedArrayUsingDescriptors:@[sort]]];

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
            [_txtOtherInjury setHidden:NO];
            if (_btnBodyPartInjury.selected) {
                [_lblBodyPart setHidden:YES];
                [_lblBodyPartNote setHidden:YES];
            }
        }
        else {
            [_txtOtherInjury setHidden:YES];
            if (_btnBodyPartInjury.selected) {
                [_lblBodyPart setHidden:NO];
                [_lblBodyPartNote setHidden:NO];
            }
        }
        [_imvOtherInjuryBG setHidden:_txtOtherInjury.isHidden];
    }
    else if ([sender isEqual:_txtCareProvided]) {
        self.careProvided = [value valueForKey:@"name"];
    }
    [sender setText:[value valueForKey:@"name"]];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1) {
        if (buttonIndex == 0) {
            [_mutArrInjuryList removeObjectAtIndex:indexPathRemoveInjury.row];
            
            [_tblAddedInjuryList reloadData];
        }
    }
}

@end
