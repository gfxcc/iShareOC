//
//  ViewController.m
//  iShare
//
//  Created by caoyong on 5/9/15.
//  Copyright (c) 2015 caoyong. All rights reserved.
//

#import "ViewController.h"
#import <TSMessageView.h>
#import <gRPC_pod/IShare.pbrpc.h>
#import <gRPC_pod/IShare.pbobjc.h>
#import <GRPCClient/GRPCCall+Tests.h>
#import <QuartzCore/QuartzCore.h>
#import "Bill.h"
#import "BillsTableViewCell.h"
#import "RKTabView.h"
#import "DateTranslate.h"
#import "BillDetailViewController.h"
#import "BillListViewController.h"
#import "AnalyzeViewController.h"
#import "Request.h"
#import "MessageCenterViewController.h"
#import "AddNewShareViewController.h"
#import "AppDelegate.h"
#import "popMenu.h"
#import "BillStatistics.h"
#import <JDStatusBarNotification/JDStatusBarNotification.h>
#import <PNChart/PNChart.h>
#import "FileOperation.h"
#import "BillListWithFriendViewController.h"
#import "IntroductionViewController.h"
#import "BaseNavigationController.h"


#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

@interface ViewController ()

//@property (strong, nonatomic) BillsTableViewCell *lastCell;
@property (strong, nonatomic) BillsTableViewCell *todayCell;
@property (strong, nonatomic) BillsTableViewCell *thisWeekCell;
@property (strong, nonatomic) BillsTableViewCell *thisMonthCell;
@property (nonatomic, strong) PopMenu *myPopMenu;
@property (nonatomic, strong) NSString *quickType;
@property (nonatomic, strong) PNPieChart *pieChart;
@property (nonatomic, strong) UIView *legend;
@property (nonatomic, strong) NSArray *quickTypeList;

@property (nonatomic, strong) FileOperation *fileOperation;

@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated {
    
    
    [super viewWillAppear:animated];

    //[_standardView disableAllItems];
    [self.tableView deselectRowAtIndexPath:[_tableView indexPathForSelectedRow] animated:YES];
    
    
}

- (void)viewDidLayoutSubviews {
    // draw line
    
    
    if (kDevice_Is_iPhone6Plus) {
        _statusView.frame = CGRectMake(_statusView.frame.origin.x, _statusView.frame.origin.y, _statusView.frame.size.width, _statusView.frame.size.height - 55);
        _addNewButtion.frame = CGRectMake(_addNewButtion.frame.origin.x, _addNewButtion.frame.origin.y - 55, _addNewButtion.frame.size.width, _addNewButtion.frame.size.height);
        _tableView.frame = CGRectMake(_tableView.frame.origin.x, _tableView.frame.origin.y - 55, _tableView.frame.size.width, _tableView.frame.size.height + 55);
    } else if (kDevice_Is_iPhone5) {
        _statusView.frame = CGRectMake(_statusView.frame.origin.x, _statusView.frame.origin.y, _statusView.frame.size.width, _statusView.frame.size.height + 55);
        _addNewButtion.frame = CGRectMake(_addNewButtion.frame.origin.x, _addNewButtion.frame.origin.y + 55, _addNewButtion.frame.size.width, _addNewButtion.frame.size.height);
        _tableView.frame = CGRectMake(_tableView.frame.origin.x, _tableView.frame.origin.y + 55, _tableView.frame.size.width, _tableView.frame.size.height);
    } else if (kDevice_Is_iPhone4) {
        _statusView.frame = CGRectMake(_statusView.frame.origin.x, _statusView.frame.origin.y, _statusView.frame.size.width, _statusView.frame.size.height + 110);
        _addNewButtion.frame = CGRectMake(_addNewButtion.frame.origin.x, _addNewButtion.frame.origin.y + 110, _addNewButtion.frame.size.width, _addNewButtion.frame.size.height);
        _tableView.frame = CGRectMake(_tableView.frame.origin.x, _tableView.frame.origin.y + 110, _tableView.frame.size.width, _tableView.frame.size.height);
        
    }
    CALayer *line1 = [CALayer layer];
    line1.frame = CGRectMake(_tableView.frame.origin.x, _tableView.frame.origin.y - 1, _tableView.frame.size.width, 1.0f);
    line1.backgroundColor = RGB(199, 199, 199).CGColor;
    [self.view.layer addSublayer:line1];
    
}

