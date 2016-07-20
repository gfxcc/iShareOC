//
//  QuickTypeViewController.m
//  iShare
//
//  Created by caoyong on 1/23/16.
//  Copyright © 2016 caoyong. All rights reserved.
//

#import "QuickTypeViewController.h"
#import "QuickTypeCollectionViewCell.h"
#import "NewQuickTypeViewController.h"

@interface QuickTypeViewController ()

@property (nonatomic) CGFloat cellWidth;
@property (nonatomic, strong) FileOperation *fileOperation;
@property (nonatomic, strong) NSMutableArray *quickTypeList;
@property (nonatomic, weak) NSIndexPath *selectedIndex;
@end

@implementation QuickTypeViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _quickTypeList = [_fileOperation getQuickType];
    [_collectionView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _fileOperation = [[FileOperation alloc] init];
    
    _quickTypeList = [_fileOperation getQuickType];
    _cellWidth = ([UIScreen mainScreen].bounds.size.width - 80) / 3;
    
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    // Do any additional setup after loading the view.
}


#pragma mark -
#pragma mark UICollectionView delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 6;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    QuickTypeCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [cell initWithTypeIcon:_quickTypeList[indexPath.row][1] TypeName:_quickTypeList[indexPath.row][0]];
//    cell[cell initWithFrame:CGRectMake(0, 0, 50, 50)];
    
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
//    imageView.image = [UIImage imageNamed:[self getImageNameWithTag:indexPath.row]];
//    [cell addSubview:imageView];
//    
//    
//    UITapGestureRecognizer* myLabelGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellClick:)];
//    [cell setUserInteractionEnabled:YES];
//    cell.tag = indexPath.row;
//    [cell addGestureRecognizer:myLabelGesture1];
    //cell.layer.borderWidth = 0.5;
    //cell.backgroundColor = [UIColor blackColor];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

    QuickTypeCollectionViewCell *cell = (QuickTypeCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = RGB(211, 214, 219);
    
    _selectedIndex = indexPath;
    
    [self performSegueWithIdentifier:@"newQuickType" sender:self];
    cell.backgroundColor = [UIColor clearColor];

}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(_cellWidth, _cellWidth);
}
//
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(20, 20, 20, 20);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"newQuickType"]) {
        NewQuickTypeViewController *newQuickTypeView = (NewQuickTypeViewController *)[segue destinationViewController];
        newQuickTypeView.selectedIndex = _selectedIndex.row;
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
