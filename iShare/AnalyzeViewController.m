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
#import "ViewController.h"
#import "FileOperation.h"

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

@interface AnalyzeViewController ()

//@property (nonatomic, strong) ODRefreshControl *refreshControl;

@property (nonatomic, strong) ODRefreshControl *refreshControl;
@property (nonatomic, strong) FileOperation *fileOperation;
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
    _fileOperation = [[FileOperation alloc] init];
    
    /* setup refresh
    // Do any additional setup after loading the view.
//    _refreshControl = [[ODRefreshControl alloc] initInScrollView:self.tableView];
//    [_refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    
    _refreshControl = [[UIRefreshControl alloc] init];
    //_refreshControl.backgroundColor = [UIColor purpleColor];
    //_refreshControl.tintColor = [UIColor whiteColor];
    [_refreshControl addTarget:self
                            action:@selector(refresh)
                  forControlEvents:UIControlEventValueChanged];
    [_tableView addSubview:_refreshControl];*/
    
    //RGB(115, 117, 122)
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    
    _refreshControl = [[ODRefreshControl alloc] initInScrollView:self.tableView];
    [_refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    


    _friendsArray = [[NSMutableArray alloc] initWithArray:[_fileOperation getFriendsNameList]];
    _friendsIdArray = [[NSMutableArray alloc] initWithArray:[_fileOperation getFriendsIdList]];

    _idText = [_fileOperation getUsername];
    
    //  init billsWithFriend
    _billsWithFriend = [[NSMutableArray alloc] init];
    _result = [[NSMutableArray alloc] init];
    
    for (int i = 0; i != _friendsArray.count; i++) {
        [_billsWithFriend addObject:[[NSMutableArray alloc] init]];
        //[_result addObject:];
    }
    

    NSString *exist = [_fileOperation getFileContent:@"billRecord"];
    NSArray *bills = [exist componentsSeparatedByString:@"\n"];
    
    NSString *user_id = [_fileOperation getUserId];
    
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

        if ([bill.paidBy isEqualToString:user_id]) {
            // LEND mode
            for (NSInteger j = 0; j != bill.members.count; j++) {
                NSString *paidStatus = bill.paidStatus;
                if ([paidStatus characterAtIndex:j] == '0') {
                    bill.status = LEND;
                } else {
                    bill.status = PAID;
                }
                
                // share with self
                if ([user_id isEqualToString:bill.members[j]]) {
                    continue;
                }
                
                NSInteger friendIndex = -1;
                for (NSInteger k = 0; k != _friendsArray.count; k++) {
                    if ([[_friendsIdArray objectAtIndex:k] isEqualToString:bill.members[j]]) {
                        friendIndex = k;
                        Bill *addBill = [[Bill alloc] init];
                        [addBill initWithBill:bill];
                        [[_billsWithFriend objectAtIndex:friendIndex] addObject:addBill];
                        break;
                    }
                }
                if (friendIndex == -1) {
                    continue;
                }
                
            }
        } else { // OWE mode
            NSInteger index = 0;
            for (NSInteger j = 0; j != bill.members.count; j++) {
                if ([[bill.members objectAtIndex:j] isEqualToString:user_id]) {
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
            

            NSInteger friendIndex = -1;
            for (NSInteger k = 0; k != _friendsArray.count; k++) {
                if ([[_friendsIdArray objectAtIndex:k] isEqualToString:bill.paidBy]) {
                    friendIndex = k;
                    break;
                }
            }
            if (friendIndex == -1) {
                continue;
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
    
    ViewController *mainUI = (ViewController*)_mainUIView;
    [mainUI updateAllBills];
    
    /*
    [UIView animateWithDuration:2.0 animations:^{
        [_refreshControl endRefreshing];
    }];*/
    [self performSelector:@selector(finishRefresh) withObject:nil afterDelay:0.5f];
}

- (void)finishRefresh {
    [_refreshControl endRefreshing];
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
    
    dataPath = [NSString stringWithFormat:@"%@/%@.png", dataPath, _friendsIdArray[indexPath.row]];
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
