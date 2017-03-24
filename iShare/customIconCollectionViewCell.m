//
//  CustomIconCollectionViewCell.m
//  iShare
//
//  Created by caoyong on 9/11/15.
//  Copyright (c) 2015 caoyong. All rights reserved.
//

#import "CustomIconCollectionViewCell.h"

@implementation CustomIconCollectionViewCell

@synthesize imageView;

- (id)initWithFrame:(CGRect)aRect
{
    self = [super initWithFrame:aRect];
    {
        //we create the UIImageView in this overwritten init so that we always have it at hand.
        self.imageView = [[UIImageView alloc] initWithFrame:aRect];
        //set specs and special wants for the imageView here.
        [self addSubview:imageView]; //the only place we want to do this addSubview: is here!
        
    }
    return self;
}

@end
