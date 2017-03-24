//
//  BillTypeTableViewCell.h
//  iShare
//
//  Created by caoyong on 9/11/15.
//  Copyright (c) 2015 caoyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BillTypeTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *typeName;


- (void)initWithIcon:(UIImage *)icon typeName:(NSString *)typeName;
@end
