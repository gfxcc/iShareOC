//
//  RequestView.m
//  iShare
//
//  Created by caoyong on 9/7/15.
//  Copyright (c) 2015 caoyong. All rights reserved.
//

#import "RequestView.h"

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

@implementation RequestView

- (instancetype)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle {
    
    self = [super initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - 288) / 2, -190, 288, 190)];
    
    self.layer.borderWidth = 1;
    self.layer.borderColor = RGB(26, 142, 180).CGColor;
    self.backgroundColor = [UIColor whiteColor];
    
    UILabel *requestTitle = [[UILabel alloc] initWithFrame:CGRectMake(28, 25, 232, 42)];
    requestTitle.text = @"Friend request";
    requestTitle.textAlignment = NSTextAlignmentCenter;
    [self addSubview:requestTitle];
    
    _UserNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(28, 25, 232, 42)];
    _PasswordTextField = [[UITextField alloc] initWithFrame:CGRectMake(28, 87, 232, 42)];
    
    [_UserNameTextField setPlaceholder:@"Email"];
    [_PasswordTextField setText:title];
    
    _UserNameTextField.layer.masksToBounds = YES;
    _PasswordTextField.layer.masksToBounds = YES;
    
    _UserNameTextField.layer.cornerRadius = 3;
    _PasswordTextField.layer.cornerRadius = 3;
    
    _UserNameTextField.layer.borderWidth = 1;
    _PasswordTextField.layer.borderWidth = 1;
    
    UIColor* boColor = [UIColor colorWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:100];
    
//    _UserNameTextField.layer.borderColor = boColor.CGColor;
//    _UserNameTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
//    _UserNameTextField.leftViewMode = UITextFieldViewModeAlways;
//    UIImageView* imgUser = [[UIImageView alloc] initWithFrame:CGRectMake(11, 11, 22, 22)];
//    imgUser.image = [UIImage imageNamed:@"iconfont-user"];
//    [_UserNameTextField.leftView addSubview:imgUser];
    
    _PasswordTextField.layer.borderColor = boColor.CGColor;
    _PasswordTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    _PasswordTextField.leftViewMode = UITextFieldViewModeAlways;
    UIImageView* imgPwd = [[UIImageView alloc] initWithFrame:CGRectMake(11, 11, 22, 22)];
    imgPwd.image = [UIImage imageNamed:@"iconfont-user"];
    [_PasswordTextField.leftView addSubview:imgPwd];

    //[self addSubview:_UserNameTextField];
    [self addSubview:_PasswordTextField];
    
    //
    UILabel *botLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 137, 288, 53)];
    botLabel.backgroundColor = RGB(238, 238, 238);
    [self addSubview:botLabel];
    
    
    
    _LoginButton = [[UIButton alloc] initWithFrame:CGRectMake(200, 151, 60, 30)];
    _LoginButton.backgroundColor = RGB(26, 142, 180);
    _LoginButton.layer.masksToBounds = YES;
    _LoginButton.layer.cornerRadius = 3;
    [_LoginButton setTitle:@"Send" forState:UIControlStateNormal];
    //_LoginButton.tintColor = [UIColor blackColor];
    [_LoginButton addTarget:self action:@selector(rightDisappear) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_LoginButton];
    
    _CancelButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 151, 60, 30)];
    [_CancelButton setTitle:@"cancel" forState:UIControlStateNormal];
    [_CancelButton setTitleColor:RGB(26, 142, 180) forState:UIControlStateNormal];
    [_CancelButton addTarget:self action:@selector(botDisappear) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_CancelButton];
    
    //self.backgroundColor = [UIColor blackColor];
    return self;
}

- (void)show {
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - 288) / 2, 150, 288, 190);
    }];
}

- (void)rightDisappear {
    [self.delegate sendRequest];
    [UIView animateWithDuration:0.2 animations:^{
        self.frame = CGRectMake([UIScreen mainScreen].bounds.size.width, 150, 288, 190);
    }];
}

- (void)botDisappear {
    [UIView animateWithDuration:0.2 animations:^{
        self.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - 288) / 2, [UIScreen mainScreen].bounds.size.height, 288, 190);
    }];
}

@end
