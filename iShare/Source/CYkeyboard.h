//
//  CYkeyboard.h
//  iShare
//
//  Created by caoyong on 5/12/15.
//  Copyright (c) 2015 caoyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZenKeyboard.h"

#define kTSMessageAnimationDuration 0.2
#define InterfaceHigh 190

typedef NS_ENUM(NSInteger, CYkeyboardKind) {
    typeKeyboard = 0,
    accountKeyboard,
    dataKeyboard,
    memberKeyboard
};

@interface CYkeyboard : UIView <UIPickerViewDataSource, UIPickerViewDelegate, UITableViewDataSource, UITableViewDelegate>{

    BOOL _shown; // for judge the view show or not
    UILabel *amount_;
    
    UILabel *type_;
    
    UILabel *account_;
    
    UILabel *data_;
    
    UILabel *member_;
    
}

@property (strong, nonatomic) UITextField *textfield;
@property (strong, nonatomic) UIPickerView *typePicker;
@property (strong, nonatomic) UIPickerView *accountPicker;
@property (strong, nonatomic) UIDatePicker *datepicker;
@property (strong, nonatomic) UITableView *memberPicker;
@property (strong, nonatomic) NSDate *mydata;
@property (strong, nonatomic) NSMutableArray *typeArray;
@property (strong, nonatomic) NSMutableArray *memberArray;

@property (strong, nonatomic) NSMutableArray *selectedItems;

- (id)initWithTitle:(NSString *)title;

- (void)setLables:(UILabel *)amount type:(UILabel *)type account:(UILabel *)account data:(UILabel *)data member:(UILabel *)member;

- (void)show;

- (void)fadeMeOut;

- (void)amountMode;
- (void)typeMode;
- (void)accountMode;
- (void)dataMode;
- (void)memberMode;
@end
