//
//  DateTranslate.m
//  iShare
//
//  Created by caoyong on 7/25/15.
//  Copyright (c) 2015 caoyong. All rights reserved.
//

#import "DateTranslate.h"

@implementation DateTranslate

- (DateTranslate *)init {

    _dayOfMonth = [[NSMutableDictionary alloc] init];
    [_dayOfMonth setObject:@"31" forKey:@"1"];
    [_dayOfMonth setObject:@"28" forKey:@"2"];
    [_dayOfMonth setObject:@"31" forKey:@"3"];
    [_dayOfMonth setObject:@"30" forKey:@"4"];
    [_dayOfMonth setObject:@"31" forKey:@"5"];
    [_dayOfMonth setObject:@"30" forKey:@"6"];
    [_dayOfMonth setObject:@"31" forKey:@"7"];
    [_dayOfMonth setObject:@"31" forKey:@"8"];
    [_dayOfMonth setObject:@"30" forKey:@"9"];
    [_dayOfMonth setObject:@"31" forKey:@"10"];
    [_dayOfMonth setObject:@"30" forKey:@"11"];
    [_dayOfMonth setObject:@"31" forKey:@"12"];
    
    _dayOfWeek = [[NSMutableDictionary alloc] init];
    [_dayOfWeek setObject:@"0" forKey:@"Sun"];
    [_dayOfWeek setObject:@"1" forKey:@"Mon"];
    [_dayOfWeek setObject:@"2" forKey:@"Tue"];
    [_dayOfWeek setObject:@"3" forKey:@"Wed"];
    [_dayOfWeek setObject:@"4" forKey:@"Thu"];
    [_dayOfWeek setObject:@"5" forKey:@"Fri"];
    [_dayOfWeek setObject:@"6" forKey:@"Sat"];
    return self;
}




@end

