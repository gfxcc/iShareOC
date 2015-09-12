//
//  AddNewTypeViewController.m
//  iShare
//
//  Created by caoyong on 9/12/15.
//  Copyright (c) 2015 caoyong. All rights reserved.
//

#import "AddNewTypeViewController.h"

@interface AddNewTypeViewController ()

@end

@implementation AddNewTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveType)];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:saveItem, nil];
    //[_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    
}


- (void)cellClick:(UITapGestureRecognizer *)sender{
    _icon.image = [self getImageWithTag:sender.view.tag];
}

- (void)saveType {
    
}

#pragma mark -
#pragma mark UICollectionView delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 35;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"collectionCell" forIndexPath:indexPath];
    //cell[cell initWithFrame:CGRectMake(0, 0, 50, 50)];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    imageView.image = [self getImageWithTag:indexPath.row];
    [cell addSubview:imageView];
    
    
    UITapGestureRecognizer* myLabelGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellClick:)];
    [cell setUserInteractionEnabled:YES];
    cell.tag = indexPath.row;
    [cell addGestureRecognizer:myLabelGesture1];
    //cell.layer.borderWidth = 0.5;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(50, 50);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(-50, 10, 10, 10);
}

- (UIImage *)getImageWithTag:(NSInteger)tag {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    switch (tag) {
        case 0:
            imageView.image = [UIImage imageNamed:@"ballet_shoes.png"];
            break;
        case 1:
            imageView.image = [UIImage imageNamed:@"Rent and Fee.png"];
            break;
        case 2:
            imageView.image = [UIImage imageNamed:@"barbell.png"];
            break;
        case 3:
            imageView.image = [UIImage imageNamed:@"bed.png"];
            break;
        case 4:
            imageView.image = [UIImage imageNamed:@"Food and Drind.png"];
            break;
        case 5:
            imageView.image = [UIImage imageNamed:@"bowler_hat.png"];
            break;
        case 6:
            imageView.image = [UIImage imageNamed:@"bread.png"];
            break;
        case 7:
            imageView.image = [UIImage imageNamed:@"bus.png"];
            break;
        case 8:
            imageView.image = [UIImage imageNamed:@"businesswoman.png"];
            break;
        case 9:
            imageView.image = [UIImage imageNamed:@"supermarket.png"];
            break;
        case 10:
            imageView.image = [UIImage imageNamed:@"carrot.png"];
            break;
        case 11:
            imageView.image = [UIImage imageNamed:@"clinic.png"];
            break;
        case 12:
            imageView.image = [UIImage imageNamed:@"cloakroom.png"];
            break;
        case 13:
            imageView.image = [UIImage imageNamed:@"clothes.png"];
            break;
        case 14:
            imageView.image = [UIImage imageNamed:@"cafe.png"];
            break;
        case 15:
            imageView.image = [UIImage imageNamed:@"game.png"];
            break;
        case 16:
            imageView.image = [UIImage imageNamed:@"cookies.png"];
            break;
        case 17:
            imageView.image = [UIImage imageNamed:@"house.png"];
            break;
        case 18:
            imageView.image = [UIImage imageNamed:@"Borrow and Lend.png"];
            break;
        case 19:
            imageView.image = [UIImage imageNamed:@"dog.png"];
            break;
        case 20:
            imageView.image = [UIImage imageNamed:@"PSEG.png"];
            break;
        case 21:
            imageView.image = [UIImage imageNamed:@"food.png"];
            break;
        case 22:
            imageView.image = [UIImage imageNamed:@"french_fries.png"];
            break;
        case 23:
            imageView.image = [UIImage imageNamed:@"gas_station.png"];
            break;
        case 24:
            imageView.image = [UIImage imageNamed:@"gift.png"];
            break;
        case 25:
            imageView.image = [UIImage imageNamed:@"hamburger.png"];
            break;
        case 26:
            imageView.image = [UIImage imageNamed:@"interstate_truck.png"];
            break;
        case 27:
            imageView.image = [UIImage imageNamed:@"kebab.png"];
            break;
        case 28:
            imageView.image = [UIImage imageNamed:@"milk_bottle.png"];
            break;
        case 29:
            imageView.image = [UIImage imageNamed:@"lend.png"];
            break;
        case 30:
            imageView.image = [UIImage imageNamed:@"package.png"];
            break;
        case 31:
            imageView.image = [UIImage imageNamed:@"park_and_charge.png"];
            break;
        case 32:
            imageView.image = [UIImage imageNamed:@"pen.png"];
            break;
        case 33:
            imageView.image = [UIImage imageNamed:@"pizza.png"];
            break;
        case 34:
            imageView.image = [UIImage imageNamed:@"price_tag_usd.png"];
            break;
        case 35:
            imageView.image = [UIImage imageNamed:@"sent.png"];
            break;
        case 36:
            imageView.image = [UIImage imageNamed:@"Shopping.png"];
            break;
        case 37:
            imageView.image = [UIImage imageNamed:@"soap.png"];
            break;
        case 38:
            imageView.image = [UIImage imageNamed:@"sofa.png"];
            break;
        case 39:
            imageView.image = [UIImage imageNamed:@"students.png"];
            break;
        case 40:
            imageView.image = [UIImage imageNamed:@"Car and Bus.png"];
            break;
        case 41:
            imageView.image = [UIImage imageNamed:@"traffic_light.png"];
            break;
        case 42:
            imageView.image = [UIImage imageNamed:@"truck.png"];
            break;
        case 43:
            imageView.image = [UIImage imageNamed:@"Entertament.png"];
            break;
        case 44:
            imageView.image = [UIImage imageNamed:@"water.png"];
            break;
        case 45:
            imageView.image = [UIImage imageNamed:@"network.png"];
            break;
            
        default:
            break;
    }
    return imageView.image;
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
