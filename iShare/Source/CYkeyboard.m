//
//  CYkeyboard.m
//  iShare
//
//  Created by caoyong on 5/12/15.
//  Copyright (c) 2015 caoyong. All rights reserved.
//

#import "CYkeyboard.h"
#import "AddNewShareViewController.h"
#import "FileOperation.h"

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

@interface CYkeyboard ()
@property (nonatomic, strong) FileOperation *fileOperation;
@end

@implementation CYkeyboard

- (id)initWithTitle:(NSString *)title {
    _fileOperation = [[FileOperation alloc] init];
    
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
        
        // shareMode button
        _shareMode = [UIButton buttonWithType:UIButtonTypeSystem];
        [_shareMode setFrame:CGRectMake(0, self.bounds.origin.y - 40 + 4, 60, 40)];
        _shareMode.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_shareMode setTitle:@"   Mode" forState:UIControlStateNormal];
        [_shareMode setTitleColor:RGB(255, 255, 255) forState:UIControlStateNormal];
        [_shareMode addTarget:self action:@selector(shareModePage) forControlEvents:UIControlEventTouchUpInside];
        _shareMode.backgroundColor = RGB(98, 98, 98);
        //fade corner
        _shareMode.layer.cornerRadius = 5;
        _shareMode.clipsToBounds = YES;
        [self addSubview:_shareMode];
        
        CALayer *TopBorder = [CALayer layer];
        UIColor *borderColor = RGB(73, 71, 72);
        TopBorder.frame = CGRectMake(0.0f, 0, self.bounds.size.width, 5.0f);
        TopBorder.backgroundColor = borderColor.CGColor;
        [self.layer addSublayer:TopBorder];
        
    }
    
    
    
    _memberArray = [[NSMutableArray alloc] initWithArray:[_fileOperation getFriendsNameList]];
    _memberIdArray = [[NSMutableArray alloc] initWithArray:[_fileOperation getFriendsIdList]];
    [_memberArray insertObject:[_fileOperation getUsername] atIndex:0];
    [_memberIdArray insertObject:[_fileOperation getUserId] atIndex:0];
    
    _mydata = NULL;
    _selectedItems = [[NSMutableArray alloc] init];
    // load member icon
    _memberIcons = [[NSMutableArray alloc] init];
    for (int i = 0; i != _memberIdArray.count; i++) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
        NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"/Icon"];
        
        dataPath = [NSString stringWithFormat:@"%@/%@.png", dataPath, _memberIdArray[i]];
        BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:dataPath];
        UIImage *icon = fileExists ? [UIImage imageWithContentsOfFile:dataPath] : [UIImage imageNamed:@"icon-user-default.png"];
        [_memberIcons addObject:icon];
    }
    
    // ##load billType file.

    _typeArray = [_fileOperation getBillType];
//    NSString *content = [_fileOperation getFileContent:@"billType"];
//    NSArray *linesOfFile= [content componentsSeparatedByString:@"\n"];
//    
    // check empty or not
    
