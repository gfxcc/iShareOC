//
//  PullAction.m
//  iShare
//
//  Created by caoyong on 12/27/15.
//  Copyright © 2015 caoyong. All rights reserved.
//

#import "PullAction.h"

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

const CGFloat pMaxDistance          = 53.0f;
const CGFloat pLabelImageDistance   = 10.0f;
const CGFloat pViewHeight           = 50.0f;
const CGFloat pActivityHeight       = 80.0f;
const CGFloat pDistanceToBot        = 5.0f;
const CGFloat pDistanceToTop        = 15.0f;

#define AnimationDuration 0.0

@interface PullActionDefaultContentView : UIView <PullActionContentView>

- (id)initWithFrame:(CGRect)frame;

@property (nonatomic,getter=isEnabled) BOOL enabled;
@property (nonatomic, strong) UIColor *tintColor;
@property (nonatomic,getter=isEnabled) BOOL atBot;


@end

@interface PullActionDefaultContentView ()
{
    UIView *_activity;
    BOOL _refreshing;
    UILabel *_label;
    UIImageView *_imageView;
    CGSize _contentSize;
    BOOL _changed;
    BOOL _processingAnimation;

}

@end

@implementation PullActionDefaultContentView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _changed = false;
        _processingAnimation = false;
        
        id activity = nil;
        _activity = activity ? activity : [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        //_activity.center = CGPointMake(floor(self.frame.size.width / 2), floor(self.frame.size.height / 2));
        _activity.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        _activity.alpha = 0;
        if ([_activity respondsToSelector:@selector(startAnimating)]) {
            [(UIActivityIndicatorView *)_activity startAnimating];
        }
        [self addSubview:_activity];
        
        
        _imageView = [[UIImageView alloc] init];
        _imageView.image = [UIImage imageNamed:@"arrowDown.png"];
        [self addSubview:_imageView];
        
        _label = [[UILabel alloc] init];
        _label.text = @"pull to load next year";
        _label.textColor = RGB(26, 142, 180);
        [self addSubview:_label];
        
        // set frame
        [self setContentFrame];
    }
    return self;
}

- (void)layoutSubviews {
    if (_refreshing) {
        // Keep thing pinned at the top
        //_activity.center = CGPointMake(floor(self.frame.size.width / 2), MIN(floor([self openHeight] / 2), self.frame.size.height - [self openHeight]/ 2));
    } else {
        _activity.frame = _imageView.frame;
        if (_atBot) {
            [self setContentFrame];
            //_changed = YES;
            if ([_label.text isEqualToString:@"pull to load next year"]) {
                _label.text = @"pull to load last year";
                _imageView.image = [UIImage imageNamed:@"arrowUp.png"];
            }
            if (self.frame.size.height > pActivityHeight && !_changed) {
                _changed = YES;
                _imageView.image = [UIImage imageNamed:@"arrowDown.png"];
                _label.text = @"release to load";
            } else if (self.frame.size.height <= pActivityHeight && _changed) {
                _changed = NO;
                _imageView.image = [UIImage imageNamed:@"arrowUp.png"];
                _label.text = @"pull to load last year";
            }
        } else {
            if (self.frame.size.height > pActivityHeight && !_changed) {
                _processingAnimation = YES;
                _changed = YES;
                [UIView animateWithDuration:AnimationDuration animations:^
                 {
                     _imageView.image = [UIImage imageNamed:@"arrowUp.png"];
                     _label.text = @"release to load";
                     [self setContentFrame];
                     
                 } completion:^(BOOL finished)
                 {
                     _processingAnimation = NO;
                 }];
                
                
            } else if (self.frame.size.height <= pActivityHeight && (_changed || [_label.text isEqualToString:@"pull to load last year"])){
                _changed = NO;
                _processingAnimation = YES;
                [UIView animateWithDuration:AnimationDuration animations:^
                 {
                     _imageView.image = [UIImage imageNamed:@"arrowDown.png"];
                     _label.text = @"pull to load next year";
                     [self setContentFrame];
                     
                 } completion:^(BOOL finished)
                 {
                     _processingAnimation = NO;
                 }];
                
            }
            
            if (!_processingAnimation) {
                _imageView.frame = CGRectMake(_imageView.frame.origin.x, -(pViewHeight / 2 + _contentSize.height / 2) + self.frame.size.height,
                                              _imageView.frame.size.width, _imageView.frame.size.height);
                _label.frame = CGRectMake(_label.frame.origin.x, -(pViewHeight / 2 + _contentSize.height / 2) + self.frame.size.height,
                                          _label.frame.size.width, _label.frame.size.height);
            }
        }
    }
    
    
    //CGRect cc = self.frame;
    //NSLog(@"%f %f %f %f\n", cc.origin.x, cc.origin.y, cc.size.width, cc.size.height);

}

