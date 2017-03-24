//
//  ComBinedImage.h
//  iShare
//
//  Created by caoyong on 6/17/16.
//  Copyright © 2016 caoyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ComBinedImage : UIView

@property (strong, nonatomic) NSArray* imageArray;

- (id)initWithImageArray:(NSArray*)imageArray CGRect:(CGRect)rect;
- (void)initWithImageArray:(NSArray*)imageArray;

@end
