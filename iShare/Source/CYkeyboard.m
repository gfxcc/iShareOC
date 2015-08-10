//
//  CYkeyboard.m
//  iShare
//
//  Created by caoyong on 5/12/15.
//  Copyright (c) 2015 caoyong. All rights reserved.
//

#import "CYkeyboard.h"

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

@implementation CYkeyboard

- (id)initWithTitle:(NSString *)title {

    
    if (self = [super initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height + 40, [UIScreen mainScreen].bounds.size.width, InterfaceHigh)]) {
        
        self.backgroundColor = RGB(255, 255, 255);
        
        
        
        _fadeout = [UIButton buttonWithType:UIButtonTypeSystem];
        [_fadeout setFrame:CGRectMake(self.bounds.size.width - 60, self.bounds.origin.y - 40 + 4, 60, 40)];
        _fadeout.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_fadeout setTitle:@"    back" forState:UIControlStateNormal];
        [_fadeout setTitleColor:RGB(255, 255, 255) forState:UIControlStateNormal];
        [_fadeout addTarget:self action:@selector(clickFadeOut) forControlEvents:UIControlEventTouchUpInside];
        _fadeout.backgroundColor = RGB(98, 98, 98);
        //fade corner
        _fadeout.layer.cornerRadius = 5;
        _fadeout.clipsToBounds = YES;
        [self addSubview:_fadeout];
        
        // edit button
        _edit = [UIButton buttonWithType:UIButtonTypeSystem];
        [_edit setFrame:CGRectMake(0, self.bounds.origin.y - 40 + 4, 60, 40)];
        _edit.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_edit setTitle:@"    Edit" forState:UIControlStateNormal];
        [_edit setTitleColor:RGB(255, 255, 255) forState:UIControlStateNormal];
        [_edit addTarget:self action:@selector(editPage) forControlEvents:UIControlEventTouchUpInside];
        _edit.backgroundColor = RGB(98, 98, 98);
        //fade corner
        _edit.layer.cornerRadius = 5;
        _edit.clipsToBounds = YES;
        
        
        [self addSubview:_edit];
        
        CALayer *TopBorder = [CALayer layer];
        UIColor *borderColor = RGB(73, 71, 72);
        TopBorder.frame = CGRectMake(0.0f, 0, self.bounds.size.width, 5.0f);
        TopBorder.backgroundColor = borderColor.CGColor;
        [self.layer addSublayer:TopBorder];
        
    }
    
    _typeArray = [[NSMutableArray alloc] initWithObjects:@"lunch && dinner", @"PSEG && Network", @"SuperMarket", @"Rent", nil];
    _selectedItems = [[NSMutableArray alloc] init];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    //make a file name to write the data to using the documents directory:
    NSString *fileName = [NSString stringWithFormat:@"%@/friends",
                          documentsDirectory];
    NSString *content = [[NSString alloc] initWithContentsOfFile:fileName
                                                    usedEncoding:nil
                                                           error:nil];
    NSArray *members = [content componentsSeparatedByString:@"\n"];
    //_memberArray = [[NSMutableArray alloc] initWithObjects:@"Yong Cao", @"Xiaotong Ding", @"Xiaohang Lv", @"Yuchi Chen", nil];
    _memberArray = [NSMutableArray arrayWithArray:members];
    
    _mydata = NULL;
    
    // load member icon
    _memberIcons = [[NSMutableArray alloc] init];
    for (int i = 0; i != _memberArray.count; i++) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
        NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"/Icon"];
        
        dataPath = [NSString stringWithFormat:@"%@/%@.png", dataPath, _memberArray[i]];
        BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:dataPath];
        UIImage *icon = fileExists ? [UIImage imageWithContentsOfFile:dataPath] : [UIImage imageNamed:@"icon-user-default.png"];
        [_memberIcons addObject:icon];
    }
    
    return self;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    if (CGRectContainsPoint(self.bounds, point) ||
        CGRectContainsPoint(_fadeout.frame, point) ||
        CGRectContainsPoint(_edit.frame, point))
    {
        return YES;
    }
    return NO;
}

- (void)textFieldDidChange {
    amount_.text = _textfield.text;
}

- (void)datepickerDidChange {
    _mydata = _datepicker.date;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MMM d, yyyy 'at' hh:mm aa"];
    NSString *prettyVersion = [dateFormat stringFromDate:_mydata];
    
    data_.text = prettyVersion;
}

