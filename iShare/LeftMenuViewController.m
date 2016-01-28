//
//  LeftMenuViewController.m
//  iShare
//
//  Created by caoyong on 5/11/15.
//  Copyright (c) 2015 caoyong. All rights reserved.
//
#import "LeftMenuViewController.h"
#import "SlideNavigationContorllerAnimatorFade.h"
#import "SlideNavigationContorllerAnimatorSlide.h"
#import "SlideNavigationContorllerAnimatorScale.h"
#import "SlideNavigationContorllerAnimatorScaleAndFade.h"
#import "SlideNavigationContorllerAnimatorSlideAndFade.h"
#import <gRPC_pod/IShare.pbrpc.h>
#import <gRPC_pod/IShare.pbobjc.h>
#import "LoginViewController.h"
#import "SignUpViewController.h"
#import "SearchViewController.h"
#import "UIWindow+YUBottomPoper.h"
#import "ViewController.h"
#import "UserListTableViewCell.h"
#import "BaseNavigationController.h"
#import "SettingViewController.h"
#import <TSMessageView.h>

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

@interface LeftMenuViewController ()

@property(nonatomic, strong) NSIndexPath *deleteIndex;

@end

@implementation LeftMenuViewController

#pragma mark - UIViewController Methods -

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self.slideOutAnimationEnabled = YES;
    
    return [super initWithCoder:aDecoder];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView deselectRowAtIndexPath:[_tableView indexPathForSelectedRow] animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.tableView.separatorColor = [UIColor lightGrayColor];

    self.tableView.contentInset = UIEdgeInsetsMake(-1.0f, 0.0f, 0.0f, 0.0);
    self.view.backgroundColor = RGB(61, 64, 71);
    _headImage.layer.cornerRadius = 5;
    _headImage.clipsToBounds = YES;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *fileName = [NSString stringWithFormat:@"%@/friends",
                          documentsDirectory];
    NSString *content = [[NSString alloc] initWithContentsOfFile:fileName
                                                    usedEncoding:nil
                                                           error:nil];
    NSArray *members = [content componentsSeparatedByString:@"\n"];
    
    [_idText setTextColor:RGB(255, 255, 255)];
    _idText.text = members.count == 0 ? @"" : members[0];
    if ([_idText.text isEqualToString:@""]) {
        [_log_button setTitle:@"Log In/Sign up" forState:UIControlStateNormal];
    }
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"/Icon"];
    
    dataPath = [NSString stringWithFormat:@"%@/%@.png", dataPath, _idText.text];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:dataPath];
    
    if (fileExists) {
        _headImage.image = [UIImage imageWithContentsOfFile:dataPath];
    } else {
        _headImage.image = [UIImage imageNamed:@"icon-user-default.png"];
    }
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touch_icon)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    [_headImage addGestureRecognizer:singleTap];
    [_headImage setUserInteractionEnabled:YES];
    
    _friendsArray = [[NSMutableArray alloc] init];
    
    [self obtain_friends];
    //[self loadFriends];
}



#pragma mark - custom functions

- (void)loadFriends {
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fileName = [NSString stringWithFormat:@"%@/friends",
                          documentsDirectory];
    NSString *content = [[NSString alloc] initWithContentsOfFile:fileName
                                                  usedEncoding:nil
                                                         error:nil];
    /* if no exist friends data */
    if ([content isEqualToString:@""]) {
        return;
    }
    NSArray *members = [content componentsSeparatedByString:@"\n"];
    for (int i = 1; i < members.count; i++) {
        [_friendsArray addObject:members[i]];
    }
}

- (void)touch_icon {
    // do not login
    if ([_idText.text isEqualToString:@""]) {
        return;
    }
    
    [self.view.window  showPopWithButtonTitles:@[@"Take a picture", @"Choose from Library"] styles:@[YUDefaultStyle,YUDefaultStyle] whenButtonTouchUpInSideCallBack:^(int index  ) {
        // optimize popup view
//        if (index > 1) {
//            return;
//        }
        NSLog(@"%d", index);
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        
        switch (index) {
            case 0:{
                // hide mainUI first
                ViewController *mainUI = (ViewController *)_mainUIView;
                [mainUI hideMainUI];
                
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:picker animated:YES completion:NULL];
                break;
            }
            case 1:{
                // hide mainUI first
                ViewController *mainUI = (ViewController *)_mainUIView;
                [mainUI hideMainUI];
                
                picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                [self presentViewController:picker animated:YES completion:NULL];
                break;
            }
            default:
                break;
        }
    }];
}

