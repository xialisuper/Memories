//
//  MXImagePickerBottomView.m
//  MemoryForYou
//
//  Created by xialisuper on 2017/11/23.
//  Copyright © 2017年 xialisuper. All rights reserved.
//

#import "MXImagePickerBottomView.h"
#import <Masonry.h>

static double const kShowAnimationDurationTimeInterval = 0.3;
static double const kHideAnimationDurationTimeInterval = 0.15;
static double const kViewHeight = 50;

@interface MXImagePickerBottomView ()
@property(nonatomic, strong) UICollectionView *photoCollectionView;
//判断当前view是否已经在显示中.
@property(nonatomic, assign, getter=isShow) BOOL show;

@end

@implementation MXImagePickerBottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor orangeColor];
        self.show = NO;
        
    }
    return self;
}

#pragma mark - UI
- (void)initCollectionView {
    
    
    UICollectionView *photoCollectionView = [UICollectionView alloc] initWithFrame:<#(CGRect)#> collectionViewLayout:<#(nonnull UICollectionViewLayout *)#>
}


#pragma mark - method

- (void)showBottomViewFromView:(UIView *)view {
    if (self.isShow) {
        return;
    }
    
    [view addSubview:self];
    
    self.frame = CGRectMake(0, view.bounds.size.height, view.bounds.size.width, kViewHeight);
    
    [UIView animateWithDuration:kShowAnimationDurationTimeInterval animations:^{
        self.frame = CGRectMake(0, view.bounds.size.height - kViewHeight, view.bounds.size.width, kViewHeight);
        
    } completion:^(BOOL finished) {
        self.show = YES;
    }];
}

- (void)hideHideBottomViewFromView:(UIView *)view {
    if (!self.isShow) {
        return;
    }
    [UIView animateWithDuration:kHideAnimationDurationTimeInterval animations:^{
        
        self.frame = CGRectMake(0, view.bounds.size.height, view.bounds.size.width, kViewHeight);
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        self.show = NO;
    }];
    
}

@end
