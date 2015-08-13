//
//  MessageCenterViewController.m
//  iShare
//
//  Created by caoyong on 8/10/15.
//  Copyright (c) 2015 caoyong. All rights reserved.
//

#import "MessageCenterViewController.h"
#import <gRPC_pod/IShare.pbrpc.h>
#import <gRPC_pod/IShare.pbobjc.h>
#import <TSMessageView.h>
#import "Request.h"
#import "RequestTableViewCell.h"
#import <gRPC/RxLibrary/GRXWriter.h>
#import <gRPC/RxLibrary/GRXWriteable.h>
#import <gRPC/RxLibrary/GRXWriter+Immediate.h>
#import "Bill.h"

@interface MessageCenterViewController ()

@end

@implementation MessageCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.allowsSelection = NO;
    
    [_segmentedControl addTarget:self action:@selector(segmentedControlHasChangedValue:) forControlEvents: UIControlEventValueChanged];
    
    _requestArray = [[NSMutableArray alloc] init];
    _requestLogArray = [[NSMutableArray alloc] init];
    
    [self obtain_request];
    [self obtain_requestLog];
    
}

- (void)segmentedControlHasChangedValue:(UISegmentedControl *)segment
{
    if(segment.selectedSegmentIndex == 0)
    {
        [_tableView reloadData];
    } else if (segment.selectedSegmentIndex == 1) {
        [_tableView reloadData];
    }
    
    NSLog(@"%ld", segment.selectedSegmentIndex);
}

- (void)confirmButtonClick:(UIButton *)sender {
    NSLog(@"%ld", sender.tag);
    [self makePayment:sender.tag];
    
}

- (void)obtain_request {
    [_requestArray removeAllObjects];
    NSString * const kRemoteHost = ServerHost;
    Inf *request = [Inf message];
    request.information = _idText;
    
    Greeter *service = [[Greeter alloc] initWithHost:kRemoteHost];
    [service obtain_requestWithRequest:request handler:^(BOOL done, Request *response, NSError *error){
        if (!done) {
            Request_ *req = [[Request_ alloc] init];
            [req initWithRequest_id:response.requestId sender:response.sender receiver:response.receiver type:response.type content:response.content response:nil request_date:response.requestDate response_date:nil];
            [_requestArray addObject:req];
            
        } else if (error) {
            [TSMessage showNotificationWithTitle:@"GRPC ERROR"
                                        subtitle:@"obtain_request"
                                            type:TSMessageNotificationTypeError];
        } else {
            
            [_tableView reloadData];
            
        }
    }];
}

- (void)obtain_requestLog {
    [_requestLogArray removeAllObjects];
    NSString * const kRemoteHost = ServerHost;
    Inf *request = [Inf message];
    request.information = _idText;
    
    Greeter *service = [[Greeter alloc] initWithHost:kRemoteHost];

    [service obtain_requestLogHistoryWithRequest:request handler:^(BOOL done, Request *response, NSError *error){
        if (!done) {
            Request_ *req = [[Request_ alloc] init];
            [req initWithRequest_id:response.requestId sender:response.sender receiver:response.receiver type:response.type content:response.content response:response.response request_date:response.requestDate response_date:response.responseDate];
            [_requestLogArray addObject:req];
            
        } else if (error) {
            [TSMessage showNotificationWithTitle:@"GRPC ERROR"
                                        subtitle:@"obtain_requestLog"
                                            type:TSMessageNotificationTypeError];
        } else {
            
            [_tableView reloadData];
            
        }
    }];
}

- (void)makePayment:(NSInteger)index {
    NSString * const kRemoteHost = ServerHost;
    
    NSMutableArray *bills = [[NSMutableArray alloc] initWithArray:[self getBills:[_requestArray objectAtIndex:index]]];
    
    NSMutableArray *paybills = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i != bills.count; i++) {
        BillPayment *requst = [BillPayment message];
        Bill *bill = bills[i];
        requst.billId = bill.bill_id;
        requst.paidStatus = bill.paidStatus;
        
        [paybills addObject:requst];
    }
    
    GRXWriter *_requestsWriter = [GRXWriter writerWithContainer:paybills];
    
    Greeter *service = [[Greeter alloc] initWithHost:kRemoteHost];
    
    [service makePaymentWithRequestsWriter:_requestsWriter handler:^(Inf *response, NSError *error) {
        if (response) {
            // payment finish, create requestLog and update local date
            //Request_ *req = [_requestArray objectAtIndex:index];
            [self responseToRequestID:index];
            
        } else {
            [TSMessage showNotificationWithTitle:@"GRPC ERROR"
                                        subtitle:@"makePayment"
                                            type:TSMessageNotificationTypeError];
        }
    }];
}

- (void)responseToRequestID:(NSInteger)index {
    NSString * const kRemoteHost = ServerHost;
    
    Request_ *req = [_requestArray objectAtIndex:index];
    
    Response *request = [Response message];
    request.requestId = req.request_id;
    request.response = @"OK";
    request.sender = req.sender;
    request.receiver = req.receiver;
    
    
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd hh:mm"];
    NSString *prettyVersion = [dateFormat stringFromDate:now];
    request.responseDate = prettyVersion;
    
    Greeter *service = [[Greeter alloc] initWithHost:kRemoteHost];
    [service request_responseWithRequest:request handler:^(Inf *response, NSError *error) {
        if (response) {
            //[self obtain_request];
            //[_tableView reloadData];
            [_requestArray removeObjectAtIndex:index];
            [_tableView reloadData];
            
        } else {
            [TSMessage showNotificationWithTitle:@"GRPC ERROR"
                                        subtitle:@"responseToRequestID"
                                            type:TSMessageNotificationTypeError];
        }
    }];
    
}

