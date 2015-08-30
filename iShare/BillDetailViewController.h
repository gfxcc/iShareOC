//
//  BillDetailViewController.h
//  iShare
//
//  Created by caoyong on 7/28/15.
//  Copyright (c) 2015 caoyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CYkeyboard.h"
#import <gRPC_pod/IShare.pbrpc.h>
#import <gRPC_pod/IShare.pbobjc.h>
#import "FullSizeView.h"
#import "tview.h"

@interface BillDetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *takePicture;

@property (weak, nonatomic) IBOutlet UILabel *amount;

@property (weak, nonatomic) IBOutlet UILabel *type;

@property (weak, nonatomic) IBOutlet UILabel *paidBy;

@property (weak, nonatomic) IBOutlet UILabel *data;

@property (weak, nonatomic) IBOutlet UILabel *member;

@property (weak, nonatomic) IBOutlet UITextView *comment;
@property (weak, nonatomic) IBOutlet UILabel *creater;

@property (strong, nonatomic) NSMutableArray *memberArray;
@property (strong, nonatomic) NSDate *mydate;
@property (strong, nonatomic) NSString *billId;

@property (strong, nonatomic) UIImage *image;

@property (strong, nonatomic) FullSizeView *fullSizeView;

@property (strong, nonatomic) CYkeyboard *keyboard;

@end
