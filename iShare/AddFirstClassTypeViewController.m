//
//  AddFirstClassTypeViewController.m
//  iShare
//
//  Created by caoyong on 9/12/15.
//  Copyright (c) 2015 caoyong. All rights reserved.
//

#import "AddFirstClassTypeViewController.h"
#import "AddSecondClassTypeViewController.h"

@interface AddFirstClassTypeViewController ()

@end

@implementation AddFirstClassTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    
    _typeName.delegate = self;
    
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(nextToSecondClassType)];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:saveItem, nil];
    //[_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    
}


- (void)cellClick:(UITapGestureRecognizer *)sender{
    _icon.image = [UIImage imageNamed:[self getImageNameWithTag:sender.view.tag]];
    _imageName = [self getImageNameWithTag:sender.view.tag];
}

- (void)nextToSecondClassType {
    
    // check typename valide
    for (int i = 0; i != _typeName.text.length; i++) {
        if ([_typeName.text characterAtIndex:i] == '#' || [_typeName.text characterAtIndex:i] == '\n') {
            // invalid character
            UIAlertView *updateAlert = [[UIAlertView alloc] initWithTitle:@"Waring" message:@"The second class type name cannot contain '*' and '\n'." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            [updateAlert show];
            return;
            
        }
    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fileName = [NSString stringWithFormat:@"%@/billType",
                          documentsDirectory];
    NSString *content = [[NSString alloc] initWithContentsOfFile:fileName
                                                    usedEncoding:nil
                                                           error:nil];
    NSArray *linesOfFile = [content componentsSeparatedByString:@"\n"];
    for (int i = 0; i != linesOfFile.count; i++) {
        NSArray *types = [linesOfFile[i] componentsSeparatedByString:@"#"];
        if ([types[0] isEqualToString:_typeName.text]) {
            UIAlertView *updateAlert = [[UIAlertView alloc] initWithTitle:@"Waring" message:@"The first class type name has been used. Please enter a new type name" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            [updateAlert show];
            return;
        }
    }
    
    
    [self performSegueWithIdentifier:@"createSecondClassType" sender:self];
    
    // save first class type;
    
    NSString *newType = [NSString stringWithFormat:@"%@#%@", _typeName.text, _imageName];
    content = [NSString stringWithFormat:@"%@\n%@", content, newType];
    
    [content writeToFile:fileName
              atomically:NO
                encoding:NSUTF8StringEncoding
                   error:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"createSecondClassType"]) {
        AddSecondClassTypeViewController *addSecondTypeView = (AddSecondClassTypeViewController *)[segue destinationViewController];
        addSecondTypeView.typeEditerView = _typeEditerView;
        addSecondTypeView.navigationItem.title = @"Create second class type";
    }

}

#pragma mark -
#pragma mark UICollectionView delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
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
    [cell.contentView addSubview:imageView];
    
    
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
