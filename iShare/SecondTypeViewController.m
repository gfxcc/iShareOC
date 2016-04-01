//
//  SecondTypeViewController.m
//  iShare
//
//  Created by caoyong on 9/11/15.
//  Copyright (c) 2015 caoyong. All rights reserved.
//

#import "SecondTypeViewController.h"
#import "BillTypeTableViewCell.h"
#import "AddNewSecondClassTypeViewController.h"
#import "FileOperation.h"

@interface SecondTypeViewController ()
@property (nonatomic, strong) FileOperation *fileOperation;
@end

@implementation SecondTypeViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadType];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _fileOperation = [[FileOperation alloc] init];
    
    //self.tableView.allowsMultipleSelectionDuringEditing = NO;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
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
    // !!!! this array contain all element of a type. The really count of second type should be (_typeArray.count / 2) - 1
    _typeArray = [[NSMutableArray alloc] initWithArray:typeContent];
    
}

- (void)reloadType {

    NSString *content = [_fileOperation getFileContent:@"billType"];
    NSArray *linesOfFile= [content componentsSeparatedByString:@"\n"];
    
    // check empty or not
    NSArray *typeContent = [linesOfFile[_indexOfType] componentsSeparatedByString:@"#"];
    // !!!! this array contain all element of a type. The really count of second type should be (_typeArray.count / 2) - 1
    _typeArray = [[NSMutableArray alloc] initWithArray:typeContent];
    [_tableView reloadData];
}

- (IBAction)editButtonClick:(id)sender {
    
    if ([_editButton.titleLabel.text isEqualToString:@"Edit"]) {
        [UIView animateWithDuration:0.3 animations:^{
            _editButton.frame = CGRectMake(_editButton.frame.origin.x, _editButton.frame.origin.y, [UIScreen mainScreen].bounds.size.width, _editButton.frame.size.height);
        }];
        [_tableView setEditing: YES animated: YES];
        [_editButton setTitle:@"done" forState:UIControlStateNormal];
    } else if ([_editButton.titleLabel.text isEqualToString:@"done"]) {
        [UIView animateWithDuration:0.3 animations:^{
            _editButton.frame = CGRectMake(_editButton.frame.origin.x, _editButton.frame.origin.y, [UIScreen mainScreen].bounds.size.width / 2, _editButton.frame.size.height);
        }];
        [_tableView setEditing: NO animated: YES];
        [_editButton setTitle:@"Edit" forState:UIControlStateNormal];
        //[_tableView reloadData];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"createNewSecondClassType"]) {
        AddNewSecondClassTypeViewController *addSecondTypeView = (AddNewSecondClassTypeViewController *)[segue destinationViewController];
        //addSecondTypeView.typeEditerView = _typeEditerView;
        addSecondTypeView.navigationItem.title = @"Create second class type";
        addSecondTypeView.indexOfFirstClassType = _indexOfType;
        addSecondTypeView.firstClassTypeView = self;
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
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fileName = [NSString stringWithFormat:@"%@/billType",
                          documentsDirectory];
    NSString *content = [[NSString alloc] initWithContentsOfFile:fileName
                                                    usedEncoding:nil
                                                           error:nil];
    NSMutableArray *linesOfFile= [[NSMutableArray alloc] initWithArray:[content componentsSeparatedByString:@"\n"]];
    NSMutableArray *types = [[NSMutableArray alloc] initWithArray:[linesOfFile[_indexOfType] componentsSeparatedByString:@"#"]];
    NSMutableArray *newOrderType = [[NSMutableArray alloc] initWithArray:types];
    
    NSString *typeName = newOrderType[(sourceIndexPath.row + 1) * 2];
    NSString *iconName = newOrderType[(sourceIndexPath.row + 1) * 2 + 1];
    
    [newOrderType removeObjectAtIndex:(sourceIndexPath.row + 1) * 2];
    [newOrderType removeObjectAtIndex:(sourceIndexPath.row + 1) * 2];
    
    [newOrderType insertObject:iconName atIndex:(destinationIndexPath.row + 1) * 2];
    [newOrderType insertObject:typeName atIndex:(destinationIndexPath.row + 1) * 2];
    
    // save to file
    NSString *newTypeLine = newOrderType[0];
    for (int i = 1; i != newOrderType.count; i++) {
        newTypeLine = [NSString stringWithFormat:@"%@#%@", newTypeLine, newOrderType[i]];
    }
    
    // change lines
    [linesOfFile removeObjectAtIndex:_indexOfType];
    [linesOfFile insertObject:newTypeLine atIndex:_indexOfType];
    
    content = linesOfFile[0];
    for (int i = 1; i != linesOfFile.count; i++) {
        content = [NSString stringWithFormat:@"%@\n%@", content, linesOfFile[i]];
    }
    
    [content writeToFile:fileName
              atomically:NO
                encoding:NSUTF8StringEncoding
                   error:nil];
    
    
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        // check type count
        if (_typeArray.count <= 4) { // first class name# first class icon name# 1.name# 1.icon name
            UIAlertView *updateAlert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"You need have at least 1 second class type" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [updateAlert show];
            return;
        }
        
        NSString *content = [_fileOperation getFileContent:@"billType"];
        NSMutableArray *linesOfFile= [[NSMutableArray alloc] initWithArray:[content componentsSeparatedByString:@"\n"]];
        NSArray *typeContent = [linesOfFile[_indexOfType] componentsSeparatedByString:@"#"];
        //_typeArray = [[NSMutableArray alloc] initWithArray:typeContent];
        
        NSMutableArray *types = [[NSMutableArray alloc] initWithArray:typeContent];
        [types removeObjectAtIndex:(indexPath.row + 1) * 2]; // remove name
        [types removeObjectAtIndex:(indexPath.row + 1) * 2]; // remove icon name
        
        // get new line
        NSString *newLine = types[0];
        for (int i = 1; i != types.count; i++) {
            newLine = [NSString stringWithFormat:@"%@#%@", newLine, types[i]];
        }
        
        [linesOfFile removeObjectAtIndex:_indexOfType];
        [linesOfFile insertObject:newLine atIndex:_indexOfType];
        
        // get new content
        content = linesOfFile[0];
        for (int i = 1; i != linesOfFile.count; i++) {
            content = [NSString stringWithFormat:@"%@\n%@", content, linesOfFile[i]];
        }
        [_fileOperation setFileContent:content filename:@"billType"];
        
        [_typeArray removeObjectAtIndex:(indexPath.row + 1) * 2]; // remove name
        [_typeArray removeObjectAtIndex:(indexPath.row + 1) * 2]; // remove icon name
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
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