-(void)setContentFrame {
    
    CGSize labelSize = [_label.text sizeWithAttributes:@{NSFontAttributeName: _label.font}];
    CGFloat contentWidth = ceilf(labelSize.height) + ceilf(labelSize.width) + pLabelImageDistance;
    _contentSize = CGSizeMake(contentWidth, ceilf(labelSize.height));
    
    if (_atBot) {
        _imageView.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - contentWidth) / 2,
                                      pDistanceToBot,
                                      ceilf(labelSize.height),
                                      ceilf(labelSize.height));
        _label.frame = CGRectMake(_imageView.frame.origin.x + _imageView.frame.size.width + pLabelImageDistance,
                                  pDistanceToBot,
                                  ceilf(labelSize.width),
                                  ceilf(labelSize.height));
    } else {
        
        
        _imageView.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - contentWidth) / 2,
                                      -(pViewHeight / 2 + ceilf(labelSize.height) / 2) + self.frame.size.height,
                                      ceilf(labelSize.height),
                                      ceilf(labelSize.height));
        _label.frame = CGRectMake(_imageView.frame.origin.x + _imageView.frame.size.width + pLabelImageDistance,
                                  -(pViewHeight / 2 + ceilf(labelSize.height) / 2) + self.frame.size.height,
                                  ceilf(labelSize.width),
                                  ceilf(labelSize.height));
    }
    
}

- (CGFloat)triggerHeight
{
    return pMaxDistance + 43;
}

- (CGFloat)openHeight
{
    return 44.0f;
}

- (void)beginRefreshing:(BOOL)animated {
    _refreshing = YES;
    _activity.alpha = 1;
    _label.text = @"loading";
    _imageView.alpha = 0;
    [self setContentFrame];
    _activity.frame = _imageView.frame;
    _label.frame = CGRectMake(_label.frame.origin.x, pDistanceToTop, _label.frame.size.width, _label.frame.size.height);
    _activity.frame = CGRectMake(_activity.frame.origin.x, pDistanceToTop, _activity.frame.size.width, _activity.frame.size.height);
    
    
    
}
- (void)endRefreshing {
    if (_refreshing) {
        [UIView animateWithDuration:0.4 animations:^{
            _activity.alpha = 0;
            _imageView.alpha = 1;
            //_activity.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1);
        } completion:^(BOOL finished) {
            _refreshing = NO;
        }];
    }
}

@end

#pragma mark -
#pragma mark PullAction

@interface PullAction ()
{
    UIView<PullActionContentView> *_contentView;
    
    BOOL _canRefresh;
    BOOL _ignoreInset;
    BOOL _ignoreOffset;
    BOOL _didSetInset;
    BOOL _hasSectionHeaders;
    CGFloat _lastOffset;
    CGFloat _currentTopInset;
}

@property (nonatomic, readwrite) BOOL refreshing;
@property (nonatomic, assign) UIScrollView *scrollView;
@property (nonatomic, assign) UIEdgeInsets originalContentInset;

@end

@implementation PullAction

- (id)initInScrollView:(UIScrollView *)scrollView {
    return [self initInScrollView:scrollView activityIndicatorView:nil];
}

