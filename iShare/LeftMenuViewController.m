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
#import "FileOperation.h"
#import "BillListWithFriendViewController.h"
#import <APParallaxHeader/UIScrollView+APParallaxHeader.h>


#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

@interface LeftMenuViewController ()

@property(nonatomic, strong) NSIndexPath *deleteIndex;
@property (nonatomic, strong) FileOperation *fileOperation;

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
    
    _fileOperation = [[FileOperation alloc] init];
    _user_id = [_fileOperation getUserId];

    _tableView.delegate = self;
    _tableView.dataSource = self;
    self.tableView.contentInset = UIEdgeInsetsMake(-1.0f, 0.0f, 0.0f, 0.0);
    self.view.backgroundColor = RGB(61, 64, 71);
    

    _headImage.layer.cornerRadius = 5;
    _headImage.clipsToBounds = YES;
  
    [_idText setTextColor:RGB(255, 255, 255)];
    
    NSString *username = [_fileOperation getUsername];
    if ([username isEqualToString:@""] || !username) {
        _idText.text = @"";
    } else {
        _idText.text = username;
    }
    if ([_idText.text isEqualToString:@""]) {
        [_log_button setTitle:@"Log In/Sign up" forState:UIControlStateNormal];
    }
    
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"/Icon"];
    
    dataPath = [NSString stringWithFormat:@"%@/%@.png", dataPath, _user_id];
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
    
    __weak typeof(self) weakSelf = self;
    _headerView = [EaseUserHeaderView userHeaderViewWithBackground:[UIImage imageNamed:@"background_stars.jpg"] Icon:_headImage.image Username:_idText.text];
    _headerView.userIconClicked = ^(){
        [weakSelf touch_icon];
    };
    [_tableView addParallaxWithView:_headerView andHeight:CGRectGetHeight(_headerView.frame)];
//    [_tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
//    [_tableView addObserver:self forKeyPath:@"contentInset" options:NSKeyValueObservingOptionNew context:nil];
//    
    _friendsArray = [[NSMutableArray alloc] init];
    _friendsIdArray = [[NSMutableArray alloc] init];
    _friendsLastModified = [[NSMutableArray alloc] init];
    _friendsIconList = [[NSMutableArray alloc] init];
    
    [self obtain_friends];
    //[self loadFriends];
}



#pragma mark - custom functions

