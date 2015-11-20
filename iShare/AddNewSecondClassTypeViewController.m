//
//  AddNewSecondClassTypeViewController.m
//  iShare
//
//  Created by caoyong on 9/13/15.
//  Copyright (c) 2015 caoyong. All rights reserved.
//

#import "AddNewSecondClassTypeViewController.h"

@interface AddNewSecondClassTypeViewController ()

@end

@implementation AddNewSecondClassTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    
    _typeName.delegate =self;
    
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
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fileName = [NSString stringWithFormat:@"%@/billType",
                          documentsDirectory];
    NSString *content = [[NSString alloc] initWithContentsOfFile:fileName
                                                    usedEncoding:nil
                                                           error:nil];
    NSMutableArray *linesOfFile = [[NSMutableArray alloc] initWithArray:[content componentsSeparatedByString:@"\n"]];
    
    // check type name duplicate
    NSArray *types = [linesOfFile[_indexOfFirstClassType] componentsSeparatedByString:@"#"];
    for (int i = 0; i < types.count; i += 2) {
        if ([types[i] isEqualToString:_typeName.text]) {
            UIAlertView *updateAlert = [[UIAlertView alloc] initWithTitle:@"Waring" message:@"The second class type name has been used. Please enter a new type name" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            [updateAlert show];
            return;
        }
    }
    
    [self.navigationController popToViewController:_firstClassTypeView animated:YES];
    
    // save second class type;
    NSString *newType = [NSString stringWithFormat:@"%@#%@", _typeName.text, _imageName];
    
    NSString *newline = [NSString stringWithFormat:@"%@#%@", linesOfFile[_indexOfFirstClassType], newType];
    
    [linesOfFile removeObjectAtIndex:_indexOfFirstClassType];
    [linesOfFile insertObject:newline atIndex:_indexOfFirstClassType];
    
    content = linesOfFile[0];
    for (int i = 1; i != linesOfFile.count; i++) {
        content = [NSString stringWithFormat:@"%@\n%@", content, linesOfFile[i]];
    }
    
    [content writeToFile:fileName
              atomically:NO
                encoding:NSUTF8StringEncoding
                   error:nil];
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
    NSString *nameFile = @"anchor.png#Apartment-icon.png#aperture.png#arrow-down.png#arrow-up.png#art.png#Bag-Present-icon.png#barchart.png#batteryfull.png#batterylow.png#Beach-icon.png#bike.png#biker.png#bikewheel.png#blimp.png#bolt.png#bomb.png#Bonsai-icon.png#booklet.png#bookshelf.png#briefcase.png#brightness.png#browser.png#brush-pencil.png#Bus-icon.png#calculator.png#calendar.png#camera.png#car.png#cart.png#carwheel.png#caution.png#chat.png#check.png#Cheese-icon.png#circlecompass.png#clapboard.png#clipboard.png#clock.png#cloud.png#cmyk.png#Coding-Html-icon.png#colorwheel.png#compass.png#compose.png#computer.png#cone.png#contacts.png#contrast.png#countdown.png#creditcard.png#crop.png#crossroads.png#cruise.png#cursor.png#denied.png#dev.png#die.png#document.png#dolly.png#door.png#Download-Computer-icon.png#download.png#easel.png#email.png#Euro-Coin-icon.png#eye.png#eyedropper.png#fashion.png#filmreel.png#filmroll.png#flag.png#flame.png#flash.png#flower.png#focus.png#folder.png#Food-Dome-icon.png#frames.png#gamecontroller.png#gas.png#gear.png#genius.png#global.png#globe.png#gps.png#Hat-icon.png#hazard.png#heart.png#helicopter.png#hotair.png#hourglass.png#image.png#interstate.png#key.png#keyboard.png#Laptop-Signal-icon.png#lens.png#lightbulb.png#loading.png#location.png#locked.png#magicwand.png#magnifyingglass.png#mail.png#map.png#megaphone.png#megaphone2.png#memorycard.png#merge.png#mic.png#microphone.png#Mind-Map-Paper-icon.png#Money-Increase-icon.png#money.png#motorcycle.png#music.png#news.png#Online-Shopping-icon.png#paintbrush.png#paintbrush2.png#paintcan.png#paintroller.png#Paper-Plane-icon.png#parachute.png#pencil.png#phone.png#pie-chart.png#pin.png#pin2.png#plane.png#play.png#plugin.png#polaroid.png#polaroidcamera.png#polaroids.png#power.png#present.png#profle.png#quote.png#racingflags.png#radio.png#radiotower.png#rainbow.png#Record-Player-icon.png#recycle.png#rgb.png#ribbon.png#roadblock.png#rocket.png#rulertriangle.png#running.png#sailboat.png#schooolbus.png#scissors.png#scooter.png#security.png#selftimer.png#settings.png#shipwheel.png#shoeprints.png#shop.png#skateboard.png#slr.png#smartphone.png#Sneakers-2-icon.png#spaceshuttle.png#speaker.png#speedometer.png#spraypaint.png#stack.png#star.png#steeringwheel.png#stop.png#sub.png#submarine.png#support.png#Surgeon-icon.png#swatches.png#T-Shirt-2-icon.png#tablet.png#takeoff.png#target.png#taxi.png#toolbox.png#tools.png#tractor.png#traffic.png#train.png#travelerbag.png#trends.png#tripod.png#trophy.png#truck.png#tv.png#typography.png#ufo.png#umbrella.png#unicycle.png#unlocked.png#upload.png#video.png#videocameraclassic.png#videocameracompact.png#volume.png#water.png#weather.png#windsock.png#windy.png#Wooden-Horse-icon.png#x.png#zoomin.png#zoomout.png";
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
