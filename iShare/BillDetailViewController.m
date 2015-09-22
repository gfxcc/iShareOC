//
//  BillDetailViewController.m
//  iShare
//
//  Created by caoyong on 7/28/15.
//  Copyright (c) 2015 caoyong. All rights reserved.
//

#import "BillDetailViewController.h"


#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

@interface BillDetailViewController ()

@end

@implementation BillDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.barTintColor = RGB(26, 142, 180);
    [self.navigationController.navigationBar setTintColor:RGB(255, 255, 255)];
    //self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    
    
    //[_amount setFont:[UIFont fontWithName:@"Allura-Regular.ttf" size:35]];
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
    
    _memberArray = [[NSMutableArray alloc] init];
    //
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    //make a file name to write the data to using the documents directory:
    NSString *fileName = [NSString stringWithFormat:@"%@/billRecord",
                          documentsDirectory];
    NSString *exist = [[NSString alloc] initWithContentsOfFile:fileName
                                                  usedEncoding:nil
                                                         error:nil];
    NSArray *bills = [exist componentsSeparatedByString:@"\n"];
    for (int i = 0; i != bills.count; i++) {
        NSArray *billContent = [bills[i] componentsSeparatedByString:@"*"];
    
        if ([billContent[0] isEqualToString:_billId]) {
            _amount.text = billContent[1];
            _type.text = billContent[2];
            _data.text = billContent[3];
            _creater.text = billContent[4];
            _paidBy.text = billContent[5];
            _comment.text = billContent[6];
            
            _image = NULL;
            NSString *imageName = billContent[7];
            if (![imageName isEqualToString:@""]) {
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
                NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"/billsImage"];
                dataPath = [NSString stringWithFormat:@"%@/%@.png", dataPath, imageName];
                BOOL imageExist = [[NSFileManager defaultManager] fileExistsAtPath:dataPath];
                if (imageExist) {
                    [_takePicture setImage:[UIImage imageWithContentsOfFile:dataPath]];
                    _image = [UIImage imageWithContentsOfFile:dataPath];
                } else {
                    [self downloadPicture:imageName];
                }
            }
            
            for (int j = 8; j != 18; j++) {
                if ([billContent[j] isEqualToString:@""]) {
                    break;
                }
                [_memberArray addObject:billContent[j]];
            }
            for (int j = 0; j != _memberArray.count; j++) {
                if (j >= 3) {
                    _member.text = [NSString stringWithFormat:@"%@...", _member.text];
                    break;
                }
                _member.text = [NSString stringWithFormat:@"%@ %@", _member.text, _memberArray[j]];
            }
            break;
        }
    }
    
    _keyboard = [[CYkeyboard alloc] initWithTitle:@"keyboard"];
    _keyboard.memberArray = _memberArray;
    _keyboard.mainUI = self;
    [self.view addSubview:_keyboard];

    if (_image) {
        _fullSizeView = [[FullSizeView alloc] initWithBounds:self.view.bounds SuperView:self.view ImageView:_takePicture Image:_image];
        [self.view addSubview:_fullSizeView];
    }
    
    
    
}


- (void)downloadPicture:(NSString*)image {
    
    
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithFrame:_takePicture.frame];
    activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [self.view addSubview:activityView];
    [activityView startAnimating];
    
    NSString * const kRemoteHost = ServerHost;
    
    Repeated_string *request = [Repeated_string message];
    
    // better?
    
    [request.contentArray insertObject:@"billsImage" atIndex:0];
    [request.contentArray insertObject:image atIndex:1];
    
    for (int i = 0; i != request.contentArray.count; i++) {
        NSLog(@"%@", request.contentArray[i]);
    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"/billsImage"];
    
    Greeter *service = [[Greeter alloc] initWithHost:kRemoteHost];
    [service receive_ImgWithRequest:request handler:^(BOOL done, Image *response, NSError *error) {
        if (!done) {
            if (response.data_p.length == 0) {
                return;
            }
            NSLog(@"%lu", (unsigned long)response.data_p.length);
            [response.data_p writeToFile:[NSString stringWithFormat:@"%@/%@.png", dataPath, response.name] atomically:YES];
        } else if (error) {
            
        } else { // done
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
            NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"/billsImage"];
            dataPath = [NSString stringWithFormat:@"%@/%@.png", dataPath, image];
            [_takePicture setImage:[UIImage imageWithContentsOfFile:dataPath]];
            
            _image = [UIImage imageWithContentsOfFile:dataPath];
            
            _fullSizeView = [[FullSizeView alloc] initWithBounds:self.view.bounds SuperView:self.view ImageView:_takePicture Image:_image];
            [self.view addSubview:_fullSizeView];
            
            //stop UIActivityIndicatorView animation
            [activityView stopAnimating];
        }
    }];
    
}

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
    
    //[keyboard amountMode];
    //[keyboard show];
}

- (void)label2Clicked {
    _amount.backgroundColor = RGB(255, 255, 255);
    _typeBackground.backgroundColor = RGB(211, 214, 219);
    _paidByBackground.backgroundColor = RGB(255, 255, 255);
    _dataBackground.backgroundColor = RGB(255, 255, 255);
    _memberBackground.backgroundColor = RGB(255, 255, 255);
    
    
//    [keyboard typeMode];
//    [keyboard show];
}

- (void)label3Clicked {
    _amount.backgroundColor = RGB(255, 255, 255);
    _typeBackground.backgroundColor = RGB(255, 255, 255);
    _paidByBackground.backgroundColor = RGB(211, 214, 219);
    _dataBackground.backgroundColor = RGB(255, 255, 255);
    _memberBackground.backgroundColor = RGB(255, 255, 255);
    
//    [keyboard accountMode];
//    [keyboard show];
}

- (void)label4Clicked {
    _amount.backgroundColor = RGB(255, 255, 255);
    _typeBackground.backgroundColor = RGB(255, 255, 255);
    _paidByBackground.backgroundColor = RGB(255, 255, 255);
    _dataBackground.backgroundColor = RGB(211, 214, 219);
    _memberBackground.backgroundColor = RGB(255, 255, 255);
    
//    [keyboard dataMode];
//    [keyboard show];
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


- (void)cancel {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
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
