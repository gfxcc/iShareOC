//
//  Request.h
//  iShare
//
//  Created by caoyong on 8/1/15.
//  Copyright (c) 2015 caoyong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Request_ : NSObject

@property (strong, nonatomic) NSString *request_id;
@property (strong, nonatomic) NSString *sender;
@property (strong, nonatomic) NSString *receiver;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSString *response;
@property (strong, nonatomic) NSString *request_date;
@property (strong, nonatomic) NSString *response_date;

- (void)initWithSender:(NSString *)sender receiver:(NSString *)receiver type:(NSString *)type content:(NSString *)content response:(NSString *)response request_date:(NSString *)request_date response_date:(NSString *)response_date;

- (void)initWithRequest_id:(NSString *)request_id  sender:(NSString *)sender receiver:(NSString *)receiver type:(NSString *)type content:(NSString *)content response:(NSString *)response request_date:(NSString *)request_date response_date:(NSString *)response_date;

@end
