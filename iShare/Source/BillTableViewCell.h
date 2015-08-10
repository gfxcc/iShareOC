//
//  BillTableViewCell.h
//  iShare
//
//  Created by caoyong on 7/6/15.
//  Copyright (c) 2015 caoyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BillTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UILabel *amount;
@property (weak, nonatomic) IBOutlet UILabel *day;
@property (weak, nonatomic) IBOutlet UILabel *memberCount;
@property (strong, nonatomic) UIImageView *monthLine;


- (void)initWithLabel:(NSString *)label;
- (void)initWithType:(NSString *)type amount:(NSString *)amount memberCount:(NSString *)memberCount day:(NSString *)day dayHiden:(BOOL)dayHiden;
- (void)SetDayHiden:(BOOL)dayHiden;
- (void)SetMonthLineHiden:(BOOL)hiden;
@end
