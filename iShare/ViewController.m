//
//  ViewController.m
//  iShare
//
//  Created by caoyong on 5/9/15.
//  Copyright (c) 2015 caoyong. All rights reserved.
//

#import "ViewController.h"
#import <gRPC_pod/IShare.pbrpc.h>
#import <gRPC_pod/IShare.pbobjc.h>
#import <QuartzCore/QuartzCore.h>
#import "Bill.h"
#import "BillsTableViewCell.h"
#import "RKTabView.h"


#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

@interface ViewController ()

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
    [_standardView disableAllItems];
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
    
    _bill_latest = [[NSMutableArray alloc] init];
    _bills = [[NSMutableArray alloc] init];
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
    

    [self obtail_bills];
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
    
    // Example gRPC call using a generated proto client library:

    GRXWriter *_requestsWriter = [GRXWriter writerWithValueSupplier:^id() {
        Inf *test1 = [Inf message];
        test1.information = _leftMenu.idText.text;
        [NSThread sleepForTimeInterval:1.0f];
        return test1;
    }];
    
    NSLog(@"test");
    //[_requestsWriter startWithWriteable:writable];
    Greeter *service = [[Greeter alloc] initWithHost:kRemoteHost];
    
    [service synWithRequestsWriter:_requestsWriter handler:^(BOOL done, Syn_data *response, NSError *error) {
        if (!done) {
            NSLog(@"receive message:%@  %@", response.friend_p, response.bill);
            
            if ([response.friend_p isEqualToString:@"0"]) {
                
            } else if ([response.friend_p isEqualToString:@"1"]) {
                [_leftMenu obtain_friends];
            }
            
            if ([response.bill isEqualToString:@"0"]) {
            } else if ([response.bill isEqualToString:@"1"]) {
                [self obtail_bills];
            }
            
            if ([response.delete_p isEqualToString:@"0"]) {
            } else if ([response.delete_p isEqualToString:@"1"]) {
                [self updatAllBills];
            }
            
        } else if (error) {
            NSLog(@"Finished with error: %@", error);
        } else {
            _requestsWriter.state = GRXWriterStateStarted;
            NSLog(@"%li", (long)_requestsWriter.state);
        }
    }];
    
}

- (void)obtail_bills {
    [_bill_latest removeAllObjects];
    
    NSString * const kRemoteHost = ServerHost;
    Bill_request *request = [Bill_request message];
    request.username = _leftMenu.idText.text;
    request.start = @"0";
    request.amount = @"4";
    
    //
//    if ([_result isEqualToString:@""]) {
//        _result = [NSString stringWithFormat:@"%@\nNULL*NULL", _leftMenu.idText.text];
//    }
    
    Greeter *service = [[Greeter alloc] initWithHost:kRemoteHost];
    [service obtain_billsWithRequest:request handler:^(BOOL done, Share_inf *response, NSError *error){
        if (!done) {
            Bill *bill = [[Bill alloc] init];
            [bill initWithID:response.billId amount:response.amount type:response.type account:response.account date:response.data_p members:response.membersArray creater:response.creater note:response.note image:nil];

            [_bill_latest addObject:bill];
            NSLog(@"%@", response.data_p);

        } else if (error) {
            
        } else {
            [_tableView reloadData];
            
            if ([self noBillRecord]) {
                [self updatAllBills];
            } else {
            
                NSString *lastID = [[self getLatestBill] componentsSeparatedByString:@"*"][0];
                for (NSInteger i = 0; i != _bill_latest.count; i++) {
                    Bill *bill = [_bill_latest objectAtIndex:i];
                    if ([bill.bill_id isEqualToString:lastID] && i != 0) {

                        for (NSInteger j = i - 1; j >= 0; j--) {
                            bill = [_bill_latest objectAtIndex:j];
                            NSString *bill_string = [NSString stringWithFormat:@"%@*%@*%@*%@*%@*%@*%@*%@*%@*%@*%@*%@*%@*%@*%@*%@*%@*%@", bill.bill_id, bill.amount, bill.type, bill.account, bill.date, bill.creater, bill.note, bill.image, bill.members[0], bill.members[1], bill.members[2], bill.members[3], bill.members[4], bill.members[5], bill.members[6], bill.members[7], bill.members[8], bill.members[9]];
                            [self addBillToFile:bill_string];
                        }
                        break;
                    }
                    // do not update
                    if (i == _bill_latest.count - 1) {
                        [self updatAllBills];
                    }
                }
            }
            
        }
    }];
}

