//
//  EaseUserHeaderView.m
//  Coding_iOS
//
//  Created by Ease on 15/3/17.
//  Copyright (c) 2015年 Coding. All rights reserved.
//

#define EaseUserHeaderView_Height_Me kScaleFrom_iPhone5_Desgin(190)
#define EaseUserHeaderView_Height_Other kScaleFrom_iPhone5_Desgin(250)

#import "EaseUserHeaderView.h"

@interface EaseUserHeaderView ()



@property (strong, nonatomic) UIView *coverView;
@property (assign, nonatomic) CGFloat userIconViewWith;
@end


@implementation EaseUserHeaderView

+ (id)userHeaderViewWithBackground:(UIImage*)background Icon:(UIImage*)icon Username:(NSString*)username {

    EaseUserHeaderView *headerView = [[EaseUserHeaderView alloc] init];
    headerView.userInteractionEnabled = YES;
    headerView.contentMode = UIViewContentModeScaleAspectFill;
    headerView.bgImage = background;
    headerView.iconImage = icon;
    headerView.username = username;

    [headerView configUI];
    return headerView;
}

- (void)setBgImage:(UIImage *)bgImage{
    _bgImage = bgImage;
    self.image = _bgImage;
}

- (void)configUI{

    if (!_coverView) {//遮罩
        _coverView = [[UIView alloc] init];
        _coverView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        [self addSubview:_coverView];

    }
    
    [self setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, EaseUserHeaderView_Height_Me)];
    __weak typeof(self) weakSelf = self;
    
    if (!_userLabel) {
        _userLabel = [[UILabel alloc] init];
        _userLabel.font = [UIFont boldSystemFontOfSize:18];
        _userLabel.textColor = [UIColor whiteColor];
        _userLabel.textAlignment = NSTextAlignmentCenter;
        _userLabel.text = _username;
        [self addSubview:_userLabel];
    }
    
    [_userLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self).offset(-30);
        make.bottom.equalTo(self.mas_bottom).offset(kScaleFrom_iPhone5_Desgin(-15));
    }];
    
    if (kDevice_Is_iPhone6Plus) {
        _userIconViewWith = 130;
    }else if (kDevice_Is_iPhone6){
        _userIconViewWith = 110;
    }else{
        _userIconViewWith = 90;
    }
    
    if (!_userIconView) {
        _userIconView = [[UITapImageView alloc] init];
        _userIconView.backgroundColor = [UIColor whiteColor];
        _userIconView.image = _iconImage;
        _userIconView.layer.masksToBounds = YES;
        _userIconView.layer.cornerRadius = _userIconViewWith/2;
        _userIconView.layer.borderWidth = 1.0;
        _userIconView.layer.borderColor = [[UIColor whiteColor] CGColor];

        [_userIconView addTapBlock:^(id obj) {
            if (weakSelf.userIconClicked) {
                weakSelf.userIconClicked();
            }
        }];
        [self addSubview:_userIconView];
    }
    

    
    
    [_userIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(_userIconViewWith, _userIconViewWith));
        make.bottom.equalTo(_userLabel.mas_top).offset(-15);
        make.centerX.equalTo(self).offset(-30);
    }];


}

- (NSMutableAttributedString*)getStringWithTitle:(NSString *)title andValue:(NSString *)value{
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@", value, title]];
    [attrString addAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:17],
                                NSForegroundColorAttributeName : [UIColor whiteColor]}
                        range:NSMakeRange(0, value.length)];
    
    [attrString addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14],
                                NSForegroundColorAttributeName : [UIColor whiteColor]}
                        range:NSMakeRange(value.length+1, title.length)];
    return  attrString;
}

@end
