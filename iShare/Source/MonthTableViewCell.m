//
//  MonthTableViewCell.m
//  iShare
//
//  Created by caoyong on 7/6/15.
//  Copyright (c) 2015 caoyong. All rights reserved.
//

#import "MonthTableViewCell.h"

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

@implementation MonthTableViewCell
//
//- (void)awakeFromNib {
//    // Initialization code
//}
//
//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}

- (void)initWithMonth:(NSString *)month dayRange:(NSString *)dayRange amount:(NSString *)amount {
    
    _month.text = month;
    _dayRange.text = dayRange;
    _amount.text = amount;
    
    self.backgroundColor = RGB(232, 232, 232);
}
@end
