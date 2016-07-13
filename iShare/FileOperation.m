//
//  FileOperation.m
//  iShare
//
//  Created by caoyong on 1/27/16.
//  Copyright © 2016 caoyong. All rights reserved.
//

#import "FileOperation.h"

@implementation FileOperation

#pragma mark - character check

- (BOOL)checkString:(NSString*)string cha:(char)cha {
    for (int i = 0; i != string.length; i++) {
        if ([string characterAtIndex:i] == cha) {
            return NO;
        }
    }
    return YES;
}

#pragma mark - read functions

- (NSString*)getFileContent:(NSString*)filename {
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    //make a file name to write the data to using the documents directory:
    NSString *fullName = [NSString stringWithFormat:@"%@/%@", documentsDirectory, filename];
    NSString *exist = [[NSString alloc] initWithContentsOfFile:fullName
                                                  usedEncoding:nil
                                                         error:nil];
    return exist;
}

- (NSString*)getUsername {

    NSString *exist = [self getFileContent:@"friends"];
    NSArray *array = [exist componentsSeparatedByString:@"\n"];

    NSString *line = array[0];
    NSArray *content = [line componentsSeparatedByString:@"*"];
    return content[0];
}

- (NSString*)getUserIdByUsername:(NSString*)username {
    NSString *fileContent = [self getFileContent:@"friends"];
    NSArray *nameList = [fileContent componentsSeparatedByString:@"\n"];
    for (int i = 0; i != nameList.count; i++) {
        NSString *line = nameList[i];
        NSArray *nameAndId = [line componentsSeparatedByString:@"*"];
        if ([(NSString*)nameAndId[0] isEqualToString:username]) {
            return nameAndId[1];
        }
    }
    return nil;
}

- (NSString*)getUsernameByUserId:(NSString*)userId {
    NSString *fileContent = [self getFileContent:@"friends"];
    NSArray *nameList = [fileContent componentsSeparatedByString:@"\n"];
    for (int i = 0; i != nameList.count; i++) {
        NSString *line = nameList[i];
        NSArray *nameAndId = [line componentsSeparatedByString:@"*"];
        if ([(NSString*)nameAndId[1] isEqualToString:userId]) {
            return nameAndId[0];
        }
    }
    return @"nil";
}

- (NSString*)getLastModifiedByUserId:(NSString*)userId {
    NSString *fileContent = [self getFileContent:@"friends"];
    NSArray *nameList = [fileContent componentsSeparatedByString:@"\n"];
    for (int i = 0; i != nameList.count; i++) {
        NSString *line = nameList[i];
        NSArray *content = [line componentsSeparatedByString:@"*"];
        if ([(NSString*)content[1] isEqualToString:userId]) {
            if (content.count < 3)
                return @"nil";
            return content[2];
        }
    }
    return @"nil";
}


- (NSString*)getUserId {


    NSString *exist = [self getFileContent:@"friends"];
    NSArray *array = [exist componentsSeparatedByString:@"\n"];
    
    NSString *line = array[0];
    NSArray *content = [line componentsSeparatedByString:@"*"];
    if (content.count == 2) {
        return content[1];
    }
    return @"";
}

- (NSArray*)getFriendsNameList {

    NSString *exist = [self getFileContent:@"friends"];
    NSArray *array = [exist componentsSeparatedByString:@"\n"];
    
    if (array.count < 2) {
        NSArray *empyt = [[NSArray alloc] init];
        return empyt;
    }
    
    NSMutableArray *friendNameList = [[NSMutableArray alloc] init];
    for (int i = 1; i != array.count; i++) {
        NSString *line = array[i];
        NSArray *contentOfLine = [line componentsSeparatedByString:@"*"];
        [friendNameList addObject:contentOfLine[0]];
    }

    NSArray *result = [[NSArray alloc] initWithArray:friendNameList];
    return result;
}

- (NSArray*)getFriendsIdList {
    NSString *exist = [self getFileContent:@"friends"];
    NSArray *array = [exist componentsSeparatedByString:@"\n"];
    
    if (array.count < 2) {
        NSArray *empyt = [[NSArray alloc] init];
        return empyt;
    }
    
    NSMutableArray *friendIdList = [[NSMutableArray alloc] init];
    for (int i = 1; i != array.count; i++) {
        NSString *line = array[i];
        NSArray *contentOfLine = [line componentsSeparatedByString:@"*"];
        [friendIdList addObject:contentOfLine[1]];
    }
    
    NSArray *result = [[NSArray alloc] initWithArray:friendIdList];
    return result;
}

