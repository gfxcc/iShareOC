//
//  LoginViewController.h
//  iShare
//
//  Created by caoyong on 6/13/15.
//  Copyright (c) 2015 caoyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftMenuViewController.h"

@interface LoginViewController : UIViewController <UITextFieldDelegate>

typedef NS_ENUM(NSInteger, LogingAnimationType) {
    LogingAnimationType_NONE,
    LogingAnimationType_USER,
    LogingAnimationType_PWD
};

@property (weak, nonatomic) IBOutlet UITextField *UserNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *PasswordTextField;

@property (weak, nonatomic) IBOutlet UIView *loginView;

@property (weak, nonatomic) IBOutlet UIImageView *left_hidden;
@property (weak, nonatomic) IBOutlet UIImageView *right_hidden;

@property (weak, nonatomic) IBOutlet UIImageView *left_look;
@property (weak, nonatomic) IBOutlet UIImageView *right_look;

@property (weak, nonatomic) IBOutlet UIButton *LoginButton;

@property (weak, nonatomic) LeftMenuViewController *LeftMenuView;

@end
