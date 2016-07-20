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
- (NSString*)getLastModifiedByUserId:(NSString*)userId;
- (NSArray*)getFriendsNameList;
- (NSArray*)getFriendsIdList;
- (NSArray*)getFriendsLastModifiedList;

- (NSString*)getDeviceToken;

- (NSMutableArray*)getQuickType;


// write
- (void)setFileContent:(NSString*)content filename:(NSString*)filename;
- (void)setUserId:(NSString*)userId;
- (void)setUsername:(NSString*)username;
- (void)setFriendList:(NSArray*)nameList UserId:(NSArray*)idList LastModified:(NSArray*)lastModifiedList;
- (void)setUsernameAndUserId:(NSString*)nameAndId;
- (void)setUsername:(NSString*)username userId:(NSString*)userId;
- (void)setQuickType:(NSArray*)quickType;
- (void)setQucikTypeWithName:(NSString*)typeName TypeIcon:(NSString*)typeIcon Index:(NSInteger)index;

- (void)setDeviceToken:(NSString*)deviceToken;
- (void)cleanAllFile;
@end
