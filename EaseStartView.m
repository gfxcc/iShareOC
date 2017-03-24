//
//  EaseStartView.m
//  iShare
//
//  Created by caoyong on 11/2/15.
//  Copyright © 2015 caoyong. All rights reserved.
//

#import "EaseStartView.h"
//#import <NYXImagesKit/NYXImagesKit.h>
//#import "StartImagesManager.h"

@interface EaseStartView ()
@property (strong, nonatomic) UIImageView *bgImageView, *logoIconView;
@property (strong, nonatomic) UILabel *descriptionStrLabel;
@end

@implementation EaseStartView

+ (instancetype)startView{
    UIImage *logoIcon = [UIImage imageNamed:@"logo_coding_top"];
    //StartImage *st = [[StartImagesManager shareManager] randomImage];
    return [[self alloc] initWithBgImage:[UIImage imageNamed:@"introduce.png"] logoIcon:logoIcon descriptionStr:@"Introduce"];
}

- (instancetype)initWithBgImage:(UIImage *)bgImage logoIcon:(UIImage *)logoIcon descriptionStr:(NSString *)descriptionStr{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        //add custom code
        UIColor *blackColor = [UIColor blackColor];
        self.backgroundColor = blackColor;
        
        _bgImageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _bgImageView.contentMode = UIViewContentModeScaleAspectFill;
        _bgImageView.alpha = 0.0;
        [self addSubview:_bgImageView];
        
        _logoIconView = [[UIImageView alloc] init];
        _logoIconView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_logoIconView];
        _descriptionStrLabel = [[UILabel alloc] init];
        _descriptionStrLabel.font = [UIFont systemFontOfSize:10];
        _descriptionStrLabel.textColor = [UIColor colorWithWhite:1.0 alpha:0.5];
        _descriptionStrLabel.textAlignment = NSTextAlignmentCenter;
        _descriptionStrLabel.alpha = 0.0;
        [self addSubview:_descriptionStrLabel];
        
//        [_descriptionStrLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(@[self, _logoIconView]);
//            make.height.mas_equalTo(10);
//            make.bottom.equalTo(self.mas_bottom).offset(-15);
//            make.left.equalTo(self.mas_left).offset(20);
//            make.right.equalTo(self.mas_right).offset(-20);
//        }];
//        
//        [_logoIconView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(self);
//            make.top.mas_equalTo(kScreen_Height/7);
//            make.width.mas_equalTo(kScreen_Width *2/3);
//            make.height.mas_equalTo(kScreen_Width/4 *2/3);
//        }];
        
        [self configWithBgImage:bgImage logoIcon:logoIcon descriptionStr:descriptionStr];
    }
    return self;
}

- (CGSize)doubleSizeOfFrame:(CGSize)fsize{
    CGSize size = fsize;
    return CGSizeMake(size.width*2, size.height*2);
}

- (void)configWithBgImage:(UIImage *)bgImage logoIcon:(UIImage *)logoIcon descriptionStr:(NSString *)descriptionStr{
    //bgImage = [bgImage scaleToSize:[self doubleSizeOfFrame:_bgImageView.frame.size] usingMode:NYXResizeModeAspectFill];
    self.bgImageView.image = bgImage;
    self.logoIconView.image = logoIcon;
    self.descriptionStrLabel.text = descriptionStr;
    [self updateConstraintsIfNeeded];
}

- (void)startAnimationWithCompletionBlock:(void(^)(EaseStartView *easeStartView))completionHandler{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self];
    _bgImageView.alpha = 1.0;
    _descriptionStrLabel.alpha = 1.0;
    
    //@weakify(self);
    [UIView animateWithDuration:2.0 animations:^{
        //@strongify(self);
        self.bgImageView.alpha = 1.0;
        self.descriptionStrLabel.alpha = 1.0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.6 delay:0.3 options:UIViewAnimationOptionCurveEaseIn animations:^{
            //@strongify(self);
            CGRect frame = self.frame;
            frame.origin.x = [UIScreen mainScreen].bounds.size.width;
            self.frame = frame;
        } completion:^(BOOL finished) {
            //@strongify(self);
            [self removeFromSuperview];
            if (completionHandler) {
                completionHandler(self);
            }
        }];
    }];
}

@end
