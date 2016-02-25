//
//  IntroView.m
//  DrawPad
//
//  Created by Adam Cooper on 2/4/15.
//  Copyright (c) 2015 Adam Cooper. All rights reserved.
//

#import "ABCIntroView.h"

@interface ABCIntroView () <UIScrollViewDelegate>
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIPageControl *pageControl;
@property (strong, nonatomic) UIButton *doneButton;

@property (strong, nonatomic) UIView *viewOne;
@property (strong, nonatomic) UIView *viewTwo;
@property (strong, nonatomic) UIView *viewThree;
@property (strong, nonatomic) UIView *viewFour;
@property (strong, nonatomic) UIView *viewFive;
@property (strong, nonatomic) UIView *viewSix;


@end

@implementation ABCIntroView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        
        UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:self.frame];
        backgroundImageView.image = [UIImage imageNamed:@"Intro_Screen_Background.png"];
        [self addSubview:backgroundImageView];
        
        [self addSubview:self.scrollView];
        [self addSubview:self.pageControl];
    
        [self.scrollView addSubview:self.viewOne];
        [self.scrollView addSubview:self.viewTwo];
        [self.scrollView addSubview:self.viewThree];
        [self.scrollView addSubview:self.viewFour];
        [self.scrollView addSubview:self.viewFive];
        [self.scrollView addSubview:self.viewSix];
        
        
        //Done Button
        [self addSubview:self.doneButton];
            

    }
    return self;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat pageWidth = CGRectGetWidth(self.bounds);
    CGFloat pageFraction = self.scrollView.contentOffset.x / pageWidth;
    self.pageControl.currentPage = roundf(pageFraction);
    
}

-(UIView *)viewOne {
    if (!_viewOne) {
    
        _viewOne = [[UIView alloc] initWithFrame:self.frame];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height*.05, self.frame.size.width*.8, 60)];
        titleLabel.center = CGPointMake(self.center.x, self.frame.size.height*.1);
        titleLabel.text = [NSString stringWithFormat:@"New Interface"];
        titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:35.0];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.textAlignment =  NSTextAlignmentCenter;
        titleLabel.numberOfLines = 0;
        [_viewOne addSubview:titleLabel];
        
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width*.2, self.frame.size.height*.15, self.frame.size.width*.6, self.frame.size.height*.6)];
        imageview.contentMode = UIViewContentModeScaleAspectFit;
        imageview.image = [UIImage imageNamed:@"introduce1.jpg"];
        [_viewOne addSubview:imageview];
        
//        UILabel *descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width*.1, self.frame.size.height*.7, self.frame.size.width*.8, 60)];
//        descriptionLabel.text = [NSString stringWithFormat:@"Description for First Screen."];
//        descriptionLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:18.0];
//        descriptionLabel.textColor = [UIColor whiteColor];
//        descriptionLabel.textAlignment =  NSTextAlignmentCenter;
//        descriptionLabel.numberOfLines = 0;
//        [descriptionLabel sizeToFit];
//        [_viewOne addSubview:descriptionLabel];
//        
//        CGPoint labelCenter = CGPointMake(self.center.x, self.frame.size.height*.7);
//        descriptionLabel.center = labelCenter;
        
    }
    return _viewOne;
    
}

-(UIView *)viewTwo {
    if (!_viewTwo) {
        CGFloat originWidth = self.frame.size.width;
        CGFloat originHeight = self.frame.size.height;
        
        _viewTwo = [[UIView alloc] initWithFrame:CGRectMake(originWidth, 0, originWidth, originHeight)];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height*.05, self.frame.size.width*.8, 60)];
        titleLabel.center = CGPointMake(self.center.x, self.frame.size.height*.1);
        titleLabel.text = [NSString stringWithFormat:@"Connect to friends"];
        titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:35.0];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.textAlignment =  NSTextAlignmentCenter;
        titleLabel.numberOfLines = 0;
        [_viewTwo addSubview:titleLabel];
        
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width*.2, self.frame.size.height*.15, self.frame.size.width*.6, self.frame.size.height*.6)];
        imageview.contentMode = UIViewContentModeScaleAspectFit;
        imageview.image = [UIImage imageNamed:@"introduce2.jpg"];
        [_viewTwo addSubview:imageview];
        
//        UILabel *descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width*.1, self.frame.size.height*.7, self.frame.size.width*.8, 60)];
//        descriptionLabel.text = [NSString stringWithFormat:@"Description for Second Screen."];
//        descriptionLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:18.0];
//        descriptionLabel.textColor = [UIColor whiteColor];
//        descriptionLabel.textAlignment =  NSTextAlignmentCenter;
//        descriptionLabel.numberOfLines = 0;
//        [descriptionLabel sizeToFit];
//        [_viewTwo addSubview:descriptionLabel];
//        
//        CGPoint labelCenter = CGPointMake(self.center.x, self.frame.size.height*.7);
//        descriptionLabel.center = labelCenter;
    }
    return _viewTwo;
    
}

