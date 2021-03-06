//
//  AddNewSecondClassTypeViewController.h
//  iShare
//
//  Created by caoyong on 9/13/15.
//  Copyright (c) 2015 caoyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddNewSecondClassTypeViewController : UIViewController <UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UITextField *typeName;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) NSString *imageName;
@property (strong, nonatomic) UIViewController *firstClassTypeView;
@property (nonatomic) NSInteger indexOfFirstClassType;

@end
