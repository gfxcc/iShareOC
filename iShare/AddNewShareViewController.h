//
//  AddNewShareViewController.h
//  iShare
//
//  Created by caoyong on 5/12/15.
//  Copyright (c) 2015 caoyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CYkeyboard.h"
#import "DaiDodgeKeyboard.h"

@interface AddNewShareViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate>


@property (weak, nonatomic) IBOutlet UIButton *takePicture;

@property (weak, nonatomic) IBOutlet UILabel *amount;

@property (weak, nonatomic) IBOutlet UILabel *type;

@property (weak, nonatomic) IBOutlet UILabel *account;

@property (weak, nonatomic) IBOutlet UILabel *data;

@property (weak, nonatomic) IBOutlet UILabel *member;

@property (weak, nonatomic) IBOutlet UITextView *comment;

@property (weak, nonatomic) NSString *idText;
@property (strong, nonatomic) NSDate *mydate;

- (void)unlight;
@end


CYkeyboard *keyboard;