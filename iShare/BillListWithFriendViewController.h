//
//  BillListWithFriendViewController.h
//  iShare
//
//  Created by caoyong on 7/30/15.
//  Copyright (c) 2015 caoyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BillListWithFriendViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;


@property (strong, nonatomic) NSString *idText;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSMutableArray *bills;
@property (nonatomic) NSInteger countOfBillsNeedPaid;
@property (nonatomic) NSInteger countOfMakePayment;
@property (strong, nonatomic) NSMutableArray *billsWithMonth;
@property (strong, nonatomic) NSString *sum;


@end
