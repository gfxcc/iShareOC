//
//  AnalyzeViewController.h
//  iShare
//
//  Created by caoyong on 7/6/15.
//  Copyright (c) 2015 caoyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnalyzeViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(strong, nonatomic) NSMutableArray *friendsArray;
@property(strong, nonatomic) NSMutableArray *friendsIdArray;
@property(strong, nonatomic) NSMutableArray *billsWithFriend;
@property(strong, nonatomic) NSMutableArray *result;
@property(strong, nonatomic) NSString *idText;
@property (strong, nonatomic) UIViewController *mainUIView;

@end