- (NSArray*)getFriendsLastModifiedList {
    NSString *exist = [self getFileContent:@"friends"];
    NSArray *array = [exist componentsSeparatedByString:@"\n"];
    
    if (array.count < 2) {
        NSArray *empyt = [[NSArray alloc] init];
        return empyt;
    }
    
    NSMutableArray *friendIdList = [[NSMutableArray alloc] init];
    for (int i = 1; i != array.count; i++) {
        NSString *line = array[i];
        NSArray *contentOfLine = [line componentsSeparatedByString:@"*"];
        [friendIdList addObject:contentOfLine[2]];
    }
    
    NSArray *result = [[NSArray alloc] initWithArray:friendIdList];
    return result;
}

#pragma mark - write functions

- (void)setFileContent:(NSString*)content filename:(NSString*)filename {
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    //make a file name to write the data to using the documents directory:
    NSString *fullName = [NSString stringWithFormat:@"%@/%@",documentsDirectory, filename];
    
    [content writeToFile:fullName
                 atomically:NO
                   encoding:NSUTF8StringEncoding
                      error:nil];
}


- (void)setUserId:(NSString *)userId {

    NSString *exist = [self getFileContent:@"friends"];
    NSArray *array = [exist componentsSeparatedByString:@"\n"];
    
    NSString *firstLine = array[0];
    NSArray *contentOfFirstline = [firstLine componentsSeparatedByString:@"*"];
    NSString *newLine = [NSString stringWithFormat:@"%@*%@", contentOfFirstline[0], userId];
    
    NSString *newContent = newLine;
    for (int i = 1; i < array.count; i++) {
        newContent = [NSString stringWithFormat:@"%@\n%@", newContent, array[i]];
    }
    
    [self setFileContent:newContent filename:@"friends"];
}

- (void)setUsername:(NSString *)username {

    NSString *exist = [self getFileContent:@"friends"];
    NSArray *array = [exist componentsSeparatedByString:@"\n"];
    
    NSString *firstLine = array[0];
    NSArray *contentOfFirstline = [firstLine componentsSeparatedByString:@"*"];
    NSString *newLine;
    if (contentOfFirstline.count == 2) {
        newLine = [NSString stringWithFormat:@"%@*%@", username, contentOfFirstline[1]];
    } else {
        newLine = username;
    }
    
    NSString *newContent = newLine;
    for (int i = 1; i < array.count; i++) {
        newContent = [NSString stringWithFormat:@"%@\n%@", newContent, array[i]];
    }
    
    [self setFileContent:newContent filename:@"friends"];
}

- (void)setUsernameAndUserId:(NSString*)nameAndId {

    NSString *exist = [self getFileContent:@"friends"];
    NSArray *array = [exist componentsSeparatedByString:@"\n"];
    
    //NSString *firstLine = array[0];
    NSString *newLine = nameAndId;
    
    NSString *newContent = newLine;
    for (int i = 1; i < array.count; i++) {
        newContent = [NSString stringWithFormat:@"%@\n%@", newContent, array[i]];
    }
    
    [self setFileContent:newContent filename:@"friends"];
}

- (void)setUsername:(NSString*)username userId:(NSString*)userId {
    [self setUsernameAndUserId:[NSString stringWithFormat:@"%@*%@", username, userId]];
}

- (void)setFriendList:(NSArray*)nameList UserId:(NSArray*)idList LastModified:(NSArray*)lastModifiedList {
    NSString *exist = [self getFileContent:@"friends"];
    NSArray *array = [exist componentsSeparatedByString:@"\n"];
    
    NSString *newContent = array[0];
    for (int i = 0; i != nameList.count; i++) {
        NSString *line = [NSString stringWithFormat:@"%@*%@*%@", nameList[i], idList[i], lastModifiedList[i]];
        
        newContent = [NSString stringWithFormat:@"%@\n%@", newContent, line];
    }
    
    [self setFileContent:newContent filename:@"friends"];
}



@end
