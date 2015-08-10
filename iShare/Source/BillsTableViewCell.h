//
//  BillsTableViewCell.h
//  iShare
//
//  Created by caoyong on 7/3/15.
//  Copyright (c) 2015 caoyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BillsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *type_icon;
@property (weak, nonatomic) IBOutlet UILabel *noteOrType;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *amount;
@property (weak, nonatomic) IBOutlet UIImageView *shareWith_0;
@property (weak, nonatomic) IBOutlet UIImageView *shareWith_1;
@property (weak, nonatomic) IBOutlet UIImageView *shareWith_2;
@property (weak, nonatomic) IBOutlet UIImageView *shareWith_3;

- (void)initWithTypeIcon:(UIImage *)type_icon noteOrType:(NSString *)noteOrType date:(NSString *)date amount:(NSString *)amount shareWith_0:(UIImage *)shareWith_0 shareWith_1:(UIImage *)shareWith_1 shareWith_2:(UIImage *)shareWith_2 shareWith_3:(UIImage *)shareWith_3;
@end