//    if (linesOfFile.count == 1 || !linesOfFile) { // not necessary
//        
//        NSMutableArray *array1 = [[NSMutableArray alloc] init];
//        [array1 addObject:@"Food & Drind"];// type name
//        [array1 addObject:@"ifood"];// type icon name
//        [array1 addObject:@"fruit"];
//        [array1 addObject:@"apple2-icon"];
//        [array1 addObject:@"cafe"];
//        [array1 addObject:@"can-icon"];
//        [_typeArray addObject:array1];
//        
//        NSMutableArray *array2 = [[NSMutableArray alloc] init];
//        [array2 addObject:@"Rent & Fee"];
//        [array2 addObject:@"clipboard"];
//        [array2 addObject:@"house"];
//        [array2 addObject:@"Apartment-icon"];
//        [array2 addObject:@"PSEG"];
//        [array2 addObject:@"cmyk"];
//        [array2 addObject:@"network"];
//        [array2 addObject:@"global"];
//        [_typeArray addObject:array2];
//        
//        NSMutableArray *array3 = [[NSMutableArray alloc] init];
//        [array3 addObject:@"Transportation"];
//        [array3 addObject:@"ibus"];
//        [array3 addObject:@"Taix"];
//        [array3 addObject:@"car"];
//        [array3 addObject:@"Train"];
//        [array3 addObject:@"train"];
//        [array3 addObject:@"Helicopter"];
//        [array3 addObject:@"helicopter"];
//        [_typeArray addObject:array3];
//        
//        NSMutableArray *array4 = [[NSMutableArray alloc] init];
//        [array4 addObject:@"Shopping"];
//        [array4 addObject:@"ishopping"];
//        [array4 addObject:@"SuperMarket"];
//        [array4 addObject:@"cart"];
//        [array4 addObject:@"online"];
//        [array4 addObject:@"shop"];
//        [_typeArray addObject:array4];
//        
//        NSMutableArray *array6 = [[NSMutableArray alloc] init];
//        [array6 addObject:@"Borrow & Lend"];
//        [array6 addObject:@"booklet"];
//        [array6 addObject:@"lend"];
//        [array6 addObject:@"compose"];
//        [_typeArray addObject:array6];
//        
//        // save to file
//        
//        for (int i = 0; i != _typeArray.count; i++) {
//            NSString *typeString = @"";
//            NSMutableArray *type = _typeArray[i];
//            for (int j = 0; j != type.count; j++) {
//                if (j == 0) {
//                    typeString = type[0];
//                } else {
//                    typeString = [NSString stringWithFormat:@"%@#%@", typeString, type[j]];
//                }
//            }
//            
//            if (i == 0) {
//                content = typeString;
//            } else {
//                content = [NSString stringWithFormat:@"%@\n%@", content, typeString];
//            }
//        }
//        
//        [_fileOperation setFileContent:content filename:@"billType"];
//        
//        
//    } else {
//        
//        for (int i = 0; i != linesOfFile.count; i++) {
//            NSString *stringOfLine = linesOfFile[i];
//            NSMutableArray *contentOfLine = [[NSMutableArray alloc] initWithArray:[stringOfLine componentsSeparatedByString:@"#"]];
//            [_typeArray addObject:contentOfLine];
//            
//        }
//    
//    }
    
//    _typeArray = [[NSMutableArray alloc] initWithObjects:@"lunch && dinner", @"PSEG && Network", @"SuperMarket", @"Rent", nil];
    
//    [@"" writeToFile:fileName
//          atomically:NO
//            encoding:NSUTF8StringEncoding
//               error:nil];

    
    return self;
}

