//
//  PullAction.h
//  iShare
//
//  Created by caoyong on 12/27/15.
//  Copyright © 2015 caoyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PullActionContentView <NSObject>

//@property (nonatomic, strong) NSString *message;
@property (nonatomic, getter=isEnabled) BOOL atBot;

- (void)beginRefreshing:(BOOL)animated;
- (void)endRefreshing;

@end


@interface PullAction : UIControl

@property (nonatomic, strong) UIColor *tintColor;
@property (nonatomic, assign) UIActivityIndicatorViewStyle activityIndicatorViewStyle;
@property (nonatomic, strong) UIColor *activityIndicatorViewColor; // iOS5 or more
//@property (nonatomic, strong) BOOL refreshing;

- (id)initInScrollView:(UIScrollView *)scrollView;

// use custom activity indicator
- (id)initInScrollView:(UIScrollView *)scrollView activityIndicatorView:(UIView *)activity;

// Tells the control that a refresh operation was started programmatically
- (void)beginRefreshing;

// Tells the control the refresh operation has ended
- (void)endRefreshing;

@end