- (void)obtain_friends {
    NSString * const kRemoteHost = ServerHost;

    Inf *request = [[Inf alloc] init];
    request.information = _idText.text;
    //NSString *t = _idText.text;
    
    // Example gRPC call using a generated proto client library:
    
    Greeter *service = [[Greeter alloc] initWithHost:kRemoteHost];
    [service user_infWithRequest:request handler:^(User_detail *response, NSError *error) {
        if (response) {
            [_friendsArray removeAllObjects];
            for (int i = 0; i != response.friendsArray.count; i++) {
                //NSLog(@"%@  ", response.friendsArray[i]);
                _friendsArray[i] = response.friendsArray[i];
            }
            [self download_friends_icon];
            [self save_data];
            [_tableView reloadData];
        } else if (error) {
            //NSLog(@"Finished with error: %@", error);
            return;
        }
    }];
    
}


- (void)delete_friend {
    NSString * const kRemoteHost = ServerHost;
    Repeated_string *request = [[Repeated_string alloc] init];
    [request.contentArray addObject:_idText.text];
    [request.contentArray addObject:_friendsArray[_deleteIndex.row]];
    
    // Example gRPC call using a generated proto client library:
    
    Greeter *service = [[Greeter alloc] initWithHost:kRemoteHost];
    [service delete_friendWithRequest:request handler:^(Inf *response, NSError *error) {
        if (response) {
            
            if ([response.information isEqualToString:@"OK"]) {
                NSLog(@"Delete success!");
            }
            [_friendsArray removeObjectAtIndex:_deleteIndex.row];
            [_tableView deleteRowsAtIndexPaths:@[_deleteIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
            
        } else if (error) {
            [TSMessage showNotificationInViewController:self
                                                  title:@"GRPC ERROR"
                                               subtitle:@"delete_friendWithRequest"
                                                   type:TSMessageNotificationTypeError
                                               duration:TSMessageNotificationDurationEndless];
        }
    }];
}

// save friend list and icon
- (void)save_data {

    NSString *result = _idText.text;
    for (int i = 0; i != _friendsArray.count ; i++) {
        result = [NSString stringWithFormat:@"%@\n%@", result, _friendsArray[i]];
    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fileName = [NSString stringWithFormat:@"%@/friends",
                          documentsDirectory];
    [result writeToFile:fileName
             atomically:NO
               encoding:NSUTF8StringEncoding
                  error:nil];
    // save icon
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"/Icon"];
    NSData *image_data = UIImagePNGRepresentation(_headImage.image);
    [image_data writeToFile:[NSString stringWithFormat:@"%@/%@.png", dataPath, _idText.text] atomically:YES];
}

- (void)loginView {
    UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginPage = [mainStoryboard instantiateViewControllerWithIdentifier:@"LogInView"];
    
    //loginPage.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    loginPage.LeftMenuView = self;
    
    UINavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:loginPage];
    //[_mainUINavgation presentViewController:loginPage animated:YES completion:nil];
    [_mainUIView presentViewController:nav animated:YES completion:nil];
}

- (void)signUpView {
    UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SignUpViewController *signUpPage = [mainStoryboard instantiateViewControllerWithIdentifier:@"SignUpView"];
    
    signUpPage.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    signUpPage.LeftMenuView = self;
    [_mainUINavgation presentViewController:signUpPage animated:YES completion:^{
        NSLog(@"Present Modal View");
    }];
}

- (void)send_imge:(UIImage *)image name:(NSString *)name path:(NSString *)path {
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


- (void)download_friends_icon {
    NSString * const kRemoteHost = ServerHost;
    
    Repeated_string *request = [Repeated_string message];
    
    // better?
    
//    request.contentArray = [NSMutableArray arrayWithArray:_friendsArray];
//    [request.contentArray insertObject:@"icon" atIndex:0];
//    [request.contentArray insertObject:_idText.text atIndex:1];
    request.contentArray = [[NSMutableArray alloc] init];
    [request.contentArray addObject:@"icon"];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"/Icon"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/%@.png", dataPath, _idText.text]]) {
        [request.contentArray addObject:_idText.text];
    }
    
    for (int i = 0; i != _friendsArray.count; i++) {
        if (![[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/%@.png", dataPath, _friendsArray[i]]]) {
            [request.contentArray addObject:_friendsArray[i]];
        }
    }
    
    
    for (int i = 0; i != request.contentArray.count; i++) {
        NSLog(@"%@", request.contentArray[i]);
    }
    
    Greeter *service = [[Greeter alloc] initWithHost:kRemoteHost];
    [service receive_ImgWithRequest:request eventHandler:^(BOOL done, Image *response, NSError *error) {
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
            NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"/Icon"];
            
            dataPath = [NSString stringWithFormat:@"%@/%@.png", dataPath, _idText.text];
            BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:dataPath];
            
            if (fileExists) {
                _headImage.image = [UIImage imageWithContentsOfFile:dataPath];
            } else {
                _headImage.image = [UIImage imageNamed:@"icon-user-default.png"];
            }
            // reload
            [_tableView reloadData];
            ViewController *mainView = (ViewController *)_mainUIView;
            [mainView.tableView reloadData];
        }
    }];
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"setting"]) {

        
        UINavigationController *navgation = (UINavigationController *)[segue destinationViewController];
        //
        SettingViewController *settingView = (SettingViewController *)([navgation viewControllers][0]);
        settingView.mainUIView = _mainUIView;
        settingView.username = _idText.text;
        
        
        ViewController *mainUI = (ViewController *)_mainUIView;
        [mainUI hideMainUI];
    }
}

