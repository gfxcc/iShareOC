//
//  FriendWithBillTableViewCell.h
//  iShare
//
//  Created by caoyong on 7/29/15.
//  Copyright (c) 2015 caoyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendWithBillTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *amount;

- (void)initWithIcon:(UIImage *)icon username:(NSString *)username amount:(NSString *)amount;

@end
