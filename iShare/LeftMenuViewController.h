//
//  LeftMenuViewController.h
//  iShare
//
//  Created by caoyong on 5/11/15.
//  Copyright (c) 2015 caoyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FullSizeView.h"


@interface LeftMenuViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, FullSizeViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (nonatomic, assign) BOOL slideOutAnimationEnabled;
@property (weak, nonatomic) IBOutlet UILabel *idText;
@property (weak, nonatomic) IBOutlet UIButton *log_button;
@property (weak, nonatomic) IBOutlet UIButton *add_sign_button;


@property(strong, nonatomic) NSMutableArray *friendsArray;


@property (weak, nonatomic) UIViewController *mainUIView;
@property (weak, nonatomic) UINavigationController *mainUINavgation;

- (void)obtain_friends;


@end
