//
//  BillStatistics.m
//  iShare
//
//  Created by caoyong on 1/10/16.
//  Copyright © 2016 caoyong. All rights reserved.
//

#import "BillStatistics.h"

@implementation BillStatistics

/*
 type - amount
 
 */
- (void)initDate {
    
    
    NSMutableDictionary *amountWithType = [[NSMutableDictionary alloc] init];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    //make a file name to write the data to using the documents directory:
    NSString *fileName = [NSString stringWithFormat:@"%@/billRecord",
                          documentsDirectory];
    NSString *exist = [[NSString alloc] initWithContentsOfFile:fileName
                                                  usedEncoding:nil
                                                         error:nil];
    NSArray *bills = [exist componentsSeparatedByString:@"\n"];
    
    if ([exist isEqualToString:@""]) {
        NSLog(@"no record for statistics");
        return;
    }
    for (int i = 0; i != bills.count; i++) {
        NSArray *bill_content = [bills[i] componentsSeparatedByString:@"*"];
        /* amount = 1; type = 2*/
        NSString *amount = [amountWithType valueForKey:bill_content[2]];
        if (!amount) {
            /* this type not exist */
            [amountWithType setValue:bill_content[1] forKey:bill_content[2]];
        } else {
            double newAmount = amount.doubleValue + [bill_content[1] doubleValue];
            [amountWithType setValue:[NSString stringWithFormat:@"%f", newAmount] forKey:bill_content[2]];
        }
    }
    
    /* save date to file */
    NSArray *allKey = [amountWithType keysSortedByValueUsingComparator:^(id obj1, id obj2) {
        
        if ([obj1 doubleValue] < [obj2 doubleValue]) {
            
            return (NSComparisonResult)NSOrderedDescending;
        }
        if ([obj1 doubleValue] > [obj2 doubleValue]) {
            
            return (NSComparisonResult)NSOrderedAscending;
        }
        
        return (NSComparisonResult)NSOrderedSame;}];
    NSString *statistics = @"";
    for (int i = 0; i != allKey.count; i++) {
        NSString *line = [NSString stringWithFormat:@"%@*%@", allKey[i], [amountWithType valueForKey:allKey[i]]];
        if (i == 0) {
            statistics = line;
        } else {
            statistics = [NSString stringWithFormat:@"%@\n%@", statistics, line];
        }
    }
    
    fileName = [NSString stringWithFormat:@"%@/statisticsRecord",
                          documentsDirectory];
    [statistics writeToFile:fileName
               atomically:NO
                 encoding:NSUTF8StringEncoding
                    error:nil];
}

- (void)update {

}


/*
 array with nsstring
 type*percent
 
 */
- (NSArray *)compositionOfFirst:(NSInteger)num {
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    //make a file name to write the data to using the documents directory:
    NSString *fileName = [NSString stringWithFormat:@"%@/statisticsRecord",
                          documentsDirectory];
    NSString *exist = [[NSString alloc] initWithContentsOfFile:fileName
                                                  usedEncoding:nil
                                                         error:nil];
    if ([exist isEqualToString:@""]) {
        return nil;
    }
    NSArray *statistics = [exist componentsSeparatedByString:@"\n"];
    double allAmount = 0;
    for (int i = 0; i != statistics.count; i++) {
        NSArray *content = [statistics[i] componentsSeparatedByString:@"*"];
        allAmount += [content[1] doubleValue];
        
        if (i < num) {
            [result addObject:statistics[i]];
        }
    }
    
    // translate amount to percent
    for (int i = 0; i != result.count; i++) {
        NSMutableArray *content = [[NSMutableArray alloc] initWithArray:[result[i] componentsSeparatedByString:@"*"]];
        content[1] = [NSString stringWithFormat:@"%.2f", [content[1] doubleValue] / allAmount];
        result[i] = content;
    }
    
    NSArray *result_ = [[NSArray alloc] initWithArray:result];
    return result_;
}
@end
