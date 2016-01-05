//
//  BillListWithFriendViewController.m
//  iShare
//
//  Created by caoyong on 7/30/15.
//  Copyright (c) 2015 caoyong. All rights reserved.
//

#import "BillListWithFriendViewController.h"
#import "Bill.h"
#import "BillTableViewCell.h"
#import "MonthTableViewCell.h"
#import "DateTranslate.h"
#import "BillDetailViewController.h"
#import <gRPC_pod/IShare.pbrpc.h>
#import <gRPC_pod/IShare.pbobjc.h>
#import <TSMessageView.h>
#import <gRPC/RxLibrary/GRXWriter.h>
#import <gRPC/RxLibrary/GRXWriteable.h>
#import <gRPC/RxLibrary/GRXWriter+Immediate.h>
#import "PullAction.h"

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

@interface BillListWithFriendViewController ()

@property (nonatomic) NSInteger selectedhead;
@property (strong, nonatomic) NSMutableDictionary *dayOfMonth;
@property (strong, nonatomic) NSString *currentYear;
@property (strong, nonatomic) NSString *realYear;
@property (strong, nonatomic) UILabel *currentLabel;
@property (nonatomic, strong) PullAction *pullAction;

@end

@implementation BillListWithFriendViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView deselectRowAtIndexPath:[_tableView indexPathForSelectedRow] animated:YES];
}

- (BOOL)prefersStatusBarHidden {
    return self.navigationController.isNavigationBarHidden;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];

    [button setImage:[UIImage imageNamed:@"payment.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(payAllBills)forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(0, 0, 50, 50)];
    UIBarButtonItem *payment = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:payment, nil];
    _bills = [[NSMutableArray alloc] init];
    _billsWithMonth = [[NSMutableArray alloc] init];
    
    DateTranslate *dateTranslate = [[DateTranslate alloc] init];
    _dayOfMonth = dateTranslate.dayOfMonth;
    
    // set navigation title
    // get year
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy";
    NSString *year = [formatter stringFromDate:[NSDate date]];
    _currentYear = year;
    _realYear = year;
    
    // set back button's text to year
    
    //self.navigationController.navigationItem.leftBarButtonItem.
    CGSize labelSize = [[NSString stringWithFormat:@"%@ list", year] sizeWithAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:17]}];
    //UIFont *font = [UIFont boldSystemFontOfSize:17];
    UIView *yearView = [[UIView alloc] initWithFrame:CGRectMake(0, -labelSize.height, labelSize.width, labelSize.height)];
    yearView.clipsToBounds = YES;
    UILabel *label = [[UILabel alloc] initWithFrame:yearView.frame];
    _currentLabel = label;
    //[label setFont:font];
    label.text = [NSString stringWithFormat:@"%@ list", year];
    
    [yearView addSubview:label];
    self.navigationItem.titleView = yearView;
    
    [UIView animateWithDuration:0.5 animations:^{
        label.frame = CGRectMake(0, 0, labelSize.width, labelSize.height);
    }];
    
    [self loadBills];
    
    _pullAction = [[PullAction alloc] initInScrollView:self.tableView];
    [_pullAction addTarget:self action:@selector(changeYear) forControlEvents:UIControlEventValueChanged];

}

- (void)changeYear {
    //NSLog(@"invoked\n");
    //NSLog(@"invoked %i\n", _pullAction.functionNum);
    
    switch (_pullAction.functionNum) {
        case 0:
            /* invoke top */
            [self changeToNextYear];
            break;
        case 1:
            /* invoke bot */
            [self changeToLastYear];
            break;
        default:
            break;
    }
    
    [self performSelector:@selector(finishRefresh) withObject:nil afterDelay:0.5f];
}

- (void)finishRefresh {
    [_pullAction endRefreshing];
    [self loadBills];
}

- (void)changeToNextYear {
    UIView *yearView = self.navigationItem.titleView;
    NSString *nextYear = [NSString stringWithFormat:@"%i", _currentYear.intValue + 1];
    _currentYear = nextYear;
    UILabel *newLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, -_currentLabel.frame.size.height, _currentLabel.frame.size.width, _currentLabel.frame.size.height)];
    newLabel.text = [NSString stringWithFormat:@"%@ list", nextYear];
    
    [yearView addSubview:newLabel];
    
    [UIView animateWithDuration:0.5 animations:^{
        _currentLabel.frame = CGRectMake(0, _currentLabel.frame.size.height, _currentLabel.frame.size.width, _currentLabel.frame.size.height);
        newLabel.frame = CGRectMake(0, 0, _currentLabel.frame.size.width, _currentLabel.frame.size.height);
    } completion:^(BOOL finished)
     {
         [_currentLabel removeFromSuperview];
         _currentLabel = newLabel;
     }];
    
}

