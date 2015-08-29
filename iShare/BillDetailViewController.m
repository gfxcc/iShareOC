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
    self.navigationController.navigationBar.barTintColor = RGB(78, 107, 165);
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
    line2.frame = CGRectMake(_type.frame.origin.x, _type.frame.origin.y + _type.frame.size.height, _type.frame.size.width, 1.0f);
    line3.frame = CGRectMake(_data.frame.origin.x, _data.frame.origin.y + _data.frame.size.height, _data.frame.size.width, 1.0f);
    line4.frame = CGRectMake(_member.frame.origin.x, _member.frame.origin.y + _member.frame.size.height, _member.frame.size.width, 1.0f);
    line5.frame = CGRectMake(_creater.frame.origin.x, _creater.frame.origin.y + _creater.frame.size.height, _member.frame.size.width, 1.0f);
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
    [_type setUserInteractionEnabled:YES];
    [_type addGestureRecognizer:myLabelGesture2];
    
    UITapGestureRecognizer* myLabelGesture3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(label3Clicked)];
    [_paidBy setUserInteractionEnabled:YES];
    [_paidBy addGestureRecognizer:myLabelGesture3];
    
    UITapGestureRecognizer* myLabelGesture4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(label4Clicked)];
    [_data setUserInteractionEnabled:YES];
    [_data addGestureRecognizer:myLabelGesture4];
    
    UITapGestureRecognizer* myLabelGesture5 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(label5Clicked)];
    [_member setUserInteractionEnabled:YES];
    [_member addGestureRecognizer:myLabelGesture5];
    
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
            
            NSString *imageName = billContent[7];
            if (![imageName isEqualToString:@""]) {
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
                NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"/billsImage"];
                dataPath = [NSString stringWithFormat:@"%@/%@.png", dataPath, imageName];
                BOOL imageExist = [[NSFileManager defaultManager] fileExistsAtPath:dataPath];
                if (imageExist) {
                    [_takePicture setImage:[UIImage imageWithContentsOfFile:dataPath] forState:UIControlStateNormal];
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
    [self.view addSubview:_keyboard];

}


- (void)downloadPicture:(NSString*)image {
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
            [_takePicture setImage:[UIImage imageWithContentsOfFile:dataPath ] forState:UIControlStateNormal];
        }
    }];
    
}

#pragma mark - set mode

- (void)label1Clicked {
    _amount.backgroundColor = RGB(211, 214, 219);
    _type.backgroundColor = RGB(255, 255, 255);
    _paidBy.backgroundColor = RGB(255, 255, 255);
    _data.backgroundColor = RGB(255, 255, 255);
    _member.backgroundColor = RGB(255, 255, 255);
    
    //[keyboard amountMode];
    //[keyboard show];
}

- (void)label2Clicked {
    _amount.backgroundColor = RGB(255, 255, 255);
    _type.backgroundColor = RGB(211, 214, 219);
    _paidBy.backgroundColor = RGB(255, 255, 255);
    _data.backgroundColor = RGB(255, 255, 255);
    _member.backgroundColor = RGB(255, 255, 255);
    
    
//    [keyboard typeMode];
//    [keyboard show];
}

- (void)label3Clicked {
    _amount.backgroundColor = RGB(255, 255, 255);
    _type.backgroundColor = RGB(255, 255, 255);
    _paidBy.backgroundColor = RGB(211, 214, 219);
    _data.backgroundColor = RGB(255, 255, 255);
    _member.backgroundColor = RGB(255, 255, 255);
    
//    [keyboard accountMode];
//    [keyboard show];
}

- (void)label4Clicked {
    _amount.backgroundColor = RGB(255, 255, 255);
    _type.backgroundColor = RGB(255, 255, 255);
    _paidBy.backgroundColor = RGB(255, 255, 255);
    _data.backgroundColor = RGB(211, 214, 219);
    _member.backgroundColor = RGB(255, 255, 255);
    
//    [keyboard dataMode];
//    [keyboard show];
}

- (void)label5Clicked {
    _amount.backgroundColor = RGB(255, 255, 255);
    _type.backgroundColor = RGB(255, 255, 255);
    _paidBy.backgroundColor = RGB(255, 255, 255);
    _data.backgroundColor = RGB(255, 255, 255);
    _member.backgroundColor = RGB(211, 214, 219);
    
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
