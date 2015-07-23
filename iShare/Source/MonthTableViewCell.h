//
//  MonthTableViewCell.h
//  iShare
//
//  Created by caoyong on 7/6/15.
//  Copyright (c) 2015 caoyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MonthTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *month;
@property (weak, nonatomic) IBOutlet UILabel *dayRange;
@property (weak, nonatomic) IBOutlet UILabel *amount;


- (void)initWithMonth:(NSString *)month dayRange:(NSString *)dayRange amount:(NSString *)amount;
@end
