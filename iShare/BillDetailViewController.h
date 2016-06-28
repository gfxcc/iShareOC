//
//  BillDetailViewController.h
//  iShare
//
//  Created by caoyong on 7/28/15.
//  Copyright (c) 2015 caoyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CYkeyboard.h"

#import "FullSizeView.h"

@interface BillDetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *takePicture;

@property (weak, nonatomic) IBOutlet UILabel *amount;

@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UIView *typeBackground;

@property (weak, nonatomic) IBOutlet UILabel *paidBy;
@property (weak, nonatomic) IBOutlet UIView *paidByBackground;

@property (weak, nonatomic) IBOutlet UILabel *data;
@property (weak, nonatomic) IBOutlet UIView *dataBackground;

@property (weak, nonatomic) IBOutlet UILabel *member;
@property (weak, nonatomic) IBOutlet UIView *memberBackground;

@property (weak, nonatomic) IBOutlet UITextView *comment;
@property (weak, nonatomic) IBOutlet UILabel *creater;
@property (weak, nonatomic) IBOutlet UIView *createrBackground;

@property (strong, nonatomic) NSMutableArray *memberArray;
@property (strong, nonatomic) NSDate *mydate;


@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) FullSizeView *fullSizeView;
@property (strong, nonatomic) CYkeyboard *keyboard;
@property (strong, nonatomic) NSString *billId;
@property (strong, nonatomic) UIViewController *mainUIView;

@end
