//
//  SettingViewController.h
//  iShare
//
//  Created by caoyong on 1/23/16.
//  Copyright © 2016 caoyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface SettingViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) UIViewController *mainUIView;
@property (strong, nonatomic) NSString *username;

@end
