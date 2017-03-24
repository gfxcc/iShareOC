//
//  UserListTableViewCell.m
//  iShare
//
//  Created by caoyong on 6/30/15.
//  Copyright (c) 2015 caoyong. All rights reserved.
//

#import "UserListTableViewCell.h"

@implementation UserListTableViewCell

//- (void)awakeFromNib {
//    // Initialization code
//}
//
//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}

- (void)initWith:(NSString *)username icon:(UIImage *)icon {
    _icon.image = icon;
    _username.text = username;
}
@end