- (void)loadFriends {

    NSArray *members = [_fileOperation getFriendsNameList];
    for (int i = 0; i < members.count; i++) {
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
    if ([_idText.text isEqualToString:@""]) {
        return;
    }
    
    NSString * const kRemoteHost = ServerHost;
    
    Inf *request = [[Inf alloc] init];
    request.information = _user_id;
    //NSString *t = _idText.text;
    
    // Example gRPC call using a generated proto client library:
    
    Greeter *service = [[Greeter alloc] initWithHost:kRemoteHost];
    [service user_infWithRequest:request handler:^(User_detail *response, NSError *error) {
        if (response) {
            [_friendsArray removeAllObjects];
            [_friendsIdArray removeAllObjects];
            [_friendsLastModified removeAllObjects];
            for (int i = 0; i != response.friendsNameArray.count; i++) {
                //NSLog(@"%@  ", response.friendsArray[i]);
                [_friendsArray addObject:response.friendsNameArray[i]];
                [_friendsIdArray addObject:response.friendsIdArray[i]];
                [_friendsLastModified addObject:response.friendsLastModifiedArray[i]];
            }
            
            [self updateFriendsIcon];
            [self save_data];
            
        } else if (error) {
            //NSLog(@"Finished with error: %@", error);
            return;
        }
    }];
    
}


- (void)delete_friend {
    NSString * const kRemoteHost = ServerHost;
    Repeated_string *request = [[Repeated_string alloc] init];
    [request.contentArray addObject:_user_id];
    [request.contentArray addObject:_friendsIdArray[_deleteIndex.row]];

    
    // Example gRPC call using a generated proto client library:
    
    Greeter *service = [[Greeter alloc] initWithHost:kRemoteHost];
    [service delete_friendWithRequest:request handler:^(Inf *response, NSError *error) {
        if (response) {
            NSLog(@"Delete success!");
            [_friendsArray removeObjectAtIndex:_deleteIndex.row];
            [_tableView deleteRowsAtIndexPaths:@[_deleteIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
            
        } else if (error) {
            [TSMessage showNotificationInViewController:self
                                                  title:@"Sorry"
                                               subtitle:@"Please try again later."
                                                   type:TSMessageNotificationTypeError
                                               duration:TSMessageNotificationDurationEndless];
        }
    }];
}

// save friend list and icon
- (void)save_data {
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    [_fileOperation setFriendList:_friendsArray UserId:_friendsIdArray LastModified:_friendsLastModified];
    
    // save icon
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"/Icon"];
    NSData *image_data = UIImagePNGRepresentation(_headImage.image);
    [image_data writeToFile:[NSString stringWithFormat:@"%@/%@.png", dataPath, _user_id] atomically:YES];
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

- (void)updateLastModified {
    NSString * const kRemoteHost = ServerHost;
    Inf *request = [Inf message];
    request.information = _user_id;
    
    Greeter *service = [[Greeter alloc] initWithHost:kRemoteHost];
    [service update_user_lastModifiedWithRequest:request handler:^(Inf *response, NSError *error) {
        if (response) {
           
        } else if (error) {
            [TSMessage showNotificationInViewController:self
                                                  title:@"Sorry"
                                               subtitle:@"Some error happend, please contact developer."
                                                   type:TSMessageNotificationTypeError
                                               duration:TSMessageNotificationDurationEndless];
        }
    }];
}

- (void)updateFriendsIcon {
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
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/%@.png", dataPath, _user_id]]) {
        [request.contentArray addObject:_user_id];
    }
    
    // compare lastModified
    for (int i = 0; i != _friendsArray.count; i++) {
        //if (![[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/%@.png", dataPath, _friendsIdArray[i]]]) {}
        NSString *lastModifiedFromFile = [_fileOperation getLastModifiedByUserId:_friendsIdArray[i]];
        if ([lastModifiedFromFile isEqualToString:_friendsLastModified[i]])
            continue;
        [request.contentArray addObject:_friendsIdArray[i]];
    }
    

    Greeter *service = [[Greeter alloc] initWithHost:kRemoteHost];
    [service receive_ImgWithRequest:request eventHandler:^(BOOL done, Image *response, NSError *error) {
        if (!done) {
            if (response.data_p.length == 0) {
                return;
            }
            NSLog(@"%@  %lu", response.name, (unsigned long)response.data_p.length);
            [response.data_p writeToFile:[NSString stringWithFormat:@"%@/%@.png", dataPath, response.name] atomically:YES];
            
        } else if (error) {
            
        } else { // done
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
            NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"/Icon"];
            
            dataPath = [NSString stringWithFormat:@"%@/%@.png", dataPath, _user_id];
            BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:dataPath];
            
            if (fileExists) {
                _headerView.userIconView.image = [UIImage imageWithContentsOfFile:dataPath];
            }
            [self loadFriendsIcons];
            // reload
            [_tableView reloadData];
            ViewController *mainView = (ViewController *)_mainUIView;
            [mainView.tableView reloadData];
        }
    }];
    
}

- (void)loadFriendsIcons {
    // obtin image into FriendsIconList
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"/Icon"];
    
    for (int i = 0; i != _friendsIdArray.count; i++) {
        NSString *imagePath = [NSString stringWithFormat:@"%@/%@.png", dataPath, _friendsIdArray[i]];
        BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:imagePath];
        
        if (fileExists) {
            [_friendsIconList addObject:[UIImage imageWithContentsOfFile:imagePath]];
        } else {
            [_friendsIconList addObject:[UIImage imageNamed:@"icon-user-default.png"]];
        }
    }
}

