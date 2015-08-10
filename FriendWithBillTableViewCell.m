//
//  FriendWithBillTableViewCell.m
//  iShare
//
//  Created by caoyong on 7/29/15.
//  Copyright (c) 2015 caoyong. All rights reserved.
//

#import "FriendWithBillTableViewCell.h"

@implementation FriendWithBillTableViewCell

//- (void)awakeFromNib {
//    // Initialization code
//}
//
//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}
- (void)initWithIcon:(UIImage *)icon username:(NSString *)username amount:(NSString *)amount {
    //self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    _icon.image = icon;
    _username.text = username;
    _amount.text = amount;
    
}
@end
