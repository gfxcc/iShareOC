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
#import <RxLibrary/GRXWriter+Immediate.h>
#import "Bill.h"
#import "FileOperation.h"

@interface MessageCenterViewController ()
@property (nonatomic, strong) FileOperation *fileOperation;
@end

@implementation MessageCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _fileOperation = [[FileOperation alloc] init];
    _userId = [_fileOperation getUserId];
    
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
        //[segment setSelectedSegmentIndex:0];
        [_tableView reloadData];
    }
    
    NSLog(@"%ld", segment.selectedSegmentIndex);
}

- (void)confirmButtonClick:(UIButton *)sender {
    NSLog(@"%ld", sender.tag);
    Request_ *req = [_requestArray objectAtIndex:sender.tag];
    if ([req.type isEqualToString:@"payment"]) {
        [self makePayment:sender.tag];
    } else {
        [self addFriend:sender.tag];
    }
    
    
}

- (void)deleteButtonClick:(UIButton *)sender {
    NSLog(@"%ld", sender.tag);
    [self rejectRequest:sender.tag];
}

- (void)obtain_request {
    [_requestArray removeAllObjects];
    NSString * const kRemoteHost = ServerHost;
    Inf *request = [Inf message];
    request.information = [_fileOperation getUserId];
    if ([request.information isEqualToString:@""])
        return;
    
    Greeter *service = [[Greeter alloc] initWithHost:kRemoteHost];
    [service obtain_requestWithRequest:request eventHandler:^(BOOL done, Request *response, NSError *error){
        if (!done) {
            Request_ *req = [[Request_ alloc] init];
            [req initWithRequest_id:response.requestId sender:response.sender receiver:response.receiver type:response.type content:response.content response:nil request_date:response.requestDate response_date:nil];
            [_requestArray addObject:req];
            
        } else if (error) {
            [TSMessage showNotificationWithTitle:@"Sorry"
                                        subtitle:@"Can not connect to server. Please try again later."
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
    request.information = [_fileOperation getUserId];
    if ([request.information isEqualToString:@""])
        return;
    
    Greeter *service = [[Greeter alloc] initWithHost:kRemoteHost];

    [service obtain_requestLogHistoryWithRequest:request eventHandler:^(BOOL done, Request *response, NSError *error){
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
            [TSMessage showNotificationInViewController:self
                                                  title:@"GRPC ERROR"
                                               subtitle:@"makePaymentWithRequestsWriter"
                                                   type:TSMessageNotificationTypeError
                                               duration:TSMessageNotificationDurationEndless];
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
            [TSMessage showNotificationInViewController:self
                                                  title:@"GRPC ERROR"
                                               subtitle:@"request_responseWithRequest"
                                                   type:TSMessageNotificationTypeError
                                               duration:TSMessageNotificationDurationEndless];
        }
    }];
    
}

- (void)addFriend:(NSInteger)index {
    
    Request_ *req = [_requestArray objectAtIndex:index];
    
    NSString * const kRemoteHost = ServerHost;
    Repeated_string *request = [[Repeated_string alloc] init];
    [request.contentArray addObject:req.sender];
    [request.contentArray addObject:req.receiver];
    
    // Example gRPC call using a generated proto client library:
    
    Greeter *service = [[Greeter alloc] initWithHost:kRemoteHost];
    [service add_friendWithRequest:request handler:^(Inf *response, NSError *error) {
        if (response) {
            [self responseToRequestID:index];
        
        } else if (error) {
            [TSMessage showNotificationInViewController:self
                                                  title:@"Sorry"
                                               subtitle:@"Please try again later."
                                                   type:TSMessageNotificationTypeError
                                               duration:TSMessageNotificationDurationEndless];
        }
    }];

}

- (void)rejectRequest:(NSInteger)index {
    NSString * const kRemoteHost = ServerHost;
    
    Request_ *req = [_requestArray objectAtIndex:index];
    
    Response *request = [Response message];
    request.requestId = req.request_id;
    request.response = @"REJECTED";
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

    NSString *exist = [_fileOperation getFileContent:@"billRecord"];
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
        [bill initWithID:bill_content[0] amount:bill_content[1] type:bill_content[2] date:bill_content[3] members:members creater:bill_content[4] paidBy:bill_content[5] note:bill_content[6] image:bill_content[7] paidStatus:bill_content[18] typeIcon:bill_content[19]];
        
        BOOL isMember = NO;
        if ([req.sender isEqualToString:bill.paidBy]) {
            isMember = YES;
        } else {
            for (int i = 0; i != bill.members.count; i++) { // bill not paid by username. so bill need paid by idText and username owe it
                if ([req.sender isEqualToString:bill.members[i]] && [bill.paidBy isEqualToString:_userId]) {
                    isMember = YES;
                    break;
                }
            }
        }
        
        if (!isMember) {
            continue;
        }
        
        if ([bill.paidBy isEqualToString:_userId]) {
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
                if ([[bill.members objectAtIndex:i] isEqualToString:_userId]) {
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
    cell.confrimButton.hidden = NO;
    cell.deleteButton.hidden = NO;
    if (_segmentedControl.selectedSegmentIndex == 0) {
        // Request View
        Request_ *req = [_requestArray objectAtIndex:indexPath.row];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
        NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"/Icon"];
        BOOL iconExist = [[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/%@.png", dataPath, req.sender]];
        
        NSArray *req_content = [req.content componentsSeparatedByString:@"*"];
        
        if ([req.type isEqualToString:@"payment"]) {
            [cell initWithIcon:(iconExist ? [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.png", dataPath, req.sender]] : [UIImage imageNamed:@"question.png"]) label:[NSString stringWithFormat:@"%@ has paid you %@ $", req.sender, req_content[3]]];
            cell.confrimButton.tag = indexPath.row;
            [cell.confrimButton addTarget:self action:@selector(confirmButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            cell.deleteButton.tag = indexPath.row;
            [cell.deleteButton addTarget:self action:@selector(deleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        } else if ([req.type isEqualToString:@"friendInvite"]) {
            if (!iconExist) {
                [self downloadPicture:req.sender];
            }
            
            [cell initWithIcon:(iconExist ? [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.png", dataPath, req.sender]] : [UIImage imageNamed:@"question.png"]) label:[NSString stringWithFormat:@"Friend invite: %@", req.content]];
            cell.confrimButton.tag = indexPath.row;
            [cell.confrimButton addTarget:self action:@selector(confirmButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            cell.deleteButton.tag = indexPath.row;
            [cell.deleteButton addTarget:self action:@selector(deleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            
        }
    } else {
        // RequestLog View
        Request_ *req = [_requestLogArray objectAtIndex:indexPath.row];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
        NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"/Icon"];
        BOOL iconExist = [[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/%@.png", dataPath, req.sender]];
        
        NSArray *req_content = [req.content componentsSeparatedByString:@"*"];
        
        if ([req.type isEqualToString:@"payment"]) {
            [cell initWithIcon:(iconExist ? [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.png", dataPath, req.sender]] : [UIImage imageNamed:@"question.png"]) label:[NSString stringWithFormat:@"%@ has paid you %@ $", req.sender, req_content[3]]];
        } else if ([req.type isEqualToString:@"friendInvite"]) {
            [cell initWithIcon:(iconExist ? [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.png", dataPath, req.sender]] : [UIImage imageNamed:@"question.png"]) label:[NSString stringWithFormat:@"Friend invite: %@", req.content]];
        }
        
        if ([req.response isEqualToString:@"OK"]) {
            cell.deleteButton.hidden = YES;
        } else {
            cell.confrimButton.hidden = YES;
        }
        
    }
    
    return cell;
}

- (void)downloadPicture:(NSString*)image {
    
    NSString * const kRemoteHost = ServerHost;
    
    Repeated_string *request = [Repeated_string message];
    
    // better?
    
    [request.contentArray insertObject:@"icon" atIndex:0];
    [request.contentArray insertObject:image atIndex:1];
    
//    for (int i = 0; i != request.contentArray.count; i++) {
//        NSLog(@"%@", request.contentArray[i]);
//    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"/Icon"];
    
    Greeter *service = [[Greeter alloc] initWithHost:kRemoteHost];
    [service receive_ImgWithRequest:request eventHandler:^(BOOL done, Image *response, NSError *error) {
        if (!done) {
            if (response.data_p.length == 0) {
                return;
            }
            NSLog(@"%lu", (unsigned long)response.data_p.length);
            [response.data_p writeToFile:[NSString stringWithFormat:@"%@/%@.png", dataPath, response.name] atomically:YES];
        } else if (error) {
            [TSMessage showNotificationInViewController:self
                                                  title:@"GRPC ERROR"
                                               subtitle:@"receive_ImgWithRequest"
                                                   type:TSMessageNotificationTypeError
                                               duration:TSMessageNotificationDurationEndless];
        } else { // done
            BOOL iconExist = [[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/%@.png", dataPath, image]];
            if (iconExist) {
                [_tableView reloadData];
            }
        }
    }];
    
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
