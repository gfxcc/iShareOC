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
#import <QuartzCore/QuartzCore.h>
#import "Bill.h"
#import "BillsTableViewCell.h"
#import "RKTabView.h"
#import "DateTranslate.h"
#import "BillDetailViewController.h"
#import "BillListViewController.h"
#import "Request.h"

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

@interface ViewController ()

@property (strong, nonatomic) BillsTableViewCell *lastCell;
@property (strong, nonatomic) BillsTableViewCell *todayCell;
@property (strong, nonatomic) BillsTableViewCell *thisWeekCell;
@property (strong, nonatomic) BillsTableViewCell *thisMonthCell;

@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    for (int i = 0; i != 3; i++) {
//        RKTabItem *item = (RKTabItem *)_standardView.tabItems[i];
//        if (0 == item.tabState) {
//            [_standardView switchTabIndex:i];
//        }
//    }
    
    [super viewWillAppear:animated];
    [_standardView disableAllItems];
    [self.tableView deselectRowAtIndexPath:[_tableView indexPathForSelectedRow] animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.navigationController.navigationBar setTintColor:RGB(255, 255, 255)];
    //[self.navigationController.navigationBar setBackgroundColor:RGB(78, 107, 165)];
    self.navigationController.navigationBar.barTintColor = RGB(78, 107, 165);
    
    self.view.backgroundColor = RGB(211, 214, 219);
    
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle: nil];
    
    [_addNewButtion setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    _addNewButtion.layer.cornerRadius = 5;
    _addNewButtion.clipsToBounds = YES;
    [_addNewButtion addTarget:self action:@selector(buttonHighlight) forControlEvents:UIControlEventTouchDown];
    [_addNewButtion addTarget:self action:@selector(buttonNormal) forControlEvents:UIControlEventTouchUpInside];
    
    _leftMenu = (LeftMenuViewController*)[mainStoryboard
                                                                 instantiateViewControllerWithIdentifier: @"LeftMenuViewController"];
    
    _leftMenu.mainUINavgation = self.navigationController;
    _leftMenu.mainUIView = self;
    
    [SlideNavigationController sharedInstance].leftMenu = _leftMenu;
    [SlideNavigationController sharedInstance].menuRevealAnimationDuration = .18;
    [_leftMenu viewDidLoad];
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    // modify tableViewCells
    static NSString *CellIdentifier = @"BillListCell";
    
    _lastCell = [_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    _todayCell = [_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    _thisWeekCell = [_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    _thisMonthCell = [_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    _bill_latest = [[NSMutableArray alloc] init];
    _bills = [[NSMutableArray alloc] init];
    _request = [[NSMutableArray alloc] init];
    //
    
    // RKTabView Setting

    
    _billList = [RKTabItem createUsualItemWithImageEnabled:[UIImage imageNamed:@"TableIcon6@2x.png"] imageDisabled:[UIImage imageNamed:@"TableIcon7@2x.png"]];
    _analyze = [RKTabItem createUsualItemWithImageEnabled:[UIImage imageNamed:@"TableIcon2@2x.png"] imageDisabled:[UIImage imageNamed:@"TableIcon3@2x.png"]];
    _mapView = [RKTabItem createUsualItemWithImageEnabled:[UIImage imageNamed:@"TableIcon0@2x.png"] imageDisabled:[UIImage imageNamed:@"TableIcon1@2x.png"]];
    
    
    self.standardView.horizontalInsets = HorizontalEdgeInsetsMake(25, 25);
    
    self.standardView.darkensBackgroundForEnabledTabs = YES;
    self.standardView.drawSeparators = YES;
    self.standardView.tabItems = @[_billList, _analyze, _mapView];
    self.standardView.delegate = (id<RKTabViewDelegate>)self;
    
    _statusView.layer.cornerRadius = 5.0f;
    _statusView.layer.masksToBounds = YES;
    

    [self obtain_bills];
    [self keepSyn];
    [self create_folder];
    
}

- (void)buttonHighlight {

    _addNewButtion.backgroundColor = RGB(78, 107, 165);
}

- (void)buttonNormal {

    _addNewButtion.backgroundColor = RGB(118, 137, 166);
}

- (IBAction)addNewShare:(id)sender {
    
//    UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    AddNewShareViewController *addpage = [mainStoryboard instantiateViewControllerWithIdentifier:@"LogInView"];
//    
//    addpage.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
//    addpage.idText = _leftMenu.idText.text;
//    [self presentViewController:addpage animated:YES completion:^{
//        NSLog(@"Present Modal View");
//    }];
//    
}

//start syn
- (void)keepSyn {
    NSString * const kRemoteHost = ServerHost;
    //[self deleteAllRequests];
    // Example gRPC call using a generated proto client library:

    GRXWriter *_requestsWriter = [GRXWriter writerWithValueSupplier:^id() {
        Inf *test1 = [Inf message];
        test1.information = _leftMenu.idText.text;
        [NSThread sleepForTimeInterval:1.0f];
        return test1;
    }];
    
    //NSLog(@"test");
    //[_requestsWriter startWithWriteable:writable];
    Greeter *service = [[Greeter alloc] initWithHost:kRemoteHost];
    
    [service synWithRequestsWriter:_requestsWriter handler:^(BOOL done, Syn_data *response, NSError *error) {
        if (!done) {
            NSLog(@"receive message:%@ %@ %@ %@", response.friend_p, response.bill, response.delete_p, response.request);
            
            if ([response.friend_p isEqualToString:@"0"]) {
                
            } else if ([response.friend_p isEqualToString:@"1"]) {
                [_leftMenu obtain_friends];
            }
            
            if ([response.bill isEqualToString:@"0"]) {
                _billProcessing = NO;
            } else if ([response.bill isEqualToString:@"1"]) {
                _billProcessing = YES;
                [self obtain_bills];
            }
            
            if ([response.delete_p isEqualToString:@"0"]) {
            } else if ([response.delete_p isEqualToString:@"1"]) {
                [self updateAllBills];
            }
            
            if ([response.request isEqualToString:@"0"]) {
                _requestProcessing = NO;
            } else if ([response.request isEqualToString:@"1"] && !_requestProcessing) {
                _requestProcessing = YES;
                [self obtain_request];
            } else if ([response.request isEqualToString:@"2"] && !_requestProcessing) {
                _requestProcessing = YES;
                [self obtain_requestLog];
            }
            
        } else if (error) {
            NSLog(@"Finished with error: %@", error);
        } else {
            _requestsWriter.state = GRXWriterStateStarted;
            NSLog(@"%li", (long)_requestsWriter.state);
        }
    }];
    
}

- (void)obtain_requestLog {
    
    NSString * const kRemoteHost = ServerHost;
    Inf *request = [Inf message];
    request.information = _leftMenu.idText.text;
    
    Greeter *service = [[Greeter alloc] initWithHost:kRemoteHost];
    [service obtain_requestLogWithRequest:request handler:^(BOOL done, Request *response, NSError *error){
        if (!done) {
            Request_ *req = [[Request_ alloc] init];
            [req initWithRequest_id:response.requestId sender:response.sender receiver:response.receiver type:response.type content:response.content response:nil request_date:response.requestDate response_date:nil];
            [_request addObject:req];
            
        } else if (error) {
            [TSMessage showNotificationWithTitle:@"GRPC ERROR"
                                        subtitle:@"obtain_request"
                                            type:TSMessageNotificationTypeError];
        } else {
            if (_request.count > 0) {
                Request *req = _request[0];
                NSArray *content = [req.content componentsSeparatedByString:@"*"];
                
                [TSMessage showNotificationWithTitle:@"Success"
                                            subtitle:[NSString stringWithFormat:@"%@ paid %@ : %@ successed", req.receiver, req.sender, content[3]]
                                                type:TSMessageNotificationTypeSuccess];
            }
            //_requestProcessing = NO;
        }
    }];
    
}

- (void)obtain_request {
    
    //_requestProcessing = YES;
    [_request removeAllObjects];
    NSString * const kRemoteHost = ServerHost;
    Inf *request = [Inf message];
    request.information = _leftMenu.idText.text;
    
    Greeter *service = [[Greeter alloc] initWithHost:kRemoteHost];
    [service obtain_requestWithRequest:request handler:^(BOOL done, Request *response, NSError *error){
        if (!done) {
            Request_ *req = [[Request_ alloc] init];
            [req initWithRequest_id:response.requestId sender:response.sender receiver:response.receiver type:response.type content:response.content response:nil request_date:response.requestDate response_date:nil];
            [_request addObject:req];
            
        } else if (error) {
            [TSMessage showNotificationWithTitle:@"GRPC ERROR"
                                        subtitle:@"obtain_request"
                                            type:TSMessageNotificationTypeError];
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
                                             [self performSegueWithIdentifier:@"mapview" sender:self];
                                         }
                                             atPosition:TSMessageNotificationPositionTop
                                   canBeDismissedByUser:YES];
            //_requestProcessing = NO;
        }
    }];
}

- (void)obtain_bills {

    [_bill_latest removeAllObjects];
    
    if ([_leftMenu.idText.text isEqualToString:@""]) {
        return;
    }
    
    NSString * const kRemoteHost = ServerHost;
    Bill_request *request = [Bill_request message];
    request.username = _leftMenu.idText.text;
    request.start = @"0";
    request.amount = @"4";
    
    Greeter *service = [[Greeter alloc] initWithHost:kRemoteHost];
    [service obtain_billsWithRequest:request handler:^(BOOL done, Share_inf *response, NSError *error){
        if (!done) {
            Bill *bill = [[Bill alloc] init];
            [bill initWithID:response.billId amount:response.amount type:response.type date:response.data_p members:response.membersArray creater:response.creater paidBy:response.paidBy note:response.note image:nil paidStatus:response.paidStatus];

            [_bill_latest addObject:bill];
            NSLog(@"%@", response.data_p);

        } else if (error) {
            
        } else {
            [_tableView reloadData];
            
            if (_billProcessing) {
                [TSMessage showNotificationWithTitle:@"New Bill"
                                            subtitle:@"you get a new bill share with you!"
                                                type:TSMessageNotificationTypeMessage];
            }
            
            if ([self noBillRecord]) {
                [self updateAllBills];
            } else {
            
                NSString *lastID = [[self getLatestBill] componentsSeparatedByString:@"*"][0];
                for (NSInteger i = 0; i != _bill_latest.count; i++) {
                    Bill *bill = [_bill_latest objectAtIndex:i];
                    if ([bill.bill_id isEqualToString:lastID]) {
                        if (i == 0) {
                            break;
                        }
                        
                        for (NSInteger j = i - 1; j >= 0; j--) {
                            bill = [_bill_latest objectAtIndex:j];
                            NSString *bill_string = [NSString stringWithFormat:@"%@*%@*%@*%@*%@*%@*%@*%@*%@*%@*%@*%@*%@*%@*%@*%@*%@*%@*%@", bill.bill_id, bill.amount, bill.type, bill.date, bill.creater, bill.paidBy, bill.note, bill.image, bill.members[0], bill.members[1], bill.members[2], bill.members[3], bill.members[4], bill.members[5], bill.members[6], bill.members[7], bill.members[8], bill.members[9], bill.paidStatus];
                            [self addBillToFile:bill_string];
                        }
                        break;
                    }
                    // do not update
                    if (i == _bill_latest.count - 1) {
                        [self updateAllBills];
                    }
                }
            }
            
        }
    }];
}

- (void)updateAllBills {
    NSString * const kRemoteHost = ServerHost;
    Bill_request *request = [Bill_request message];
    request.username = _leftMenu.idText.text;
    request.start = @"0";
    request.amount = @"all";
    
    [_bills removeAllObjects];
    Greeter *service = [[Greeter alloc] initWithHost:kRemoteHost];
    [service obtain_billsWithRequest:request handler:^(BOOL done, Share_inf *response, NSError *error){
        if (!done) {
            
            NSString *bill = [NSString stringWithFormat:@"%@*%@*%@*%@*%@*%@*%@*%@*%@*%@*%@*%@*%@*%@*%@*%@*%@*%@*%@", response.billId, response.amount, response.type, response.data_p, response.creater, response.paidBy, response.note, response.image, response.membersArray[0], response.membersArray[1], response.membersArray[2], response.membersArray[3], response.membersArray[4], response.membersArray[5], response.membersArray[6], response.membersArray[7], response.membersArray[8], response.membersArray[9], response.paidStatus];
            [_bills addObject:bill];
        } else if (error) {
            
        } else {
            [self deleteAllBills];
            for (NSInteger i = _bills.count - 1; i >= 0; i--) {
                [self addBillToFile:_bills[i]];
            }
            [_tableView reloadData];
            [self finishUpdate];
        }
    }];
}

- (void)finishUpdate {
    NSString * const kRemoteHost = ServerHost;
    Inf *request = [Inf message];
    request.information = _leftMenu.idText.text;
    
    Greeter *service = [[Greeter alloc] initWithHost:kRemoteHost];
    [service reset_StatusWithRequest:request handler:^(Inf *response, NSError *error) {
        if (response) {
        
        
        } else if (error) {
            NSLog(@"reset error");
        }
    }];
    
}

#pragma mark - RKTabViewDelegate

- (void)tabView:(RKTabView *)tabView tabBecameEnabledAtIndex:(NSUInteger)index tab:(RKTabItem *)tabItem {
    NSLog(@"Tab № %tu became enabled on tab view", index);
    
    if ([_leftMenu.idText.text isEqualToString:@""]) {
        return;
    }
    switch (index) {
        case 0:
            [self performSegueWithIdentifier:@"billList" sender:self];
            break;
        case 1:
            [self performSegueWithIdentifier:@"analyze" sender:self];
            break;
        case 2:
            [self performSegueWithIdentifier:@"mapview" sender:self];
            break;
        default:
            break;
    }
    
}

- (void)tabView:(RKTabView *)tabView tabBecameDisabledAtIndex:(NSUInteger)index tab:(RKTabItem *)tabItem {
    NSLog(@"Tab № %tu became disabled on tab view", index);
}


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
    return _bill_latest.count == 0 ? 0 : 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
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
    
    switch (indexPath.row) {
        case 0:
            [_lastCell initWithTypeIcon:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png", bill.type]]
                             noteOrType:[bill.note isEqualToString:@""] ? bill.type : bill.note
                                   date:date[0]
                                 amount:bill.amount
                            shareWith_0:([bill.members[0] isEqualToString:@""] ? nil : (fileExist_0 ? [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.png", dataPath, bill.members[0]]] : [UIImage imageNamed:@"icon-user-default.png"]))
                            shareWith_1:([bill.members[1] isEqualToString:@""] ? nil : (fileExist_1 ? [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.png", dataPath, bill.members[1]]] : [UIImage imageNamed:@"icon-user-default.png"]))
                            shareWith_2:([bill.members[2] isEqualToString:@""] ? nil : (fileExist_2 ? [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.png", dataPath, bill.members[2]]] : [UIImage imageNamed:@"icon-user-default.png"]))
                            shareWith_3:([bill.members[3] isEqualToString:@""] ? nil : (fileExist_3 ? [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.png", dataPath, bill.members[3]]] : [UIImage imageNamed:@"icon-user-default.png"]))];
            //_lastCell.textLabel.text = @"fdsafds";
            return _lastCell;
        case 1:
            [_todayCell initWithTypeIcon:[UIImage imageNamed:@"calendar_day.png"]
                              noteOrType:@"Today"
                                    date:[NSString stringWithFormat:@"%@ %@, %@", month, day,year]
                                  amount:bill.amount
                             shareWith_0:nil
                             shareWith_1:nil
                             shareWith_2:nil
                             shareWith_3:nil];
            return _todayCell;
        case 2:
            [_thisWeekCell initWithTypeIcon:[UIImage imageNamed:@"calendar_week.png"]
                                 noteOrType:@"This Week"
                                       date:[NSString stringWithFormat:@"%ld,%@ - %ld,%@", (long)week_head, month, (long)week_tail, month]
                                     amount:bill.amount
                                shareWith_0:nil
                                shareWith_1:nil
                                shareWith_2:nil
                                shareWith_3:nil];
            return _thisWeekCell;
        case 3:
            [_thisMonthCell initWithTypeIcon:[UIImage imageNamed:@"calendar_month.png"]
                                  noteOrType:@"This Month"
                                        date:[NSString stringWithFormat:@"01,%@ - %@,%@", month, [dateTranslate.dayOfMonth objectForKey:monthWithInt], month]
                                      amount:bill.amount
                                 shareWith_0:nil
                                 shareWith_1:nil
                                 shareWith_2:nil
                                 shareWith_3:nil];
            return _thisMonthCell;
    }
    
    return nil;
}

- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {

    switch (indexPath.row) {
        case 0:
            [self performSegueWithIdentifier:@"lastBillDetail" sender:self];
            break;
        case 1:
            break;
        case 2:
            break;
        case 3:
            break;
        default:
            break;
    }


}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"lastBillDetail"]) {
        BillDetailViewController *billDetail = (BillDetailViewController *)[segue destinationViewController];
        billDetail.billId = [[self getLatestBill] componentsSeparatedByString:@"*"][0];

    } else if ([segue.identifier isEqualToString:@"billList"]) {
        BillListViewController *billList = (BillListViewController *)[segue destinationViewController];
        billList.idText = _leftMenu.idText.text;
    
    }
}

#pragma mark - HELP functions

//- (void)addRequestToFile:(NSString *)request {
//    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    
//    //make a file name to write the data to using the documents directory:
//    NSString *fileName = [NSString stringWithFormat:@"%@/RequestRecord",
//                          documentsDirectory];
//    NSString *exist = [[NSString alloc] initWithContentsOfFile:fileName
//                                                  usedEncoding:nil
//                                                         error:nil];
//    NSString *newRequest;
//    if (![exist isEqualToString:@""]) {
//        newRequest = [NSString stringWithFormat:@"%@\n%@", request, exist];
//    } else {
//        newRequest = [NSString stringWithFormat:@"%@", request];
//    }
//    
//    
//    [newRequest writeToFile:fileName
//               atomically:NO
//                 encoding:NSUTF8StringEncoding
//                    error:nil];
//}
//
//- (void)deleteAllRequests {
//    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    
//    //make a file name to write the data to using the documents directory:
//    NSString *fileName = [NSString stringWithFormat:@"%@/RequestRecord",
//                          documentsDirectory];
//    [@"" writeToFile:fileName
//          atomically:NO
//            encoding:NSUTF8StringEncoding
//               error:nil];
//}
//
//- (NSString *)getLatestRequest {
//    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    
//    //make a file name to write the data to using the documents directory:
//    NSString *fileName = [NSString stringWithFormat:@"%@/RequestRecord",
//                          documentsDirectory];
//    NSString *exist = [[NSString alloc] initWithContentsOfFile:fileName
//                                                  usedEncoding:nil
//                                                         error:nil];
//    NSArray *request = [exist componentsSeparatedByString:@"\n"];
//    
//    return request.count == 0 ? nil : request[0];
//}
//
//- (BOOL)noRequestRecord {
//    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    
//    //make a file name to write the data to using the documents directory:
//    NSString *fileName = [NSString stringWithFormat:@"%@/RequestRecord",
//                          documentsDirectory];
//    NSString *exist = [[NSString alloc] initWithContentsOfFile:fileName
//                                                  usedEncoding:nil
//                                                         error:nil];
//    return [exist isEqualToString:@""]||!exist ? YES : NO;
//}


//////////////////////////////////////////////////////////////////////////////

- (void)addBillToFile:(NSString *)bill {
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    //make a file name to write the data to using the documents directory:
    NSString *fileName = [NSString stringWithFormat:@"%@/billRecord",
                          documentsDirectory];
    NSString *exist = [[NSString alloc] initWithContentsOfFile:fileName
                                          usedEncoding:nil
                                                 error:nil];
    NSString *newBills;
    if (![exist isEqualToString:@""]) {
        newBills = [NSString stringWithFormat:@"%@\n%@", bill, exist];
    } else {
        newBills = [NSString stringWithFormat:@"%@", bill];
    }
    
    
    [newBills writeToFile:fileName
              atomically:NO
                encoding:NSUTF8StringEncoding
                   error:nil];
}

- (void)deleteAllBills {
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    //make a file name to write the data to using the documents directory:
    NSString *fileName = [NSString stringWithFormat:@"%@/billRecord",
                          documentsDirectory];
    [@"" writeToFile:fileName
               atomically:NO
                 encoding:NSUTF8StringEncoding
                    error:nil];
}

- (NSString *)getLatestBill {
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    //make a file name to write the data to using the documents directory:
    NSString *fileName = [NSString stringWithFormat:@"%@/billRecord",
                          documentsDirectory];
    NSString *exist = [[NSString alloc] initWithContentsOfFile:fileName
                                                  usedEncoding:nil
                                                         error:nil];
    NSArray *bills = [exist componentsSeparatedByString:@"\n"];
    
    return bills.count == 0 ? nil : bills[0];
}



- (BOOL)noBillRecord {
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    //make a file name to write the data to using the documents directory:
    NSString *fileName = [NSString stringWithFormat:@"%@/billRecord",
                          documentsDirectory];
    NSString *exist = [[NSString alloc] initWithContentsOfFile:fileName
                                                  usedEncoding:nil
                                                         error:nil];
    return [exist isEqualToString:@""] ? YES : NO;
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
    [SlideNavigationController sharedInstance].enableShadow = [SlideNavigationController sharedInstance].enableShadow ? NO : YES;
}
- (void)hidehelp {
    [[SlideNavigationController sharedInstance] hideMainUI:nil];
}

// change shadow show or not
- (void)changeShadow {
    [SlideNavigationController sharedInstance].enableShadow = [SlideNavigationController sharedInstance].enableShadow ? NO : YES;
}


- (IBAction)grpc_t:(id)sender {

    [TSMessage showNotificationWithTitle:@"Your Title"
                                subtitle:@"A description"
                                    type:TSMessageNotificationTypeSuccess];

}

- (void)create_folder {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"/Icon"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:nil]; //Create folder
    
    dataPath = [documentsDirectory stringByAppendingPathComponent:@"/bills"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:nil]; //Create folder
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
