//
//  NotificationViewController.m
//  iShare
//
//  Created by caoyong on 1/23/16.
//  Copyright © 2016 caoyong. All rights reserved.
//

#import "NotificationViewController.h"
#import <JDStatusBarNotification/JDStatusBarNotification.h>
#import <gRPC_pod/IShare.pbrpc.h>
#import <gRPC_pod/IShare.pbobjc.h>
#import "FileOperation.h"

@interface NotificationViewController ()

@property (strong, nonatomic) UITableViewCell *friendInvite;

@property (strong, nonatomic) UITableViewCell *receiveBill;
@property (strong, nonatomic) UITableViewCell *editDeleteBill;
@property (strong, nonatomic) UITableViewCell *commentBill;

@property (strong, nonatomic) UITableViewCell *paidNotice;

@property (nonatomic) BOOL changed;

@property (nonatomic, strong) FileOperation *fileOperation;
@end

@implementation NotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _fileOperation = [[FileOperation alloc] init];
    _changed = NO;
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _tableView.allowsSelection = NO;
    
    _friendInvite = [[UITableViewCell alloc]init];
    _receiveBill = [[UITableViewCell alloc]init];
    _editDeleteBill = [[UITableViewCell alloc]init];;
    _commentBill = [[UITableViewCell alloc]init];
    _paidNotice = [[UITableViewCell alloc]init];
    
    _friendInvite.textLabel.text = @"when someone adds me as a friend";
    _receiveBill.textLabel.text = @"when a bill is created";
    _editDeleteBill.textLabel.text = @"when a bill edited/deleted";
    _commentBill.textLabel.text = @"when someone comments on a bill";
    _paidNotice.textLabel.text = @"when someone paid me";

    UISwitch *switchview0 = [[UISwitch alloc] initWithFrame:CGRectZero];
    UISwitch *switchview1 = [[UISwitch alloc] initWithFrame:CGRectZero];
    UISwitch *switchview2 = [[UISwitch alloc] initWithFrame:CGRectZero];
    UISwitch *switchview3 = [[UISwitch alloc] initWithFrame:CGRectZero];
    UISwitch *switchview4 = [[UISwitch alloc] initWithFrame:CGRectZero];
    switchview0.tag = 0;
    switchview1.tag = 1;
    switchview2.tag = 2;
    switchview3.tag = 3;
    switchview4.tag = 4;
    
    [switchview0 addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventValueChanged];
    [switchview1 addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventValueChanged];
    [switchview2 addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventValueChanged];
    [switchview3 addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventValueChanged];
    [switchview4 addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventValueChanged];
    
    _friendInvite.accessoryView = switchview0;
    _receiveBill.accessoryView = switchview1;
    _editDeleteBill.accessoryView = switchview2;
    _commentBill.accessoryView = switchview3;
    _paidNotice.accessoryView = switchview4;
    
    [self loadSetting];
    
}

-(void) viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        
        if (_changed) {
            [self uploadSetting];
        }
    }
    [super viewWillDisappear:animated];
}

- (void)loadSetting {
    NSString * const kRemoteHost = ServerHost;
    
    Inf *request = [[Inf alloc] init];
    request.information = [_fileOperation getUserId];
    
    if ([request.information isEqualToString:@""]) {
        return;
    }
    
    Greeter *service = [[Greeter alloc] initWithHost:kRemoteHost];
    [service obtain_settingWithRequest:request handler:^(Setting *response, NSError *error) {
        if (response) {
            if (response.friendInvite) {
                UISwitch *s1 = (UISwitch*)_friendInvite.accessoryView;
                [s1 setOn:YES];
            }
            if (response.newBill) {
                UISwitch *s1 = (UISwitch*)_receiveBill.accessoryView;
                [s1 setOn:YES];
            }
            if (response.editedDeleteBill) {
                UISwitch *s1 = (UISwitch*)_editDeleteBill.accessoryView;
                [s1 setOn:YES];
            }
            if (response.commentBill) {
                UISwitch *s1 = (UISwitch*)_commentBill.accessoryView;
                [s1 setOn:YES];
            }
            if (response.paidNotice) {
                UISwitch *s1 = (UISwitch*)_paidNotice.accessoryView;
                [s1 setOn:YES];
            }
            [JDStatusBarNotification showWithStatus:@"load setting success" dismissAfter:2.0];
        } else if (error) {
            //NSLog(@"Finished with error: %@", error);
            return;
        }
    }];

    
}