- (void)updatAllBills {
    NSString * const kRemoteHost = ServerHost;
    Bill_request *request = [Bill_request message];
    request.username = _leftMenu.idText.text;
    request.start = @"0";
    request.amount = @"all";
    
    [_bills removeAllObjects];
    Greeter *service = [[Greeter alloc] initWithHost:kRemoteHost];
    [service obtain_billsWithRequest:request handler:^(BOOL done, Share_inf *response, NSError *error){
        if (!done) {
            
            NSString *bill = [NSString stringWithFormat:@"%@*%@*%@*%@*%@*%@*%@*%@*%@*%@*%@*%@*%@*%@*%@*%@*%@*%@", response.billId, response.amount, response.type, response.account, response.data_p, response.creater, response.note, response.image, response.membersArray[0], response.membersArray[1], response.membersArray[2], response.membersArray[3], response.membersArray[4], response.membersArray[5], response.membersArray[6], response.membersArray[7], response.membersArray[8], response.membersArray[9]];
            [_bills addObject:bill];
        } else if (error) {
            
        } else {
            [self deleteAllBills];
            for (NSInteger i = _bills.count - 1; i >= 0; i--) {
                [self addBillToFile:_bills[i]];
            }
        }
    }];
}

/*
NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
NSString *documentsDirectory = [paths objectAtIndex:0];
NSString *fileName = [NSString stringWithFormat:@"%@/friends",
                      documentsDirectory];
[result writeToFile:fileName
         atomically:NO
           encoding:NSUTF8StringEncoding
              error:nil];
 */



#pragma mark - RKTabViewDelegate

- (void)tabView:(RKTabView *)tabView tabBecameEnabledAtIndex:(NSUInteger)index tab:(RKTabItem *)tabItem {
    NSLog(@"Tab № %tu became enabled on tab view", index);
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
    return _bill_latest.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"BillListCell";
    
    BillsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    //
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"/Icon"];
    Bill *bill = _bill_latest[indexPath.row];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@.png", dataPath, bill.creater];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    BOOL fileExist_0 = [[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/%@.png", dataPath, bill.members[0]]];
    BOOL fileExist_1 = [[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/%@.png", dataPath, bill.members[1]]];
    BOOL fileExist_2 = [[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/%@.png", dataPath, bill.members[2]]];
    BOOL fileExist_3 = [[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/%@.png", dataPath, bill.members[3]]];
    
    NSArray *date = [bill.date componentsSeparatedByString:@"-"];
    NSArray *time = [date[2] componentsSeparatedByString:@" "];

    [cell initWithTypeIcon:(fileExists ? [UIImage imageWithContentsOfFile:filePath] : [UIImage imageNamed:@"icon-user-default.png"])
                     date_day:time[0]
                   date_month:date[1]
                       amount:bill.amount
                  shareWith_0:([bill.members[0] isEqualToString:@""] ? nil : (fileExist_0 ? [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.png", dataPath, bill.members[0]]] : [UIImage imageNamed:@"icon-user-default.png"]))
                  shareWith_1:([bill.members[1] isEqualToString:@""] ? nil : (fileExist_1 ? [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.png", dataPath, bill.members[1]]] : [UIImage imageNamed:@"icon-user-default.png"]))
                  shareWith_2:([bill.members[2] isEqualToString:@""] ? nil : (fileExist_2 ? [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.png", dataPath, bill.members[2]]] : [UIImage imageNamed:@"icon-user-default.png"]))
                  shareWith_3:([bill.members[3] isEqualToString:@""] ? nil : (fileExist_3 ? [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.png", dataPath, bill.members[3]]] : [UIImage imageNamed:@"icon-user-default.png"]))];
    
    
    //cell.textLabel.text = _bills[indexPath.row];
    
    return cell;
}

#pragma mark - HELP functions

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

    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    //make a file name to write the data to using the documents directory:
    NSString *fileName = [NSString stringWithFormat:@"%@/billRecord",
                          documentsDirectory];
    NSString *exist = [[NSString alloc] initWithContentsOfFile:fileName
                                                  usedEncoding:nil
                                                         error:nil];
    int a;

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