-(UIView *)viewThree{
    
    if (!_viewThree) {
        CGFloat originWidth = self.frame.size.width;
        CGFloat originHeight = self.frame.size.height;
        
        _viewThree = [[UIView alloc] initWithFrame:CGRectMake(originWidth*2, 0, originWidth, originHeight)];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height*.05, self.frame.size.width*.8, 60)];
        titleLabel.center = CGPointMake(self.center.x, self.frame.size.height*.1);
        titleLabel.text = [NSString stringWithFormat:@"Quick type"];
        titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:35.0];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.textAlignment =  NSTextAlignmentCenter;
        titleLabel.numberOfLines = 0;
        [_viewThree addSubview:titleLabel];
        
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width*.2, self.frame.size.height*.15, self.frame.size.width*.6, self.frame.size.height*.6)];
        imageview.contentMode = UIViewContentModeScaleAspectFit;
        imageview.image = [UIImage imageNamed:@"introduce3.jpg"];
        [_viewThree addSubview:imageview];
    
    }
    return _viewThree;
    
}

-(UIView *)viewFour {
    if (!_viewFour) {
    
        CGFloat originWidth = self.frame.size.width;
        CGFloat originHeight = self.frame.size.height;
        
        _viewFour = [[UIView alloc] initWithFrame:CGRectMake(originWidth*3, 0, originWidth, originHeight)];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height*.05, self.frame.size.width*.8, 60)];
        titleLabel.center = CGPointMake(self.center.x, self.frame.size.height*.1);
        titleLabel.text = [NSString stringWithFormat:@"Bill detail"];
        titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:35.0];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.textAlignment =  NSTextAlignmentCenter;
        titleLabel.numberOfLines = 0;
        [_viewFour addSubview:titleLabel];
        
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width*.2, self.frame.size.height*.15, self.frame.size.width*.6, self.frame.size.height*.6)];
        imageview.contentMode = UIViewContentModeScaleAspectFit;
        imageview.image = [UIImage imageNamed:@"introduce4.jpg"];
        [_viewFour addSubview:imageview];
    }
    return _viewFour;
    
}

-(UIView *)viewFive {
    if (!_viewFive) {
        
        CGFloat originWidth = self.frame.size.width;
        CGFloat originHeight = self.frame.size.height;
        
        _viewFive = [[UIView alloc] initWithFrame:CGRectMake(originWidth*4, 0, originWidth, originHeight)];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height*.05, self.frame.size.width*.8, 60)];
        titleLabel.center = CGPointMake(self.center.x, self.frame.size.height*.1);
        titleLabel.text = [NSString stringWithFormat:@"Manage type"];
        titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:35.0];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.textAlignment =  NSTextAlignmentCenter;
        titleLabel.numberOfLines = 0;
        [_viewFive addSubview:titleLabel];
        
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width*.2, self.frame.size.height*.15, self.frame.size.width*.6, self.frame.size.height*.6)];
        imageview.contentMode = UIViewContentModeScaleAspectFit;
        imageview.image = [UIImage imageNamed:@"introduce5.jpg"];
        [_viewFive addSubview:imageview];
    }
    return _viewFive;
    
}

-(UIView *)viewSix {
    if (!_viewSix) {
        
        CGFloat originWidth = self.frame.size.width;
        CGFloat originHeight = self.frame.size.height;
        
        _viewSix = [[UIView alloc] initWithFrame:CGRectMake(originWidth*5, 0, originWidth, originHeight)];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height*.05, self.frame.size.width*.8, 60)];
        titleLabel.center = CGPointMake(self.center.x, self.frame.size.height*.1);
        titleLabel.text = [NSString stringWithFormat:@"Bill list"];
        titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:35.0];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.textAlignment =  NSTextAlignmentCenter;
        titleLabel.numberOfLines = 0;
        [_viewSix addSubview:titleLabel];
        
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width*.2, self.frame.size.height*.15, self.frame.size.width*.6, self.frame.size.height*.6)];
        imageview.contentMode = UIViewContentModeScaleAspectFit;
        imageview.image = [UIImage imageNamed:@"introduce6.jpg"];
        [_viewSix addSubview:imageview];
    }
    return _viewSix;
    
}

-(UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.frame];
        [_scrollView setDelegate:self];
        [_scrollView setPagingEnabled:YES];
        [_scrollView setContentSize:CGSizeMake(self.frame.size.width*6, self.scrollView.frame.size.height)];
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    return _scrollView;
}

-(UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.frame.size.height*.8, self.frame.size.width, 10)];
        [_pageControl setCurrentPageIndicatorTintColor:[UIColor colorWithRed:0.153 green:0.533 blue:0.796 alpha:1.000]];
        [_pageControl setNumberOfPages:6];
    }
    return _pageControl;
}

-(UIButton *)doneButton {
    if (!_doneButton) {
        _doneButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width*.1, self.frame.size.height*.85, self.frame.size.width*.8, 60)];
        [_doneButton setTintColor:[UIColor whiteColor]];
        [_doneButton setTitle:@"Let's Go!" forState:UIControlStateNormal];
        [_doneButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:18.0]];
        [_doneButton setBackgroundColor:[UIColor colorWithRed:0.153 green:0.533 blue:0.796 alpha:1.000]];
        [_doneButton addTarget:self.delegate action:@selector(onDoneButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [_doneButton.layer setCornerRadius:5];
        [_doneButton setClipsToBounds:YES];
    }
    return _doneButton;
}

@end