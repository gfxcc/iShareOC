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

@property (weak, nonatomic) LeftMenuViewController *LeftMenuView;

@end
