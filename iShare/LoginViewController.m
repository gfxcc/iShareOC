//
//  LoginViewController.m
//  iShare
//
//  Created by caoyong on 6/13/15.
//  Copyright (c) 2015 caoyong. All rights reserved.
//

#import "LoginViewController.h"
#import <gRPC_pod/IShare.pbrpc.h>
#import <gRPC_pod/IShare.pbobjc.h>
#import "ViewController.h"
#import "BaseNavigationController.h"
#import "SignUpViewController.h"
#import "FileOperation.h"
#import <TSMessageView.h>
#import "AppDelegate.h"
#import "ViewController.h"

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

@interface LoginViewController ()

//@property (strong, nonatomic) UITextField *userTextField;
//@property (strong, nonatomic) UITextField *pwTextField;
//
//@property (strong, nonatomic) UIImageView* imgLeftHand;
//@property (strong, nonatomic) UIImageView* imgRightHand;
//
//@property (strong, nonatomic) UIImageView* imgLeftHandGone;
//@property (strong, nonatomic) UIImageView* imgRightHandGone;

@property (nonatomic) LogingAnimationType AnimationType;
@property (nonatomic, strong) FileOperation *fileOperation;
@end

@implementation LoginViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //

    
    [self UISetting];
    _fileOperation = [[FileOperation alloc] init];
}

-(void)UISetting{
    
    _AnimationType = LogingAnimationType_NONE;
    
    UIColor* boColor = [UIColor colorWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:100];
    
    _UserNameTextField.layer.borderColor = boColor.CGColor;
    _UserNameTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    _UserNameTextField.leftViewMode = UITextFieldViewModeAlways;
    _UserNameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    _UserNameTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    UIImageView* imgUser = [[UIImageView alloc] initWithFrame:CGRectMake(11, 11, 22, 22)];
    imgUser.image = [UIImage imageNamed:@"iconfont-user"];
    [_UserNameTextField.leftView addSubview:imgUser];
    
    _PasswordTextField.layer.borderColor = boColor.CGColor;
    _PasswordTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    _PasswordTextField.leftViewMode = UITextFieldViewModeAlways;
    _PasswordTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    _PasswordTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    UIImageView* imgPwd = [[UIImageView alloc] initWithFrame:CGRectMake(11, 11, 22, 22)];
    imgPwd.image = [UIImage imageNamed:@"iconfont-password"];
    [_PasswordTextField.leftView addSubview:imgPwd];
    
    _loginView.layer.borderColor = boColor.CGColor;
    
    [_LoginButton setTitle:_buttonText forState:UIControlStateNormal];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
//    if ([textField isEqual:_PasswordTextField]) {
//        _AnimationType = LogingAnimationType_PWD;
//        [self AnimationUserToPassword];
//        
//    }else{
//        
//        if (_AnimationType == LogingAnimationType_NONE) {
//            _AnimationType = LogingAnimationType_USER;
//            return;
//        }
//        _AnimationType = LogingAnimationType_USER;
//        [self AnimationPasswordToUser];
//        
//    }
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([textField isEqual:_UserNameTextField]) {
        [self usernameCheck];
    }
}

