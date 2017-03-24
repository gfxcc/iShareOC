//
//  EaseStartView.h
//  iShare
//
//  Created by caoyong on 11/2/15.
//  Copyright © 2015 caoyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EaseStartView : UIView
+ (instancetype)startView;

- (void)startAnimationWithCompletionBlock:(void(^)(EaseStartView *easeStartView))completionHandler;
@end