- (void)changeToLastYear {
    UIView *yearView = self.navigationItem.titleView;
    NSString *nextYear = [NSString stringWithFormat:@"%i", _currentYear.intValue - 1];
    _currentYear = nextYear;
    UILabel *newLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _currentLabel.frame.size.height, _currentLabel.frame.size.width, _currentLabel.frame.size.height)];
    newLabel.text = [NSString stringWithFormat:@"%@ list", nextYear];
    
    [yearView addSubview:newLabel];
    
    [UIView animateWithDuration:0.5 animations:^{
        _currentLabel.frame = CGRectMake(0, -_currentLabel.frame.size.height, _currentLabel.frame.size.width, _currentLabel.frame.size.height);
        newLabel.frame = CGRectMake(0, 0, _currentLabel.frame.size.width, _currentLabel.frame.size.height);
    } completion:^(BOOL finished)
     {
         [_currentLabel removeFromSuperview];
         _currentLabel = newLabel;
     }];
}

- (void)loadBills {
    // clear bills
    [_bills removeAllObjects];
    [_billsWithMonth removeAllObjects];
    
    // analyze this month
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MM";
    NSString *month = [formatter stringFromDate:[NSDate date]];
    _selectedhead = 0;
    
    /* create month label */
    int monthNum;
    if ([_currentYear isEqualToString:_realYear]) {
        monthNum = month.intValue;
    } else if (_currentYear.intValue < _realYear.intValue) {
        monthNum = 12;
    } else {
        monthNum = 1;
    }
    for (int i = 0; i != monthNum; i++) {
        NSMutableArray *bill = [[NSMutableArray alloc] init];
        [_billsWithMonth addObject:bill];
    }
    
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
    
    if ([bills[0] isEqualToString:@""]) {
        bills = [[NSArray alloc] init];
    }
    
    _countOfBillsNeedPaid = 0;
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
        
        // analyze date
        NSArray *date = [bill.date componentsSeparatedByString:@"-"];
        NSString *year = date[0];
        if (![year isEqualToString:_currentYear]) {
            continue;
        }
        
        BOOL isMember = NO;
        if ([_username isEqualToString:bill.paidBy]) {
            isMember = YES;
        } else {
            for (int i = 0; i != bill.members.count; i++) { // bill not paid by username. so bill need paid by idText and username owe it
                if ([_username isEqualToString:bill.members[i]] && [bill.paidBy isEqualToString:_idText]) {
                    isMember = YES;
                    break;
                }
            }
        }
        
        if (!isMember) {
            continue;
        }
        
        // get login username
        fileName = [NSString stringWithFormat:@"%@/friends",
                    documentsDirectory];
        exist = [[NSString alloc] initWithContentsOfFile:fileName
                                            usedEncoding:nil
                                                   error:nil];
        NSArray *friends = [exist componentsSeparatedByString:@"\n"];
        if ([bill.paidBy isEqualToString:friends[0]]) {
            //bill.status = LEND;
            NSInteger index = 0;
            for (NSInteger i = 0; i != bill.members.count; i++) {
                if ([[bill.members objectAtIndex:i] isEqualToString:_username]) {
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
                if ([[bill.members objectAtIndex:i] isEqualToString:friends[0]]) {
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
            [_bills addObject:bill];
            if (bill.status != PAID) {
                _countOfBillsNeedPaid++;
            }
        }
    }
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //_selectedhead = 12;

    
    // load bills
    
    for (NSInteger i = 0; i != _bills.count; i++) {
        
        
        // start analyze date
        Bill *bill = [_bills objectAtIndex:i];
        NSArray *date = [bill.date componentsSeparatedByString:@"-"];
        NSString *month = date[1];
        [[_billsWithMonth objectAtIndex:(_billsWithMonth.count - [month intValue])] addObject:bill];
        //[_bills addObject:bill];
    }
    [_tableView reloadData];
}

- (void)obtainBillsAtIndex {
    
}

#pragma mark - UITableView Delegate & Datasrouce -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    // If You have only one(1) section, return 1, otherwise you must handle sections
    return _billsWithMonth.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    if (section == _selectedhead) {
        return [[_billsWithMonth objectAtIndex:section] count] == 0 ? 1 : [[_billsWithMonth objectAtIndex:section] count];
    }
    
    return 0;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

//设置表头的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60;
}

//Section Footer的高度
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 0.2;
//}

//设置view，将替代titleForHeaderInSection方法
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    
    static NSString *CellIdentifier = @"monthcell";
    
    MonthTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NSInteger month = _billsWithMonth.count - section;
    double amount = 0;
    // count amount
    for (int i = 0; i != [[_billsWithMonth objectAtIndex:section] count]; i++) {
        Bill *bill = [_billsWithMonth objectAtIndex:section][i];
        //amount += bill.amount.intValue;
        switch (bill.status) {
            case OWE:
                amount -= bill.amount.doubleValue / bill.members.count;
                break;
            case LEND:
                amount += bill.amount.doubleValue / bill.members.count;
                break;
            default:
                break;
        }
    }
    
    
    
    NSString *monthWithString = [NSString stringWithFormat:@"%ld", month].length == 2 ? [NSString stringWithFormat:@"%ld", month] : [NSString stringWithFormat:@"0%ld", month];
    NSString *dayRange = [NSString stringWithFormat:@"%@.01-%@.%@", monthWithString, monthWithString, [_dayOfMonth objectForKey:[NSString stringWithFormat:@"%ld", month]]];
    [cell initWithMonth:[NSString stringWithFormat:@"%ld", month] dayRange:dayRange amount:[NSString stringWithFormat:@"%.1f", amount]];
    UITapGestureRecognizer* myLabelGesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headClick:)];
    cell.tag = section;
    [cell setUserInteractionEnabled:YES];
    [cell addGestureRecognizer:myLabelGesture2];
    
    UIImageView *lineImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 59, [UIScreen mainScreen].bounds.size.width, 1)];
    lineImage.image = [UIImage imageNamed:@"line.png"];
    [cell addSubview:lineImage];
    
    return cell.viewForBaselineLayout;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"billcell";
    //
    if ([[_billsWithMonth objectAtIndex:indexPath.section] count] == 0) {
        //norecordcell
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"norecordcell"];
        return cell;
    }
    
    BillTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    Bill *bill = [[_billsWithMonth objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    NSArray *date = [bill.date componentsSeparatedByString:@"-"];
    NSString *day = [date[2] componentsSeparatedByString:@" "][0];
    [cell initWithType:bill.type TypeIcon:bill.typeIcon amount:[NSString stringWithFormat:@"%.1f", (bill.amount.doubleValue / bill.members.count)]  memberCount:[NSString stringWithFormat:@"%ld", bill.members.count] day:day dayHiden:NO];
    
    // day hiden or not
    if (indexPath.row != 0) {
        Bill *preBill = [[_billsWithMonth objectAtIndex:indexPath.section] objectAtIndex:(indexPath.row - 1)];
        NSString *preDay = [[preBill.date componentsSeparatedByString:@"-"][2] componentsSeparatedByString:@" "][0];
        if ([preDay isEqualToString:day]) {
            [cell SetDayHiden:YES];
        }
    }
    
    // monthLine hiden or not
    if ((indexPath.row + 1) != [[_billsWithMonth objectAtIndex:indexPath.section] count]) {
        Bill *nextBill = [[_billsWithMonth objectAtIndex:indexPath.section] objectAtIndex:(indexPath.row + 1)];
        NSString *nextDay = [[nextBill.date componentsSeparatedByString:@"-"][2] componentsSeparatedByString:@" "][0];
        if ([nextDay isEqualToString:day]) {
            [cell SetMonthLineHiden:YES];
        }
    }
    
    // amount color
    switch (bill.status) {
        case OWE:
            cell.amount.textColor = RGB(255, 121, 100);
            break;
        case LEND:
            cell.amount.textColor = RGB(132, 183, 255);
            break;
        case PAID:
            cell.amount.textColor = RGB(185, 185, 185);
            break;
        default:
            break;
    }
    
    return cell;
    
}

- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {
    [self performSegueWithIdentifier:@"billDetail" sender:self];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"billDetail"]) {
        BillDetailViewController *billDetail = (BillDetailViewController *)[segue destinationViewController];
        Bill *bill = [[_billsWithMonth objectAtIndex:[_tableView indexPathForSelectedRow].section] objectAtIndex:[_tableView indexPathForSelectedRow].row];
        billDetail.billId = bill.bill_id;
        billDetail.mainUIView = _mainUIView;
    }
}

