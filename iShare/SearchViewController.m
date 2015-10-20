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


#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

@interface SearchViewController ()

@property (strong, nonatomic) NSMutableArray* search_result;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
    
    _search_result = [[NSMutableArray alloc] init];
    self.navigationItem.title = @"Search";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
    return [_search_result count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CellIdentifier";
    
    // Dequeue or create a cell of the appropriate type.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    // Configure the cell.
    cell.textLabel.text = _search_result[indexPath.row];
    return cell;
}

- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {
    
    // check already be friend.
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fileName = [NSString stringWithFormat:@"%@/friends",
                          documentsDirectory];
    NSString *content = [[NSString alloc] initWithContentsOfFile:fileName
                                                    usedEncoding:nil
                                                           error:nil];
    NSArray *members = [content componentsSeparatedByString:@"\n"];
    
    for (int i = 0; i != members.count; i++) {
        if ([members[i] isEqualToString:_search_result[_selectedIndex]]) {
            [TSMessage showNotificationInViewController:self
                                                  title:@"Wrong"
                                               subtitle:@"You are already friend."
                                                   type:TSMessageNotificationTypeWarning
                                               duration:TSMessageNotificationDurationAutomatic];
            return;
        }
    }
    
    _selectedIndex = indexPath.row;
    _requestView = [[RequestView alloc] initWithTitle:[NSString stringWithFormat:@"I am %@", _LeftMenuView.idText.text] subtitle:@"t"];
    _requestView.delegate = self;
    [self.view addSubview:_requestView];
    [_requestView show];

}

#pragma mark - RequestViewDelegate -
- (void)sendRequest {
    
    

    // start grpc
    NSString * const kRemoteHost = ServerHost;
    Request *request = [Request message];
    request.sender = _LeftMenuView.idText.text;
    request.receiver = _search_result[_selectedIndex];
    request.type = @"friendInvite";
    
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
    
    [_search_result removeAllObjects];
    [self.searchDisplayController.searchResultsTableView reloadData];
    [self obtain_search_result:searchString];
    return NO;
}

- (void)obtain_search_result:(NSString *)searchString {

    NSString * const kRemoteHost = ServerHost;
    Inf *request = [[Inf alloc] init];
    request.information = searchString;
    
    // Example gRPC call using a generated proto client library:
    
    Greeter *service = [[Greeter alloc] initWithHost:kRemoteHost];
    [service search_usernameWithRequest:request handler:^(Repeated_string *response, NSError *error) {
        if (response) {
            for (int i = 0; i != response.contentArray.count; i++) {
                [_search_result addObject:response.contentArray[i]];
            }
            [self.searchDisplayController.searchResultsTableView reloadData];

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