- (void)uploadSetting {
    
    NSString * const kRemoteHost = ServerHost;
    Setting *request = [[Setting alloc] init];
    
    request.userId = [_fileOperation getUserId];
    request.friendInvite = [(UISwitch*)_friendInvite.accessoryView isOn] ? 1 : 0;
    request.newBill = [(UISwitch*)_receiveBill.accessoryView isOn] ? 1 : 0;
    request.editedDeleteBill = [(UISwitch*)_editDeleteBill.accessoryView isOn] ? 1 : 0;
    request.commentBill = [(UISwitch*)_commentBill.accessoryView isOn] ? 1 : 0;
    request.paidNotice = [(UISwitch*)_paidNotice.accessoryView isOn] ? 1 : 0;
    
    Greeter *service = [[Greeter alloc] initWithHost:kRemoteHost];
    [service reset_settingWithRequest:request handler:^(Inf *response, NSError *error) {
        if (response) {
            [JDStatusBarNotification showWithStatus:@"upload setting success" dismissAfter:2.0];
        } else if (error) {

            return;
        }
    }];
}

- (void)changeSwitch:(id)sender{
    if([sender isOn]){
        NSLog(@"Switch is ON");
    } else{
        NSLog(@"Switch is OFF");
    }
    _changed = YES;
}

#pragma mark -
#pragma mark TableView delegate

// Return the number of sections

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    // If You have only one(1) section, return 1, otherwise you must handle sections
    return 3;
}

// Return the row for the corresponding section and row
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch(indexPath.section)
    {
        case 0:
            switch(indexPath.row)
        {
            case 0: return self.friendInvite;  // section 0, row 0 is the first name
        }
        case 1:
            switch(indexPath.row)
        {
            case 0: return self.receiveBill;      // section 1, row 0 is the share option
            case 1: return self.editDeleteBill;
            case 2: return self.commentBill;
        }
        case 2:
            switch(indexPath.row)
        {
            case 0: return self.paidNotice;
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
        case 2:  return 1;
        default: return 0;
    };
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch(section)
    {
        case 0: return @"Invite";
        case 1: return @"Bill";
        case 2: return @"Activity";
    }
    return nil;
}



//- (void)readSettingFromFile {
//    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    
//    //make a file name to write the data to using the documents directory:
//    NSString *fileName = [NSString stringWithFormat:@"%@/settingRecord",
//                          documentsDirectory];
//    NSString *exist = [[NSString alloc] initWithContentsOfFile:fileName
//                                                  usedEncoding:nil
//                                                         error:nil];
//    if (!exist) {
//        NSString *defaultSetting = @"ACCOUNTDETAIL\nNOTIFICATION 1 1 1 1 1\nQUICKTYPE\nCUSTOMVIEW";
//        [defaultSetting writeToFile:fileName
//                         atomically:NO
//                           encoding:NSUTF8StringEncoding
//                              error:nil];
//        exist = defaultSetting;
//    }
//    
//    
//    NSArray *set = [exist componentsSeparatedByString:@"\n"];
//    /*
//     *  each line represent one setting order by
//     *
//     *  ACCOUNTDETAIL
//     *  NOTIFICATION 1 1 1 1 1
//     *  QUICKTYPE
//     *  CUSTOMVIEW
//     */
//    NSMutableArray *settingRecord = [[NSMutableArray alloc] init];
//    for (int i = 0; i != set.count; i++) {
//        NSArray *line = [set[i] componentsSeparatedByString:@" "];
//        [settingRecord addObject:line];
//    }
//    
//    /* set switch */
//    for (int i = 0; i != settingRecord.count; i++) {
//        if ([settingRecord[i][0] isEqualToString:@"NOTIFICATION"]) {
//            if ([settingRecord[i][1] isEqualToString:@"1"]) {
//                [switchview0 setOn:YES];
//            } else {
//                [switchview0 setOn:NO];
//            }
//            if ([settingRecord[i][2] isEqualToString:@"1"]) {
//                [switchview1 setOn:YES];
//            } else {
//                [switchview1 setOn:NO];
//            }
//            if ([settingRecord[i][3] isEqualToString:@"1"]) {
//                [switchview2 setOn:YES];
//            } else {
//                [switchview2 setOn:NO];
//            }
//            if ([settingRecord[i][4] isEqualToString:@"1"]) {
//                [switchview3 setOn:YES];
//            } else {
//                [switchview3 setOn:NO];
//            }
//            if ([settingRecord[i][5] isEqualToString:@"1"]) {
//                [switchview4 setOn:YES];
//            } else {
//                [switchview4 setOn:NO];
//            }
//        }
//    }
//}



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
