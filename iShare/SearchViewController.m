//
//  SearchViewController.m
//  iShare
//
//  Created by caoyong on 6/14/15.
//  Copyright (c) 2015 caoyong. All rights reserved.
//

#import "SearchViewController.h"
#import <gRPC_pod/IShare.pbrpc.h>
#import <gRPC_pod/IShare.pbobjc.h>
#import "ViewController.h"
#import <TSMessageView.h>
#import "UIButton+PPiAwesome.h"
#import "UIAwesomeButton.h"
#import "FileOperation.h"



#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

@interface SearchViewController ()

@property (strong, nonatomic) NSMutableArray* search_result_username;
@property (strong, nonatomic) NSMutableArray* search_result_userIcon;
@property (strong, nonatomic) NSMutableArray* search_result_userId;
@property (nonatomic, strong) FileOperation *fileOperation;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _fileOperation = [[FileOperation alloc] init];
    
    UINavigationBar *navbar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 60)];
    navbar.barTintColor = RGB(26, 142, 180);
    [navbar setTintColor:RGB(255, 255, 255)];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                    style:UIBarButtonItemStyleDone target:nil action:@selector(back_to_mainUI)];
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:@"Title"];
    item.rightBarButtonItem = rightButton;
    item.hidesBackButton = YES;
    [navbar pushNavigationItem:item animated:NO];
    [self.view addSubview:navbar];
    
    _search_result_username = [[NSMutableArray alloc] init];
    _search_result_userIcon = [[NSMutableArray alloc] init];
    _search_result_userId = [[NSMutableArray alloc] init];
    self.navigationItem.title = @"Search";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
    return [_search_result_username count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CellIdentifier";
    
    // Dequeue or create a cell of the appropriate type.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    cell.accessoryType = UITableViewCellAccessoryNone;
    // remove subview
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"/cacheFolder"];
    
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(15, 5, 40, 40)];
    if ([[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/%@.png", dataPath, _search_result_userId[indexPath.row]]]) {
        icon.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.png", dataPath, _search_result_userId[indexPath.row]]];
    } else {
        icon.image = [UIImage imageNamed:@"placeholder_coding_square_55"];
    }
    [cell addSubview:icon];
    
    // Configure the cell.
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(80, 5, 100, 40)];
    label.text = _search_result_username[indexPath.row];
    [cell addSubview:label];
    
//    UIButton *twitter1=[UIButton buttonWithType:UIButtonTypeCustom text:@"add" icon:nil textAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[UIColor whiteColor]} andIconPosition:IconPositionLeft];
//    [twitter1 setBackgroundColor:[UIColor colorWithRed:27.0f/255 green:178.0f/255 blue:233.0f/255 alpha:1.0] forUIControlState:UIControlStateNormal];
//    [twitter1 setBackgroundColor:[UIColor colorWithRed:60.0f/255 green:89.0f/255 blue:157.0f/255 alpha:1.0] forUIControlState:UIControlStateHighlighted];
//    twitter1.frame=CGRectMake(300, 10, 50, 30);
//    [twitter1 setRadius:5.0];
//    [cell addSubview:twitter1];
    
    //cell.textLabel.text = _search_result_username[indexPath.row];
    return cell;
}

- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {
    _selectedIndex = indexPath.row;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // check already be friend.


    NSArray *members = [_fileOperation getFriendsNameList];
    
    for (int i = 0; i != members.count; i++) {
        if ([members[i] isEqualToString:_search_result_username[_selectedIndex]]) {
            [TSMessage showNotificationInViewController:self
                                                  title:@"Wrong"
                                               subtitle:@"You are already friend."
                                                   type:TSMessageNotificationTypeWarning
                                               duration:TSMessageNotificationDurationAutomatic];
            return;
        }
    }
    
    
    _requestView = [[RequestView alloc] initWithTitle:[NSString stringWithFormat:@"I am %@", _LeftMenuView.idText.text] subtitle:@"t"];
    _requestView.delegate = self;
    [self.view addSubview:_requestView];
    [_requestView show];

}