- (NSMutableArray *)getBills:(Request_ *)req {
    
    
    NSMutableArray *billsNeedPaid = [[NSMutableArray alloc] init];
    // load bills
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    //make a file name to write the data to using the documents directory:
    NSString *fileName = [NSString stringWithFormat:@"%@/billRecord",
                          documentsDirectory];
    NSString *exist = [[NSString alloc] initWithContentsOfFile:fileName
                                                  usedEncoding:nil
                                                         error:nil];
    NSArray *bills = [exist componentsSeparatedByString:@"\n"];

    for (NSInteger i = 0; i != bills.count; i++) {
        NSArray *bill_content = [bills[i] componentsSeparatedByString:@"*"];
        NSMutableArray *members = [[NSMutableArray alloc] init];
        for (int j = 0; j != 10; j++) {
            if ([bill_content[j + 8] isEqualToString:@""]) {
                break;
            }
            [members addObject:bill_content[j + 8]];
        }
        Bill *bill = [[Bill alloc] init];
        [bill initWithID:bill_content[0] amount:bill_content[1] type:bill_content[2] date:bill_content[3] members:members creater:bill_content[4] paidBy:bill_content[5] note:bill_content[6] image:bill_content[7] paidStatus:bill_content[18]];
        
        BOOL isMember = NO;
        if ([req.sender isEqualToString:bill.paidBy]) {
            isMember = YES;
        } else {
            for (int i = 0; i != bill.members.count; i++) { // bill not paid by username. so bill need paid by idText and username owe it
                if ([req.sender isEqualToString:bill.members[i]] && [bill.paidBy isEqualToString:_idText]) {
                    isMember = YES;
                    break;
                }
            }
        }
        
        if (!isMember) {
            continue;
        }
        
        if ([bill.paidBy isEqualToString:_idText]) {
            //bill.status = LEND;
            NSInteger index = 0;
            for (NSInteger i = 0; i != bill.members.count; i++) {
                if ([[bill.members objectAtIndex:i] isEqualToString:req.sender]) {
                    index = i;
                    break;
                }
            }
            
            NSString *paidStatus = bill.paidStatus;
            
            
            if ([paidStatus characterAtIndex:index] == '0') {
                bill.status = LEND;
            } else {
                bill.status = PAID;
            }
            
            // generate new paidstatus for makepayment;
            NSString *newPaidStatus = @"";
            for (NSInteger i = 0; i != paidStatus.length; i++) {
                if (i == index) {
                    newPaidStatus = [NSString stringWithFormat:@"%@1", newPaidStatus];
                    continue;
                }
                if ([paidStatus characterAtIndex:i] == '0') {
                    newPaidStatus = [NSString stringWithFormat:@"%@0", newPaidStatus];
                } else {
                    newPaidStatus = [NSString stringWithFormat:@"%@1", newPaidStatus];
                }
            }
            bill.paidStatus = newPaidStatus;
            
        } else { // OWE mode
            //bill.status = OWE;
            NSInteger index = 0;
            for (NSInteger i = 0; i != bill.members.count; i++) {
                if ([[bill.members objectAtIndex:i] isEqualToString:_idText]) {
                    index = i;
                    break;
                }
            }
            
            NSString *paidStatus = bill.paidStatus;
            
            if ([paidStatus characterAtIndex:index] == '0') {
                bill.status = OWE;
                //_countOfBillsNeedPaid++;
            } else {
                bill.status = PAID;
            }
            NSString *newPaidStatus = @"";
            for (NSInteger i = 0; i != paidStatus.length; i++) {
                if (i == index) {
                    newPaidStatus = [NSString stringWithFormat:@"%@1", newPaidStatus];
                    continue;
                }
                if ([paidStatus characterAtIndex:i] == '0') {
                    newPaidStatus = [NSString stringWithFormat:@"%@0", newPaidStatus];
                } else {
                    newPaidStatus = [NSString stringWithFormat:@"%@1", newPaidStatus];
                }
            }
            bill.paidStatus = newPaidStatus;
        }
        if (isMember) {
            // isMember and not PAID
            if (bill.status != PAID) {
                [billsNeedPaid addObject:bill];
            }
        }
    }
    return billsNeedPaid;
}

#pragma mark - UITableView Delegate & Datasrouce -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    // If You have only one(1) section, return 1, otherwise you must handle sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return _segmentedControl.selectedSegmentIndex ? _requestLogArray.count : _requestArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"requestCell";
    
    RequestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    Request_ *req = [_requestArray objectAtIndex:indexPath.row];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"/Icon"];
    BOOL iconExist = [[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/%@.png", dataPath, req.sender]];
    
    NSArray *req_content = [req.content componentsSeparatedByString:@"*"];
    
    [cell initWithIcon:(iconExist ? [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.png", dataPath, req.sender]] : [UIImage imageNamed:@"question.png"]) label:[NSString stringWithFormat:@"%@ has paid you %@ $", req.sender, req_content[3]]];
    cell.confrimButton.tag = indexPath.row;
    [cell.confrimButton addTarget:self action:@selector(confirmButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
