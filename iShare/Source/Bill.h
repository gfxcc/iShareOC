//
//  Bill.h
//  iShare
//
//  Created by caoyong on 7/3/15.
//  Copyright (c) 2015 caoyong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

enum BillStatus {
    OWE,
    LEND,
    PAID
};

@interface Bill : NSObject 

@property (strong, nonatomic) NSString *bill_id;
@property (strong, nonatomic) NSString *amount;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *paidBy;
@property (strong, nonatomic) NSString *date;
@property (strong, nonatomic) NSMutableArray *members;
@property (strong, nonatomic) NSString *creater;
@property (strong, nonatomic) NSString *note;
@property (strong, nonatomic) NSString *image;
@property (strong, nonatomic) NSString *paidStatus;
@property (strong, nonatomic) NSString *typeIcon;
@property (nonatomic) enum BillStatus status;

- (void)initWithAmount:(NSString *)amount type:(NSString *)type date:(NSString *)date members:(NSMutableArray *)members creater:(NSString *)creater paidBy:(NSString *)paidBy note:(NSString *)note image:(UIImage *)image;

- (void)initWithID:(NSString *)bill_id amount:(NSString *)amount type:(NSString *)type date:(NSString *)date members:(NSMutableArray *)members creater:(NSString *)creater paidBy:(NSString *)paidBy note:(NSString *)note image:(NSString *)image paidStatus:(NSString *)paidStatus typeIcon:(NSString *)typeIcon;

- (void)initWithBill:(Bill *)bill;
@end
