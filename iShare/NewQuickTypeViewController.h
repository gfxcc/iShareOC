//
//  NewQuickTypeViewController.h
//  iShare
//
//  Created by yongcao on 7/15/16.
//  Copyright © 2016 caoyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewQuickTypeViewController : UIViewController <UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UITextField *typeName;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) NSString *imageName;
@property (nonatomic) NSInteger selectedIndex;
@end
