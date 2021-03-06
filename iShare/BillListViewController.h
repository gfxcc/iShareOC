//
//  BillListViewController.h
//  iShare
//
//  Created by caoyong on 7/6/15.
//  Copyright (c) 2015 caoyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BillListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;


@property (strong, nonatomic) NSMutableArray *billsWithMonth;
@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) UIViewController *mainUIView;

- (UIImage *)imageWithColor:(UIColor *)color;


@end

