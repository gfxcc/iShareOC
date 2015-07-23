//
//  SearchViewController.h
//  iShare
//
//  Created by caoyong on 6/14/15.
//  Copyright (c) 2015 caoyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftMenuViewController.h"

@interface SearchViewController : UIViewController <UISearchDisplayDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) LeftMenuViewController *LeftMenuView;

@end
