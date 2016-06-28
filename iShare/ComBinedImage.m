//
//  ComBinedImage.m
//  iShare
//
//  Created by caoyong on 6/17/16.
//  Copyright © 2016 caoyong. All rights reserved.
//

#import "ComBinedImage.h"

#define ImageDistance 2

@implementation ComBinedImage


- (id)initWithImageArray:(NSArray*)imageArray CGRect:(CGRect)rect {
    if (self = [super initWithFrame:rect]) {
        self.backgroundColor = [UIColor blueColor];
        if (imageArray.count == 0)
            return self;
        
        // calculate line
        int row, col;
        if (imageArray.count == 1) {
            row = 1;
            col = 1;
        } else if (imageArray.count == 2) {
            row = 1;
            col = 2;
        } else if (imageArray.count <= 4) {
            row = 2;
            col = 2;
        } else {
            row = 3;
            col = 3;
        }
        // calculate image size
        CGSize imageSize = CGSizeMake((rect.size.width - ImageDistance * (col + 1)) / col, (rect.size.width - ImageDistance * (col + 1)) / col);
        
        // create imageView
        for (int i = 0; i != imageArray.count; i++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(ImageDistance + (imageSize.width + ImageDistance) * (col - 1), ImageDistance + (imageSize.height + ImageDistance) * (row - 1), imageSize.width, imageSize.height)];
            imageView.image = imageArray[i];
            [self addSubview:imageView];
            // update row and col
            col--;
            if (col == 0) {
                row--;
                col = 3;
            }
        }
        
//        unsigned long row = imageArray.count / 3 + 1;
////        CGFloat width = (rect.size.width - ImageDistance * 4) / 3;
//        if (imageArray.count == 1) {
//            UIImageView *imageV1 = [[UIImageView alloc] initWithFrame:CGRectMake(ImageDistance, ImageDistance, rect.size.width - 2 * ImageDistance, rect.size.height - 2 * ImageDistance)];
//            imageV1.image = imageArray[0];
//            [self addSubview:imageV1];
//        } else if (imageArray.count == 2) {
//            CGFloat imageWidth = (rect.size.width - ImageDistance * 3) / 2;
//            UIImageView *imageV1 = [[UIImageView alloc] initWithFrame:CGRectMake(ImageDistance, (rect.size.height - imageWidth) / 2, imageWidth, (rect.size.width - ImageDistance * 3) / 2)];
//            UIImageView *imageV2 = [[UIImageView alloc] initWithFrame:CGRectMake(ImageDistance + imageWidth + ImageDistance, (rect.size.height - imageWidth) / 2, imageWidth, (rect.size.width - ImageDistance * 3) / 2)];
//            imageV1.image = imageArray[0];
//            imageV2.image = imageArray[1];
//            [self addSubview:imageV1];
//            [self addSubview:imageV2];
//                                                                                 
//        } else if (imageArray.count == 3) {
//            
//        } else if (row == 3){
//        
//        }
        
    }
    return self;
}

- (void)initWithImageArray:(NSArray*)imageArray {
    [self.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    if (imageArray.count == 0)
        return;
    CGRect rect = self.bounds;
    // calculate line
    int row, col;
    if (imageArray.count == 1) {
        row = 1;
        col = 1;
    } else if (imageArray.count == 2) {
        row = 1;
        col = 2;
    } else if (imageArray.count <= 4) {
        row = 2;
        col = 2;
    } else {
        row = 3;
        col = 3;
    }
    // calculate image size
    CGSize imageSize = CGSizeMake((rect.size.width - ImageDistance * (col + 1)) / col, (rect.size.width - ImageDistance * (col + 1)) / col);
    
    // create imageView
    int col_max = col, row_max = row;
    for (int i = 0; i != imageArray.count; i++) {
        UIImageView *imageView;
//        if (row_max == 1 && col_max == 2) {
//            imageView = [[UIImageView alloc] initWithFrame:CGRectMake(ImageDistance + (imageSize.width + ImageDistance) * (col - 1), (rect.size.height - imageSize.height) / 2, imageSize.width, imageSize.height)];
//        } else {
            imageView = [[UIImageView alloc] initWithFrame:CGRectMake(ImageDistance + (imageSize.width + ImageDistance) * (col - 1), ImageDistance + (imageSize.height + ImageDistance) * (row - 1), imageSize.width, imageSize.height)];
//        }
        imageView.image = imageArray[i];
        [self addSubview:imageView];
        // update row and col
        col--;
        if (col == 0) {
            row--;
            col = col_max;
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