- (void)headClick:(UITapGestureRecognizer *)sender {
    
    _selectedhead = (_selectedhead == sender.view.tag) ? 12 : sender.view.tag;
    
    [_tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)payAllBills {

    UIAlertView *updateAlert = [[UIAlertView alloc] initWithTitle:@"Payment" message:[NSString stringWithFormat:@"I have paid %.1f to %@", _sum.doubleValue, _username] delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"Sure!", nil];
    
    [updateAlert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            break;
        case 1:// Sure!
            if ([_sum isEqualToString:@"0.0"]) {
                
                [TSMessage showNotificationWithTitle:@"NO bill"
                                            subtitle:@"...."
                                                type:TSMessageNotificationTypeWarning];
            } else if (_sum.doubleValue > 0) {
                [self makePayment];
            } else {
                [self sendPaymentRequest];
            }
            
            break;
        default:
            break;
    }
    
}

- (void)makePayment {
    NSString * const kRemoteHost = ServerHost;

    
    NSMutableArray *paybills = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i != _countOfBillsNeedPaid; i++) {
        BillPayment *requst = [BillPayment message];
        Bill *bill = _bills[i];
        requst.billId = bill.bill_id;
        requst.paidStatus = bill.paidStatus;
        
        [paybills addObject:requst];
    }

    GRXWriter *_requestsWriter = [GRXWriter writerWithContainer:paybills];
    
//    GRXWriter *_requestsWriter = [GRXWriter writerWithValueSupplier:^id() {
//        BillPayment *test1 = [BillPayment message];
//        //test1.information = _leftMenu.idText.text;
//        [NSThread sleepForTimeInterval:1.0f];
//        return test1;
//    }];
    
    
    Greeter *service = [[Greeter alloc] initWithHost:kRemoteHost];
    
    [service makePaymentWithRequestsWriter:_requestsWriter handler:^(Inf *response, NSError *error) {
        if (response) {
            // payment finish, create requestLog and update local date
            [self createRequestLog];
            
        } else {
            [TSMessage showNotificationWithTitle:@"GRPC ERROR"
                                        subtitle:@"makePayment"
                                            type:TSMessageNotificationTypeError];
        }
    }];
}

