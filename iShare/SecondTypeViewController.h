//
//  SecondTypeViewController.h
//  iShare
//
//  Created by caoyong on 9/11/15.
//  Copyright (c) 2015 caoyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecondTypeViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *editButton;

@property (nonatomic) NSInteger indexOfType;
@property (strong, nonatomic) NSMutableArray *typeArray; // !!!! this array contain all element of a type. The really count of second type should be (_typeArray.count / 2) - 1

@end
