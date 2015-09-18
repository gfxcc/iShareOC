//
//  AppDelegate.m
//  iShare
//
//  Created by caoyong on 5/9/15.
//  Copyright (c) 2015 caoyong. All rights reserved.
//

#import "AppDelegate.h"
#include <TSMessage.h>
#import <gRPC_pod/IShare.pbrpc.h>
#import <gRPC_pod/IShare.pbobjc.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    UIUserNotificationSettings* notificationSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
    
    //判断是否注册了远程通知
    if (![application isRegisteredForRemoteNotifications]) {
        UIUserNotificationSettings *uns = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound) categories:nil];
        [application registerUserNotificationSettings:uns];
        //注册远程通知
        [application registerForRemoteNotifications];
    }
    return YES;
}

//注册成功，返回deviceToken
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    UIAlertView *updateAlert = [[UIAlertView alloc] initWithTitle:@"DeviceTaken" message:[NSString stringWithFormat:@"%@", deviceToken] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    [updateAlert show];
    NSLog(@"%@", deviceToken);
}

//注册失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    [TSMessage showNotificationWithTitle:@"RegisterFail"
                                subtitle:[NSString stringWithFormat:@"%@", error]
                                    type:TSMessageNotificationTypeError];
    NSLog(@"%@", error);
}

//接收到推送消息
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    UIAlertView *updateAlert = [[UIAlertView alloc] initWithTitle:@"Get Remote Notification" message:[NSString stringWithFormat:@"%@", userInfo] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    [updateAlert show];
    NSLog(@"%@", userInfo);
}
///////////////////

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
