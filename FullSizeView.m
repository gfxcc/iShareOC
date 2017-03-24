//
//  FullSizeView.m
//  iShare
//
//  Created by caoyong on 8/29/15.
//  Copyright (c) 2015 caoyong. All rights reserved.
//

#import "FullSizeView.h"

@implementation FullSizeView

- (instancetype)initWithBounds:(CGRect)Bounds SuperView:(UIView *)SuperView ImageView:(UIImageView *)ImageView Image:(UIImage *)Image {
    _smallImage = ImageView;
    _superView = SuperView;
    _image = Image;
    
    // init full size image uiview

    self = [super initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height)];
    self.backgroundColor = [UIColor clearColor];
    self.alpha = 0.0;
    //[_superView addSubview:self];
    
    // init backgrand uiview
    _imageBackgrand = [[UIView alloc] initWithFrame:Bounds];
    _imageBackgrand.backgroundColor = [UIColor blackColor];
    _imageBackgrand.alpha = 0.0;
    [self addSubview:_imageBackgrand];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Tapped)];
    [ImageView setUserInteractionEnabled:YES];
    [ImageView addGestureRecognizer:tapGestureRecognizer];
    
    _imageView = [[UIImageView alloc] init];
    
    return self;
}

- (void)Tapped {
    [_superView bringSubviewToFront:self];
    self.alpha = 1.0;
    
    // init image view
    
    _imageView.clipsToBounds = YES;
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:_imageView];
    
    CGRect convertRect = [[_smallImage superview] convertRect:_smallImage.frame toView:self];
    _imageView.frame = convertRect;
    [self setImage];
    
    [self performSelector:@selector(setOriginFrame) withObject:nil afterDelay:0.1];
    
    // delegate
    if ([self delegateRespondsToOriginalSelector]) {
        [self.delegate originalImageViewTapped];
    }
}

- (void) setOriginFrame
{
    [UIView animateWithDuration:0.4 animations:^{
        _imageView.frame = _scaleOriginRect;
        _imageBackgrand.alpha = 1.0;
    }];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageViewTapped)];
    [_imageView setUserInteractionEnabled:YES];
    [_imageView addGestureRecognizer:tapGestureRecognizer];
}

- (void) tapImageViewTapped {

    [UIView animateWithDuration:0.5 animations:^{
        _imageBackgrand.alpha = 0;
        //self.zoomScale = 1.0;
        CGRect convertRect = [[_smallImage superview] convertRect:_smallImage.frame toView:self];
        _imageView.frame = convertRect;
    } completion:^(BOOL finished) {
        self.alpha = 0;
    }];
    
    if ([self delegateRespondsToFullSizeSelector]) {
        [self.delegate fullSizeViewTapped];
    }
}

- (void) setImage
{
    if (_image)
    {
        _imageView.image = _image;
        CGSize imgSize = _image.size;
        
        //判断首先缩放的值
        float scaleX = [UIScreen mainScreen].bounds.size.width/imgSize.width;
        float scaleY = [UIScreen mainScreen].bounds.size.height/imgSize.height;
        
        //倍数小的，先到边缘
        
        if (scaleX > scaleY)
        {
            //Y方向先到边缘
            float imgViewWidth = imgSize.width*scaleY;
            //self.maximumZoomScale = self.frame.size.width/imgViewWidth;
            
            _scaleOriginRect = (CGRect){self.frame.size.width/2-imgViewWidth/2,0,imgViewWidth,self.frame.size.height};
        }
        else
        {
            //X先到边缘
            float imgViewHeight = imgSize.height*scaleX;
            //self.maximumZoomScale = self.frame.size.height/imgViewHeight;
            
            _scaleOriginRect = (CGRect){0,[UIScreen mainScreen].bounds.size.height/2-imgViewHeight/2,[UIScreen mainScreen].bounds.size.width,imgViewHeight};
        }
    }
}

#pragma mark -
#pragma mark - FullSize delegate





- (BOOL)delegateRespondsToOriginalSelector {
    if ([self.delegate respondsToSelector:@selector(originalImageViewTapped)]) {
        return YES;
    } else {
        NSLog(@"Attention! Your delegate doesn't have originalImageViewTapped method implementation!");
        return NO;
    }
}

- (BOOL)delegateRespondsToFullSizeSelector {
    if ([self.delegate respondsToSelector:@selector(fullSizeViewTapped)]) {
        return YES;
    } else {
        NSLog(@"Attention! Your delegate doesn't have fullSizeViewTapped method implementation!");
        return NO;
    }
}

@end
