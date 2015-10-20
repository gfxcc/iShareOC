//
//  AddSecondClassTypeViewController.m
//  iShare
//
//  Created by caoyong on 9/13/15.
//  Copyright (c) 2015 caoyong. All rights reserved.
//

#import "AddSecondClassTypeViewController.h"

@interface AddSecondClassTypeViewController ()

@end

@implementation AddSecondClassTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    
    _typeName.delegate = self;
    
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveType)];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:saveItem, nil];
    //[_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    
}


- (void)cellClick:(UITapGestureRecognizer *)sender{
    _icon.image = [UIImage imageNamed:[self getImageNameWithTag:sender.view.tag]];
    _imageName = [self getImageNameWithTag:sender.view.tag];
}

- (void)saveType {
    
    // check typename valide
    for (int i = 0; i != _typeName.text.length; i++) {
        if ([_typeName.text characterAtIndex:i] == '#' || [_typeName.text characterAtIndex:i] == '\n') {
            // invalid character
            UIAlertView *updateAlert = [[UIAlertView alloc] initWithTitle:@"Waring" message:@"The second class type name cannot contain '*' and '\n'." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            [updateAlert show];
            return;
            
        }
    }
    
    
    [self.navigationController popToViewController:_typeEditerView animated:YES];
    // save first class type;
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fileName = [NSString stringWithFormat:@"%@/billType",
                          documentsDirectory];
    NSString *content = [[NSString alloc] initWithContentsOfFile:fileName
                                                    usedEncoding:nil
                                                           error:nil];
    NSString *newType = [NSString stringWithFormat:@"%@#%@", _typeName.text, _imageName];
    content = [NSString stringWithFormat:@"%@#%@", content, newType];
    [content writeToFile:fileName
              atomically:NO
                encoding:NSUTF8StringEncoding
                   error:nil];
}

#pragma mark -
#pragma mark UICollectionView delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 35;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"collectionCell" forIndexPath:indexPath];
    //cell[cell initWithFrame:CGRectMake(0, 0, 50, 50)];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    imageView.image = [UIImage imageNamed:[self getImageNameWithTag:indexPath.row]];
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
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (NSString *)getImageNameWithTag:(NSInteger)tag {
    //UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    NSString *imageName;
    switch (tag) {
        case 0:
            imageName = @"ballet_shoes.png";
            break;
        case 1:
            imageName = @"Rent and Fee.png";
            break;
        case 2:
            imageName = @"barbell.png";
            break;
        case 3:
            imageName = @"bed.png";
            break;
        case 4:
            imageName = @"Food and Drind.png";
            break;
        case 5:
            imageName = @"bowler_hat.png";
            break;
        case 6:
            imageName = @"bread.png";
            break;
        case 7:
            imageName = @"bus.png";
            break;
        case 8:
            imageName = @"businesswoman.png";
            break;
        case 9:
            imageName = @"SuperMarket.png";
            break;
        case 10:
            imageName = @"carrot.png";
            break;
        case 11:
            imageName = @"clinic.png";
            break;
        case 12:
            imageName = @"cloakroom.png";
            break;
        case 13:
            imageName = @"clothes.png";
            break;
        case 14:
            imageName = @"cafe.png";
            break;
        case 15:
            imageName = @"game.png";
            break;
        case 16:
            imageName = @"cookies.png";
            break;
        case 17:
            imageName = @"house.png";
            break;
        case 18:
            imageName = @"Borrow and Lend.png";
            break;
        case 19:
            imageName = @"dog.png";
            break;
        case 20:
            imageName = @"PSEG.png";
            break;
        case 21:
            imageName = @"food.png";
            break;
        case 22:
            imageName = @"french_fries.png";
            break;
        case 23:
            imageName = @"gas_station.png";
            break;
        case 24:
            imageName = @"gift.png";
            break;
        case 25:
            imageName = @"hamburger.png";
            break;
        case 26:
            imageName = @"interstate_truck.png";
            break;
        case 27:
            imageName = @"kebab.png";
            break;
        case 28:
            imageName = @"milk_bottle.png";
            break;
        case 29:
            imageName = @"lend.png";
            break;
        case 30:
            imageName = @"package.png";
            break;
        case 31:
            imageName = @"park_and_charge.png";
            break;
        case 32:
            imageName = @"pen.png";
            break;
        case 33:
            imageName = @"pizza.png";
            break;
        case 34:
            imageName = @"price_tag_usd.png";
            break;
        case 35:
            imageName = @"sent.png";
            break;
        case 36:
            imageName = @"Shopping.png";
            break;
        case 37:
            imageName = @"soap.png";
            break;
        case 38:
            imageName = @"sofa.png";
            break;
        case 39:
            imageName = @"students.png";
            break;
        case 40:
            imageName = @"Car and Bus.png";
            break;
        case 41:
            imageName = @"traffic_light.png";
            break;
        case 42:
            imageName = @"truck.png";
            break;
        case 43:
            imageName = @"Entertament.png";
            break;
        case 44:
            imageName = @"water.png";
            break;
        case 45:
            imageName = @"network.png";
            break;
            
        default:
            break;
    }
    return imageName;
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
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
