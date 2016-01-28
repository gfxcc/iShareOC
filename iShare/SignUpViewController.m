//
//  SignUpViewController.m
//  iShare
//
//  Created by caoyong on 6/14/15.
//  Copyright (c) 2015 caoyong. All rights reserved.
//

#import "SignUpViewController.h"
#import <gRPC_pod/IShare.pbrpc.h>
#import <gRPC_pod/IShare.pbobjc.h>
#import "ViewController.h"
#import "LeftMenuViewController.h"
#import <TSMessageView.h>

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

@interface SignUpViewController ()

@property (strong, nonatomic) UITextField *userTextField;
@property (strong, nonatomic) UITextField *pwTextField;

@end

@implementation SignUpViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithRed:248.0/255 green:248.0/255 blue:248.0/255 alpha:1.0];
    
    
    
    CALayer *TopBorder = [CALayer layer];
    UIColor *borderColor = RGB(232, 232, 232);
    TopBorder.frame = CGRectMake(0.0f, 200, [UIScreen mainScreen].bounds.size.width, 1.0f);
    TopBorder.backgroundColor = borderColor.CGColor;
    [self.view.layer addSublayer:TopBorder];
    
    CALayer *TopBorder1 = [CALayer layer];
    TopBorder1.frame = CGRectMake(0.0f, 300, [UIScreen mainScreen].bounds.size.width, 1.0f);
    TopBorder1.backgroundColor = borderColor.CGColor;
    [self.view.layer addSublayer:TopBorder1];
    
    UIImageView *content = [[UIImageView alloc] initWithFrame:CGRectMake(0, 201, [UIScreen mainScreen].bounds.size.width, 99)];
    content.backgroundColor = RGB(255, 255, 255);
    [self.view addSubview:content];
    
    CALayer *TopBorder2 = [CALayer layer];
    TopBorder2.frame = CGRectMake(10.0f, 250, [UIScreen mainScreen].bounds.size.width - 20, 1.0f);
    TopBorder2.backgroundColor = borderColor.CGColor;
    [self.view.layer addSublayer:TopBorder2];
    
    
    UIImageView *userIcon = [[UIImageView alloc] initWithFrame:CGRectMake(20, 210, 30, 30)];
    userIcon.image = [UIImage imageNamed:@"userIcon.png"];
    [self.view addSubview:userIcon];
    UIImageView *pwIcon = [[UIImageView alloc] initWithFrame:CGRectMake(20, 260, 30, 30)];
    pwIcon.image = [UIImage imageNamed:@"PWIcon.png"];
    [self.view addSubview:pwIcon];
    
    _userTextField = [[UITextField alloc] initWithFrame:CGRectMake(60, 205, [UIScreen mainScreen].bounds.size.width - 70, 40)];
    [_userTextField setKeyboardType:UIKeyboardTypeASCIICapable];
    _userTextField.delegate = self;
    _userTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    _userTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [self.view addSubview:_userTextField];
    
    _pwTextField = [[UITextField alloc] initWithFrame:CGRectMake(60, 255, [UIScreen mainScreen].bounds.size.width - 70, 40)];
    [_pwTextField setKeyboardType:UIKeyboardTypeASCIICapable];
    _pwTextField.delegate = self;
    _pwTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    _pwTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [self.view addSubview:_pwTextField];
    
    
    // add image
    UIImageView *imageHolder = [[UIImageView alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - 113) / 2, 60, 130, 130)];
    imageHolder.image = [UIImage imageNamed:@"money_icon.png"];
    UIButton *login_button = [UIButton buttonWithType:UIButtonTypeSystem];
    [login_button setFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - 300) / 2, 320, 300, 40)];
    
    login_button.backgroundColor = RGB(118, 137, 166);//255 135 43
    [login_button setTitle:@"Sign Up" forState:UIControlStateNormal];
    [login_button setTitleColor:RGB(255, 255, 255) forState:UIControlStateNormal];
    [login_button addTarget:self action:@selector(SignUp) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:imageHolder];
    [self.view addSubview:login_button];

}

- (void)SignUp {
    
    NSString * const kRemoteHost = ServerHost;
    Sign_m *request = [[Sign_m alloc] init];
    request.username = _userTextField.text;
    request.password = _pwTextField.text;
    
    // Example gRPC call using a generated proto client library:
    
    Greeter *service = [[Greeter alloc] initWithHost:kRemoteHost];
    [service sign_upWithRequest:request handler:^(Inf *response, NSError *error) {
        if (response) {
            if ([response.information isEqualToString:@"OK"]) {
                
                LeftMenuViewController *leftView = (LeftMenuViewController *)_LeftMenuView;
                //[leftView.add_sign_button setTitle:@"Add" forState:UIControlStateNormal];
                [leftView.log_button setTitle:@"Log out" forState:UIControlStateNormal];
                [leftView.idText setText:_userTextField.text];
                [leftView obtain_friends];
                
                ViewController *mainUI = (ViewController*)leftView.mainUIView;
                [mainUI obtain_bills];
                
                [self dismissViewControllerAnimated:true completion:^{
                    NSLog(@"Present Modal View");
                }];
            } else {
                UIAlertView *updateAlert = [[UIAlertView alloc] initWithTitle: @"Error" message: @"username has been used, please change" delegate: self cancelButtonTitle: @"OK"  otherButtonTitles:nil];
                
                [updateAlert show];
            }
        } else if (error) {
            //NSLog(@"Finished with error: %@", error);
            [TSMessage showNotificationInViewController:self
                                                  title:response.information
                                               subtitle:@"Your username might has been used. Please change your username."
                                                   type:TSMessageNotificationTypeError
                                               duration:TSMessageNotificationDurationAutomatic];
        }
    }];
    
}

- (IBAction)back_mainUI:(id)sender {
    [self dismissViewControllerAnimated:true completion:^{
        NSLog(@"Present Modal View");
    }];
}


-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
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