#pragma mark  - UIAlertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    ViewController *mainUI = (ViewController *)_mainUIView;
    
    if (alertView.tag == 0) {
        switch (buttonIndex) {
            case 0:
                break;
            case 1:// Sure!
                [_friendsArray removeAllObjects];
                [_tableView reloadData];
                
                [mainUI.bill_latest removeAllObjects];
                [mainUI.tableView reloadData];
                [mainUI removeCharts];
                mainUI.helloWorld.text = @"Sign In OR Log In";
                [self clean];
                [_log_button setTitle:@"Log In/Sign up" forState:UIControlStateNormal];
                [_add_sign_button setTitle:@"Sign Up" forState:UIControlStateNormal];
                
                _idText.text = @"";
                _headImage.image = [UIImage imageNamed:@"icon-user-default.png"];
                
                break;
            default:
                break;
        }
    } else if (alertView.tag == 1) {
        switch (buttonIndex) {
            case 0:
                break;
            case 1:
                [self delete_friend];
                
            default:
                break;
        }
    }
    
}

#pragma mark - reaction functions

- (IBAction)log_out:(id)sender {
    
    //log out button
    if ([_log_button.titleLabel.text isEqualToString:@"Log out"]) {
        
        UIAlertView *updateAlert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Log out confirm" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"Sure!", nil];
        updateAlert.tag = 0;
        [updateAlert show];
    } else {// log in button
        
        [self loginView];
        //[_log_button setTitle:@"log out" forState:UIControlStateNormal];
    }
}
- (IBAction)add_sign:(id)sender {
    
    if ([_add_sign_button.titleLabel.text isEqualToString:@"Add"]) {
        
        UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        SearchViewController *searchView = [mainStoryboard instantiateViewControllerWithIdentifier:@"SearchView"];
        searchView.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        searchView.LeftMenuView = self;
        
        // hide mainUI first
        ViewController *mainUI = (ViewController *)_mainUIView;
        [mainUI hideMainUI];
        
        [self presentViewController:searchView animated:YES completion:^{
            NSLog(@"Present Modal View");
        }];
        
    } else {
        [self signUpView];
        
    }
}

// clean data like friends file, billRecord fill, billType
- (void)clean {
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fileName = [NSString stringWithFormat:@"%@/friends",
                          documentsDirectory];
    [@"" writeToFile:fileName
             atomically:NO
               encoding:NSUTF8StringEncoding
                  error:nil];
    
    fileName = [NSString stringWithFormat:@"%@/billRecord",
                documentsDirectory];
    [@"" writeToFile:fileName
          atomically:NO
            encoding:NSUTF8StringEncoding
               error:nil];
    
    fileName = [NSString stringWithFormat:@"%@/billType",
                documentsDirectory];
    
    [@"" writeToFile:fileName
          atomically:NO
            encoding:NSUTF8StringEncoding
               error:nil];
    
    fileName = [NSString stringWithFormat:@"%@/statisticsRecord",
                documentsDirectory];
    
    [@"" writeToFile:fileName
          atomically:NO
            encoding:NSUTF8StringEncoding
               error:nil];
    
    fileName = [NSString stringWithFormat:@"%@/settingRecord",
                documentsDirectory];
    
    [@"" writeToFile:fileName
          atomically:NO
            encoding:NSUTF8StringEncoding
               error:nil];

}

#pragma mark - imagePickerController Delegate & Datasrouce -
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    
    [_headImage setImage:chosenImage];
    [self save_data];
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    ViewController *mainUI = (ViewController *)_mainUIView;
    [mainUI hideMainUI];
    
    // send image
    [self send_imge:chosenImage name:_idText.text path:@"icon"];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
    ViewController *mainUI = (ViewController *)_mainUIView;
    [mainUI hideMainUI];
}

