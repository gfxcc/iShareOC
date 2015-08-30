//
//  FullSizeView.h
//  iShare
//
//  Created by caoyong on 8/29/15.
//  Copyright (c) 2015 caoyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FullSizeViewDelegate <NSObject>

// call after original imageView tapped
- (void) originalImageViewTapped;
// call after full size imageView tapped
- (void) fullSizeViewTapped;

@end

@interface FullSizeView : UIView

@property (assign,nonatomic) id<FullSizeViewDelegate> delegate;
@property (strong, nonatomic) UIImageView *smallImage;
@property (strong, nonatomic) UIView *superView;
@property (strong, nonatomic) UIImage *image;
//
//
//
@property (strong, nonatomic) UIView *imageBackgrand;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UITapGestureRecognizer *tapGestureRecognizer;
@property (nonatomic) CGRect scaleOriginRect;

- (instancetype)initWithBounds:(CGRect)Bounds SuperView:(UIView *)SuperView ImageView:(UIImageView *)ImageView Image:(UIImage *)Image;

@end
