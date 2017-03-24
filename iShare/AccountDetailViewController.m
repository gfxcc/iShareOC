//
//  AccountDetailViewController.m
//  iShare
//
//  Created by caoyong on 1/23/16.
//  Copyright © 2016 caoyong. All rights reserved.
//

#import "AccountDetailViewController.h"
#import "FileOperation.h"
#import <JDStatusBarNotification/JDStatusBarNotification.h>
#import <TSMessageView.h>
#import <gRPC_pod/IShare.pbrpc.h>
#import <gRPC_pod/IShare.pbobjc.h>
#import "LeftMenuViewController.h"

@interface AccountDetailViewController ()

@property (strong, nonatomic) UITableViewCell *usernameCell;
@property (strong, nonatomic) UITableViewCell *emailCell;

@property (strong, nonatomic) UITableViewCell *passwordCell;

@property (strong, nonatomic) UITableViewCell *defaultCurrencyCell;

@property (strong, nonatomic) UITableViewCell *saveCell;


@property (strong, nonatomic) UITextField *usernameText;
@property (strong, nonatomic) UITextField *passwordText;
@property (strong, nonatomic) UITextField *emailText;

@property (nonatomic) BOOL changed;
@property (strong, nonatomic) NSString *originalPassword;

@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) FileOperation *fileOperation;
@end

@implementation AccountDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _fileOperation = [[FileOperation alloc] init];
    _userId = [_fileOperation getUserId];
    _changed = NO;
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //_tableView.allowsSelection = NO;
    
    _usernameCell = [[UITableViewCell alloc]init];
    _passwordCell = [[UITableViewCell alloc]init];
    _emailCell = [[UITableViewCell alloc]init];
    _defaultCurrencyCell = [[UITableViewCell alloc]init];
    _saveCell = [[UITableViewCell alloc] init];
    
    _usernameCell.selectionStyle = UITableViewCellSelectionStyleNone;
    _passwordCell.selectionStyle = UITableViewCellSelectionStyleNone;
    _emailCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _saveCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    _usernameCell.textLabel.text = @"Username";
    _emailCell.textLabel.text = @"Email";
    _passwordCell.textLabel.text = @"Password";
    _defaultCurrencyCell.textLabel.text = @"Default currency";
    _saveCell.textLabel.text = @"SAVE CHANGES";
    _saveCell.textLabel.textAlignment = NSTextAlignmentCenter;
    _saveCell.textLabel.textColor = [UIColor grayColor];
    
    _usernameText = [[UITextField alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 185 - 10,
                                                                              0, 185, 44)];
    _usernameText.adjustsFontSizeToFitWidth = YES;
    //_usernameText.placeholder = @"gfxcc";
    _usernameText.textAlignment = NSTextAlignmentRight;
    _usernameText.delegate = self;
    _usernameText.tag = 0;
    [_usernameText addTarget:self
                      action:@selector(textFieldDidChange:)
         forControlEvents:UIControlEventEditingChanged];
    
    _usernameText.text = [_fileOperation getUsername];
    
    
    _emailText = [[UITextField alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 185 - 10,
                                                               0, 185, 44)];
    _emailText.adjustsFontSizeToFitWidth = YES;
    _emailText.placeholder = @"yong_stevens@outlook.com";
    _emailText.textAlignment = NSTextAlignmentRight;
    _emailText.autocorrectionType = UITextAutocorrectionTypeNo;
    _emailText.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _emailText.delegate = self;
    _emailText.tag = 1;
    [_emailText addTarget:self
                   action:@selector(textFieldDidChange:)
         forControlEvents:UIControlEventEditingChanged];
    
    _passwordText = [[UITextField alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 185 - 10,
                                                                  0, 185, 44)];
    _passwordText.adjustsFontSizeToFitWidth = YES;
    _passwordText.placeholder = @"123456";
    _passwordText.textAlignment = NSTextAlignmentRight;
    _passwordText.autocorrectionType = UITextAutocorrectionTypeNo;
    _passwordText.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _passwordText.secureTextEntry = YES;
    _passwordText.delegate = self;
    _passwordText.tag = 2;
    [_passwordText addTarget:self
                      action:@selector(textFieldDidChange:)
            forControlEvents:UIControlEventEditingChanged];
    
    
    
    [_usernameCell.contentView addSubview:_usernameText];
    [_emailCell.contentView addSubview:_emailText];
    [_passwordCell.contentView addSubview:_passwordText];
    
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
//    label.text = @"USD";
//    _defaultCurrencyCell.accessoryView = label;
    
    [self loadSetting];
    
//    [TSMessage showNotificationInViewController:self
//                                          title:@"Warning"
//                                       subtitle:@"Username can not be changed"
//                                           type:TSMessageNotificationTypeWarning
//                                       duration:TSMessageNotificationDurationAutomatic];
}


