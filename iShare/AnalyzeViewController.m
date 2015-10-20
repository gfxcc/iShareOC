//
//  AnalyzeViewController.m
//  iShare
//
//  Created by caoyong on 7/6/15.
//  Copyright (c) 2015 caoyong. All rights reserved.
//

#import "AnalyzeViewController.h"
#import "FriendWithBillTableViewCell.h"
#import "BillListWithFriendViewController.h"
#import "Bill.h"
#import "ODRefreshControl.h"

@interface AnalyzeViewController ()

@end

@implementation AnalyzeViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView deselectRowAtIndexPath:[_tableView indexPathForSelectedRow] animated:YES];
}

//- (BOOL)prefersStatusBarHidden {
//    return self.navigationController.isNavigationBarHidden;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    ODRefreshControl *refreshControl = [[ODRefreshControl alloc] initInScrollView:self.tableView];
    [refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    
    NSString *fileName = [NSString stringWithFormat:@"%@/friends",
                          documentsDirectory];
    NSString *content = [[NSString alloc] initWithContentsOfFile:fileName
                                                    usedEncoding:nil
                                                           error:nil];
    NSArray *members = [content componentsSeparatedByString:@"\n"];
    _friendsArray = [[NSMutableArray alloc] init];
    for (int i = 1; i < members.count; i++) {
        [_friendsArray addObject:members[i]];
    }
    _idText = members[0];
    
    //  init billsWithFriend
    _billsWithFriend = [[NSMutableArray alloc] init];
    _result = [[NSMutableArray alloc] init];
    
    for (int i = 0; i != _friendsArray.count; i++) {
        [_billsWithFriend addObject:[[NSMutableArray alloc] init]];
        //[_result addObject:];
    }
    
    fileName = [NSString stringWithFormat:@"%@/billRecord",
                          documentsDirectory];
    NSString *exist = [[NSString alloc] initWithContentsOfFile:fileName
                                                  usedEncoding:nil
                                                         error:nil];
    NSArray *bills = [exist componentsSeparatedByString:@"\n"];
    
    if ([bills[0] isEqualToString:@""]) {
        bills = [[NSArray alloc] init];
    }
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
        //
        // get login username
        fileName = [NSString stringWithFormat:@"%@/friends",
                    documentsDirectory];
        exist = [[NSString alloc] initWithContentsOfFile:fileName
                                            usedEncoding:nil
                                                   error:nil];
        NSArray *friends = [exist componentsSeparatedByString:@"\n"];
        if ([bill.paidBy isEqualToString:friends[0]]) {
            // LEND mode
            for (NSInteger j = 0; j != bill.members.count; j++) {
                NSString *paidStatus = bill.paidStatus;
                if ([paidStatus characterAtIndex:j] == '0') {
                    bill.status = LEND;
                } else {
                    bill.status = PAID;
                }
                
                // share with self
                if ([friends[0] isEqualToString:bill.members[j]]) {
                    continue;
                }
                
                NSInteger friendIndex = 0;
                for (NSInteger k = 0; k != _friendsArray.count; k++) {
                    if ([[_friendsArray objectAtIndex:k] isEqualToString:bill.members[j]]) {
                        friendIndex = k;
                        Bill *addBill = [[Bill alloc] init];
                        [addBill initWithBill:bill];
                        [[_billsWithFriend objectAtIndex:friendIndex] addObject:addBill];
                        break;
                    }
                }
                if (friendIndex == 0) {
                    NSLog(@"");
                }
                
            }
        } else { // OWE mode
            NSInteger index = 0;
            for (NSInteger j = 0; j != bill.members.count; j++) {
                if ([[bill.members objectAtIndex:j] isEqualToString:friends[0]]) {
                    index = j;
                    break;
                }
            }
            NSString *paidStatus = bill.paidStatus;
            if ([paidStatus characterAtIndex:index] == '0') {
                bill.status = OWE;
            } else {
                bill.status = PAID;
            }
            

            NSInteger friendIndex = 0;
            for (NSInteger k = 0; k != _friendsArray.count; k++) {
                if ([[_friendsArray objectAtIndex:k] isEqualToString:bill.paidBy]) {
                    friendIndex = k;
                    break;
                }
            }
            if (friendIndex == 0) {
                NSLog(@"");
            }
            [[_billsWithFriend objectAtIndex:friendIndex] addObject:bill];
        }
    }
    
    // sum
    for (NSInteger i = 0; i != _billsWithFriend.count; i++) {
        double sum = 0;
        NSMutableArray *bills = [_billsWithFriend objectAtIndex:i];
        for (NSInteger j = 0; j != bills.count; j++) {
            Bill *bill = [bills objectAtIndex:j];
            switch (bill.status) {
                case OWE:
                    sum -= bill.amount.doubleValue / bill.members.count;
                    break;
                case LEND:
                    sum += bill.amount.doubleValue / bill.members.count;
                    
                default:
                    break;
            }
        }
        [_result addObject:[NSString stringWithFormat:@"%.1f", sum]];
    }
    
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
}


- (void)refresh {

}

#pragma mark -
#pragma mark TableView delegate

// Return the number of sections

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    // If You have only one(1) section, return 1, otherwise you must handle sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return _friendsArray.count;
}

// Return the row for the corresponding section and row
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"friendWithBillCell";
    FriendWithBillTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"/Icon"];
    
    dataPath = [NSString stringWithFormat:@"%@/%@.png", dataPath, _friendsArray[indexPath.row]];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:dataPath];

    
    [cell initWithIcon:(fileExists ? [UIImage imageWithContentsOfFile:dataPath] : [UIImage imageNamed:@"icon-user-default.png"]) username:_friendsArray[indexPath.row] amount:[_result objectAtIndex:indexPath.row]];
    
    return cell;
}

// Return the event when tap on the cell
- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {
    
    [self performSegueWithIdentifier:@"billListWithFriend" sender:self];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"billListWithFriend"]) {
        BillListWithFriendViewController *billList = (BillListWithFriendViewController *)[segue destinationViewController];
        //Bill *bill = [[_billsWithMonth objectAtIndex:[_tableView indexPathForSelectedRow].section] objectAtIndex:[_tableView indexPathForSelectedRow].row];
        billList.username = _friendsArray[[_tableView indexPathForSelectedRow].row];
        billList.navigationItem.title = _friendsArray[[_tableView indexPathForSelectedRow].row];
        billList.sum = [_result objectAtIndex:[_tableView indexPathForSelectedRow].row];
        billList.idText = _idText;
        billList.mainUIView = _mainUIView;
    }
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
