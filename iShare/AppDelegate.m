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
#import "ViewController.h"
#import "UIViewController+Utils.h"
#import "EaseStartView.h"
#import "IntroductionViewController.h"
#import <GRPCClient/GRPCCall+Tests.h>
#import "LeftMenuViewController.h"
#import "SlideNavigationController.h"
#import "FileOperation.h"

@interface AppDelegate ()

@property(strong, nonatomic) ViewController *mainUI;
@property(strong, nonatomic) IntroductionViewController *introductionVC;
@property (nonatomic, strong) FileOperation *fileOperation;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSString * host = ServerHost;
    [GRPCCall useInsecureConnectionsForHost:host];
    //[GRPCCall useInsecureConnectionsForHost:@"11"];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    
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
    
    _fileOperation = [[FileOperation alloc] init];
    
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce_1.2.0.2"])
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasLaunchedOnce_1.2.0.2"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [_fileOperation cleanAllFile];
        [self setupIntroductionViewController];
    } else {
        if ([self isLogin]) {
            [self setupTabViewController];
        } else {
            [self setupIntroductionViewController];
        }
    }
    
    [self.window makeKeyAndVisible];
    
//    UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    ViewController *mainView = [mainStoryboard instantiateViewControllerWithIdentifier:@"ViewController"];
//    SlideNavigationController *nav = [[SlideNavigationController alloc] initWithRootViewController:mainView];
//    
//    [self.window setRootViewController:nav];
//
//    mainView.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
//
//    LeftMenuViewController *leftMenu = (LeftMenuViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"LeftMenuViewController"];
//    leftMenu.mainUINavgation = nav;
//    leftMenu.mainUIView = mainView;
//    mainView.leftMenu = leftMenu;
//    [leftMenu viewDidLoad];
//    [SlideNavigationController sharedInstance].leftMenu = leftMenu;
//    [SlideNavigationController sharedInstance].menuRevealAnimationDuration = .18;
//    [SlideNavigationController sharedInstance].enableShadow = NO;
//    
//    
    
    
    return YES;
}

- (bool)isLogin {
    NSString *username = [_fileOperation getUsername];
    if ([username isEqualToString:@""]) {
        return NO;
    }
    return YES;
}

- (void)setupIntroductionViewController{
    _introductionVC = [[IntroductionViewController alloc] init];
    //    [self.window setRootViewController:[[BaseNavigationController alloc] initWithRootViewController:introductionVC]];
    [self.window setRootViewController:_introductionVC];
}

- (void)setupTabViewController{
    [_introductionVC.view setHidden:YES];
    
    UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ViewController *mainView = [mainStoryboard instantiateViewControllerWithIdentifier:@"ViewController"];
    SlideNavigationController *nav = [[SlideNavigationController alloc] initWithRootViewController:mainView];
    
    [self.window setRootViewController:nav];
    
    mainView.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    LeftMenuViewController *leftMenu = (LeftMenuViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"LeftMenuViewController"];
    leftMenu.mainUINavgation = nav;
    leftMenu.mainUIView = mainView;
    mainView.leftMenu = leftMenu;
    
    [leftMenu customedViewDidLoad];

    [SlideNavigationController sharedInstance].leftMenu = leftMenu;
    [SlideNavigationController sharedInstance].menuRevealAnimationDuration = .18;
    [SlideNavigationController sharedInstance].enableShadow = NO;
    
    [self.window setRootViewController:nav];
}


//注册成功，返回deviceToken
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
//    UIAlertView *updateAlert = [[UIAlertView alloc] initWithTitle:@"DeviceTaken" message:[NSString stringWithFormat:@"%@", deviceToken] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//    
//    [updateAlert show];
    NSLog(@"%@", deviceToken);
    NSString *tokenStringOriginal = [NSString stringWithFormat:@"%@", deviceToken];
    NSString *tokenString = @"";
    for (int i = 0; i != tokenStringOriginal.length; i++) {
        if ([tokenStringOriginal characterAtIndex:i] == '<' || [tokenStringOriginal characterAtIndex:i] == '>' || [tokenStringOriginal characterAtIndex:i] == ' ') {
            continue;
        }
        //NSString *tmp = [tokenStringOriginal characterAtIndex:i];
        tokenString = [NSString stringWithFormat:@"%@%c", tokenString, [tokenStringOriginal characterAtIndex:i]];
    }

    
//    ViewController *mainUI = (ViewController *)[UIViewController currentViewController];
//    _mainUI = mainUI;
//
//    mainUI.deviceToken = tokenString;
//    mainUI.deviceTokenBool = true;
//    [mainUI sendToken];
    
    //[_fileOperation setDeviceToken:tokenString];
    
    [self sendToken:tokenString];
}

//注册失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
//    [TSMessage showNotificationWithTitle:@"RegisterFail"
//                                subtitle:[NSString stringWithFormat:@"%@", error]
//                                    type:TSMessageNotificationTypeError];
    NSLog(@"%@", error);
}

//接收到推送消息
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
//    UIAlertView *updateAlert = [[UIAlertView alloc] initWithTitle:@"Get Remote Notification" message:[NSString stringWithFormat:@"%@", userInfo] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//    
//    [updateAlert show];
//    [TSMessage showNotificationInViewController:_mainUI
//                                          title:@"didReceiveRemoteNotification"
//                                       subtitle:[NSString stringWithFormat:@"%@", userInfo]
//                                           type:TSMessageNotificationTypeError
//                                       duration:TSMessageNotificationDurationEndless];
    NSLog(@"%@", userInfo);
}
///////////////////

- (void)sendToken:(NSString*)deviceToken {
    NSString *currentId = [_fileOperation getUserId];
    if ([currentId isEqualToString:@""]) {
        return;
    }
    
    NSString *const kRemoteHost = ServerHost;
    
    Repeated_string *request = [Repeated_string message];
    
    [request.contentArray addObject:currentId];
    [request.contentArray addObject:deviceToken];
    
    Greeter *service = [[Greeter alloc] initWithHost:kRemoteHost];
    [service send_DeviceTokenWithRequest:request handler:^(Inf *response, NSError *error) {
        if (response) {
            NSLog(@"%@", response.information);
            
        } else if(error){
//            [TSMessage showNotificationInViewController:self
//                                                  title:@"GRPC ERROR"
//                                               subtitle:@"send_DeviceTokenWithRequest"
//                                                   type:TSMessageNotificationTypeError
//                                               duration:TSMessageNotificationDurationEndless];
        }
    }];
}



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
