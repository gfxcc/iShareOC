//
//  AddFirstClassTypeViewController.h
//  iShare
//
//  Created by caoyong on 9/12/15.
//  Copyright (c) 2015 caoyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddFirstClassTypeViewController : UIViewController <UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UITextField *typeName;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) NSString *imageName;
@property (strong, nonatomic) UIViewController *typeEditerView;

@end
