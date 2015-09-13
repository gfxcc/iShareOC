//
//  SecondTypeViewController.m
//  iShare
//
//  Created by caoyong on 9/11/15.
//  Copyright (c) 2015 caoyong. All rights reserved.
//

#import "SecondTypeViewController.h"
#import "BillTypeTableViewCell.h"

@interface SecondTypeViewController ()

@end

@implementation SecondTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    // ##load data from file
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fileName = [NSString stringWithFormat:@"%@/billType",
                          documentsDirectory];
    NSString *content = [[NSString alloc] initWithContentsOfFile:fileName
                                                    usedEncoding:nil
                                                           error:nil];
    NSArray *linesOfFile= [content componentsSeparatedByString:@"\n"];
    
    // check empty or not
    NSArray *typeContent = [linesOfFile[_indexOfType] componentsSeparatedByString:@"#"];
    _typeArray = [[NSMutableArray alloc] initWithArray:typeContent];
    
}

- (IBAction)editButtonClick:(id)sender {
    
    if ([_editButton.titleLabel.text isEqualToString:@"Edit"]) {
        [UIView animateWithDuration:0.4 animations:^{
            _editButton.frame = CGRectMake(_editButton.frame.origin.x, _editButton.frame.origin.y, [UIScreen mainScreen].bounds.size.width, _editButton.frame.size.height);
        }];
        [_tableView setEditing: YES animated: YES];
        [_editButton setTitle:@"done" forState:UIControlStateNormal];
    } else if ([_editButton.titleLabel.text isEqualToString:@"done"]) {
        [UIView animateWithDuration:0.4 animations:^{
            _editButton.frame = CGRectMake(_editButton.frame.origin.x, _editButton.frame.origin.y, [UIScreen mainScreen].bounds.size.width / 2, _editButton.frame.size.height);
        }];
        [_tableView setEditing: NO animated: YES];
        [_editButton setTitle:@"Edit" forState:UIControlStateNormal];
        //[_tableView reloadData];
    }
}
#pragma mark -
#pragma mark TableView delegate

// Return the number of sections

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    // If You have only one(1) section, return 1, otherwise you must handle sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return (_typeArray.count / 2) - 1;
}

// Return the row for the corresponding section and row
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"billTypeCell";
    BillTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    [cell initWithIcon:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png", _typeArray[(indexPath.row + 1) * 2 + 1]]] typeName:_typeArray[(indexPath.row + 1) * 2]];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    //NSString *stringToMove = [self.reorderingRows objectAtIndex:sourceIndexPath.row];
    //[self.reorderingRows removeObjectAtIndex:sourceIndexPath.row];
    //[self.reorderingRows insertObject:stringToMove atIndex:destinationIndexPath.row];
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
