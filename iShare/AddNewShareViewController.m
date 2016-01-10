//
//  AddNewShareViewController.m
//  iShare
//
//  Created by caoyong on 5/12/15.
//  Copyright (c) 2015 caoyong. All rights reserved.
//

#import "AddNewShareViewController.h"
#import "UIWindow+YUBottomPoper.h"
#import <gRPC_pod/IShare.pbrpc.h>
#import <gRPC_pod/IShare.pbobjc.h>
#import "ViewController.h"
#import <TSMessageView.h>

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

@interface AddNewShareViewController ()

@end

@implementation AddNewShareViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_keyboard reloadType];
//    _keyboard = [[CYkeyboard alloc] initWithTitle:@"keyboard"];
//    [_keyboard setLables:_amount type:_type data:_data member:_member paidBy:_paidBy];
//    _keyboard.mainUI = self;
//    [self.view addSubview:_keyboard];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [DaiDodgeKeyboard addRegisterTheViewNeedDodgeKeyboard:self.view];
    
    self.navigationController.navigationBar.barTintColor = RGB(26, 142, 180);
    [self.navigationController.navigationBar setTintColor:RGB(255, 255, 255)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(add)];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fileName = [NSString stringWithFormat:@"%@/billType",
                documentsDirectory];
    NSString *content = [[NSString alloc] initWithContentsOfFile:fileName
                                          usedEncoding:nil
                                                 error:nil];
    NSArray *linesOfFile= [content componentsSeparatedByString:@"\n"];
    //NSArray *firstType = [linesOfFile[0] componentsSeparatedByString:@"#"];
//    _type.text = firstType.count < 2 ? @"Food and Drind > hamburger" : [NSString stringWithFormat:@"%@ > %@", firstType[0], firstType[2]];
    
    
    //set date label
    UIDatePicker *_datepicker = [[UIDatePicker alloc] init];
    _datepicker.datePickerMode = UIDatePickerModeDateAndTime;
    _datepicker.minuteInterval = 1;
    //_mydate = [[NSDate alloc] init];
    _mydate = _datepicker.date;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MMM d, yyyy 'at' hh:mm aa"];
    NSString *prettyVersion = [dateFormat stringFromDate:_mydate];
    _data.text = prettyVersion;
    NSLog(@"%@", prettyVersion);
    
    _type.text = _quickType;
    // judge food type
    if ([_quickType isEqualToString:@"Food"]) {
        [dateFormat setDateFormat:@"HH"];
        NSString *prettyVersion = [dateFormat stringFromDate:_mydate];
        int hour = [prettyVersion intValue];
        if (hour <= 10) {
            _type.text = @"Breakfast";
        } else if (hour <= 15) {
            _type.text = @"Lunch";
        } else if (hour <= 21) {
            _type.text = @"Dinner";
        } else {
            _type.text = @"Night Food";
        }
    }
    
    CALayer *line1 = [CALayer layer];
    CALayer *line2 = [CALayer layer];
    CALayer *line3 = [CALayer layer];
    CALayer *line4 = [CALayer layer];
    CALayer *line5 = [CALayer layer];
    CALayer *line6 = [CALayer layer];
    
    line1.frame = CGRectMake(_amount.frame.origin.x, _amount.frame.origin.y + _amount.frame.size.height, _amount.frame.size.width, 1.0f);
    line2.frame = CGRectMake(_typeBackground.frame.origin.x, _typeBackground.frame.origin.y + _typeBackground.frame.size.height, _typeBackground.frame.size.width, 1.0f);
    line3.frame = CGRectMake(_dataBackground.frame.origin.x, _dataBackground.frame.origin.y + _dataBackground.frame.size.height, _dataBackground.frame.size.width, 1.0f);
    line4.frame = CGRectMake(_memberBackground.frame.origin.x, _memberBackground.frame.origin.y + _memberBackground.frame.size.height, _memberBackground.frame.size.width, 1.0f);
    line5.frame = CGRectMake(_memberBackground.frame.origin.x, _creater.frame.origin.y + _creater.frame.size.height, _memberBackground.frame.size.width, 1.0f);
    line6.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 1, _creater.frame.origin.y, 1, _creater.frame.size.height);
    
    
    line1.backgroundColor = RGB(204, 204, 204).CGColor;
    line2.backgroundColor = RGB(204, 204, 204).CGColor;
    line3.backgroundColor = RGB(204, 204, 204).CGColor;
    line4.backgroundColor = RGB(204, 204, 204).CGColor;
    line5.backgroundColor = RGB(204, 204, 204).CGColor;
    line6.backgroundColor = RGB(204, 204, 204).CGColor;
    
    [self.view.layer addSublayer:line1];
    [self.view.layer addSublayer:line2];
    [self.view.layer addSublayer:line3];
    [self.view.layer addSublayer:line4];
    [self.view.layer addSublayer:line5];
    [self.view.layer addSublayer:line6];
    
    UITapGestureRecognizer* myLabelGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(label1Clicked)];
    [_amount setUserInteractionEnabled:YES];
    [_amount addGestureRecognizer:myLabelGesture1];
    
    UITapGestureRecognizer* myLabelGesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(label2Clicked)];
    [_typeBackground setUserInteractionEnabled:YES];
    [_typeBackground addGestureRecognizer:myLabelGesture2];
    
    UITapGestureRecognizer* myLabelGesture3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(label3Clicked)];
    [_paidByBackground setUserInteractionEnabled:YES];
    [_paidByBackground addGestureRecognizer:myLabelGesture3];
    
    UITapGestureRecognizer* myLabelGesture4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(label4Clicked)];
    [_dataBackground setUserInteractionEnabled:YES];
    [_dataBackground addGestureRecognizer:myLabelGesture4];
    
    UITapGestureRecognizer* myLabelGesture5 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(label5Clicked)];
    [_memberBackground setUserInteractionEnabled:YES];
    [_memberBackground addGestureRecognizer:myLabelGesture5];
    
    
    
    _keyboard = [[CYkeyboard alloc] initWithTitle:@"keyboard"];
    [_keyboard setLables:_amount type:_type data:_data member:_member paidBy:_paidBy];
    _keyboard.mainUI = self;
    [self.view addSubview:_keyboard];
    [self label1Clicked];
    [_keyboard amountMode];
    
    // test
