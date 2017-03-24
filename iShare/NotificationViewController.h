//
//  NotificationViewController.h
//  iShare
//
//  Created by caoyong on 1/23/16.
//  Copyright © 2016 caoyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