- (void)usernameCheck {
    NSString *username = _UserNameTextField.text;
    if ([username isEqualToString:@""]) {
        return;
    }
    // start check username. first, remove blank
    for (; [username characterAtIndex:username.length - 1] == ' '; ) {
        username = [username substringToIndex:username.length - 1];
    }
    // check invalid character
    if (![_fileOperation checkString:_UserNameTextField.text cha:'*'] ||! [_fileOperation checkString:_UserNameTextField.text cha:'\'']) {
        UIAlertView *updateAlert = [[UIAlertView alloc] initWithTitle:@"Waring" message:@"'*', ''' is invalid character. Please change username." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [updateAlert show];
        [_UserNameTextField setText:@""];
        return;
    }
    
    [_UserNameTextField setText:username];
}

#pragma mark
-(void)AnimationPasswordToUser{
    
    [UIView animateWithDuration:0.5f animations:^{
        
//        self.left_look.frame = CGRectMake(self.left_look.frame.origin.x - 80, self.left_look.frame.origin.y, 40, 40);
//        self.right_look.frame = CGRectMake(self.right_look.frame.origin.x + 40, self.right_look.frame.origin.y, 40, 40);
//        
//        self.right_hidden.frame = CGRectMake(self.right_hidden.frame.origin.x+55, self.right_hidden.frame.origin.y+40, 40, 66);
//        self.left_hidden.frame = CGRectMake(self.left_hidden.frame.origin.x-60, self.left_hidden.frame.origin.y+40, 40, 66);
        
        self.left_look.frame = CGRectMake(self.left_look.frame.origin.x - 40, self.left_look.frame.origin.y, 40, 40);
        self.right_look.frame = CGRectMake(self.right_look.frame.origin.x + 40, self.right_look.frame.origin.y, 40, 40);
        
        self.right_hidden.frame = CGRectMake(self.right_hidden.frame.origin.x + 40, self.right_hidden.frame.origin.y+40, 40, 66);
        self.left_hidden.frame = CGRectMake(self.left_hidden.frame.origin.x - 40, self.left_hidden.frame.origin.y+40, 40, 66);
        
    } completion:^(BOOL finished) {
        
    }];
    
}

#pragma mark
-(void)AnimationUserToPassword{
    [UIView animateWithDuration:0.5f animations:^{
        
//        self.right_look.frame = CGRectMake(self.right_look.frame.origin.x - 40, self.right_look.frame.origin.y, 0, 0);
//        self.left_look.frame = CGRectMake(self.left_look.frame.origin.x + 80, self.left_look.frame.origin.y, 0, 0);
        self.right_look.frame = CGRectMake([UIScreen mainScreen].bounds.size.width / 2 + 2, self.right_look.frame.origin.y, 0, 0);
        self.left_look.frame = CGRectMake([UIScreen mainScreen].bounds.size.width / 2 - 20 - 40, self.left_look.frame.origin.y, 0, 0);
        
//        self.right_hidden.frame = CGRectMake(self.right_hidden.frame.origin.x-55, self.right_hidden.frame.origin.y-40, 40, 66);
//        self.left_hidden.frame = CGRectMake(self.left_hidden.frame.origin.x+60, self.left_hidden.frame.origin.y-40, 40, 66);
        self.right_hidden.frame = CGRectMake([UIScreen mainScreen].bounds.size.width / 2 + 2, self.right_hidden.frame.origin.y-40, 40, 66);
        self.left_hidden.frame = CGRectMake([UIScreen mainScreen].bounds.size.width / 2 - 20 - 40, self.left_hidden.frame.origin.y-40, 40, 66);
        
    } completion:^(BOOL finished) {
        
    }];
}

- (IBAction)EndEDitTap:(id)sender {
    if (_AnimationType == LogingAnimationType_PWD) {
        [self AnimationPasswordToUser];
    }
    _AnimationType = LogingAnimationType_NONE;
    [self.view endEditing:YES];
}


- (IBAction)logIn:(id)sender {
    // string check
    [self usernameCheck];
    if ([_UserNameTextField.text isEqualToString:@""] || [_PasswordTextField.text isEqualToString:@""]) {
        UIAlertView *updateAlert = [[UIAlertView alloc] initWithTitle: @"Warming" message: @"Invalid Email or Password." delegate: self cancelButtonTitle: @"OK"  otherButtonTitles:nil];
        [updateAlert show];
        
        return;
    }
    
    NSString *text = _LoginButton.titleLabel.text;
    if ([text isEqualToString:@"Log in"]) {
        
        
        NSString * const kRemoteHost = ServerHost;
        Login_m *request = [[Login_m alloc] init];
        request.username = _UserNameTextField.text;
        request.password = _PasswordTextField.text;
        
        // Example gRPC call using a generated proto client library:
        
        Greeter *service = [[Greeter alloc] initWithHost:kRemoteHost];
        [service loginWithRequest:request handler:^(Reply_inf *response, NSError *error) {
            if (response) {
                if ([response.status isEqualToString:@"OK"]) {
                    
                    [self didLogin:response.information];
                } else {
                    UIAlertView *updateAlert = [[UIAlertView alloc] initWithTitle: @"Message" message:response.information delegate: self cancelButtonTitle: @"OK"  otherButtonTitles:nil];
                    
                    [updateAlert show];
                }
                
            } else if (error) {
                NSLog(@"Finished with error: %@", error);
            }
        }];
    } else {
        /*
        NSString * const kRemoteHost = ServerHost;
        Sign_m *request = [[Sign_m alloc] init];
        request.username = _UserNameTextField.text;
        request.password = _PasswordTextField.text;
        
        // Example gRPC call using a generated proto client library:
        
        Greeter *service = [[Greeter alloc] initWithHost:kRemoteHost];
        [service sign_upWithRequest:request handler:^(Reply_inf *response, NSError *error) {
        
        }];
         */
        UIAlertView *emailInput = [[UIAlertView alloc] initWithTitle:@"Email" message:@"Please input your Email" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        emailInput.alertViewStyle = UIAlertViewStylePlainTextInput;
        [emailInput textFieldAtIndex:0].delegate = self;
        [emailInput show];
        
    }

}

- (void)didLogin:(NSString*)response {
    [_fileOperation setUsernameAndUserId:[NSString stringWithFormat:@"%@*%@", _UserNameTextField.text, response]];
    [self dismissViewControllerAnimated:true completion:nil];
    if (!_reLoadFlag) {
        [((AppDelegate *)[UIApplication sharedApplication].delegate) setupTabViewController];
    } else {
        [_LeftMenuView loadUserData];
        [(ViewController*)(_LeftMenuView.mainUIView) obtain_bills];
         //*t;
    };
    
    
//    _LeftMenuView.user_id = response;
//    
//    [_LeftMenuView.log_button setTitle:@"Log out" forState:UIControlStateNormal];
//    [_LeftMenuView.idText setText:_UserNameTextField.text];
//    [_LeftMenuView.headerView.userLabel setText:_UserNameTextField.text];
//    [_LeftMenuView obtain_friends];
//    
//    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
//    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"/Icon"];
//    
//    dataPath = [NSString stringWithFormat:@"%@/%@.png", dataPath, [_fileOperation getUserId]];
//    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:dataPath];
//    
//    if (fileExists) {
//        _LeftMenuView.headerView.userIconView.image = [UIImage imageWithContentsOfFile:dataPath];
//    } else {
//        _LeftMenuView.headerView.userIconView.image = [UIImage imageNamed:@"icon-user-default.png"];
//    }
//    
//    ViewController *mainUI = (ViewController *)_LeftMenuView.mainUIView;
//    mainUI.user_id = response;
//    [mainUI obtain_bills];
//    [mainUI sendToken];
//    
//    //mainUI.helloWorld.text = @"Welcome to Ishare";
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            break;
        case 1:// OK
            [self signUpWithEmail:[alertView textFieldAtIndex:0].text];
            break;
        default:
            break;
    }
}

- (void)signUpWithEmail:(NSString*)email {
    NSString * const kRemoteHost = ServerHost;
    Sign_m *request = [[Sign_m alloc] init];
    request.username = _UserNameTextField.text;
    request.password = _PasswordTextField.text;
    request.email = email;
    
    // Example gRPC call using a generated proto client library:
    
    Greeter *service = [[Greeter alloc] initWithHost:kRemoteHost];
    [service sign_upWithRequest:request handler:^(Reply_inf *response, NSError *error) {
        if (response) {
            if ([response.status isEqualToString:@"OK"]) {
                
                [self didLogin:response.information];
                
                [self dismissViewControllerAnimated:true completion:^{
                    NSLog(@"Present Modal View");
                }];
            } else {
                UIAlertView *updateAlert = [[UIAlertView alloc] initWithTitle: @"Warning" message: @"username has been used, please change" delegate: self cancelButtonTitle: @"OK"  otherButtonTitles:nil];
                
                [updateAlert show];
            }
        } else if(error) {
            [TSMessage showNotificationInViewController:self
                                                  title:@"ERROR"
                                               subtitle:response.information
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


- (IBAction)changeSignMode:(id)sender {
    NSString *text = _LoginButton.titleLabel.text;
    if ([text isEqualToString:@"Log in"]) {
        [_LoginButton setTitle:@"Sign up" forState:UIControlStateNormal];
    } else {
        [_LoginButton setTitle:@"Log in" forState:UIControlStateNormal];
    }
}




- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"transformToSignUp"]) {
        SignUpViewController *signUpView = (SignUpViewController *)[segue destinationViewController];
        signUpView.LeftMenuView = _LeftMenuView;
        signUpView.navigationItem.title = @"Sign up";
    }
    
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

- (void)signInMode {
    _buttonText = @"Sign in";
}

- (void)loginMode {
    _buttonText = @"Log in";
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
