//
//  RequestTableViewCell.m
//  iShare
//
//  Created by caoyong on 8/10/15.
//  Copyright (c) 2015 caoyong. All rights reserved.
//

#import "RequestTableViewCell.h"

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

@implementation RequestTableViewCell

- (void)initWithIcon:(UIImage *)icon label:(NSString *)label {

    _label.text = label;
    _icon.image = icon;
    _confrimButton.layer.cornerRadius = 5.0f;
    _confrimButton.layer.masksToBounds = YES;
    _deleteButton.layer.cornerRadius = 5.0f;
    _deleteButton.layer.masksToBounds = YES;
    
    //[_confrimButton setImage:[UIImage imageNamed:@"Btn0.png"] forState:UIControlStateNormal];
    //[_confrimButton setImage:[self imageWithColor:RGB(170, 199, 255)] forState:UIControlStateSelected];
    
    //_confrimButton.backgroundColor = RGB(88, 144, 255);
    _deleteButton.layer.borderWidth = 1;
    _deleteButton.layer.borderColor = RGB(209, 209, 209).CGColor;

}

- (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


//- (void)awakeFromNib {
//    // Initialization code
//}
//
//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}

@end