//    UITapGestureRecognizer* fadeOutTest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fadeoutTouch)];
//    [keyboard.fadeout setUserInteractionEnabled:YES];
//    [keyboard.fadeout addGestureRecognizer:fadeOutTest];
    
//    UITapGestureRecognizer* editTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editTouch)];
//    [keyboard.edit setUserInteractionEnabled:YES];
//    [keyboard.edit addGestureRecognizer:editTouch];

    //
    [self addDoneToolBarToKeyboard:_comment];
    _comment.delegate = self;
    _comment.text = @"comment...";
    _comment.textColor = [UIColor lightGrayColor]; //optional
    
    
    _paidBy.text = _keyboard.memberArray.count > 0 ? _keyboard.memberArray[0] : @"none";
    _creater.text = _keyboard.memberArray.count > 0 ? _keyboard.memberArray[0] : @"none";
}

//- (void)fadeoutTouch {
//    [keyboard clickFadeOut];
//}
//
//- (void)editTouch {
//    [keyboard editPage];
//}

#pragma mark - set mode

- (void)resetAllBackground {
    _amount.backgroundColor = RGB(255, 255, 255);
    _typeBackground.backgroundColor = RGB(255, 255, 255);
    _paidByBackground.backgroundColor = RGB(255, 255, 255);
    _dataBackground.backgroundColor = RGB(255, 255, 255);
    _memberBackground.backgroundColor = RGB(255, 255, 255);
}

- (void)label1Clicked {
    _amount.backgroundColor = RGB(211, 214, 219);
    _typeBackground.backgroundColor = RGB(255, 255, 255);
    _paidByBackground.backgroundColor = RGB(255, 255, 255);
    _dataBackground.backgroundColor = RGB(255, 255, 255);
    _memberBackground.backgroundColor = RGB(255, 255, 255);
    
    [_keyboard amountMode];
    //[keyboard show];
}

- (void)label2Clicked {
    _amount.backgroundColor = RGB(255, 255, 255);
    _typeBackground.backgroundColor = RGB(211, 214, 219);
    _paidByBackground.backgroundColor = RGB(255, 255, 255);
    _dataBackground.backgroundColor = RGB(255, 255, 255);
    _memberBackground.backgroundColor = RGB(255, 255, 255);
    

    [_keyboard typeMode];
    [_keyboard show];
}