#pragma mark - UITableView Delegate & Datasrouce -


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    // If You have only one(1) section, return 1, otherwise you must handle sections
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.

    switch(section)
    {
        case 0:  return 1;  // section 0 has 1 rows
        case 1:  return _friendsArray.count;;  // section 1 has  row
        default: return 0;
    };
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
        return 0.0f;
    return 32.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return nil;
    } else if (section == 1) {
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 32)];
        headView.backgroundColor = RGB(57, 60, 67);
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10, 2, 100, 28)];
        title.textColor = RGB(115, 117, 122);
        title.text = @"FRIENDS";
        [headView addSubview:title];
        
        UIButton *edit = [[UIButton alloc] initWithFrame:CGRectMake(200, 2, 100, 28)];
        [edit setTitle:@"EDIT" forState:UIControlStateNormal];
        [edit setTitleColor:RGB(115, 117, 122) forState:UIControlStateNormal];
        [edit addTarget:self action:@selector(editClick) forControlEvents:UIControlEventTouchUpInside];
        [headView addSubview:edit];
        return headView;
    }
    return nil;
}

- (void)editClick {
    if (_tableView.editing) {
        [_tableView setEditing: NO animated: YES];
    } else {
        [_tableView setEditing: YES animated: YES];
    }
    
    [(ViewController *)_mainUIView hideMainUI];
    //[_editButton setTitle:@"done" forState:UIControlStateNormal];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        static NSString *CellIdentifier = @"UserListCell";
        UserListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        [cell initWith:@"Add New Friend" icon:[UIImage imageNamed:@"search.png"]];
        cell.username.textColor = RGB(115, 117, 122);
        /*
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        //cell.textLabel.text = @"Add new friend";
        
        cell.backgroundColor = RGB(61, 64, 71);
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(8, 3, 44, 42)];
        icon.image = [UIImage imageNamed:@"search.png"];
        [cell addSubview:icon];
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(60, 8, 212, 37)];
        title.text = @"Add New Friend";
        title.textColor = RGB(115, 117, 122);
        [cell addSubview:title];
         */
        return cell;
        
    } else if (indexPath.section == 1) {
        static NSString *CellIdentifier = @"UserListCell";
        
        //    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        //    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        //
        //    cell.textLabel.text = _friendsArray[indexPath.row];
        UserListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
        NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"/Icon"];
        
        dataPath = [NSString stringWithFormat:@"%@/%@.png", dataPath, _friendsArray[indexPath.row]];
        BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:dataPath];
        
        if (fileExists) {
            [cell initWith:_friendsArray[indexPath.row] icon:[UIImage imageWithContentsOfFile:dataPath]];
        } else {
            [cell initWith:_friendsArray[indexPath.row] icon:[UIImage imageNamed:@"icon-user-default.png"]];
        }
        
        FullSizeView *fullSizeImage = [[FullSizeView alloc] initWithBounds:self.view.bounds SuperView:self.view ImageView:cell.icon Image:cell.icon.image];
        fullSizeImage.delegate = self;
        [self.view addSubview:fullSizeImage];
        
        
        
        return cell;
    }
    return nil;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        SearchViewController *searchView = [mainStoryboard instantiateViewControllerWithIdentifier:@"SearchView"];
        searchView.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        searchView.LeftMenuView = self;
        
        // hide mainUI first
        ViewController *mainUI = (ViewController *)_mainUIView;
        [mainUI hideMainUI];
        
        [self presentViewController:searchView animated:YES completion:^{
            NSLog(@"Present Modal View");
        }];
    }
    [self.tableView deselectRowAtIndexPath:[_tableView indexPathForSelectedRow] animated:YES];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Detemine if it's in editing mode
    if (self.tableView.editing)
    {
        return UITableViewCellEditingStyleDelete;
    }
    
    return UITableViewCellEditingStyleNone;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //[self delete_friend:indexPath.row];
        //[self obtain_friends];
        if (indexPath.section == 0) {
            return;
        }
        
        _deleteIndex = indexPath;
        
        UIAlertView *updateAlert = [[UIAlertView alloc] initWithTitle:@"Warning" message:[NSString stringWithFormat:@"delete %@ from your friend list?", _friendsArray[indexPath.row]] delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"Sure!", nil];
        updateAlert.tag = 1;
        [updateAlert show];
        
    }
}

#pragma mark - FullSizeView delegate -
- (void)originalImageViewTapped {
    ViewController *mainUI = (ViewController *)_mainUIView;
    [mainUI hideMainUI];
    
}

- (void)fullSizeViewTapped {
    ViewController *mainUI = (ViewController *)_mainUIView;
    [mainUI hideMainUI];
}


@end