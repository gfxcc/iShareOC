//
//  BillsTableViewCell.m
//  iShare
//
//  Created by caoyong on 7/3/15.
//  Copyright (c) 2015 caoyong. All rights reserved.
//

#import "BillsTableViewCell.h"

@implementation BillsTableViewCell

//- (void)awakeFromNib {
//    // Initialization code
//}
//
//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}

//-(void) setFrame:(CGRect) frame {
//    
//    frame.size.height = 66;
//    
//    [super setFrame:frame];
//}

- (void)initWithTypeIcon:(UIImage *)type_icon noteOrType:(NSString *)noteOrType date:(NSString *)date amount:(NSString *)amount shareWith_0:(UIImage *)shareWith_0 shareWith_1:(UIImage *)shareWith_1 shareWith_2:(UIImage *)shareWith_2 shareWith_3:(UIImage *)shareWith_3 {
    _type_icon.image = type_icon;
    _noteOrType.text = noteOrType;
    _date.text = date;
    _amount.text = amount;
    _shareWith_0.image = shareWith_0;
    
//    _shareWith_0.layer.cornerRadius = 20;
//    _shareWith_0.clipsToBounds = YES;
//    _shareWith_0.layer.shouldRasterize = YES;
//    _shareWith_0.layer.rasterizationScale = [UIScreen mainScreen].scale;
//    _shareWith_1.layer.cornerRadius = 20;
//    _shareWith_1.clipsToBounds = YES;
//    _shareWith_1.layer.shouldRasterize = YES;
//    _shareWith_1.layer.rasterizationScale = [UIScreen mainScreen].scale;
//    _shareWith_2.layer.cornerRadius = 20;
//    _shareWith_2.clipsToBounds = YES;
//    _shareWith_2.layer.shouldRasterize = YES;
//    _shareWith_2.layer.rasterizationScale = [UIScreen mainScreen].scale;
//    _shareWith_3.layer.cornerRadius = 20;
//    _shareWith_3.clipsToBounds = YES;
//    _shareWith_3.layer.shouldRasterize = YES;
//    _shareWith_3.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    int count = 0;
    if (shareWith_0) {
        count++;
    }
    if (shareWith_1) {
        count++;
    }
    if (shareWith_2) {
        count++;
    }
    if (shareWith_3) {
        count++;
    }
    
    CGFloat move = ((count - 2) * _shareWith_0.bounds.size.width) / (count - 1);
    
    

        CGRect convert = [[_shareWith_0 superview] convertRect:_shareWith_0.frame toView:self];
        _shareWith_1.frame = CGRectMake(convert.origin.x + _shareWith_0.bounds.size.width - move, convert.origin.y, _shareWith_0.bounds.size.width, _shareWith_0.bounds.size.height);
        CGRect t = [[_shareWith_0 superview] convertRect:_shareWith_1.frame toView:self];
        _shareWith_1.image = shareWith_1;

    

        convert = [[_shareWith_1 superview] convertRect:_shareWith_1.frame toView:self];
        _shareWith_2.frame = CGRectMake(convert.origin.x + _shareWith_0.bounds.size.width - move, convert.origin.y, _shareWith_0.bounds.size.width, _shareWith_0.bounds.size.height);
        _shareWith_2.image = shareWith_2;


        convert = [[_shareWith_2 superview] convertRect:_shareWith_2.frame toView:self];
        _shareWith_3.frame = CGRectMake(convert.origin.x + _shareWith_0.bounds.size.width - move, convert.origin.y, _shareWith_0.bounds.size.width, _shareWith_0.bounds.size.height);
        _shareWith_3.image = shareWith_3;

}

@end
