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
@property (weak, nonatomic) IBOutlet ComBinedImage *combinedImageView;


- (void)initWithTypeCombinedImage:(UIImage *)type_icon noteOrType:(NSString *)noteOrType date:(NSString *)date amount:(NSString *)amount imageArray:(NSArray*)imageArray;
@end
