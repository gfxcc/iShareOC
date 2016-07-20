//
//  ViewController.h
//  iShare
//
//  Created by caoyong on 5/9/15.
//  Copyright (c) 2015 caoyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftMenuViewController.h"
#import "SlideNavigationController.h"
#import <gRPC/RxLibrary/GRXWriter.h>
#import <gRPC/RxLibrary/GRXWriteable.h>
#import <gRPC/RxLibrary/GRXWriter+Immediate.h>
#import "RKTabView.h"
#import "ABCIntroView.h"
#import "ComBinedImage.h"
#import "IntroductionViewController.h"


@interface ViewController : UIViewController <SlideNavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *addNewButtion;
@property (weak, nonatomic) IBOutlet UIButton *grpc_test;
@property (weak, nonatomic) IBOutlet RKTabView *standardView;
@property (weak, nonatomic) IBOutlet UIView *statusView;
@property (weak, nonatomic) IBOutlet UILabel *helloWorld;

- (void)buttonHighlight;

@property(strong, nonatomic) NSMutableArray *bill_latest;
@property(strong, nonatomic) NSMutableArray *bills;
@property(strong, nonatomic) LeftMenuViewController *leftMenu;
@property(strong, nonatomic) NSMutableArray *request;
@property(strong, nonatomic) NSString *deviceToken;
@property(strong, nonatomic) NSString *user_id;
@property(strong, nonatomic) NSString *friendUsername;

@property(strong, nonatomic) RKTabItem *billList;
@property(strong, nonatomic) RKTabItem *analyze;
@property(strong, nonatomic) RKTabItem *messageCenter;
@property(atomic) BOOL requestProcessing;
@property(atomic) BOOL billProcessing;
@property(atomic) BOOL updateAllBillsProcessing;
@property(nonatomic) BOOL deviceTokenBool;
@property(nonatomic) int deviceModel;

//@property(strong, nonatomic) id<GRXWriter> requestsWriter;

- (void)loadCharts;
- (void)removeCharts;
- (void)openLeftMenu;
- (void)hideMainUI;
- (void)changeShadow;
- (void)obtain_bills;
- (void)updateAllBills;
- (void)sendToken; // send deviceToken to service
- (void)checkFlag;

- (void)viewBillWithFriend:(NSString*)username;

@end

