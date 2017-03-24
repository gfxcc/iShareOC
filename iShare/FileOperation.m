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
    if (!exist) {
        return @"";
    }
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

- (NSMutableArray*)getBillType {
    NSMutableArray *res = [[NSMutableArray alloc] init];
    NSString *content = [self getFileContent:@"billType"];
    if ([content isEqualToString:@""] || !content) {
        NSMutableArray *array1 = [[NSMutableArray alloc] init];
        [array1 addObject:@"Food & Drink"];// type name
        [array1 addObject:@"ifood"];// type icon name
        [array1 addObject:@"fruit"];
        [array1 addObject:@"apple2-icon"];
        [array1 addObject:@"cafe"];
        [array1 addObject:@"can-icon"];
        [res addObject:array1];
        
        NSMutableArray *array2 = [[NSMutableArray alloc] init];
        [array2 addObject:@"Rent & Fee"];
        [array2 addObject:@"clipboard"];
        [array2 addObject:@"house"];
        [array2 addObject:@"Apartment-icon"];
        [array2 addObject:@"PSEG"];
        [array2 addObject:@"cmyk"];
        [array2 addObject:@"network"];
        [array2 addObject:@"global"];
        [res addObject:array2];
        
        NSMutableArray *array3 = [[NSMutableArray alloc] init];
        [array3 addObject:@"Transportation"];
        [array3 addObject:@"ibus"];
        [array3 addObject:@"Taix"];
        [array3 addObject:@"car"];
        [array3 addObject:@"Train"];
        [array3 addObject:@"train"];
        [array3 addObject:@"Helicopter"];
        [array3 addObject:@"helicopter"];
        [res addObject:array3];
        
        NSMutableArray *array4 = [[NSMutableArray alloc] init];
        [array4 addObject:@"Shopping"];
        [array4 addObject:@"ishopping"];
        [array4 addObject:@"SuperMarket"];
        [array4 addObject:@"cart"];
        [array4 addObject:@"online"];
        [array4 addObject:@"shop"];
        [res addObject:array4];
        
        NSMutableArray *array6 = [[NSMutableArray alloc] init];
        [array6 addObject:@"Borrow & Lend"];
        [array6 addObject:@"booklet"];
        [array6 addObject:@"lend"];
        [array6 addObject:@"compose"];
        [res addObject:array6];
        
        [self setBillType:res];
    } else {
        NSArray *linesOfFile= [content componentsSeparatedByString:@"\n"];
        for (int i = 0; i != linesOfFile.count; i++) {
            NSString *stringOfLine = linesOfFile[i];
            NSMutableArray *contentOfLine = [[NSMutableArray alloc] initWithArray:[stringOfLine componentsSeparatedByString:@"#"]];
            [res addObject:contentOfLine];
            
        }
    }
    
    return res;
}

- (NSString*)getTypeIconByName:(NSString*)type {
    NSMutableArray *quickType = [self getQuickType];
    for (int i = 0; i != quickType.count; i++) {
        if ([quickType[i][0] isEqualToString:type]) {
            return quickType[i][1];
        }
    }
    
    NSMutableArray *billType = [self getBillType];
    for (int i = 0; i != billType.count; i++) {
        for (int j = 0; j < ((NSArray*)billType[i]).count; j += 2) {
            if ([billType[i][j] isEqualToString:type]) {
                return billType[i][j+1];
            }
        }
    }
    
    return @"";
}

- (NSMutableArray*)getQuickType {
    NSMutableArray *result = [[NSMutableArray alloc] init];
    NSString *exist = [self getFileContent:@"quickType"];
    if ([exist isEqualToString:@""] || !exist) {
        exist = @"Food*ifood\nDrink*idrink\nShopping*ishopping\nTransportation*ibus\nHome*ihome\nTrip*itrip";
    }
    NSArray *array = [exist componentsSeparatedByString:@"\n"];
    
    for (int i = 0; i != array.count; i++) {
        NSArray *contentOfLine = [array[i] componentsSeparatedByString:@"*"];
        [result addObject:contentOfLine];
    }
    
    return result;
}

- (NSString*)getDeviceToken {
    NSString *deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];;
    return deviceToken;
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

- (void)setBillType:(NSArray*)billType {
    NSString *content;
    for (int i = 0; i < billType.count; i++) {
        
        NSMutableArray *second = billType[i];
        NSString *line = second[0];
        for (int j = 1; j < second.count; j++) {
            line = [NSString stringWithFormat:@"%@#%@", line, second[j]];
        }
        if (i != 0)
            content = [NSString stringWithFormat:@"%@\n%@", content, line];
        else
            content = line;
    }
    [self setFileContent:content filename:@"billType"];
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

- (void)setQucikTypeWithName:(NSString*)typeName TypeIcon:(NSString*)typeIcon Index:(NSInteger)index {
    if (index < 0 || index > 5)
        return;
    NSString *exist = [self getFileContent:@"quickType"];
    if ([exist isEqualToString:@""]) {
        exist = @"food*ifood\ndrink*idrink\nshopping*ishopping\ntransportation*ibus\nhome*ihome\ntrip*itrip";
    }
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:[exist componentsSeparatedByString:@"\n"]];
    NSString *newLine = [NSString stringWithFormat:@"%@*%@", typeName, typeIcon];
    NSString *newContent;
    array[index] = newLine;
    
    newContent = array[0];
    for (int i = 1; i != 6; i++) {
        newContent = [NSString stringWithFormat:@"%@\n%@", newContent, array[i]];
    }
    
    
    [self setFileContent:newContent filename:@"quickType"];
}

- (void)setDeviceToken:(NSString*)deviceToken {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:deviceToken forKey:@"deviceToken"];
    [defaults synchronize];

}

- (void)cleanAllFile {
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fileName = [NSString stringWithFormat:@"%@/friends",
                          documentsDirectory];
    [@"" writeToFile:fileName
          atomically:NO
            encoding:NSUTF8StringEncoding
               error:nil];
    
    fileName = [NSString stringWithFormat:@"%@/billRecord",
                documentsDirectory];
    [@"" writeToFile:fileName
          atomically:NO
            encoding:NSUTF8StringEncoding
               error:nil];
    
    fileName = [NSString stringWithFormat:@"%@/billType",
                documentsDirectory];
    
    [@"" writeToFile:fileName
          atomically:NO
            encoding:NSUTF8StringEncoding
               error:nil];
    
    fileName = [NSString stringWithFormat:@"%@/statisticsRecord",
                documentsDirectory];
    
    [@"" writeToFile:fileName
          atomically:NO
            encoding:NSUTF8StringEncoding
               error:nil];
    
    fileName = [NSString stringWithFormat:@"%@/settingRecord",
                documentsDirectory];
    
    [@"" writeToFile:fileName
          atomically:NO
            encoding:NSUTF8StringEncoding
               error:nil];
    
    fileName = [NSString stringWithFormat:@"%@/quickType",
                documentsDirectory];
    
    [@"" writeToFile:fileName
          atomically:NO
            encoding:NSUTF8StringEncoding
               error:nil];
    
}

@end
