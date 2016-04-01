//
//  FileOperation.h
//  iShare
//
//  Created by caoyong on 1/27/16.
//  Copyright © 2016 caoyong. All rights reserved.
//
// -friends
//      username*userId
//      friendname*friendId
//          *
//          *

// -billRecord

// -billType

// -statisticsRecord

// -settingRecord

// -quickType

#import <Foundation/Foundation.h>

@interface FileOperation : NSObject

// string check

// if string contain cha return NO
- (BOOL)checkString:(NSString*)string cha:(char)cha;

// read
- (NSString*)getFileContent:(NSString*)filename;
- (NSString*)getUsername;
- (NSString*)getUserId;
- (NSString*)getUserIdByUsername:(NSString*)username;
- (NSString*)getUsernameByUserId:(NSString*)userId;
- (NSArray*)getFriendsNameList;
- (NSArray*)getFriendsIdList;
- (NSArray*)getQuickType;


// write
- (void)setFileContent:(NSString*)content filename:(NSString*)filename;
- (void)setUserId:(NSString*)userId;
- (void)setUsername:(NSString*)username;
- (void)setFriendListWithName:(NSArray*)nameList UserId:(NSArray*)idList;
- (void)setUsernameAndUserId:(NSString*)nameAndId;
- (void)setUsername:(NSString*)username userId:(NSString*)userId;
- (void)setQuickType:(NSArray*)quickType;


@end
