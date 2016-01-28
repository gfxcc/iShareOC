//
//  FileOperation.m
//  iShare
//
//  Created by caoyong on 1/27/16.
//  Copyright © 2016 caoyong. All rights reserved.
//

#import "FileOperation.h"

@implementation FileOperation

- (NSString*)getFileContent:(NSString*)filename {
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    //make a file name to write the data to using the documents directory:
    NSString *fullName = [NSString stringWithFormat:[NSString stringWithFormat:@"%@/%@",
                                                     documentsDirectory, filename],
                          documentsDirectory];
    NSString *exist = [[NSString alloc] initWithContentsOfFile:fullName
                                                  usedEncoding:nil
                                                         error:nil];
    return exist;
}

- (NSString*)getUsername {
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    //make a file name to write the data to using the documents directory:
    NSString *fullName = [NSString stringWithFormat:[NSString stringWithFormat:@"%@/friends",documentsDirectory],
                          documentsDirectory];
    NSString *exist = [[NSString alloc] initWithContentsOfFile:fullName
                                                  usedEncoding:nil
                                                         error:nil];
    NSArray *array = [exist componentsSeparatedByString:@"\n"];

    return array[0];
}
@end
