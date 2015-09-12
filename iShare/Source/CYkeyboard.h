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
    
    UILabel *data_;
    
    UILabel *member_;
    
    UILabel *paidBy_;
}

@property (strong, nonatomic) UIButton *fadeout;
@property (strong, nonatomic) UIButton *edit;
@property (strong, nonatomic) UIButton *shareMode;
@property (strong, nonatomic) UITextField *textfield;
@property (strong, nonatomic) UIPickerView *typePicker;
@property (strong, nonatomic) UIPickerView *paidByPicker;
@property (strong, nonatomic) UIDatePicker *datepicker;
@property (strong, nonatomic) UITableView *memberPicker;
@property (strong, nonatomic) NSDate *mydata;

@property (strong, nonatomic) NSMutableArray *typeArray; // first class type
@property (strong, nonatomic) NSMutableArray *secondTypeArray; // second class type

@property (strong, nonatomic) NSMutableArray *memberArray;
@property (strong, nonatomic) UIViewController *mainUI;

@property (strong, nonatomic) NSMutableArray *selectedItems;
@property (strong, nonatomic) NSMutableArray *memberIcons;

- (id)initWithTitle:(NSString *)title;

- (void)setLables:(UILabel *)amount type:(UILabel *)type data:(UILabel *)data member:(UILabel *)member paidBy:(UILabel *)paidBy;

- (void)show;

- (void)fadeMeOut;
- (void)clickFadeOut;

- (void)amountMode;
- (void)typeMode;
- (void)paidByMode;
- (void)dataMode;
- (void)memberMode;
- (void)editPage;
@end
