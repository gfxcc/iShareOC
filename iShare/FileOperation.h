//
//  FileOperation.h
//  iShare
//
//  Created by caoyong on 1/27/16.
//  Copyright © 2016 caoyong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileOperation : NSObject


- (NSString*)getFileContent:(NSString*)filename;
- (NSString*)getUsername;

@end
