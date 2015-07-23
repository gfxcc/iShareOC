//
//  Bill.m
//  iShare
//
//  Created by caoyong on 7/3/15.
//  Copyright (c) 2015 caoyong. All rights reserved.
//

#import "Bill.h"

@implementation Bill

- (void)initWithAmount:(NSString *)amount type:(NSString *)type account:(NSString *)account date:(NSString *)date members:(NSMutableArray *)members creater:(NSString *)creater note:(NSString *)note image:(UIImage *)image {
    
    _amount = amount;
    _type = type;
    _account = account;
    _date = date;
    _members = [NSMutableArray arrayWithArray:members];
    _creater = creater;
    _note = note;
    _image = image;

}

- (void)initWithID:(NSString *)bill_id amount:(NSString *)amount type:(NSString *)type account:(NSString *)account date:(NSString *)date members:(NSMutableArray *)members creater:(NSString *)creater note:(NSString *)note image:(UIImage *)image {
    _bill_id = bill_id;
    _amount = amount;
    _type = type;
    _account = account;
    _date = date;
    _members = [NSMutableArray arrayWithArray:members];
    _creater = creater;
    _note = note;
    _image = image;
}

@end
