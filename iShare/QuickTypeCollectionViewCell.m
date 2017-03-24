//
//  QuickTypeCollectionViewCell.m
//  iShare
//
//  Created by yongcao on 7/15/16.
//  Copyright © 2016 caoyong. All rights reserved.
//

#import "QuickTypeCollectionViewCell.h"

@implementation QuickTypeCollectionViewCell

- (void)initWithTypeIcon:(NSString*)icon TypeName:(NSString*)typeName {
    _iconImageView.image = [UIImage imageNamed:icon];
    _iconName.text = typeName;
}

@end
