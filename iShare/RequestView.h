//
//  RequestView.h
//  iShare
//
//  Created by caoyong on 9/7/15.
//  Copyright (c) 2015 caoyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RequestViewDelegate <NSObject>

// 
- (void) sendRequest;

@end

@interface RequestView : UIView

@property (assign,nonatomic) id<RequestViewDelegate> delegate;
@property (strong, nonatomic) UITextField *UserNameTextField;
@property (strong, nonatomic) UITextField *PasswordTextField;

@property (strong, nonatomic) UIButton *LoginButton;
@property (strong, nonatomic) UIButton *CancelButton;

- (instancetype)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle;

- (void)show;
- (void)rightDisappear;
- (void)botDisappear;
@end
