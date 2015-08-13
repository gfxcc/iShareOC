//
//  RequestTableViewCell.h
//  iShare
//
//  Created by caoyong on 8/10/15.
//  Copyright (c) 2015 caoyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RequestTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIButton *confrimButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;


- (void)initWithIcon:(UIImage *)icon label:(NSString *)label;
@end