#pragma mark  - prepareForSegue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"setting"]) {
        
        UINavigationController *navgation = (UINavigationController *)[segue destinationViewController];
        //
        SettingViewController *settingView = (SettingViewController *)([navgation viewControllers][0]);
        settingView.mainUIView = _mainUIView;
        settingView.username = _idText.text;
        settingView.leftUIView = self;
        
        ViewController *mainUI = (ViewController *)_mainUIView;
        [mainUI hideMainUI];
    } else if ([segue.identifier isEqualToString:@"checkBillWithFriend"]) {
        //BillListWithFriendViewController *billView = (BillListWithFriendViewController*)[segue destinationViewController];
        BillListWithFriendViewController *billListView = (BillListWithFriendViewController*)[segue destinationViewController];
        billListView.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        
        billListView.username = _friendsArray[[_tableView indexPathForSelectedRow].row];
        billListView.navigationItem.title = _friendsArray[[_tableView indexPathForSelectedRow].row];
        billListView.sum = @"NULL";
        billListView.idText = [_friendsArray objectAtIndex:[_tableView indexPathForSelectedRow].row];
        billListView.mainUIView = _mainUIView;
        
        // hide mainUI first
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
    
    fileName = [NSString stringWithFormat:@"%@/quickType",
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
    [self send_imge:chosenImage name:_user_id path:@"icon"];
    [self updateLastModified];
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
    return 3;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.

    switch(section)
    {
        case 0:  return 1;  // section 0 has 1 rows
        case 1:  return 0;  // section 1 has  row
        case 2:  return _friendsArray.count;
        default: return 0;
    };
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0 || section == 2)
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
        
        CGFloat originX = [UIScreen mainScreen].bounds.size.width;
        originX = originX / 2 + 20;
        UIButton *edit = [[UIButton alloc] initWithFrame:CGRectMake(originX, 2, 100, 28)];
        [edit setTitle:@"EDIT" forState:UIControlStateNormal];
        [edit setTitleColor:RGB(115, 117, 122) forState:UIControlStateNormal];
        [edit addTarget:self action:@selector(editClick) forControlEvents:UIControlEventTouchUpInside];
        [headView addSubview:edit];
        return headView;
    } else if (section == 2) {
        return nil;
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
        
    } else if (indexPath.section == 2) {
        static NSString *CellIdentifier = @"UserListCell";
        
        //    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        //    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        //
        //    cell.textLabel.text = _friendsArray[indexPath.row];
        UserListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        [cell initWith:_friendsArray[indexPath.row] icon:_friendsIconList[indexPath.row]];
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
    } else {
        //[self performSegueWithIdentifier:@"checkBillWithFriend" sender:self];
        /*
        UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        BillListWithFriendViewController *billListView = [mainStoryboard instantiateViewControllerWithIdentifier:@"BillsWithFriendView"];
        billListView.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        
        billListView.username = _friendsArray[[_tableView indexPathForSelectedRow].row];
        billListView.navigationItem.title = _friendsArray[[_tableView indexPathForSelectedRow].row];
        billListView.sum = @"NULL";
        billListView.idText = [_friendsArray objectAtIndex:indexPath.row];
        billListView.mainUIView = _mainUIView;
        
        // hide mainUI first
        ViewController *mainUI = (ViewController *)_mainUIView;
        [mainUI hideMainUI];
        
        [self presentViewController:billListView animated:YES completion:^{
            NSLog(@"Present Modal View");
        }];
         */
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

//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
//    if ([keyPath isEqualToString:@"contentInset"]) {
//        NSLog(@"t");
//    } else {
//        NSLog(@"%f  %f   %f", _tableView.contentInset.top, _tableView.contentOffset.y, _headerView.bounds.size.height);
//        if ((-_tableView.contentOffset.y) < kScaleFrom_iPhone5_Desgin(190)) {
//            UIEdgeInsets newInset = _tableView.contentInset;
//            newInset.top = -_tableView.contentOffset.y;
//            _tableView.contentInset = newInset;
//        } else {
//            UIEdgeInsets newInset = _tableView.contentInset;
//            newInset.top = kScaleFrom_iPhone5_Desgin(190);
//            _tableView.contentInset = newInset;
//        }
//
//    }
//}

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