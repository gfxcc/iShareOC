//
//  BillTypeTableViewCell.m
//  iShare
//
//  Created by caoyong on 9/11/15.
//  Copyright (c) 2015 caoyong. All rights reserved.
//

#import "BillTypeTableViewCell.h"

@implementation BillTypeTableViewCell

- (void)initWithIcon:(UIImage *)icon typeName:(NSString *)typeName {
    
    //self = [super initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 60)];

    _icon.image = icon;
    _typeName.text = typeName;
    //self.contentView.backgroundColor = [UIColor blackColor];
    //self.backgroundColor =
    
    //return self;
}

//- (void)layoutSubviews {
//    if (self.editing) {
//        //_icon.frame = CGRectMake(40, 5, 50, 50);
//    }
//    else {
//        //_icon.frame = CGRectMake(5, 5, 50, 50);
//    }
//    [super layoutSubviews];
//}
//
//- (void)willTransitionToState:(UITableViewCellStateMask)state {
//    //_icon.frame = CGRectMake(40, 5, 50, 50);
//    [super willTransitionToState:state];
//    
//    
//}
//
//- (void)didTransitionToState:(UITableViewCellStateMask)state {
//    
//    //_icon.frame = CGRectMake(5, 5, 50, 50);
//    [super didTransitionToState:state];
//    
//}

@end