- (void)label3Clicked {
    _amount.backgroundColor = RGB(255, 255, 255);
    _typeBackground.backgroundColor = RGB(255, 255, 255);
    _paidByBackground.backgroundColor = RGB(211, 214, 219);
    _dataBackground.backgroundColor = RGB(255, 255, 255);
    _memberBackground.backgroundColor = RGB(255, 255, 255);
    
    [_keyboard paidByMode];
    [_keyboard show];
}

- (void)label4Clicked {
    _amount.backgroundColor = RGB(255, 255, 255);
    _typeBackground.backgroundColor = RGB(255, 255, 255);
    _paidByBackground.backgroundColor = RGB(255, 255, 255);
    _dataBackground.backgroundColor = RGB(211, 214, 219);
    _memberBackground.backgroundColor = RGB(255, 255, 255);
    
    [_keyboard dataMode];
    [_keyboard show];
}

- (void)label5Clicked {
    _amount.backgroundColor = RGB(255, 255, 255);
    _typeBackground.backgroundColor = RGB(255, 255, 255);
    _paidByBackground.backgroundColor = RGB(255, 255, 255);
    _dataBackground.backgroundColor = RGB(255, 255, 255);
    _memberBackground.backgroundColor = RGB(211, 214, 219);
    
    [_keyboard memberMode];
    [_keyboard show];
}

#pragma mark - custom functions

- (void)unlight {
    _amount.backgroundColor = RGB(255, 255, 255);
    _typeBackground.backgroundColor = RGB(255, 255, 255);
    _paidByBackground.backgroundColor = RGB(255, 255, 255);
    _dataBackground.backgroundColor = RGB(255, 255, 255);
    _memberBackground.backgroundColor = RGB(255, 255, 255);
}


- (void)cancel {
    
    [self dismissViewControllerAnimated:true completion:^{
        NSLog(@"Present Modal View");
    }];
}

