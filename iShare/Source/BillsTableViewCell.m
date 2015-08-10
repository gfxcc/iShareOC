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
    _shareWith_1.image = shareWith_1;
    _shareWith_2.image = shareWith_2;
    _shareWith_3.image = shareWith_3;

}

@end
