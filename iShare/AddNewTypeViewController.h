//
//  AddNewTypeViewController.h
//  iShare
//
//  Created by caoyong on 9/12/15.
//  Copyright (c) 2015 caoyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddNewTypeViewController : UIViewController <UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UITextField *typeName;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end