- (void)loadSetting {
    if ([_userId isEqualToString:@""]) {
        return;
    }
    
    NSString * const kRemoteHost = ServerHost;
    
    Inf *request = [[Inf alloc] init];
    
    request.information = _userId;
    
    Greeter *service = [[Greeter alloc] initWithHost:kRemoteHost];
    [service obtain_userInfoWithRequest:request handler:^(UserInfo *response, NSError *error) {
        if (response) {
            _emailText.text = response.email;
            _passwordText.text = response.password;
            _originalPassword = response.password;
            _usernameText.text = response.username;
        } else if (error) {
            //NSLog(@"Finished with error: %@", error);
            return;
        }
    }];
    
    //[service obtain_settingWithRequest:request handler:^(Setting *response, NSError *error){}];
}

- (void)uploadSetting {
    [JDStatusBarNotification showWithStatus:@"saving your changes to server"];
    [JDStatusBarNotification showActivityIndicator:YES
                                    indicatorStyle:UIActivityIndicatorViewStyleGray];
    
    NSString * const kRemoteHost = ServerHost;
    
    UserInfo *request = [UserInfo message];
    request.userId = _userId;
    request.username = _usernameText.text;
    request.password = _passwordText.text;
    request.email = _emailText.text;
    
    
    Greeter *service = [[Greeter alloc] initWithHost:kRemoteHost];
    [service reset_userInfoWithRequest:request handler:^(Inf *response, NSError *error) {
        if (response) {
            
            if ([response.information isEqualToString:@"OK"]) {
                [_fileOperation setUsername:request.username userId:request.userId];
                LeftMenuViewController *leftView = (LeftMenuViewController *)_leftUIView;
                leftView.idText.text = request.username;
                //[_leftUIView viewDidLoad];
                [JDStatusBarNotification dismiss];
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                [TSMessage showNotificationInViewController:self
                                                      title:@"Sorry"
                                                   subtitle:response.information
                                                       type:TSMessageNotificationTypeWarning
                                                   duration:TSMessageNotificationDurationAutomatic];
                [JDStatusBarNotification dismiss];
            }
        } else if (error) {
            [TSMessage showNotificationInViewController:self
                                                  title:@"Sorry"
                                               subtitle:@"can not connect to server, Please contact with the developer."
                                                   type:TSMessageNotificationTypeWarning
                                               duration:TSMessageNotificationDurationAutomatic];
            [JDStatusBarNotification dismiss];
            return;
        }
    }];
}

// called when click SAVE CHANGES cell
// used to verify user have the permission to change the information
// need input original password
- (void)verify {
    
    UIAlertView *verifyAlert = [[UIAlertView alloc] initWithTitle:@"Verify" message:@"Please input your original password" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    verifyAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [verifyAlert textFieldAtIndex:0].delegate = self;
    [verifyAlert textFieldAtIndex:0].tag = 5;
    [verifyAlert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            break;
        case 1:// OK
            if ([[alertView textFieldAtIndex:0].text isEqualToString:_originalPassword]) {
                [self uploadSetting];
            } else {
                [TSMessage showNotificationInViewController:self
                                                      title:@"Warning"
                                                   subtitle:@"password is incorrect"
                                                       type:TSMessageNotificationTypeWarning
                                                   duration:TSMessageNotificationDurationAutomatic];
            }
            break;
        default:
            break;
    }
    [_tableView deselectRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:3] animated:YES];
}

#pragma mark -
#pragma mark UITextField

- (void)textFieldDidChange:(UITextField *)textField {

    if (![_fileOperation checkString:textField.text cha:'*'] || ![_fileOperation checkString:textField.text cha:'\'']) {
        [TSMessage showNotificationInViewController:self
                                              title:@"Warning"
                                           subtitle:@"username and password can not contain '*' and '''."
                                               type:TSMessageNotificationTypeWarning
                                           duration:TSMessageNotificationDurationAutomatic];
        _changed = NO;
        _saveCell.selectionStyle = UITableViewCellSelectionStyleNone;
    } else {
        _changed = YES;
        _saveCell.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.tag == 0) {

        UIAlertView *verifyAlert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"We do not advise you change your username frequently. Your friends might have a problem to recognize you. After you change your username, all of your friends will receive a notification about that." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [verifyAlert show];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

#pragma mark -
#pragma mark TableView delegate

// Return the number of sections

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    // If You have only one(1) section, return 1, otherwise you must handle sections
    return 4;
}

// Return the row for the corresponding section and row
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch(indexPath.section)
    {
        case 0:
            switch(indexPath.row)
        {
            case 0: return self.usernameCell;  // section 0, row 0 is the first name
            case 1: return self.emailCell;
        }
        case 1:
            switch(indexPath.row)
        {
            case 0: return self.passwordCell;      // section 1, row 0 is the share option
        }
        case 2:
            switch(indexPath.row)
        {
            case 0: return self.defaultCurrencyCell;
        }
        case 3:
            return self.saveCell;
    }
    return nil;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    switch(section)
    {
        case 0:  return 2;  // section 0 has 2 rows
        case 1:  return 1;  // section 1 has 1 row
        case 2:  return 1;
        case 3:  return 1;
        default: return 0;
    };
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch(section)
    {
        case 0: return @"Information";
        case 1: return @"Security";
        case 2: return @"setting";
        case 3: return @"";
    }
    return nil;
}

- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {
    if (indexPath.section == 3 && _changed) {
        
        [self verify];
    }
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
