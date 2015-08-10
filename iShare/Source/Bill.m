//
//  Bill.m
//  iShare
//
//  Created by caoyong on 7/3/15.
//  Copyright (c) 2015 caoyong. All rights reserved.
//

#import "Bill.h"

@implementation Bill

- (void)initWithAmount:(NSString *)amount type:(NSString *)type date:(NSString *)date members:(NSMutableArray *)members creater:(NSString *)creater paidBy:(NSString *)paidBy note:(NSString *)note image:(UIImage *)image {
    
    _amount = amount;
    _type = type;
    _paidBy = paidBy;
    _date = date;
    _members = [NSMutableArray arrayWithArray:members];
    _creater = creater;
    _note = note;
    _image = image;

}

- (void)initWithID:(NSString *)bill_id amount:(NSString *)amount type:(NSString *)type date:(NSString *)date members:(NSMutableArray *)members creater:(NSString *)creater paidBy:(NSString *)paidBy note:(NSString *)note image:(UIImage *)image paidStatus:(NSString *)paidStatus {
    _bill_id = bill_id;
    _amount = amount;
    _type = type;
    _paidBy = paidBy;
    _date = date;
    _members = [NSMutableArray arrayWithArray:members];
    _creater = creater;
    _note = note;
    _image = image;
    _paidStatus = paidStatus;
}

- (void)initWithBill:(Bill *)bill {
    _bill_id = bill.bill_id;
    _amount = bill.amount;
    _type = bill.type;
    _paidBy = bill.paidBy;
    _date = bill.date;
    _members = [NSMutableArray arrayWithArray:bill.members];
    _creater = bill.creater;
    _note = bill.note;
    _image = bill.image;
    _paidStatus = bill.paidStatus;
    _status = bill.status;
}
@end