- (void)viewDidAppear:(BOOL)animated {
    // layerout subview
    [self loadCharts];
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    

    _fileOperation = [[FileOperation alloc] init];
    _user_id = [_fileOperation getUserId];
    
    
    
    if ([UIScreen mainScreen].bounds.size.height <= 568) {
        _deviceModel = 5;
    } else {
        _deviceModel = 6;
    }
    // clear notification number
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    [self.navigationController.navigationBar setTintColor:RGB(255, 255, 255)];
    //[self.navigationController.navigationBar setBackgroundColor:RGB(78, 107, 165)];
    self.navigationController.navigationBar.barTintColor = RGB(26, 142, 180);
    
    //self.view.backgroundColor = RGB(211, 214, 219);
    [TSMessage setDefaultViewController:self.navigationController];

    
    [_addNewButtion setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    _addNewButtion.layer.cornerRadius = 5;
    _addNewButtion.clipsToBounds = YES;
    [_addNewButtion addTarget:self action:@selector(buttonHighlight) forControlEvents:UIControlEventTouchDown];
    [_addNewButtion addTarget:self action:@selector(buttonNormal) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    _tableView.dataSource = self;
    _tableView.delegate = self;

    
    // Do any additional setup after loading the view, typically from a nib.
    
    if (![self isLogin]) {

        IntroductionViewController *introductionVC = [[IntroductionViewController alloc] init];
        [self.navigationController presentViewController:introductionVC animated:YES completion:nil];
    }
    // modify tableViewCells
    static NSString *CellIdentifier = @"BillListCell";
    
    //_lastCell = [_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    _todayCell = [_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    _thisWeekCell = [_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    _thisMonthCell = [_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    _bill_latest = [[NSMutableArray alloc] init];
    _bills = [[NSMutableArray alloc] init];
    _request = [[NSMutableArray alloc] init];
    
    //*

    //*
    
    // RKTabView Setting
    _billList = [RKTabItem createButtonItemWithImage:[UIImage imageNamed:@"project_normal"] target:self selector:@selector(buttonTabPressedBillList:)];
    _analyze = [RKTabItem createButtonItemWithImage:[UIImage imageNamed:@"task_normal"] target:self selector:@selector(buttonTabPressedAnalyze:)];
    _messageCenter = [RKTabItem createButtonItemWithImage:[UIImage imageNamed:@"privatemessage_normal"] target:self selector:@selector(buttonTabPressedMessageCenter:)];
    
    
    //self.standardView.horizontalInsets = HorizontalEdgeInsetsMake(25, 25);
    
    self.standardView.darkensBackgroundForEnabledTabs = YES;
    self.standardView.drawSeparators = YES;
    self.standardView.tabItems = @[_billList, _analyze, _messageCenter];
    //self.standardView.delegate = (id<RKTabViewDelegate>)self;
    
//    _statusView.layer.cornerRadius = 5.0f;
//    _statusView.layer.masksToBounds = YES;
    
    
    [self keepSyn];
    [self loadLastestBill];
    [self obtain_bills];
    [self create_folder];

}

- (void)buttonTabPressedBillList:(id)sender {

    [self performSegueWithIdentifier:@"billList" sender:self];

}

- (void)buttonTabPressedAnalyze:(id)sender {
    [self performSegueWithIdentifier:@"analyze" sender:self];
}

- (void)buttonTabPressedMessageCenter:(id)sender {
    [self performSegueWithIdentifier:@"messageCenter" sender:self];
}


- (void)buttonHighlight {

    _addNewButtion.backgroundColor = RGB(23, 102, 137);
}

- (void)buttonNormal {

    _addNewButtion.backgroundColor = RGB(26, 142, 180);
}

- (IBAction)addNewShare:(id)sender {

    _quickTypeList = [_fileOperation getQuickType];
    NSArray *menuItems = @[
                           [[MenuItem alloc] initWithTitle:_quickTypeList[0][0] iconName:_quickTypeList[0][1] index:0],
                           [[MenuItem alloc] initWithTitle:_quickTypeList[1][0] iconName:_quickTypeList[1][1] index:1],
                           [[MenuItem alloc] initWithTitle:_quickTypeList[2][0] iconName:_quickTypeList[2][1] index:2],
                           [[MenuItem alloc] initWithTitle:_quickTypeList[3][0] iconName:_quickTypeList[3][1] index:3],
                           [[MenuItem alloc] initWithTitle:_quickTypeList[4][0] iconName:_quickTypeList[4][1] index:4],
                           [[MenuItem alloc] initWithTitle:_quickTypeList[5][0] iconName:_quickTypeList[5][1] index:5],
                           ];
    if (!_myPopMenu || YES) {
        _myPopMenu = [[PopMenu alloc] initWithFrame:[UIScreen mainScreen].bounds items:menuItems];
        _myPopMenu.perRowItemCount = 3;
        _myPopMenu.menuAnimationType = kPopMenuAnimationTypeSina;
    }
    
    _myPopMenu.didSelectedItemCompletion = ^(MenuItem *selectedItem){

        if (!selectedItem)
            return;
        switch (selectedItem.index) {
            case 0:
                _quickType = _quickTypeList[0][0];
                [self performSegueWithIdentifier:@"createShareView" sender:self];
                break;
            case 1:
                _quickType = _quickTypeList[1][0];
                [self performSegueWithIdentifier:@"createShareView" sender:self];
                break;
            case 2:
                _quickType = _quickTypeList[2][0];
                [self performSegueWithIdentifier:@"createShareView" sender:self];
                break;
            case 3:
                _quickType = _quickTypeList[3][0];
                [self performSegueWithIdentifier:@"createShareView" sender:self];
                break;
            case 4:
                _quickType = _quickTypeList[4][0];
                [self performSegueWithIdentifier:@"createShareView" sender:self];
                break;
            case 5:
                _quickType = _quickTypeList[5][0];
                [self performSegueWithIdentifier:@"createShareView" sender:self];
                break;
            default:
                NSLog(@"%@",selectedItem.title);
                break;
        }
    };
    [_myPopMenu showMenuAtView:[UIApplication sharedApplication].keyWindow startPoint:CGPointMake(0, -100) endPoint:CGPointMake(0, -100)];
     
}



- (void)sendToken {
    NSString *currentId = [_fileOperation getUserId];
//    if (!_deviceTokenBool || [currentId isEqualToString:@""]) {
//        NSLog(@"deviceToken does not exist!");
//        return;
//    }
    
    NSString *const kRemoteHost = ServerHost;
    
    Repeated_string *request = [Repeated_string message];
    
    [request.contentArray addObject:currentId];
    NSString *t = [_fileOperation getDeviceToken];
    [request.contentArray addObject:[_fileOperation getDeviceToken]];
    
    Greeter *service = [[Greeter alloc] initWithHost:kRemoteHost];
    [service send_DeviceTokenWithRequest:request handler:^(Inf *response, NSError *error) {
        if (response) {
            NSLog(@"%@", response.information);
            
        } else if(error){
            [TSMessage showNotificationInViewController:self
                                                  title:@"GRPC ERROR"
                                               subtitle:@"send_DeviceTokenWithRequest"
                                                   type:TSMessageNotificationTypeError
                                               duration:TSMessageNotificationDurationEndless];
        }
    }];
}



- (void)checkFlag {
    //AppDelegate appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    //AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    [TSMessage showNotificationInViewController:self
//                                          title:@"checked flag"
//                                       subtitle:[NSString stringWithFormat:@"%ld", (long)appDelegate.synchronismFlag]
//                                           type:TSMessageNotificationTypeError
//                                       duration:TSMessageNotificationDurationEndless];
//    [TSMessage showNotificationWithTitle:@"GRPC ERROR"
//                                subtitle:@"obtain_request"
//                                    type:TSMessageNotificationTypeError];
}


//start syn
- (void)keepSyn {
    NSString * const kRemoteHost = ServerHost;


    Inf *request = [Inf message];
    request.information = _user_id;

    Synchronism *service = [[Synchronism alloc] initWithHost:kRemoteHost];

    [service synWithRequest:request eventHandler:^(BOOL done, Syn_data *response, NSError *error) {
        if (!done) {
            NSLog(@"receive message:%@ %@ %@ %@", response.friend_p, response.bill, response.delete_p, response.request);
            
            if ([response.friend_p isEqualToString:@"1"]) {
                [_leftMenu obtain_friends];
            }
            if ([response.bill isEqualToString:@"1"]) {
                [self obtain_bills];
            }
            if ([response.delete_p isEqualToString:@"1"]) {
                [self updateAllBills];
            }
            if ([response.request isEqualToString:@"1"]) {
                [self obtain_request];
            } else if ([response.request isEqualToString:@"2"]) {
                [self obtain_requestLog];
            }
//            
//            if ([response.friend_p isEqualToString:@"0"]) {
//                
//            } else if ([response.friend_p isEqualToString:@"1"]) {
//                [_leftMenu obtain_friends];
//            }
//            
//            if ([response.bill isEqualToString:@"0"]) {
//                _billProcessing = NO;
//            } else if ([response.bill isEqualToString:@"1"]) {
//                _billProcessing = YES;
//                [self obtain_bills];
//            }
//            
//            if ([response.delete_p isEqualToString:@"0"]) {
//                _updateAllBillsProcessing = NO;
//            } else if ([response.delete_p isEqualToString:@"1"] && !_updateAllBillsProcessing) {
//                _updateAllBillsProcessing = YES;
//                [self updateAllBills];
//            }
//            
//            if ([response.request isEqualToString:@"0"]) {
//                _requestProcessing = NO;
//            } else if ([response.request isEqualToString:@"1"] && !_requestProcessing) {
//                _requestProcessing = YES;
//                [self obtain_request];
//            } else if ([response.request isEqualToString:@"2"] && !_requestProcessing) {
//                _requestProcessing = YES;
//                [self obtain_requestLog];
//            }
            
        } else if (error) {
            NSLog(@"Finished with error: %@", error);
//            [TSMessage showNotificationWithTitle:@"Warning"
//                                        subtitle:@"Server is unavailable now!"
//                                            type:TSMessageNotificationTypeWarning];
            [self performSelector:@selector(keepSyn) withObject:nil afterDelay:1.0f];
        } else {
            //requestsWriter.state = GRXWriterStateStarted;
            //NSLog(@"state:%li", (long)requestsWriter.state);
        }
    }];
    
}

- (void)obtain_requestLog {
    
    [_request removeAllObjects];
    NSString * const kRemoteHost = ServerHost;
    Inf *request = [Inf message];
    request.information = _user_id;
    
    Greeter *service = [[Greeter alloc] initWithHost:kRemoteHost];
    [service obtain_requestLogWithRequest:request eventHandler:^(BOOL done, Request *response, NSError *error){
        if (!done) {
            Request_ *req = [[Request_ alloc] init];
            [req initWithRequest_id:response.requestId sender:response.sender receiver:response.receiver type:response.type content:response.content response:response.response request_date:response.requestDate response_date:response.responseDate];
            [_request addObject:req];
            
        } else if (error) {
            [TSMessage showNotificationWithTitle:@"Sorry"
                                        subtitle:@"Can not connect to server. Please try again later"
                                            type:TSMessageNotificationTypeError];
        } else {
            if (_request.count > 0) {
                Request_ *req = _request[0];
                if ([req.type isEqualToString:@"payment"]) {
                    if ([req.response isEqualToString:@"OK"]) {
                        NSArray *content = [req.content componentsSeparatedByString:@"*"];
                        
                        [TSMessage showNotificationWithTitle:@"Success"
                                                    subtitle:[NSString stringWithFormat:@"%@ paid %@ : %@ successed", req.sender, req.receiver, content[3]]
                                                        type:TSMessageNotificationTypeSuccess];
                    } else {
                        NSArray *content = [req.content componentsSeparatedByString:@"*"];
                        
                        [TSMessage showNotificationWithTitle:@"Rejected"
                                                    subtitle:[NSString stringWithFormat:@"%@ paid %@ : %@ was rejected", req.receiver, req.sender, content[3]]
                                                        type:TSMessageNotificationTypeWarning];
                    }
                } else if ([req.type isEqualToString:@"receivePayment"]) {
                    if ([req.response isEqualToString:@"OK"]) {
                        NSArray *content = [req.content componentsSeparatedByString:@"*"];
                        
                        [TSMessage showNotificationWithTitle:@"Success"
                                                    subtitle:[NSString stringWithFormat:@"%@ paid %@ : %@ successed", req.receiver, req.sender, content[3]]
                                                        type:TSMessageNotificationTypeSuccess];
                    }
                } else if ([req.type isEqualToString:@"friendInvite"]) {
                    if ([req.response isEqualToString:@"OK"]) {
                        [TSMessage showNotificationWithTitle:@"Success"
                                                    subtitle:[NSString stringWithFormat:@"%@ friendInvite approved", req.sender]
                                                        type:TSMessageNotificationTypeSuccess];
                    } else {
                        [TSMessage showNotificationWithTitle:@"Rejected"
                                                    subtitle:[NSString stringWithFormat:@"%@ friendInvite rejected", req.sender]
                                                        type:TSMessageNotificationTypeWarning];
                    }
                
                }
            }

        }
    }];
    
}

- (void)obtain_request {
    
    //_requestProcessing = YES;
    [_request removeAllObjects];
    NSString * const kRemoteHost = ServerHost;
    Inf *request = [Inf message];
    request.information = _user_id;
    
    Greeter *service = [[Greeter alloc] initWithHost:kRemoteHost];
    [service obtain_requestWithRequest:request eventHandler:^(BOOL done, Request *response, NSError *error){
        if (!done) {
            Request_ *req = [[Request_ alloc] init];
            [req initWithRequest_id:response.requestId sender:response.sender receiver:response.receiver type:response.type content:response.content response:nil request_date:response.requestDate response_date:nil];
            [_request addObject:req];
            
        } else if (error) {
            [TSMessage showNotificationInViewController:self
                                                  title:@"GRPC ERROR"
                                               subtitle:@"obtain_requestWithRequest"
                                                   type:TSMessageNotificationTypeError
                                               duration:TSMessageNotificationDurationEndless];
        } else {

            [TSMessage showNotificationInViewController:self
                                                  title:@"New Request"
                                               subtitle:[NSString stringWithFormat:@"%ld unread requests.", _request.count]
                                                  image:nil
                                                   type:TSMessageNotificationTypeWarning
                                               duration:TSMessageNotificationDurationEndless
                                               callback:nil
                                            buttonTitle:@"Check"
                                         buttonCallback:^{
                                             [self performSegueWithIdentifier:@"messageCenter" sender:self];
                                         }
                                             atPosition:TSMessageNotificationPositionTop
                                   canBeDismissedByUser:YES];
            //_requestProcessing = NO;
        }
    }];
}

- (void)obtain_bills {
    
    
    
    
    
//    if ([_leftMenu.idText.text isEqualToString:@""]) {
//        return;
//    }
    NSLog(@"called obtain_bills");
    NSString * const kRemoteHost = ServerHost;
    Bill_request *request = [Bill_request message];
    request.username = [_fileOperation getUserId];
    NSLog(@"%@", request.username);
    request.start = @"0";
    request.amount = @"6";
    //[_bill_latest removeAllObjects];
    NSMutableArray *receivedData = [[NSMutableArray alloc] init];
    Greeter *service = [[Greeter alloc] initWithHost:kRemoteHost];
    [service obtain_billsWithRequest:request eventHandler:^(BOOL done, Share_inf *response, NSError *error){
        if (!done) {
            Bill *bill = [[Bill alloc] init];
            [bill initWithID:response.billId amount:response.amount type:response.type date:response.data_p members:response.membersArray creater:response.creater paidBy:response.paidBy note:response.note image:response.image paidStatus:response.paidStatus typeIcon:response.typeIcon];

            [receivedData addObject:bill];
            NSLog(@"get %@", response.billId);

        } else if (error) {
            [TSMessage showNotificationInViewController:self
                                                  title:@"GRPC ERROR"
                                               subtitle:@"obtain_billsWithRequest part"
                                                   type:TSMessageNotificationTypeError
                                               duration:TSMessageNotificationDurationEndless];
            NSLog(@"error:%@", error);
        } else {
            //[_tableView reloadData];
            
//            if (0) { //_billProcessing
//                [TSMessage showNotificationWithTitle:@"New Bill"
//                                            subtitle:@"you get a new bill share with you!"
//                                                type:TSMessageNotificationTypeMessage];
//            }
            
            if ([self noBillRecord]) {
                NSLog(@"start call");
                [self updateAllBills];
            } else {
            
                NSString *lastID = [[self getLatestBill] componentsSeparatedByString:@"*"][0];
                for (NSInteger i = 0; i != receivedData.count; i++) {
                    Bill *bill = [receivedData objectAtIndex:i];
                    if ([bill.bill_id isEqualToString:lastID]) {
                        if (i == 0) {
                            [JDStatusBarNotification showWithStatus:@"update successfully" dismissAfter:2.0];
                            break;
                        }
                        _bill_latest = receivedData;
                        [_tableView reloadData];
                        for (NSInteger j = i - 1; j >= 0; j--) {
                            bill = [receivedData objectAtIndex:j];
                            NSString *bill_string = [NSString stringWithFormat:@"%@*%@*%@*%@*%@*%@*%@*%@*%@*%@*%@*%@*%@*%@*%@*%@*%@*%@*%@*%@", bill.bill_id, bill.amount, bill.type, bill.date, bill.creater, bill.paidBy, bill.note, bill.image, bill.members[0], bill.members[1], bill.members[2], bill.members[3], bill.members[4], bill.members[5], bill.members[6], bill.members[7], bill.members[8], bill.members[9], bill.paidStatus, bill.typeIcon];
                            [self addBillToFile:bill_string];
                        }
                        [TSMessage showNotificationWithTitle:@"New Bill"
                                                    subtitle:@"you get a new bill share with you!"
                                                        type:TSMessageNotificationTypeMessage];
                        break;
                    }
                    // do not update
                    if (i == receivedData.count - 1) {
                        [self updateAllBills];
                    }
                }
            }
            
        }
    }];
}

- (void)updateAllBills {
    NSLog(@"did called");
    [JDStatusBarNotification showWithStatus:@"load data"];
    [JDStatusBarNotification showActivityIndicator:YES
                                    indicatorStyle:UIActivityIndicatorViewStyleGray];
    
    NSString * const kRemoteHost = ServerHost;
    Bill_request *request = [Bill_request message];
    request.username = @"1";//[_fileOperation getUserId];
    request.start = @"0";
    request.amount = @"all";
    
    if ([request.username isEqualToString:@""]) {
        [JDStatusBarNotification dismiss];
        return;
    }
    
    [_bills removeAllObjects];
    NSMutableArray *bills = [[NSMutableArray alloc] init]; // content for last bill
    Greeter *service = [[Greeter alloc] initWithHost:kRemoteHost];
    [service obtain_billsWithRequest:request eventHandler:^(BOOL done, Share_inf *response, NSError *error){
        if (!done) {
            NSLog(@"get %@", response.billId);
            Bill *bill = [[Bill alloc] init];
            [bill initWithID:response.billId amount:response.amount type:response.type date:response.data_p members:response.membersArray creater:response.creater paidBy:response.paidBy note:response.note image:response.image paidStatus:response.paidStatus typeIcon:response.typeIcon];
            if (bills.count < 6) {
                [bills addObject:bill];
            }
            NSString *billString = [NSString stringWithFormat:@"%@*%@*%@*%@*%@*%@*%@*%@*%@*%@*%@*%@*%@*%@*%@*%@*%@*%@*%@*%@", response.billId, response.amount, response.type, response.data_p, response.creater, response.paidBy, response.note, response.image, response.membersArray[0], response.membersArray[1], response.membersArray[2], response.membersArray[3], response.membersArray[4], response.membersArray[5], response.membersArray[6], response.membersArray[7], response.membersArray[8], response.membersArray[9], response.paidStatus, response.typeIcon];
            [_bills addObject:billString];
            NSLog(@"add %@", response.billId);
        } else if (error) {
            [TSMessage showNotificationInViewController:self
                                                  title:@"GRPC ERROR"
                                               subtitle:@"obtain_billsWithRequest All"
                                                   type:TSMessageNotificationTypeError
                                               duration:TSMessageNotificationDurationEndless];
        } else {
            [JDStatusBarNotification dismiss];
            
            [self deleteAllBills];
            for (NSInteger i = _bills.count - 1; i >= 0; i--) {
                [self addBillToFile:_bills[i]];
            }
            
            [_bill_latest removeAllObjects];
            for (int i = 0;i != bills.count; i++) {
                [_bill_latest addObject:bills[i]];
            }
            [self loadCharts];
            [_tableView reloadData];
            [self finishUpdate];
            //[self loadCharts];
        }
    }];
}

- (void)finishUpdate {
    NSString * const kRemoteHost = ServerHost;
    Inf *request = [Inf message];
    request.information = _user_id;
    
    Greeter *service = [[Greeter alloc] initWithHost:kRemoteHost];
    [service reset_StatusWithRequest:request handler:^(Inf *response, NSError *error) {
        if (response) {
        
        
        } else if (error) {
            [TSMessage showNotificationInViewController:self
                                                  title:@"Sorry"
                                               subtitle:@"Some error happend, please contact developer."
                                                   type:TSMessageNotificationTypeError
                                               duration:TSMessageNotificationDurationEndless];
        }
    }];
    
}


#pragma mark - RKTabViewDelegate

//- (void)tabView:(RKTabView *)tabView tabBecameEnabledAtIndex:(NSUInteger)index tab:(RKTabItem *)tabItem {
//    NSLog(@"Tab № %tu became enabled on tab view", index);
//    
//    if ([_leftMenu.idText.text isEqualToString:@""]) {
//        [TSMessage showNotificationWithTitle:(NSString *)@"Warning"
//                                    subtitle:(NSString *)@"You need Login or Sign in."
//                                        type:(TSMessageNotificationType)TSMessageNotificationTypeWarning];
//        
//        //[_standardView disableAllItems];
//        
//        return;
//    }
//    switch (index) {
//        case 0:
//            [self performSegueWithIdentifier:@"billList" sender:self];
//            break;
//        case 1:
//            [self performSegueWithIdentifier:@"analyze" sender:self];
//            break;
//        case 2:
//            [self performSegueWithIdentifier:@"messageCenter" sender:self];
//            break;
//        default:
//            break;
//    }
//
//}
//
//- (void)tabView:(RKTabView *)tabView tabBecameDisabledAtIndex:(NSUInteger)index tab:(RKTabItem *)tabItem {
//    NSLog(@"Tab № %tu became disabled on tab view", index);
//}


#pragma mark - SlideNavigationController Methods

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}


#pragma mark - UITableView Delegate & Datasrouce
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    // If You have only one(1) section, return 1, otherwise you must handle sections
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return _bill_latest.count <= 6 ? _bill_latest.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"BillListCell";
    BillsTableViewCell *_lastCell = [_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"/Icon"];
    if (_bill_latest.count == 0 && indexPath.row == 0) {
        return _lastCell;
    }
    Bill *bill = _bill_latest.count > indexPath.row ? _bill_latest[indexPath.row] : [[Bill alloc] init];

    BOOL fileExist_0 = [[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/%@.png", dataPath, bill.members[0]]];
    BOOL fileExist_1 = [[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/%@.png", dataPath, bill.members[1]]];
    BOOL fileExist_2 = [[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/%@.png", dataPath, bill.members[2]]];
    BOOL fileExist_3 = [[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/%@.png", dataPath, bill.members[3]]];
    
    NSArray *date = [bill.date componentsSeparatedByString:@" "];

    // analyze date
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MMM";
    NSString *month = [formatter stringFromDate:[NSDate date]];
    formatter.dateFormat = @"M";
    NSString *monthWithInt = [formatter stringFromDate:[NSDate date]];
    formatter.dateFormat = @"dd";
    NSString *day = [formatter stringFromDate:[NSDate date]];
    formatter.dateFormat = @"yyyy";
    NSString *year = [formatter stringFromDate:[NSDate date]];
    formatter.dateFormat = @"EEE";
    NSString *week = [formatter stringFromDate:[NSDate date]];
    NSInteger week_head;
    NSInteger week_tail;
    
    DateTranslate *dateTranslate = [[DateTranslate alloc] init];
    NSMutableDictionary *dayOfWeek = dateTranslate.dayOfWeek;
    if (([day integerValue] - [[dayOfWeek objectForKey:week] integerValue]) > 0) {
        week_head  = [day integerValue] - [[dayOfWeek objectForKey:week] integerValue];
    } else {
        week_head = 1;
    }
    if (([day integerValue] + 6 - [[dayOfWeek objectForKey:week] integerValue]) <= [[dateTranslate.dayOfMonth objectForKey:monthWithInt] integerValue]) {
        week_tail = [day integerValue] + 6 - [[dayOfWeek objectForKey:week] integerValue];
    } else {
        week_tail = [[dateTranslate.dayOfMonth objectForKey:monthWithInt] integerValue];
    }
    
    // analyze type. just display second class type name
    NSString *typeName = bill.type;
    for (int i = 0; i != typeName.length; i++) {
        if ([typeName characterAtIndex:i] == '>') {
            typeName = [typeName substringFromIndex:++i];
            bill.type = typeName;
            break;
        }
    }
    NSMutableArray* imageArray = [[NSMutableArray alloc] init];
    for (int i = 0; i != 10; i++) {
        if (![bill.members[i] isEqualToString:@""]) {
            BOOL fileExist = [[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/%@.png", dataPath, bill.members[i]]];
            [imageArray addObject:(fileExist ? [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.png", dataPath, bill.members[i]]] : [UIImage imageNamed:@"profle.png"])];
        }
    }

            /*[_lastCell initWithTypeIcon:[UIImage imageNamed:bill.typeIcon]
                             noteOrType:bill.type
                                   date:date[0]
                                 amount:bill.amount
                            shareWith_0:([bill.members[0] isEqualToString:@""] ? nil : (fileExist_0 ? [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.png", dataPath, bill.members[0]]] : [UIImage imageNamed:@"icon-user-default.png"]))
                            shareWith_1:([bill.members[1] isEqualToString:@""] ? nil : (fileExist_1 ? [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.png", dataPath, bill.members[1]]] : [UIImage imageNamed:@"icon-user-default.png"]))
                            shareWith_2:([bill.members[2] isEqualToString:@""] ? nil : (fileExist_2 ? [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.png", dataPath, bill.members[2]]] : [UIImage imageNamed:@"icon-user-default.png"]))
                            shareWith_3:([bill.members[3] isEqualToString:@""] ? nil : (fileExist_3 ? [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.png", dataPath, bill.members[3]]] : [UIImage imageNamed:@"icon-user-default.png"]))];*/
            
            [_lastCell initWithTypeCombinedImage:[UIImage imageNamed:bill.typeIcon] noteOrType:bill.type date:date[0] amount:bill.amount imageArray:imageArray];
            //_lastCell.textLabel.text = @"fdsafds";
            return _lastCell;

    
    return nil;
}

- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {

    switch (indexPath.row) {
        case 0:
            [self performSegueWithIdentifier:@"lastBillDetail" sender:self];
            //[self performSegueWithIdentifier:@"test" sender:self];
            break;
        case 1:
            [self performSegueWithIdentifier:@"lastBillDetail" sender:self];
            break;
        case 2:
            [self performSegueWithIdentifier:@"lastBillDetail" sender:self];
            break;
        case 3:
            [self performSegueWithIdentifier:@"lastBillDetail" sender:self];
            break;
        case 4:
            [self performSegueWithIdentifier:@"lastBillDetail" sender:self];
            break;
        default:
            break;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"lastBillDetail"]) {
        BillDetailViewController *billDetail = (BillDetailViewController *)[segue destinationViewController];
        //NSInteger t = [_tableView indexPathForSelectedRow].row;
        Bill *bill = _bill_latest[[_tableView indexPathForSelectedRow].row];
        billDetail.billId = bill.bill_id;
        billDetail.mainUIView = self;

    } else if ([segue.identifier isEqualToString:@"billList"]) {
        BillListViewController *billList = (BillListViewController *)[segue destinationViewController];
        //billList.idText = _leftMenu.idText.text;
        billList.mainUIView = self;
    } else if ([segue.identifier isEqualToString:@"messageCenter"]) {
        MessageCenterViewController *messageCenter = (MessageCenterViewController *)[segue destinationViewController];
        messageCenter.idText = [_fileOperation getUsername];
    } else if ([segue.identifier isEqualToString:@"createShareView"]) {
        UINavigationController *navgation = (UINavigationController *)[segue destinationViewController];
        //
        AddNewShareViewController *addNewBill = (AddNewShareViewController *)([navgation viewControllers][0]);
        addNewBill.quickType = _quickType;
        addNewBill.mainUIView = self;
    } else if ([segue.identifier isEqualToString:@"analyze"]) {
        AnalyzeViewController *analyzeView = (AnalyzeViewController *)[segue destinationViewController];
        analyzeView.mainUIView = self;
    } else if ([segue.identifier isEqualToString:@"billListWithFriendFromMain"]) {
        BillListWithFriendViewController *billList = (BillListWithFriendViewController *)[segue destinationViewController];
        //Bill *bill = [[_billsWithMonth objectAtIndex:[_tableView indexPathForSelectedRow].section] objectAtIndex:[_tableView indexPathForSelectedRow].row];
        billList.username = _friendUsername;
        billList.navigationItem.title = _friendUsername;
        billList.sum = @"NULL";
        //billList.idText = _idText;
        billList.mainUIView = self;
    }
}

#pragma mark - HELP functions



//////////////////////////////////////////////////////////////////////////////

- (void)addBillToFile:(NSString *)bill {

    NSString *exist = [_fileOperation getFileContent:@"billRecord"];
    NSString *newBills;
    if (![exist isEqualToString:@""]) {
        newBills = [NSString stringWithFormat:@"%@\n%@", bill, exist];
    } else {
        newBills = [NSString stringWithFormat:@"%@", bill];
    }
    
    
    [_fileOperation setFileContent:newBills filename:@"billRecord"];
}

- (void)deleteAllBills {
    [_fileOperation setFileContent:@"" filename:@"billRecord"];
}

- (NSString *)getLatestBill {

    NSString *exist = [_fileOperation getFileContent:@"billRecord"];
    NSArray *bills = [exist componentsSeparatedByString:@"\n"];
    
    return bills.count == 0 ? nil : bills[0];
}



- (BOOL)noBillRecord {

    NSString *exist = [_fileOperation getFileContent:@"billRecord"];
    return [exist isEqualToString:@""] ? YES : NO;
}

- (void)loadLastestBill {
    
    if ([self noBillRecord]) {
        return;
    }

    NSString *exist = [_fileOperation getFileContent:@"billRecord"];
    NSArray *bills = [exist componentsSeparatedByString:@"\n"];
    
    for (int i = 0; i != 6 && i != bills.count; i++) {
        NSArray *bill_content = [bills[i] componentsSeparatedByString:@"*"];
        NSMutableArray *members = [[NSMutableArray alloc] init];
        for (int j = 0; j != 10; j++) {
//            if ([bill_content[j + 8] isEqualToString:@""]) {
//                break;
//            }
            [members addObject:bill_content[j + 8]];
        }
        Bill *bill = [[Bill alloc] init];
        [bill initWithID:bill_content[0] amount:bill_content[1] type:bill_content[2] date:bill_content[3] members:members creater:bill_content[4] paidBy:bill_content[5] note:bill_content[6] image:bill_content[7] paidStatus:bill_content[18] typeIcon:bill_content[19]];
        [_bill_latest addObject:bill];
    }
}

- (void)loadCharts {
    /*  */
    [_legend removeFromSuperview];
    [_pieChart removeFromSuperview];
    
    BillStatistics *statistics = [[BillStatistics alloc] init];
    [statistics initDate];
    
    /* pie charts layout */
    NSArray *statisticsDate = [statistics compositionOfFirst:5];
    
    if (statisticsDate) {
//        NSArray *items = @[[PNPieChartDataItem dataItemWithValue:[statisticsDate[0][1] doubleValue] * 100 color:PNLightBlue description:statisticsDate[0][0]],
//                           [PNPieChartDataItem dataItemWithValue:[statisticsDate[1][1] doubleValue] * 100 color:PNFreshGreen description:statisticsDate[1][0]],
//                           [PNPieChartDataItem dataItemWithValue:[statisticsDate[2][1] doubleValue] * 100 color:PNDeepGreen description:statisticsDate[2][0]],
//                           [PNPieChartDataItem dataItemWithValue:[statisticsDate[3][1] doubleValue] * 100 color:PNButtonGrey description:statisticsDate[3][0]],
//                           [PNPieChartDataItem dataItemWithValue:[statisticsDate[4][1] doubleValue] * 100 color:PNBlue description:statisticsDate[4][0]],
//                           ];
        
        NSMutableArray *items = [[NSMutableArray alloc] init];
        for (int i = 0; i != statisticsDate.count; i++) {
            UIColor *color;
            switch (i) {
                case 0:
                    color = PNLightBlue;
                    break;
                case 1:
                    color = PNFreshGreen;
                    break;
                case 2:
                    color = PNDeepGreen;
                    break;
                case 3:
                    color = PNButtonGrey;
                    break;
                case 4:
                    color = PNBlue;
                    break;
                default:
                    break;
            }
            PNPieChartDataItem *item = [PNPieChartDataItem dataItemWithValue:[statisticsDate[i][1] doubleValue] * 100 color:color description:statisticsDate[i][0]];
            [items addObject:item];
        }
        self.pieChart = [[PNPieChart alloc] initWithFrame:CGRectMake(10, 10, _statusView.frame.size.height - 20, _statusView.frame.size.height - 20) items:items];
        self.pieChart.descriptionTextColor = [UIColor whiteColor];
        self.pieChart.descriptionTextFont  = [UIFont fontWithName:@"Machinato" size:15.0];
        self.pieChart.descriptionTextShadowColor = [UIColor clearColor];
        self.pieChart.showAbsoluteValues = NO;
        self.pieChart.showOnlyValues = NO;
        self.pieChart.showOnlyValues = YES;
        [self.pieChart strokeChart];
        
        
        self.pieChart.legendStyle = PNLegendItemStyleStacked;
        self.pieChart.legendFont = [UIFont fontWithName:@"Machinato" size:15.0];
        //self.pieChart.legendFontColor = [UIColor colorWithRed:91 green:104 blue:126 alpha:1.0];//RGB(91, 104, 126);
        
        _legend = [self.pieChart getLegendWithMaxWidth:200];
        CGFloat originX;
        if (_legend.frame.size.width > (_statusView.frame.size.width - (10 + _pieChart.frame.size.width))) {
            originX = _pieChart.frame.size.width + 10;
        } else {
            originX = (_statusView.frame.size.width - (10 + _pieChart.frame.size.width)) / 2 - _legend.frame.size.width / 2 + (10 + _pieChart.frame.size.width);
        }
        [_legend setFrame:CGRectMake(originX, self.statusView.frame.size.height / 2 - _legend.frame.size.height / 2, _legend.frame.size.width, _legend.frame.size.height)];
        
        
        
        [self.statusView addSubview:_legend];
        [self.statusView addSubview:_pieChart];
    }
}

- (void)removeCharts {
    [_legend removeFromSuperview];
    [_pieChart removeFromSuperview];
}

- (void)openLeftMenu {
    [self performSelector:@selector(openhelp) withObject:nil afterDelay:0.1f];
}
- (void)openhelp {
    [[SlideNavigationController sharedInstance] leftMenuSelected:nil];
}

// hide main UI. if it is hide, show main UI
- (void)hideMainUI {
    [self performSelector:@selector(hidehelp) withObject:nil afterDelay:0.1f];
    //[SlideNavigationController sharedInstance].enableShadow = [SlideNavigationController sharedInstance].enableShadow ? NO : YES;
//    if ([SlideNavigationController sharedInstance].enableShadow) {
//        [[SlideNavigationController sharedInstance] setEnableShadow:NO];
//    } else {
//        [[SlideNavigationController sharedInstance] setEnableShadow:YES];
//    }
}
- (void)hidehelp {
    
    [[SlideNavigationController sharedInstance] hideMainUI:nil];
}

// change shadow show or not
- (void)changeShadow {
    [SlideNavigationController sharedInstance].enableShadow = [SlideNavigationController sharedInstance].enableShadow ? NO : YES;
}


- (void)create_folder {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"/Icon"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:nil]; //Create folder
    
    dataPath = [documentsDirectory stringByAppendingPathComponent:@"/billsImage"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:nil]; //Create folder
    
    dataPath = [documentsDirectory stringByAppendingPathComponent:@"/cacheFolder"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:nil]; //Create folder
    
    NSFileManager *fm = [NSFileManager defaultManager];
    NSError *error = nil;
    for (NSString *file in [fm contentsOfDirectoryAtPath:dataPath error:&error]) {
        BOOL success = [fm removeItemAtPath:[NSString stringWithFormat:@"%@/%@", dataPath, file] error:&error];
        if (!success || error) {
            // it failed.
        }
    }
}


- (void)viewBillWithFriend:(NSString*)username {
    _friendUsername = username;
    [self performSegueWithIdentifier:@"billListWithFriendFromMain" sender:self];
}

- (bool)isLogin {
    NSString *username = [_fileOperation getUsername];
    if ([username isEqualToString:@""]) {
        return NO;
    }
    return YES;
}


- (void)grpcTest {
    //[GRPCCall useInsecureConnectionsForHost:ServerHost];
    //[GRPCCall setUserAgentPrefix:@"HelloWorld/1.0" forHost:kHostAddress];
    
    /*
    Greeter *client = [[Greeter alloc] initWithHost:ServerHost];
    
    //    HLWHelloRequest *request = [HLWHelloRequest message];
    //    request.name = @"Objective-C";
    //
    //    [client sayHelloWithRequest:request handler:^(HLWHelloReply *response, NSError *error) {
    //      NSLog(@"%@", response.message);
    //    }];
    
    Bill_request *request = [Bill_request message];
    request.username = @"1";
    request.start = @"0";
    request.amount = @"all";
    
    [client obtain_billsWithRequest:request eventHandler:^(BOOL done, Share_inf *note, NSError *error) {
        if (!done) {
            NSLog(@"get %@", note.billId);
        } else if (error) {
            
        } else {
            NSLog(@"Chat ended.");
        }
    }];*/
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