#pragma mark - RequestViewDelegate -
- (void)downloadUserIcon {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"/cacheFolder"];
    NSString * const kRemoteHost = ServerHost;
    
    Repeated_string *request = [Repeated_string message];
    
    // better?
    if (_search_result_username.count == 0)
        return;
    //request.contentArray = [NSMutableArray arrayWithArray:_search_result_userId];
    [request.contentArray addObject:@"icon"];

    for (int i = 0; i != _search_result_userId.count; i++) {
        if (![[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/%@.png", dataPath, _search_result_userId[i]]]) {
            [request.contentArray addObject:_search_result_userId[i]];
        }
    }
    if (request.contentArray.count  == 1) {
        [self.searchDisplayController.searchResultsTableView reloadData];
        return;
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
            [self.searchDisplayController.searchResultsTableView reloadData];
        }
    }];
    
}

- (void)sendRequest {
    // start grpc
    NSString * const kRemoteHost = ServerHost;
    Request *request = [Request message];
    request.sender = [_fileOperation getUserId];
    request.receiver = _search_result_username[_selectedIndex];
    request.type = @"friendInvite";
    
    if ([request.sender isEqualToString:@""]) {
        [TSMessage showNotificationInViewController:self
                                              title:@"Wrong"
                                           subtitle:@"Please login."
                                               type:TSMessageNotificationTypeWarning
                                           duration:TSMessageNotificationDurationAutomatic];
        return;
    }
    
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd hh:mm"];
    NSString *prettyVersion = [dateFormat stringFromDate:now];
    request.requestDate = prettyVersion;
    
    request.content = _requestView.PasswordTextField.text;
    
    Greeter *service = [[Greeter alloc] initWithHost:kRemoteHost];
    [service send_requestWithRequest:request handler:^(Inf *response, NSError *error) {
        if (response) {
            NSString *message = @"Your request have been send successfully";
            [TSMessage showNotificationInViewController:self
                                                  title:@"Success"
                                               subtitle:message
                                                   type:TSMessageNotificationTypeMessage
                                               duration:TSMessageNotificationDurationAutomatic];

        } else if (error) {
            [TSMessage showNotificationInViewController:self
                                                  title:@"GRPC ERROR"
                                               subtitle:@"send_requestWithRequest"
                                                   type:TSMessageNotificationTypeError
                                               duration:TSMessageNotificationDurationEndless];
        }
    }];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0)
    {
        _searchBar.text = @"";
    }
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    if (searchString.length == 0) {
        return NO;
    }
    
    [_search_result_username removeAllObjects];
    [self.searchDisplayController.searchResultsTableView reloadData];
    [self obtain_search_result:searchString];
    return NO;
}

- (void)obtain_search_result:(NSString *)searchString {

    [_search_result_userId removeAllObjects];
    [_search_result_username removeAllObjects];
    [_search_result_userIcon removeAllObjects];
    NSString * const kRemoteHost = ServerHost;
    NSString *username = [_fileOperation getUsername];
    Inf *request = [[Inf alloc] init];
    request.information = searchString;
    
    // Example gRPC call using a generated proto client library:
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"/cacheFolder"];
    
    Greeter *service = [[Greeter alloc] initWithHost:kRemoteHost];
    [service search_usernameWithRequest:request handler:^(Search_result *response, NSError *error) {
        if (response) {
            for (int i = 0; i != response.usernameArray.count; i++) {
                if ([username isEqualToString:response.usernameArray[i]]) {
                    continue;
                }
                [_search_result_username addObject:response.usernameArray[i]];
                [_search_result_userId addObject:response.userIdArray[i]];
            }
            [self.searchDisplayController.searchResultsTableView reloadData];
            [self downloadUserIcon];

        } else if (error) {
            NSLog(@"Finished with error: %@", error);
            return;
        }
    }];
}

- (void)back_to_mainUI {
    [self dismissViewControllerAnimated:true completion:^{
        NSLog(@"Present Modal View");
    }];
    
    ViewController *mainUI = (ViewController *)_LeftMenuView.mainUIView;
    [mainUI hideMainUI];
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
