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
    
    //return self;
}

- (void)willTransitionToState:(UITableViewCellStateMask)state {
    
    [super willTransitionToState:state];
    
    _icon.frame = CGRectMake(40, 5, 50, 50);
}

- (void)didTransitionToState:(UITableViewCellStateMask)state {
    
    [super didTransitionToState:state];
    
    _icon.frame = CGRectMake(5, 5, 50, 50);
    
}

@end