- (void)amountMode {
    [_textfield removeFromSuperview];
    [_datepicker removeFromSuperview];
    [_typePicker removeFromSuperview];
    [_memberPicker removeFromSuperview];
    
    _textfield = [[UITextField alloc] initWithFrame:CGRectMake(0, self.bounds.origin.y - 300, 0, 0)];
    _textfield.hidden = YES;
//    ZenKeyboard *keyboard = [[ZenKeyboard alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height + 25)];
//    keyboard.textField = _textfield;
//
    _textfield.keyboardType = UIKeyboardTypeDecimalPad;
    
    UIToolbar* doneToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    doneToolbar.barStyle = UIBarStyleBlackTranslucent;
    doneToolbar.items = [NSArray arrayWithObjects:
                         [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                         [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneButtonClickedDismissKeyboard)],
                         nil];
    [doneToolbar sizeToFit];
    _textfield.inputAccessoryView = doneToolbar;
    
    [_textfield addTarget:self
                   action:@selector(textFieldDidChange)
         forControlEvents:UIControlEventEditingChanged];
    [self addSubview:_textfield];
    [_textfield becomeFirstResponder];
    
}

-(void)doneButtonClickedDismissKeyboard
{
    [_textfield resignFirstResponder];
    [self clickFadeOut];
}

- (void)typeMode {
    [_textfield removeFromSuperview];
    [_datepicker removeFromSuperview];
    [_typePicker removeFromSuperview];
    [_memberPicker removeFromSuperview];
    [_paidByPicker removeFromSuperview];
    
    _typePicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0,
                                                                 0,
                                                                 [UIScreen mainScreen].bounds.size.width,
                                                                 InterfaceHigh)];
    _typePicker.dataSource = self;
    _typePicker.delegate = self;
    [self addSubview:_typePicker];
    [self sendSubviewToBack:_typePicker];
    
}
- (void)paidByMode {
    [_textfield removeFromSuperview];
    [_datepicker removeFromSuperview];
    [_typePicker removeFromSuperview];
    [_memberPicker removeFromSuperview];
    [_paidByPicker removeFromSuperview];
    
    _paidByPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0,
                                                                 0,
                                                                 [UIScreen mainScreen].bounds.size.width,
                                                                 InterfaceHigh)];
    _paidByPicker.dataSource = self;
    _paidByPicker.delegate = self;
    [self addSubview:_paidByPicker];
    [self sendSubviewToBack:_paidByPicker];

}
- (void)dataMode {
    [_textfield removeFromSuperview];
    [_datepicker removeFromSuperview];
    [_typePicker removeFromSuperview];
    [_memberPicker removeFromSuperview];
    [_paidByPicker removeFromSuperview];
    
    _datepicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0,
                                                                 0,
                                                                 [UIScreen mainScreen].bounds.size.width,
                                                                 InterfaceHigh)];
    _datepicker.datePickerMode = UIDatePickerModeDateAndTime;
    _datepicker.minuteInterval = 1;
    [_datepicker addTarget:self
                    action:@selector(datepickerDidChange)
          forControlEvents:UIControlEventValueChanged];
    [self addSubview:_datepicker];
    [self sendSubviewToBack:_datepicker];
}
- (void)memberMode {
    [_textfield removeFromSuperview];
    [_datepicker removeFromSuperview];
    [_typePicker removeFromSuperview];
    [_memberPicker removeFromSuperview];
    [_paidByPicker removeFromSuperview];
    
    _memberPicker = [[UITableView alloc] initWithFrame:CGRectMake(0,
                                                                 0,
                                                                 [UIScreen mainScreen].bounds.size.width,
                                                                 InterfaceHigh)];
    _memberPicker.dataSource = self;
    _memberPicker.delegate = self;
    [self addSubview:_memberPicker];
    [self sendSubviewToBack:_memberPicker];
}

- (void)setLables:(UILabel *)amount type:(UILabel *)type data:(UILabel *)data member:(UILabel *)member paidBy:(UILabel *)paidBy {
    amount_ = amount;
    type_ = type;
    paidBy_ = paidBy;
    data_ = data;
    member_ = member;
}

- (void)clickFadeOut {
    [self fadeMeOut];
    amount_.backgroundColor = RGB(255, 255, 255);
    type_.backgroundColor = RGB(255, 255, 255);
    paidBy_.backgroundColor = RGB(255, 255, 255);
    data_.backgroundColor = RGB(255, 255, 255);
    member_.backgroundColor = RGB(255, 255, 255);
}

- (void)show {

    [self fadeMeOut];
    
    [self performSelector:@selector(showAfterFadeMeOut) withObject:nil afterDelay:0.3f];
}

