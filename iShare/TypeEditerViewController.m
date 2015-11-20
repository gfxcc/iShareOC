//
//  TypeEditerViewController.m
//  iShare
//
//  Created by caoyong on 9/10/15.
//  Copyright (c) 2015 caoyong. All rights reserved.
//

#import "TypeEditerViewController.h"
#import "BillTypeTableViewCell.h"
#import "SecondTypeViewController.h"
#import "AddFirstClassTypeViewController.h"

@interface TypeEditerViewController ()

@end

@implementation TypeEditerViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView deselectRowAtIndexPath:[_tableView indexPathForSelectedRow] animated:YES];
    [self reloadType];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fileName = [NSString stringWithFormat:@"%@/billType",
                documentsDirectory];
    NSString *content = [[NSString alloc] initWithContentsOfFile:fileName
                                          usedEncoding:nil
                                                 error:nil];
    NSArray *linesOfFile= [content componentsSeparatedByString:@"\n"];
    
    // check empty or not
    _typeArray = [[NSMutableArray alloc] init];
    for (int i = 0; i != linesOfFile.count; i++) {
        NSString *stringOfLine = linesOfFile[i];
        NSMutableArray *contentOfLine = [[NSMutableArray alloc] initWithArray:[stringOfLine componentsSeparatedByString:@"#"]];
        [_typeArray addObject:contentOfLine];
        
    }
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

- (void)reloadType {
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fileName = [NSString stringWithFormat:@"%@/billType",
                          documentsDirectory];
    NSString *content = [[NSString alloc] initWithContentsOfFile:fileName
                                                    usedEncoding:nil
                                                           error:nil];
    NSArray *linesOfFile= [content componentsSeparatedByString:@"\n"];
    
    // check empty or not
    _typeArray = [[NSMutableArray alloc] init];
    for (int i = 0; i != linesOfFile.count; i++) {
        NSString *stringOfLine = linesOfFile[i];
        NSMutableArray *contentOfLine = [[NSMutableArray alloc] initWithArray:[stringOfLine componentsSeparatedByString:@"#"]];
        [_typeArray addObject:contentOfLine];
        
    }
    [_tableView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"secondClassType"]) {
        SecondTypeViewController *secondTypeView = (SecondTypeViewController *)[segue destinationViewController];
        NSIndexPath *selectedRowPath = [_tableView indexPathForSelectedRow];
        secondTypeView.indexOfType = selectedRowPath.row;
        
        // set navigation title
        //NSMutableArray
        secondTypeView.navigationItem.title = [_typeArray[selectedRowPath.row] objectAtIndex:0];
    } else if ([segue.identifier isEqualToString:@"createFirstClassType"]) {
        AddFirstClassTypeViewController *addTypeView = (AddFirstClassTypeViewController *)[segue destinationViewController];

        addTypeView.typeEditerView = self;
        addTypeView.navigationItem.title = @"Create first class type";
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
    return _typeArray.count;
}

// Return the row for the corresponding section and row
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"billTypeCell";
    BillTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    NSMutableArray *type = _typeArray[indexPath.row];
    
    [cell initWithIcon:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png", type[1]]] typeName:type[0]];
    
    NSLog(@"%f  %f", cell.icon.frame.size.width, cell.icon.frame.size.height);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"secondClassType" sender:self];
    
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    
    NSLog(@"%ld   %ld",(long)sourceIndexPath.row, (long)destinationIndexPath.row);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fileName = [NSString stringWithFormat:@"%@/billType",
                          documentsDirectory];
    NSString *content = [[NSString alloc] initWithContentsOfFile:fileName
                                                    usedEncoding:nil
                                                           error:nil];
    NSArray *linesOfFile= [content componentsSeparatedByString:@"\n"];
    
    
    NSMutableArray *newOrderType = [[NSMutableArray alloc] initWithArray:linesOfFile];
    /*
    // just mode 1-3 or 3-1
    if (sourceIndexPath.row > destinationIndexPath.row) { // 3-1 mode
        // load first part (does not involved)
        for (int i = 0; i != destinationIndexPath.row; i++) {
            [newOrderType addObject:linesOfFile[i]];
        }
        
        // load second part (moved part)
        [newOrderType addObject:linesOfFile[sourceIndexPath.row]];
        for (int i = (int)destinationIndexPath.row; i != sourceIndexPath.row; i++) {
            [newOrderType addObject:linesOfFile[i]];
        }
        
        // load third part (does not involved)
        for (int i = (int)sourceIndexPath.row + 1; i != linesOfFile.count; i++) {
            [newOrderType addObject:linesOfFile[i]];
        }
    } else {                                              // 1-3 mode
        for (int i = 0; i != sourceIndexPath.row; i++) {
            [newOrderType addObject:linesOfFile[i]];
        }
        
        for (int i = (int)sourceIndexPath.row + 1; i != (int)destinationIndexPath.row + 1; i++) {
            [newOrderType addObject:linesOfFile[i]];
        }
        [newOrderType addObject:linesOfFile[sourceIndexPath.row]];
        
        for (int i = (int)destinationIndexPath.row + 1; i != linesOfFile.count; i++) {
            [newOrderType addObject:linesOfFile[i]];
        }
    }
    */
    
    NSString *movedLine = linesOfFile[sourceIndexPath.row];
    [newOrderType removeObjectAtIndex:sourceIndexPath.row];
    [newOrderType insertObject:movedLine atIndex:destinationIndexPath.row];
    
    
    // save to file
    content = newOrderType[0];
    for (int i = 1; i != newOrderType.count; i++) {
        content = [NSString stringWithFormat:@"%@\n%@", content, newOrderType[i]];
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
        //[_chats removeObjectAtIndex:indexPath.row];
        NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *fileName = [NSString stringWithFormat:@"%@/billType",
                              documentsDirectory];
        NSString *content = [[NSString alloc] initWithContentsOfFile:fileName
                                                        usedEncoding:nil
                                                               error:nil];
        NSArray *linesOfFile= [content componentsSeparatedByString:@"\n"];
        NSMutableArray *types = [[NSMutableArray alloc] initWithArray:linesOfFile];
        
        // check count of first class type. At least 3
        if (types.count <= 3) {
            UIAlertView *updateAlert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"You need have at least 3 first class type" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [updateAlert show];
            return;
        }
        
        [types removeObjectAtIndex:indexPath.row];
        content = types[0];
        for (int i = 1; i != types.count; i++) {
            content = [NSString stringWithFormat:@"%@\n%@", content, types[i]];
        }
        [content writeToFile:fileName
                  atomically:NO
                    encoding:NSUTF8StringEncoding
                       error:nil];
        // delete from view
        [_typeArray removeObjectAtIndex:indexPath.row];
        
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
