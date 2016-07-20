//
//  NewQuickTypeViewController.m
//  iShare
//
//  Created by yongcao on 7/15/16.
//  Copyright © 2016 caoyong. All rights reserved.
//

#import "NewQuickTypeViewController.h"

@interface NewQuickTypeViewController ()
@property (nonatomic, strong) FileOperation *fileOperation;
@end

@implementation NewQuickTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _fileOperation = [[FileOperation alloc] init];
    // Do any additional setup after loading the view.
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    
    _typeName.delegate =self;
    
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveType)];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:saveItem, nil];
    //[_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    
}


- (void)cellClick:(UITapGestureRecognizer *)sender{
    _iconImageView.image = [UIImage imageNamed:[self getImageNameWithTag:sender.view.tag]];
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
    if ([_typeName.text isEqualToString:@""]) {
        UIAlertView *updateAlert = [[UIAlertView alloc] initWithTitle:@"Waring" message:@"Enter type name please." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [updateAlert show];
        return;
    }
    
    [_fileOperation setQucikTypeWithName:_typeName.text TypeIcon:_imageName Index:_selectedIndex];
    
    [[self navigationController] popViewControllerAnimated:YES];
 //////
}

#pragma mark -
#pragma mark UICollectionView delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 213;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"collectionCell" forIndexPath:indexPath];
    //cell[cell initWithFrame:CGRectMake(0, 0, 50, 50)];
    for (UIView *subview in [cell.contentView subviews]) {
        [subview removeFromSuperview];
    }
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
    NSString *nameFile = @"ibus#idrink#ifood#ihome#ishopping#itrip#anchor#Apartment-icon#aperture#arrow-down#arrow-up#art#Bag-Present-icon#barchart#batteryfull#batterylow#Beach-icon#bike#biker#bikewheel#blimp#bolt#bomb#Bonsai-icon#booklet#bookshelf#briefcase#brightness#browser#brush-pencil#Bus-icon#calculator#calendar#camera#car#cart#carwheel#caution#chat#check#Cheese-icon#circlecompass#clapboard#clipboard#clock#cloud#cmyk#Coding-Html-icon#colorwheel#compass#compose#computer#cone#contacts#contrast#countdown#creditcard#crop#crossroads#cruise#cursor#denied#dev#die#document#dolly#door#Download-Computer-icon#download#easel#email#Euro-Coin-icon#eye#eyedropper#fashion#filmreel#filmroll#flag#flame#flash#flower#focus#folder#Food-Dome-icon#frames#gamecontroller#gas#gear#genius#global#globe#gps#Hat-icon#hazard#heart#helicopter#hotair#hourglass#image#interstate#key#keyboard#Laptop-Signal-icon#lens#lightbulb#loading#location#locked#magicwand#magnifyingglass#mail#map#megaphone#megaphone2#memorycard#merge#mic#microphone#Mind-Map-Paper-icon#Money-Increase-icon#money#motorcycle#music#news#Online-Shopping-icon#paintbrush#paintbrush2#paintcan#paintroller#Paper-Plane-icon#parachute#pencil#phone#pie-chart#pin#pin2#plane#play#plugin#polaroid#polaroidcamera#polaroids#power#present#profle#quote#racingflags#radio#radiotower#rainbow#Record-Player-icon#recycle#rgb#ribbon#roadblock#rocket#rulertriangle#running#sailboat#schooolbus#scissors#scooter#security#selftimer#settings#shipwheel#shoeprints#shop#skateboard#slr#smartphone#Sneakers-2-icon#spaceshuttle#speaker#speedometer#spraypaint#stack#star#steeringwheel#stop#sub#submarine#support#Surgeon-icon#swatches#T-Shirt-2-icon#tablet#takeoff#target#taxi#toolbox#tools#tractor#traffic#train#travelerbag#trends#tripod#trophy#truck#tv#typography#ufo#umbrella#unicycle#unlocked#upload#video#videocameraclassic#videocameracompact#volume#water#weather#windsock#windy#Wooden-Horse-icon#x#zoomin#zoomout";
    NSArray *imageName = [nameFile componentsSeparatedByString:@"#"];
    return imageName[tag];
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
