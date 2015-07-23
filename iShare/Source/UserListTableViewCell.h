//
//  UserListTableViewCell.h
//  iShare
//
//  Created by caoyong on 6/30/15.
//  Copyright (c) 2015 caoyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *username;

- (void)initWith:(NSString *)username icon:(UIImage *)icon;

@end