- (void)reloadType {
    // ##load billType file.
    _typeArray = [_fileOperation getBillType];
//    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSString *fileName = [NSString stringWithFormat:@"%@/billType",
//                documentsDirectory];
//    NSString *content = [[NSString alloc] initWithContentsOfFile:fileName
//                                          usedEncoding:nil
//                                                 error:nil];
//    NSArray *linesOfFile= [content componentsSeparatedByString:@"\n"];
//    
//    // check empty or not
//    _typeArray = [[NSMutableArray alloc] init];
//    if (linesOfFile.count == 1 || !linesOfFile) { // not necessary
//        
//        NSMutableArray *array1 = [[NSMutableArray alloc] init];
//        [array1 addObject:@"Food and Drind"];// type name
//        [array1 addObject:@"Food and Drind"];// type icon name
//        [array1 addObject:@"hamburger"];
//        [array1 addObject:@"hamburger"];
//        [array1 addObject:@"cafe"];
//        [array1 addObject:@"cafe"];
//        [_typeArray addObject:array1];
//        
//        NSMutableArray *array2 = [[NSMutableArray alloc] init];
//        [array2 addObject:@"Rent and Fee"];
//        [array2 addObject:@"Rent and Fee"];
//        [array2 addObject:@"house"];
//        [array2 addObject:@"house"];
//        [array2 addObject:@"PSEG"];
//        [array2 addObject:@"PSEG"];
//        [array2 addObject:@"network"];
//        [array2 addObject:@"network"];
//        [_typeArray addObject:array2];
//        
//        NSMutableArray *array3 = [[NSMutableArray alloc] init];
//        [array3 addObject:@"Car and Bus"];
//        [array3 addObject:@"Car and Bus"];
//        [array3 addObject:@"bus"];
//        [array3 addObject:@"bus"];
//        [_typeArray addObject:array3];
//        
//        NSMutableArray *array4 = [[NSMutableArray alloc] init];
//        [array4 addObject:@"Shopping"];
//        [array4 addObject:@"Shopping"];
//        [array4 addObject:@"SuperMarket"];
//        [array4 addObject:@"SuperMarket"];
//        [_typeArray addObject:array4];
//        
//        NSMutableArray *array5 = [[NSMutableArray alloc] init];
//        [array5 addObject:@"Entertament"];
//        [array5 addObject:@"Entertament"];
//        [array5 addObject:@"game"];
//        [array5 addObject:@"game"];
//        [_typeArray addObject:array5];
//        
//        NSMutableArray *array6 = [[NSMutableArray alloc] init];
//        [array6 addObject:@"Borrow and Lend"];
//        [array6 addObject:@"Borrow and Lend"];
//        [array6 addObject:@"lend"];
//        [array6 addObject:@"lend"];
//        [_typeArray addObject:array6];
//        
//        // save to file
//        
//        for (int i = 0; i != 6; i++) {
//            NSString *typeString = @"";
//            NSMutableArray *type = _typeArray[i];
//            for (int j = 0; j != type.count; j++) {
//                if (j == 0) {
//                    typeString = type[0];
//                } else {
//                    typeString = [NSString stringWithFormat:@"%@#%@", typeString, type[j]];
//                }
//            }
//            
//            if (i == 0) {
//                content = typeString;
//            } else {
//                content = [NSString stringWithFormat:@"%@\n%@", content, typeString];
//            }
//        }
//        
//        [content writeToFile:fileName
//                  atomically:NO
//                    encoding:NSUTF8StringEncoding
//                       error:nil];
//        
//        
//    } else {
//        
//        for (int i = 0; i != linesOfFile.count; i++) {
//            NSString *stringOfLine = linesOfFile[i];
//            NSMutableArray *contentOfLine = [[NSMutableArray alloc] initWithArray:[stringOfLine componentsSeparatedByString:@"#"]];
//            [_typeArray addObject:contentOfLine];
//            
//        }
//        
//    }
    [_typePicker reloadAllComponents];
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
    [_paidByPicker removeFromSuperview];
    
    _textfield = [[UITextField alloc] initWithFrame:CGRectMake(0, self.bounds.origin.y - 300, 0, 0)];
    _textfield.hidden = YES;
//    ZenKeyboard *keyboard = [[ZenKeyboard alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height + 25)];
//    keyboard.textField = _textfield;
//
    _textfield.keyboardType = UIKeyboardTypeDecimalPad;
    
    UIToolbar* doneToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    doneToolbar.barStyle = UIBarStyleBlackTranslucent;
    doneToolbar.items = [NSArray arrayWithObjects:
                         [[UIBarButtonItem alloc]initWithTitle:@"15%" style:UIBarButtonItemStyleDone target:self action:@selector(calculateTips15)],
                         [[UIBarButtonItem alloc]initWithTitle:@"20%" style:UIBarButtonItemStyleDone target:self action:@selector(calculateTips20)],
                         [[UIBarButtonItem alloc]initWithTitle:@"25%" style:UIBarButtonItemStyleDone target:self action:@selector(calculateTips25)],
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
    _shown = true;
    // custom button
    
}

-(void)doneButtonClickedDismissKeyboard
{
    [_textfield resignFirstResponder];
    [self clickFadeOut];
}

- (void)calculateTips15 {
    double newAmount = [_amountLabel.text doubleValue] * 1.15;
    _amountLabel.text = [NSString stringWithFormat:@"%.2f", newAmount];
}

- (void)calculateTips20 {
    double newAmount = [_amountLabel.text doubleValue] * 1.20;
    _amountLabel.text = [NSString stringWithFormat:@"%.2f", newAmount];
}

- (void)calculateTips25 {
    double newAmount = [_amountLabel.text doubleValue] * 1.25;
    _amountLabel.text = [NSString stringWithFormat:@"%.2f", newAmount];
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
    
    // custom button
    _edit.hidden = NO;
    _shareMode.hidden = YES;
    
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
    
    // custom button
    _edit.hidden = YES;
    _shareMode.hidden = YES;

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
    
    // custom button
    _edit.hidden = YES;
    _shareMode.hidden = YES;
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
    
    // custom button
    _edit.hidden = YES;
    _shareMode.hidden = NO;
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
    AddNewShareViewController *mainUI_ = (AddNewShareViewController *)_mainUI;
    //[mainUI_ performSegueWithIdentifier:@"typeEdit" sender:mainUI_];
    [mainUI_ resetAllBackground];
//    amount_.backgroundColor = RGB(255, 255, 255);
//    type_.backgroundColor = RGB(255, 255, 255);
//    paidBy_.backgroundColor = RGB(255, 255, 255);
//    data_.backgroundColor = RGB(255, 255, 255);
//    member_.backgroundColor = RGB(255, 255, 255);
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
    [_textfield resignFirstResponder];
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
    AddNewShareViewController *mainUI_ = (AddNewShareViewController *)_mainUI;
    [mainUI_ performSegueWithIdentifier:@"typeEdit" sender:mainUI_];
}

- (void)shareModePage {
    //AddNewShareViewController *mainUI_ = (AddNewShareViewController *)_mainUI;
    //[mainUI_ performSegueWithIdentifier:@"shareMode" sender:mainUI_];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
}

#pragma mark -
#pragma mark UIPiker delegate
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if ([pickerView isEqual:_typePicker]) {
        return 2;
    } else if ([pickerView isEqual:_paidByPicker]) {
        return 1;
    }
    return 0;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if ([pickerView isEqual:_typePicker]) {
        if (component == 0) {
            return _typeArray.count;
        } else if (component == 1) {
            NSMutableArray *type = _typeArray[[_typePicker selectedRowInComponent:0]];
            return (type.count / 2) - 1;// type name and icon name
        }
    } else if ([pickerView isEqual:_paidByPicker]) {
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
        if (component == 0) {
            UIView *typeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width / 2, 40)];
            
            NSMutableArray *type = _typeArray[row];
            
            UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 30, 30)];
            image.image = [UIImage imageNamed:type[1]];
            [typeView addSubview:image];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, ([UIScreen mainScreen].bounds.size.width / 2) - 40, 40)];
            label.text = type[0];
            [typeView addSubview:label];
            return typeView;
        } else if (component == 1) {
            UIView *typeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width / 2, 40)];
            
            NSMutableArray *type = _typeArray[[_typePicker selectedRowInComponent:0]];
            
            UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 30, 30)];
            image.image = [UIImage imageNamed:type[(row + 1)*2 + 1]];
            [typeView addSubview:image];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, ([UIScreen mainScreen].bounds.size.width / 2) - 40, 40)];
            label.text = type[(row + 1)*2];
            [typeView addSubview:label];
            return typeView;
        }
        
    } else if ([pickerView isEqual:_paidByPicker]) {
        
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
        if (component == 1) {
            NSMutableArray *type = _typeArray[[_typePicker selectedRowInComponent:0]];
            type_.text = type[(row + 1) * 2];
        } else if (component == 0){
            [_typePicker reloadComponent:1];
            NSMutableArray *type = _typeArray[row];
            type_.text = type[2];
        }
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
