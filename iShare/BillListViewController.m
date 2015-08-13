//
//  BillListViewController.m
//  iShare
//
//  Created by caoyong on 7/6/15.
//  Copyright (c) 2015 caoyong. All rights reserved.
//

#import "BillListViewController.h"
#import <gRPC_pod/IShare.pbrpc.h>
#import <gRPC_pod/IShare.pbobjc.h>
#import "BillTableViewCell.h"
#import "MonthTableViewCell.h"
#import "Bill.h"
#import "DateTranslate.h"
#import "BillDetailViewController.h"

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

@interface BillListViewController ()

@property (nonatomic) NSInteger selectedhead;
@property (strong, nonatomic) NSMutableDictionary *dayOfMonth;

@end

@implementation BillListViewController

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
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _selectedhead = 12;
    
    DateTranslate *dateTranslate = [[DateTranslate alloc] init];
    _dayOfMonth = dateTranslate.dayOfMonth;//[[NSMutableDictionary alloc] init];
//    [_dayOfMonth setObject:@"01.01-01.31" forKey:@"1"];
//    [_dayOfMonth setObject:@"02.01-02.28" forKey:@"2"];
//    [_dayOfMonth setObject:@"03.01-03.31" forKey:@"3"];
//    [_dayOfMonth setObject:@"04.01-04.30" forKey:@"4"];
//    [_dayOfMonth setObject:@"05.01-05.31" forKey:@"5"];
//    [_dayOfMonth setObject:@"06.01-06.30" forKey:@"6"];
//    [_dayOfMonth setObject:@"07.01-07.31" forKey:@"7"];
//    [_dayOfMonth setObject:@"08.01-08.31" forKey:@"8"];
//    [_dayOfMonth setObject:@"09.01-09.30" forKey:@"9"];
//    [_dayOfMonth setObject:@"10.01-10.31" forKey:@"10"];
//    [_dayOfMonth setObject:@"11.01-11.30" forKey:@"11"];
//    [_dayOfMonth setObject:@"12.01-12.31" forKey:@"12"];
    
    // analyze this month
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MM";
    NSString *month = [formatter stringFromDate:[NSDate date]];
    _selectedhead = 0;
    
    _billsWithMonth = [[NSMutableArray alloc] init];
    for (int i = 0; i != month.intValue; i++) {
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
        
        
        
        
        if ([bill.paidBy isEqualToString:_idText]) {
            // LEND mode
            
            bill.status = PAID;
            for (NSInteger i = 0; i != bill.members.count; i++) {
                if ([bill.paidStatus characterAtIndex:i] == '0' && ![[bill.members objectAtIndex:i] isEqualToString:_idText]) {
                    bill.status = LEND;
                    break;
                }
            }
            
        } else {
            
            NSInteger index = 0;
            for (NSInteger i = 0; i != bill.members.count; i++) {
                if ([[bill.members objectAtIndex:i] isEqualToString:_idText]) {
                    index = i;
                    break;
                }
            }
            
            if ([bill.paidStatus characterAtIndex:index] == '0') {
                bill.status = OWE;
            } else {
                bill.status = PAID;
            }
        }
        
        // start analyze date
        NSArray *date = [bill_content[3] componentsSeparatedByString:@"-"];
        NSString *month = date[1];
        [[_billsWithMonth objectAtIndex:(_billsWithMonth.count - [month intValue])] addObject:bill];
        //[_bills addObject:bill];
    }
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
        if (bill.status == LEND) {
            amount += bill.amount.doubleValue;
        } else if (bill.status == OWE) {
            amount -= bill.amount.doubleValue / bill.members.count;
        }
        
    }
    NSString *monthWithString = [NSString stringWithFormat:@"%ld", month].length == 2 ? [NSString stringWithFormat:@"%ld", month] : [NSString stringWithFormat:@"0%ld", month];
    NSString *dayRange = [NSString stringWithFormat:@"%@.01-%@.%@", monthWithString, monthWithString, [_dayOfMonth objectForKey:[NSString stringWithFormat:@"%ld", month]]];
    [cell initWithMonth:[NSString stringWithFormat:@"%ld", month] dayRange:dayRange amount:[NSString stringWithFormat:@"%.1f", amount]];
    UITapGestureRecognizer* myLabelGesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headClick:)];
    cell.tag = section;
    [cell setUserInteractionEnabled:YES];
    [cell addGestureRecognizer:myLabelGesture2];
    
    UIImageView *lineImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 59, 320, 1)];
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
    [cell initWithType:bill.type amount:[NSString stringWithFormat:@"%.1f", (bill.amount.doubleValue / bill.members.count)]  memberCount:[NSString stringWithFormat:@"%ld", bill.members.count] day:day dayHiden:NO];
 
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