- (void)createRequestLog {
    NSString * const kRemoteHost = ServerHost;
    
    
    Request *request = [Request message];
    request.sender = _idText;
    request.receiver = _username;
    request.type = @"receivePayment";
    request.response = @"OK";
    
    Bill *lastOfPaid = _bills[0];
    Bill *firstOfPaid = _bills[_countOfBillsNeedPaid - 1];
    request.content = [NSString stringWithFormat:@"%@*%@*%ld*%@",firstOfPaid.bill_id, lastOfPaid.bill_id, _countOfBillsNeedPaid, _sum];
    
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd hh:mm"];
    NSString *prettyVersion = [dateFormat stringFromDate:now];
    request.requestDate = prettyVersion;
    request.responseDate = prettyVersion;

    Greeter *service = [[Greeter alloc] initWithHost:kRemoteHost];
    [service create_requestLogWithRequest:request handler:^(Inf *response, NSError *error) {
        if (response) {
            
        } else if (error) {
            [TSMessage showNotificationWithTitle:@"GRPC ERROR"
                                        subtitle:@"send_requestWithRequest"
                                            type:TSMessageNotificationTypeError];
        }
    }];
}

- (void)sendPaymentRequest {
    

    NSString * const kRemoteHost = ServerHost;
    Request *request = [Request message];
    request.sender = _idText;
    request.receiver = _username;
    request.type = @"payment";
    Bill *lastOfPaid = _bills[0];
    Bill *firstOfPaid = _bills[_countOfBillsNeedPaid - 1];
    
    //formate FIRSTID:%@ LASTID:%@ COUNT:%ld
    request.content = [NSString stringWithFormat:@"%@*%@*%ld*%@",firstOfPaid.bill_id, lastOfPaid.bill_id, _countOfBillsNeedPaid, [NSString stringWithFormat:@"%.1f", (_sum.doubleValue * -1)]];
    
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd hh:mm"];
    NSString *prettyVersion = [dateFormat stringFromDate:now];
    request.requestDate = prettyVersion;
    
    Greeter *service = [[Greeter alloc] initWithHost:kRemoteHost];
    [service send_requestWithRequest:request handler:^(Inf *response, NSError *error) {
        if (response) {
            [TSMessage showNotificationWithTitle:@"Message"
                                        subtitle:@"Your payment request has been send successfully. Please waiting for response!"
                                            type:TSMessageNotificationTypeMessage];
            
        } else if (error) {
            [TSMessage showNotificationWithTitle:@"GRPC ERROR"
                                        subtitle:@"send_requestWithRequest"
                                            type:TSMessageNotificationTypeError];
        }
     }];
}

- (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