- (void)showAfterFadeMeOut {
    CGPoint toPoint;
    toPoint = CGPointMake([UIScreen mainScreen].bounds.size.width/2,[UIScreen mainScreen].bounds.size.height - (self.frame.size.height/2));
    //[UIScreen mainScreen].bounds.size.height - (self.frame.size.height/2)
    dispatch_block_t animationBlock = ^{
        self.center = toPoint;
    };
    
    [UIView animateWithDuration:0.3
                          delay:0
         usingSpringWithDamping:1
          initialSpringVelocity:0.f
                        options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction
                     animations:animationBlock
                     completion:nil];
    _shown = true;
}

- (void)fadeMeOut {
    if (!_shown) {
        return;
    }
    
    [self performSelectorOnMainThread:@selector(fadeOutNotification:) withObject:self waitUntilDone:NO];
}

- (void)fadeOutNotification:(UIView *)currentView {
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self
                                             selector:@selector(fadeOutNotification:)
                                               object:currentView];
    
    CGPoint fadeOutToPoint;
    
    
    fadeOutToPoint = CGPointMake(self.center.x,[UIScreen mainScreen].bounds.size.height + (self.frame.size.height/2) + 40);
    [UIView animateWithDuration:kTSMessageAnimationDuration animations:^
     {
         self.center = fadeOutToPoint;
         
     } completion:^(BOOL finished)
     {
         //[currentView removeFromSuperview];
         _shown = false;
     }];
}

- (void)editPage {
    
}

#pragma mark -
#pragma mark UIPiker delegate
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if ([pickerView isEqual:_typePicker]) {
        return _typeArray.count;
    }
    
    if ([pickerView isEqual:_paidByPicker]) {
        return _memberArray.count;
    }
    
    return 0;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 50;
}

//-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
//{
//    return [_typeArray objectAtIndex:row];
//}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    if ([pickerView isEqual:_typePicker]) {
        UIView *typeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
        
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(-40, 5, 40, 40)];
        image.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", _typeArray[row]]];
        [typeView addSubview:image];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 150, 40)];
        label.text = _typeArray[row];
        [typeView addSubview:label];
        return typeView;
    }
    
    if ([pickerView isEqual:_paidByPicker]) {
        
        UIView *typeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
        
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(-40, 5, 40, 40)];
        
        //image.image = fileExists ? [UIImage imageWithContentsOfFile:dataPath] : [UIImage imageNamed:@"icon-user-default.png"];
        image.image = _memberIcons[row];
        [typeView addSubview:image];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 150, 40)];
        label.text = _memberArray[row];
        [typeView addSubview:label];
        return typeView;
    }
    
    return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if ([pickerView isEqual:_typePicker]) {
        type_.text = [_typeArray objectAtIndex:row];
    }
    
    if ([pickerView isEqual:_paidByPicker]) {
        paidBy_.text = [_memberArray objectAtIndex:row];
    }
    
}

#pragma mark -
#pragma mark TableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    // If You have only one(1) section, return 1, otherwise you must handle sections
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return _memberArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    if ([_selectedItems indexOfObject:[NSNumber numberWithInteger:indexPath.row]] != NSNotFound) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    } else {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    cell.textLabel.text = [_memberArray objectAtIndex:indexPath.row];
    return cell;
}

- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {
    NSUInteger index = [_selectedItems indexOfObject:[NSNumber numberWithInteger:indexPath.row]];
    if (index != NSNotFound) {
        [_selectedItems removeObjectAtIndex:index];
        UITableViewCell *tableViewCell = [tableView cellForRowAtIndexPath:indexPath];
        tableViewCell.accessoryType = UITableViewCellAccessoryNone;
    } else {
        [_selectedItems addObject:[NSNumber numberWithInteger:indexPath.row]];
        UITableViewCell *tableViewCell = [tableView cellForRowAtIndexPath:indexPath];
        tableViewCell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    [_memberPicker deselectRowAtIndexPath:[_memberPicker indexPathForSelectedRow] animated:YES];
    
    NSString *member = @"";
    NSInteger count = 0;
    for (int i = 0; i != _memberArray.count; i++) {
        NSUInteger index = [_selectedItems indexOfObject:[NSNumber numberWithInt:i]];
//        if (count > 1) {
//            member = [NSString stringWithFormat:@"%@...", member];
//            break;
//        }
        if (index != NSNotFound) {
            member = [NSString stringWithFormat:@"%@ %@", member, _memberArray[i]];
            count++;
        }
    }
//    switch (count) {
//        case 0:
//        case 1:
//            [member_ setFont:[UIFont systemFontOfSize:30]];
//            break;
//        case 2:
//        default:
//            [member_ setFont:[UIFont systemFontOfSize:15]];
//            break;
//    }
    member_.text = member;
    
}


@end
