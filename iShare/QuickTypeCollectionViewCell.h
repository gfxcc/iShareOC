//
//  QuickTypeCollectionViewCell.h
//  iShare
//
//  Created by yongcao on 7/15/16.
//  Copyright © 2016 caoyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuickTypeCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *iconName;

- (void)initWithTypeIcon:(NSString*)icon TypeName:(NSString*)typeName;

@end
