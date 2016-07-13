//
//  EaseUserHeaderView.h
//  iShare
//
//  Created by yongcao on 7/11/16.
//  Copyright © 2016 caoyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITapImageView.h"

@interface EaseUserHeaderView : UITapImageView

@property (strong, nonatomic) UIImage *bgImage;
@property (strong, nonatomic) UIImage *iconImage;
@property (strong, nonatomic) NSString *username;

@property (strong, nonatomic) UITapImageView *userIconView;

@property (nonatomic, copy) void (^userIconClicked)();
@property (nonatomic, copy) void (^userNameClicked)();


+ (id)userHeaderViewWithBackground:(UIImage*)background Icon:(UIImage*)icon Username:(NSString*)username;

@end