- (void)add {
    
    if ([_amount.text isEqualToString:@"$ 0.00"] || _keyboard.selectedItems.count == 0) {
        UIAlertView *updateAlert = [[UIAlertView alloc] initWithTitle:@"Waring" message:@"Invalid bill" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [updateAlert show];
        
        return;
    }
    
    NSString * const kRemoteHost = ServerHost;
    
    Share_inf *request = [Share_inf message];
    request.creater = _keyboard.memberArray[0];
    //NSLog(@"%@",request.creater);
    request.amount = _amount.text;
    request.type = _type.text;
    request.paidBy = _paidBy.text;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd hh:mm"];
    if (_keyboard.mydata) {
        NSString *prettyVersion = [dateFormat stringFromDate:_keyboard.mydata];
        request.data_p = prettyVersion;
    } else {
        NSString *prettyVersion = [dateFormat stringFromDate:_mydate];
        request.data_p = prettyVersion;
    }
    request.note = _comment.text;
    
    // set image name
    request.image = NULL;
    if (_customPic) {
        NSDate *now = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd hh:mm:ss";
        NSString *time = [dateFormat stringFromDate:now];
        request.image = [NSString stringWithFormat:@"%@-%@", request.creater, time];
        [self send_imgae:_takePicture.imageView.image name:request.image path:@"billsImage"];
    }
    
    // set member
    for (int i = 0; i != _keyboard.selectedItems.count; i++) {
        NSInteger index = [_keyboard.selectedItems[i] integerValue];
        [request.membersArray addObject:[_keyboard.memberArray objectAtIndex:index]];
        NSLog(@"%@", _keyboard.selectedItems[i]);
    }
    for (int i = (int)_keyboard.selectedItems.count; i != 10; i++) {
        [request.membersArray addObject:@""];
    }
    
    // set type icon name
    NSMutableArray *type = _keyboard.typeArray[[_keyboard.typePicker selectedRowInComponent:0]];
    request.typeIcon = [NSString stringWithFormat:@"%@.png", type[([_keyboard.typePicker selectedRowInComponent:1] + 1)*2 + 1]];
    if ([_type.text isEqualToString:@"Breakfast"] || [_type.text isEqualToString:@"Lunch"] || [_type.text isEqualToString:@"Dinner"] || [_type.text isEqualToString:@"Night Food"])
        request.typeIcon = @"ifood.png";
    else if ([_type.text isEqualToString:@"Drink"])
        request.typeIcon = @"idrink.png";
    else if ([_type.text isEqualToString:@"Shopping"])
        request.typeIcon = @"ishopping.png";
    else if ([_type.text isEqualToString:@"Transportation"])
        request.typeIcon = @"ibus.png";
    else if ([_type.text isEqualToString:@"Home"])
        request.typeIcon = @"ihome.png";
    else if ([_type.text isEqualToString:@"Trip"])
        request.typeIcon = @"itrip.png";
    
    
    NSLog(@"%@", request.typeIcon);
    Greeter *service = [[Greeter alloc] initWithHost:kRemoteHost];
    [service create_shareWithRequest:request handler:^(Inf *response, NSError *error) {
        if (response) {
            
            NSLog(@"%@", response.information);
            
            ViewController *mainUI = (ViewController *)_mainUIView;
            [mainUI obtain_bills];
        } else if (error) {
            [TSMessage showNotificationWithTitle:@"GRPC ERROR"
                                        subtitle:@"obtain_request"
                                            type:TSMessageNotificationTypeError];
        }
    }];
    
    [self dismissViewControllerAnimated:true completion:^{
        NSLog(@"Present Modal View");
    }];

}

- (void)send_imgae:(UIImage *)image name:(NSString *)name path:(NSString *)path {
    NSString *const kRemoteHost = ServerHost;
    
    // Example gRPC call using a generated proto client library:
    
    Image *image_name = [Image message];
    Image *image_path = [Image message];
    Image *image_pkg = [Image message];
    
    image_name.data_p = [name dataUsingEncoding:NSUTF8StringEncoding];
    image_path.data_p = [path dataUsingEncoding:NSUTF8StringEncoding];
    image_pkg.data_p = UIImagePNGRepresentation(image);
    
    NSArray *pkgs = @[image_name, image_path, image_pkg];
    GRXWriter *_requestsWriter = [GRXWriter writerWithContainer:pkgs];
    
    //[_requestsWriter startWithWriteable:writable];
    Greeter *service = [[Greeter alloc] initWithHost:kRemoteHost];
    
    [service send_ImgWithRequestsWriter:_requestsWriter handler:^(Inf *response, NSError *error) {
        if (response) {
            NSLog(@"%@", response.information);
            
        } else if(error){
            NSLog(@"Finished with error: %@", error);
        }
    }];
    
}

- (IBAction)takePictureClick:(id)sender {
    
//    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
//    picker.delegate = self;
//    picker.allowsEditing = YES;
//    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
//    
//    [self presentViewController:picker animated:YES completion:NULL];
    [self resetAllBackground];
    [_keyboard fadeMeOut];
    [self.view.window  showPopWithButtonTitles:@[@"Take a picture", @"Choose from Library"] styles:@[YUDefaultStyle,YUDefaultStyle] whenButtonTouchUpInSideCallBack:^(int index  ) {
        NSLog(@"%d", index);
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        
        switch (index) {
            case 0:{

                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:picker animated:YES completion:NULL];
                break;
            }
            case 1:{

                picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                [self presentViewController:picker animated:YES completion:NULL];
                break;
            }
            default:
                break;
        }
        
        
    }];

}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    [_takePicture setImage:chosenImage forState:UIControlStateNormal];
    _customPic = YES;
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

//set up a placeholder variable for the textfield user typing

-(void)addDoneToolBarToKeyboard:(UITextView *)textView
{
    UIToolbar* doneToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    doneToolbar.barStyle = UIBarStyleBlackTranslucent;
    doneToolbar.items = [NSArray arrayWithObjects:
                         [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                         [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneButtonClickedDismissKeyboard)],
                         nil];
    [doneToolbar sizeToFit];
    textView.inputAccessoryView = doneToolbar;

}

//remember to set your text view delegate
//but if you only have 1 text view in your view controller
//you can simply change currentTextField to the name of your text view
//and ignore this textViewDidBeginEditing delegate method
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    _comment = textView;
    //
    if ([textView.text isEqualToString:@"comment..."]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor]; //optional
    }
    [textView becomeFirstResponder];
}

-(void)doneButtonClickedDismissKeyboard
{
    [_comment resignFirstResponder];
    
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"comment...";
        textView.textColor = [UIColor lightGrayColor]; //optional
    }
    [textView resignFirstResponder];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
