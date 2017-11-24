//
//  MXImagePickerBottomView.m
//  MemoryForYou
//
//  Created by xialisuper on 2017/11/23.
//  Copyright © 2017年 xialisuper. All rights reserved.
//

#import "MXImagePickerBottomView.h"
#import "MXImagePickerBottomCollectionViewFlowLayout.h"
#import "MXImagePickerBottomCollectionViewCell.h"

#import <Masonry.h>

static double const kShowAnimationDurationTimeInterval = 0.2;
static double const kHideAnimationDurationTimeInterval = 0.1;
static double const kViewHeight = 50;
static NSString * const kMXImagePickerBottomCollectionViewCell = @"MXImagePickerBottomCollectionViewCell";

@interface MXImagePickerBottomView () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property(nonatomic, strong) UICollectionView *photoCollectionView;

@end

@implementation MXImagePickerBottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor orangeColor];
        
        [self initCollectionView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.photoCollectionView.frame = self.bounds;
}

#pragma mark - UI
- (void)initCollectionView {
    
    MXImagePickerBottomCollectionViewFlowLayout *layout = [[MXImagePickerBottomCollectionViewFlowLayout alloc] init];
    
    UICollectionView *photoCollectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    self.photoCollectionView = photoCollectionView;
    [self addSubview:photoCollectionView];
    
    photoCollectionView.backgroundColor = [UIColor redColor];
    photoCollectionView.delegate = self;
    photoCollectionView.dataSource = self;
    photoCollectionView.showsHorizontalScrollIndicator = NO;
    
    [photoCollectionView registerClass:[MXImagePickerBottomCollectionViewCell class] forCellWithReuseIdentifier:kMXImagePickerBottomCollectionViewCell];
}

#pragma mark - UICollectionViewDataSource, UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 15;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kMXImagePickerBottomCollectionViewCell forIndexPath:indexPath];
    
    
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout



#pragma mark - method

- (void)showBottomViewFromView:(UIView *)view {
    //不再使用因为快速的弹出和隐藏 会在动画中途self.isShow未改变时return.
    //造成双击 仍然弹出的问题
//    if (self.isShow) {
//        return;
//    }
    
    [view addSubview:self];
    
    self.frame = CGRectMake(0, view.bounds.size.height, view.bounds.size.width, kViewHeight);
    
    [UIView animateWithDuration:kShowAnimationDurationTimeInterval animations:^{
        self.frame = CGRectMake(0, view.bounds.size.height - kViewHeight, view.bounds.size.width, kViewHeight);
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hideHideBottomViewFromView:(UIView *)view {
//    if (!self.isShow) {
//        return;
//    }
    [UIView animateWithDuration:kHideAnimationDurationTimeInterval animations:^{
        
        self.frame = CGRectMake(0, view.bounds.size.height, view.bounds.size.width, kViewHeight);
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        
    }];
    
}

@end
