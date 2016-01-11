//
//  BillStatistics.h
//  iShare
//
//  Created by caoyong on 1/10/16.
//  Copyright © 2016 caoyong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BillStatistics : NSObject


// call this function when any new bills received
- (void)initDate;
- (void)update;
- (NSArray *)compositionOfFirst:(NSInteger)num;

@end