- (id)initInScrollView:(UIScrollView *)scrollView activityIndicatorView:(UIView *)activity
{
    self = [super initWithFrame:CGRectMake(0, 0, scrollView.frame.size.width, 0)];
    
    if (self) {
        self.scrollView = scrollView;
        self.originalContentInset = scrollView.contentInset;
        _canRefresh = YES;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [scrollView addSubview:self];
        [scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
        [scrollView addObserver:self forKeyPath:@"contentInset" options:NSKeyValueObservingOptionNew context:nil];
        
        _contentView = [[PullActionDefaultContentView alloc] initWithFrame:self.bounds];
        _contentView.clipsToBounds = YES;
        _contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:_contentView];
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"GET in dealloc\n");
    [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
    [self.scrollView removeObserver:self forKeyPath:@"contentInset"];
    self.scrollView = nil;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    if (!newSuperview) {
        [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
        [self.scrollView removeObserver:self forKeyPath:@"contentInset"];
        self.scrollView = nil;
    }
}

- (CGFloat)navigationBarInset
{
    if ([UIViewController instancesRespondToSelector:@selector(topLayoutGuide)]) {
        Class class = [UIViewController class];
        UIResponder *responder = self;
        while ((responder = [responder nextResponder])) {
            if ([responder isKindOfClass:class]) {
                break;
            }
        }
        UIViewController *viewController = (UIViewController *)responder;
        if (viewController.automaticallyAdjustsScrollViewInsets && (viewController.edgesForExtendedLayout & UIRectEdgeTop)) {
            // There's a known bug in iOS7 where calling topLayoutGuide breaks UITableViewControllers, so we do some manual calculations
            CGFloat size = MIN([UIApplication sharedApplication].statusBarFrame.size.height, [UIApplication sharedApplication].statusBarFrame.size.width);
            if (viewController.navigationController) {
                size += CGRectIntersection(viewController.navigationController.view.bounds, viewController.navigationController.navigationBar.frame).size.height;
            }
            return size;
        }
    }
    return 0.0f;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"contentInset"]) {
        if (!_ignoreInset) {
            UIEdgeInsets originalContentInset = [[change objectForKey:@"new"] UIEdgeInsetsValue];
            originalContentInset.top -= _currentTopInset;
            self.originalContentInset = originalContentInset;
            self.frame = CGRectMake(0, 0, self.scrollView.frame.size.width, 0);
            _lastOffset = self.scrollView.contentOffset.y + self.originalContentInset.top;
        }
        return;
    }
    
    if (!self.enabled || _ignoreOffset) {
        return;
    }
    
    CGFloat offset = self.originalContentInset.top != 0 ? [[change objectForKey:@"new"] CGPointValue].y + self.originalContentInset.top : 0;
    CGFloat height;
    CGFloat t = [[change objectForKey:@"new"] CGPointValue].y;
    CGFloat ttttt = self.originalContentInset.top;
    CGFloat tt = _scrollView.contentSize.height;
    CGFloat ttt = _scrollView.bounds.size.height;
    
    if ([[change objectForKey:@"new"] CGPointValue].y - (_scrollView.contentSize.height - _scrollView.bounds.size.height) > 0 && _scrollView.contentSize.height > 0) {
        //NSLog(@"detected!!!\n");
        height = [[change objectForKey:@"new"] CGPointValue].y - (_scrollView.contentSize.height - _scrollView.bounds.size.height);
        _contentView.atBot = YES;
        self.frame = CGRectMake(0, _scrollView.contentSize.height,
                                self.scrollView.frame.size.width, [[change objectForKey:@"new"] CGPointValue].y - (_scrollView.contentSize.height - _scrollView.bounds.size.height));
    } else {
        _contentView.atBot = NO;
        height = -MIN(0.0f, offset);
        self.frame = CGRectMake(0, -height - self.originalContentInset.top + [self navigationBarInset], self.scrollView.frame.size.width, height);
    }
    if (_refreshing) {
        _lastOffset = offset;
        if (offset != 0) {
            _ignoreInset = YES;
            _ignoreOffset = YES;
            
            if (offset < 0) {
                // Set the inset depending on the situation
                if (offset >= -pMaxDistance) {
                    if (!self.scrollView.dragging) {
                        if (!_didSetInset) {
                            _didSetInset = YES;
                            _hasSectionHeaders = NO;
                            if([self.scrollView isKindOfClass:[UITableView class]]){
                                for (int i = 0; i < [(UITableView *)self.scrollView numberOfSections]; ++i) {
                                    if ([(UITableView *)self.scrollView rectForHeaderInSection:i].size.height) {
                                        _hasSectionHeaders = YES;
                                        break;
                                    }
                                }
                            }
                        }
                        if (_hasSectionHeaders) {
                            _currentTopInset = MIN(-offset, pMaxDistance);
                            [self.scrollView setContentInset:UIEdgeInsetsMake(_currentTopInset + self.originalContentInset.top, self.originalContentInset.left, self.originalContentInset.bottom, self.originalContentInset.right)];
                        } else {
                            _currentTopInset = pMaxDistance;
                            [self.scrollView setContentInset:UIEdgeInsetsMake(_currentTopInset + self.originalContentInset.top, self.originalContentInset.left, self.originalContentInset.bottom, self.originalContentInset.right)];
                        }
                    } else if (_didSetInset && _hasSectionHeaders) {
                        _currentTopInset = -offset;
                        [self.scrollView setContentInset:UIEdgeInsetsMake(_currentTopInset + self.originalContentInset.top, self.originalContentInset.left, self.originalContentInset.bottom, self.originalContentInset.right)];
                    }
                }
            } else if (_hasSectionHeaders) {
                _currentTopInset = 0.0f;
                [self.scrollView setContentInset:self.originalContentInset];
            }
            _ignoreInset = NO;
            _ignoreOffset = NO;
        }
        return;
    } else {
        
        // Check if we can trigger a new refresh and if we can draw the control
        BOOL dontDraw = NO;
        if (!_canRefresh) {
            if (self.scrollView.isDragging && _lastOffset == 0 && offset <= 0) {
                _canRefresh = YES;
                _didSetInset = NO;
            } else {
                dontDraw = YES;
            }
        } else {
            if (offset >= 0) {
                // Don't draw if the control is not visible
                dontDraw = YES;
            }
        }
        if (offset > 0 && _lastOffset > offset && !self.scrollView.isTracking) {
            // If we are scrolling too fast, don't draw, and don't trigger unless the scrollView bounced back
            _canRefresh = NO;
            dontDraw = YES;
        }
        if (dontDraw) {
            self.frame = CGRectMake(0, 0, self.scrollView.frame.size.width, 0);
            _lastOffset = offset;
            return;
        }
    }
    
    _lastOffset = offset;
    

    if (_canRefresh && height > pMaxDistance && !self.scrollView.isDragging) {
        [_contentView beginRefreshing:YES];
        self.refreshing = YES;
        _canRefresh = NO;
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
    
    
    
    
}

// Tells the control that a refresh operation was started programmatically
- (void)beginRefreshing {
    [_contentView beginRefreshing:NO];
    
    CGPoint offset = self.scrollView.contentOffset;
    _ignoreInset = YES;
    _currentTopInset = pMaxDistance;
    self.scrollView.contentInset = UIEdgeInsetsMake(_currentTopInset + self.originalContentInset.top, self.originalContentInset.left, self.originalContentInset.bottom, self.originalContentInset.right);
    _ignoreInset = NO;
    [self.scrollView setContentOffset:offset animated:NO];
    
    self.refreshing = YES;
    _canRefresh = NO;
}

// Tells the control the refresh operation has ended
- (void)endRefreshing{
    if (_refreshing) {
        // Create a temporary retain-cycle, so the scrollView won't be released
        // halfway through the end animation.
        // This allows for the refresh control to clean up the observer,
        // in the case the scrollView is released while the animation is running
        __block UIScrollView *blockScrollView = self.scrollView;
        [UIView animateWithDuration:0.4 animations:^{
            _ignoreInset = YES;
            _currentTopInset = 0.0f;
            [blockScrollView setContentInset:self.originalContentInset];
            _ignoreInset = NO;
        } completion:^(BOOL finished) {
            // We need to use the scrollView somehow in the end block,
            // or it'll get released in the animation block.
            _ignoreInset = YES;
            [blockScrollView setContentInset:self.originalContentInset];
            _ignoreInset = NO;
        }];
        [_contentView endRefreshing];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.refreshing = NO;
        });
        _canRefresh = YES;
    }
}

@end
