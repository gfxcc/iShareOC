//
//  TypeEditerViewController.h
//  iShare
//
//  Created by caoyong on 9/10/15.
//  Copyright (c) 2015 caoyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TypeEditerViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UIButton *addButton;


@property (strong, nonatomic) NSMutableArray *typeArray;

@end
