//
//  MessageCenterViewController.h
//  iShare
//
//  Created by caoyong on 8/10/15.
//  Copyright (c) 2015 caoyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageCenterViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@property(strong, nonatomic) NSString *idText;
@property(strong, nonatomic) NSString *userId;
@property(strong, nonatomic) NSMutableArray *requestArray;
@property(strong, nonatomic) NSMutableArray *requestLogArray;

@end
