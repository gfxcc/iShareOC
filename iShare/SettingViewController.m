//
//  SettingViewController.m
//  iShare
//
//  Created by caoyong on 1/23/16.
//  Copyright © 2016 caoyong. All rights reserved.
//

#import "SettingViewController.h"
#import "ViewController.h"
#import "NotificationViewController.h"
#import <TSMessageView.h>

#define Version @"Version 1.1.1";
#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

@interface SettingViewController ()

@property (strong, nonatomic) UITableViewCell *accountDetail;

@property (strong, nonatomic) UITableViewCell *notification;
@property (strong, nonatomic) UITableViewCell *quickType;
@property (strong, nonatomic) UITableViewCell *customView;

@property (strong, nonatomic) UITableViewCell *rateiShare;
@property (strong, nonatomic) UITableViewCell *contactDeveloper;


@end

@implementation SettingViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView deselectRowAtIndexPath:[_tableView indexPathForSelectedRow] animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];

    self.navigationController.navigationBar.barTintColor = RGB(26, 142, 180);
    [self.navigationController.navigationBar setTintColor:RGB(255, 255, 255)];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _accountDetail = [[UITableViewCell alloc]init];
    _notification = [[UITableViewCell alloc]init];
    _quickType = [[UITableViewCell alloc]init];;
    _customView = [[UITableViewCell alloc]init];
    _rateiShare = [[UITableViewCell alloc]init];
    _contactDeveloper = [[UITableViewCell alloc]init];
    
    _accountDetail.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    _notification.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    _quickType.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    _customView.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    _rateiShare.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    _contactDeveloper.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    _accountDetail.textLabel.text = @"Account detail";
    _notification.textLabel.text = @"Notification";
    _quickType.textLabel.text = @"Quick type";
    _customView.textLabel.text = @"Custom view";
    _rateiShare.textLabel.text = @"Rate iShare";
    _contactDeveloper.textLabel.text = @"Contact developer";
}

#pragma mark -
#pragma mark TableView delegate

// Return the number of sections

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    // If You have only one(1) section, return 1, otherwise you must handle sections
    return 4;
}

// Return the event when tap on the cell
- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0: return [self AccountSetting];

            }
        case 1:
            switch (indexPath.row) {
                case 0: return [self NotificationSetting];
                case 1: return [self QuickTypeSetting];
                case 2: return [self CustomViewSetting];
            }
        case 2:
            switch (indexPath.row) {
                case 0: return [self RateiShareView];
                case 1: return [self ContactDeveLoper];
            }
    }
}

// Return the row for the corresponding section and row
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch(indexPath.section)
    {
        case 0:
            switch(indexPath.row)
        {
            case 0: return self.accountDetail;  // section 0, row 0 is the first name
        }
        case 1:
            switch(indexPath.row)
        {
            case 0: return self.notification;      // section 1, row 0 is the share option
            case 1: return self.quickType;
            case 2: return self.customView;
        }
        case 2:
            switch(indexPath.row)
        {
            case 0: return self.rateiShare;
            case 1: return self.contactDeveloper;
        }
    }
    return nil;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    switch(section)
    {
        case 0:  return 1;  // section 0 has 2 rows
        case 1:  return 3;  // section 1 has 1 row
        case 2:  return 2;
        default: return 0;
    };
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch(section)
    {
        case 0: return @"Account";
        case 1: return @"General";
        case 2: return @"About";
        case 3: return Version;
    }
    return nil;
}

#pragma mark -
#pragma mark mail delegate

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error;
{
    if (result == MFMailComposeResultSent) {
        NSLog(@"It's away!");
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark reaction funcion to cell

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"notification"]) {
        NotificationViewController *notificationView = (NotificationViewController *)[segue destinationViewController];
        notificationView.username = _username;
    }

}

- (void)AccountSetting {
    [self performSegueWithIdentifier:@"accountDetail" sender:self];
}

- (void)NotificationSetting {
    [self performSegueWithIdentifier:@"notification" sender:self];
}

- (void)QuickTypeSetting {
    //[self performSegueWithIdentifier:@"quickType" sender:self];
    [TSMessage showNotificationInViewController:self
                                          title:@"Warning"
                                       subtitle:@"This function will release soon..."
                                           type:TSMessageNotificationTypeWarning
                                       duration:TSMessageNotificationDurationAutomatic];
    [_tableView deselectRowAtIndexPath:[_tableView indexPathForSelectedRow] animated:YES];
    
}

- (void)CustomViewSetting {
    //[self performSegueWithIdentifier:@"customView" sender:self];
    [TSMessage showNotificationInViewController:self
                                          title:@"Warning"
                                       subtitle:@"This function will release soon..."
                                           type:TSMessageNotificationTypeWarning
                                       duration:TSMessageNotificationDurationAutomatic];
    [_tableView deselectRowAtIndexPath:[_tableView indexPathForSelectedRow] animated:YES];
}

- (void)RateiShareView {
    NSString *appID = @"1040263153";
    NSString *str;
    float ver = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (ver >= 7.0 && ver < 7.1) {
        str = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@",appID];
    } else if (ver >= 8.0) {
        str = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=%@&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software",appID];
    } else {
        str = [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@",appID];
    }
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

- (void)ContactDeveLoper {
    MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
    controller.mailComposeDelegate = self;
    [controller setSubject:@"iShare Report"];
    [controller setToRecipients:[[NSArray alloc] initWithObjects:@"yong_stevens@outlook.com", nil]];
    //if (controller) [self presentModalViewController:controller animated:YES];
    if (controller) {
        [self presentViewController:controller animated:YES completion:nil];
    }
}



- (void)done {
    [self dismissViewControllerAnimated:true completion:^{
    }];
    ViewController *mainUI = (ViewController *)_mainUIView;
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
