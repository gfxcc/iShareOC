//
//  Request.m
//  iShare
//
//  Created by caoyong on 8/1/15.
//  Copyright (c) 2015 caoyong. All rights reserved.
//

#import "Request.h"

@implementation Request_


- (void)initWithSender:(NSString *)sender receiver:(NSString *)receiver type:(NSString *)type content:(NSString *)content response:(NSString *)response request_date:(NSString *)request_date response_date:(NSString *)response_date {
    _sender = sender;
    _receiver = receiver;
    _type = type;
    _content = content;
    _response = response;
    _request_date= request_date;
    _response_date = response_date;
}

- (void)initWithRequest_id:(NSString *)request_id  sender:(NSString *)sender receiver:(NSString *)receiver type:(NSString *)type content:(NSString *)content response:(NSString *)response request_date:(NSString *)request_date response_date:(NSString *)response_date {
    _request_id = request_id;
    _sender = sender;
    _receiver = receiver;
    _type = type;
    _content = content;
    _response = response;
    _request_date= request_date;
    _response_date = response_date;

}
@end
