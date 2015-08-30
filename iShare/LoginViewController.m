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

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self UISetting];
}

-(void)UISetting{
    
    _AnimationType = LogingAnimationType_NONE;
    
    UIColor* boColor = [UIColor colorWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:100];
    
    _UserNameTextField.layer.borderColor = boColor.CGColor;
    _UserNameTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    _UserNameTextField.leftViewMode = UITextFieldViewModeAlways;
    UIImageView* imgUser = [[UIImageView alloc] initWithFrame:CGRectMake(11, 11, 22, 22)];
    imgUser.image = [UIImage imageNamed:@"iconfont-user"];
    [_UserNameTextField.leftView addSubview:imgUser];
    
    _PasswordTextField.layer.borderColor = boColor.CGColor;
    _PasswordTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    _PasswordTextField.leftViewMode = UITextFieldViewModeAlways;
    UIImageView* imgPwd = [[UIImageView alloc] initWithFrame:CGRectMake(11, 11, 22, 22)];
    imgPwd.image = [UIImage imageNamed:@"iconfont-password"];
    [_PasswordTextField.leftView addSubview:imgPwd];
    
    _loginView.layer.borderColor = boColor.CGColor;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    if ([textField isEqual:_PasswordTextField]) {
        _AnimationType = LogingAnimationType_PWD;
        [self AnimationUserToPassword];
        
    }else{
        
        if (_AnimationType == LogingAnimationType_NONE) {
            _AnimationType = LogingAnimationType_USER;
            return;
        }
        _AnimationType = LogingAnimationType_USER;
        [self AnimationPasswordToUser];
        
    }
    
}


#pragma mark 移开手动画
-(void)AnimationPasswordToUser{
    
    [UIView animateWithDuration:0.5f animations:^{
        
        self.left_look.frame = CGRectMake(self.left_look.frame.origin.x - 80, self.left_look.frame.origin.y, 40, 40);
        self.right_look.frame = CGRectMake(self.right_look.frame.origin.x + 40, self.right_look.frame.origin.y, 40, 40);
        
        self.right_hidden.frame = CGRectMake(self.right_hidden.frame.origin.x+55, self.right_hidden.frame.origin.y+40, 40, 66);
        self.left_hidden.frame = CGRectMake(self.left_hidden.frame.origin.x-60, self.left_hidden.frame.origin.y+40, 40, 66);
        
    } completion:^(BOOL finished) {
        
    }];
    
}

#pragma mark 捂眼
-(void)AnimationUserToPassword{
    [UIView animateWithDuration:0.5f animations:^{
        
        self.left_look.frame = CGRectMake(self.left_look.frame.origin.x + 80, self.left_look.frame.origin.y, 0, 0);
        self.right_look.frame = CGRectMake(self.right_look.frame.origin.x - 40, self.right_look.frame.origin.y, 0, 0);
        
        self.right_hidden.frame = CGRectMake(self.right_hidden.frame.origin.x-55, self.right_hidden.frame.origin.y-40, 40, 66);
        self.left_hidden.frame = CGRectMake(self.left_hidden.frame.origin.x+60, self.left_hidden.frame.origin.y-40, 40, 66);
        
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
    
    if ([_UserNameTextField.text isEqualToString:@""] || [_PasswordTextField.text isEqualToString:@""]) {
        UIAlertView *updateAlert = [[UIAlertView alloc] initWithTitle: @"Warming" message: @"Invalid Email or Password." delegate: self cancelButtonTitle: @"OK"  otherButtonTitles:nil];
        [updateAlert show];
        
        return;
    }
    
    NSString * const kRemoteHost = ServerHost;
    Login_m *request = [[Login_m alloc] init];
    request.username = _UserNameTextField.text;
    request.password = _PasswordTextField.text;
    
    // Example gRPC call using a generated proto client library:
    
    Greeter *service = [[Greeter alloc] initWithHost:kRemoteHost];
    [service loginWithRequest:request handler:^(Inf *response, NSError *error) {
        if (response) {
            if ([response.information isEqualToString:@"OK"]) {
                
                
                [_LeftMenuView.add_sign_button setTitle:@"Add" forState:UIControlStateNormal];
                [_LeftMenuView.log_button setTitle:@"Log out" forState:UIControlStateNormal];
                [_LeftMenuView.idText setText:_UserNameTextField.text];
                [_LeftMenuView obtain_friends];
                
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
                NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"/Icon"];
                
                dataPath = [NSString stringWithFormat:@"%@/%@.png", dataPath, _LeftMenuView.idText.text];
                BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:dataPath];
                
                if (fileExists) {
                    _LeftMenuView.headImage.image = [UIImage imageWithContentsOfFile:dataPath];
                } else {
                    _LeftMenuView.headImage.image = [UIImage imageNamed:@"icon-user-default.png"];
                }
                
                ViewController *mainUI = (ViewController *)_LeftMenuView.mainUIView;
                [mainUI obtain_bills];
                mainUI.helloWorld.text = @"Welcome to Ishare";
                [self dismissViewControllerAnimated:true completion:^{
                    NSLog(@"Present Modal View");
                }];
            } else {
                UIAlertView *updateAlert = [[UIAlertView alloc] initWithTitle: @"Message" message: @"Wrong username or password" delegate: self cancelButtonTitle: @"OK"  otherButtonTitles:nil];
                
                [updateAlert show];
            }
            
        } else if (error) {
            //NSLog(@"Finished with error: %@", error);
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
