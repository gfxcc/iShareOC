//
//  BillsTableViewCell.m
//  iShare
//
//  Created by caoyong on 7/3/15.
//  Copyright (c) 2015 caoyong. All rights reserved.
//
#import "CombinedImage.h"
#import "BillsTableViewCell.h"

@implementation BillsTableViewCell

//- (void)awakeFromNib {
//    // Initialization code
//}
//
//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}

//-(void) setFrame:(CGRect) frame {
//    
//    frame.size.height = 66;
//    
//    [super setFrame:frame];
//}


- (void)initWithTypeCombinedImage:(UIImage *)type_icon noteOrType:(NSString *)noteOrType date:(NSString *)date amount:(NSString *)amount imageArray:(NSArray*)imageArray {
    _type_icon.image = type_icon;
    _noteOrType.text = noteOrType;
    _date.text = date;
    _amount.text = amount;

    //[imageArray addObject:shareWith_1];
    //[imageArray addObject:shareWith_2];
    //[imageArray addObject:shareWith_3];
    [_combinedImageView initWithImageArray:imageArray];

}

@end
