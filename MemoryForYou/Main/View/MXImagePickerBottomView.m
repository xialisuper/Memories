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
#import "MXImagePickerViewController.h"

#import <Masonry.h>

static double const kShowAnimationDurationTimeInterval = 0.2;
static double const kHideAnimationDurationTimeInterval = 0.1;
static double const kViewHeight = 50;
static NSString * const kMXImagePickerBottomCollectionViewCell = @"MXImagePickerBottomCollectionViewCell";

@interface MXImagePickerBottomView () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, MXImagePickerViewControllerDelegate>

@property(nonatomic, strong) UICollectionView *photoCollectionView;
//保存被选中数据模型数组
@property(nonatomic, strong) NSMutableArray<MXImageModel *> *selectedPhotosArray;
//长按移动手势
@property(nonatomic, strong) UILongPressGestureRecognizer *longPressGesture;

@end

@implementation MXImagePickerBottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor orangeColor];
        
        [self initCollectionView];
        
        [self initGestureRecognizers];
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
    
    photoCollectionView.backgroundColor = MXToolBarColor;
    photoCollectionView.delegate = self;
    photoCollectionView.dataSource = self;
    photoCollectionView.showsHorizontalScrollIndicator = NO;
    
    [photoCollectionView registerClass:[MXImagePickerBottomCollectionViewCell class] forCellWithReuseIdentifier:kMXImagePickerBottomCollectionViewCell];
}

#pragma mark - UICollectionViewDataSource, UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.selectedPhotosArray.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (MXImagePickerBottomCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MXImagePickerBottomCollectionViewCell *cell = (MXImagePickerBottomCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kMXImagePickerBottomCollectionViewCell forIndexPath:indexPath];
    cell.model = self.selectedPhotosArray[indexPath.item];
    
    return cell;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath{
    //返回YES允许其item移动
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath {
    //取出源item数据
    id objc = [self.selectedPhotosArray objectAtIndex:sourceIndexPath.item];
    //从资源数组中移除该数据
    [self.selectedPhotosArray removeObject:objc];
    //将数据插入到资源数组中的目标位置上
    [self.selectedPhotosArray insertObject:objc atIndex:destinationIndexPath.item];
}

#pragma mark - UICollectionViewDelegateFlowLayout

#pragma mark - MXImagePickerViewControllerDelegate

- (void)imagePickerViewControllerAddModel:(MXImageModel *)model {
    
    //不这么写会有Bug 只是用insert方法
    [self.selectedPhotosArray addObject:model];
    if (self.selectedPhotosArray.count == 1 || [self.photoCollectionView numberOfItemsInSection:0] == self.selectedPhotosArray.count) {
        [self.photoCollectionView reloadData];
    } else {
        [self.photoCollectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.selectedPhotosArray.count - 1 inSection:0]]];
    }
}

- (void)imagePickerViewControllerRemoveModel:(MXImageModel *)model {
    [self.selectedPhotosArray enumerateObjectsUsingBlock:^(MXImageModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj == model) {
            [self.selectedPhotosArray removeObject:model];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:idx inSection:0];
            [self.photoCollectionView deleteItemsAtIndexPaths:@[indexPath]];
        }
    }];
}

- (void)imagePickerViewControllerRemoveAllObjects {
    [self.selectedPhotosArray removeAllObjects];
    [self.photoCollectionView reloadData];
}


#pragma mark - method

- (void)initGestureRecognizers {
    if (self.photoCollectionView == nil) {
        return;
    }
    
    _longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    _longPressGesture.minimumPressDuration = 0.3;
    _longPressGesture.delegate = self;
    [self.photoCollectionView addGestureRecognizer:_longPressGesture];
    
}

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

#pragma mark - action

- (void)handleLongPress:(UILongPressGestureRecognizer *)longPressGesture {
    //判断手势状态
    switch (longPressGesture.state) {
        case UIGestureRecognizerStateBegan:{
            //判断手势落点位置是否在路径上
            NSIndexPath *indexPath = [self.photoCollectionView indexPathForItemAtPoint:[longPressGesture locationInView:self.photoCollectionView]];
            if (indexPath == nil) {
                break;
            }
            //在路径上则开始移动该路径上的cell
            [self.photoCollectionView beginInteractiveMovementForItemAtIndexPath:indexPath];
        }
            break;
        case UIGestureRecognizerStateChanged:
            //移动过程当中随时更新cell位置
            
            if (@available(iOS 9.0, *)) {
                [self.photoCollectionView updateInteractiveMovementTargetPosition:[longPressGesture locationInView:self.photoCollectionView]];
            } else {
                // Fallback on earlier versions
            }
            break;
        case UIGestureRecognizerStateEnded:
            //移动结束后关闭cell移动
            if (@available(iOS 9.0, *)) {
                [self.photoCollectionView endInteractiveMovement];
            } else {
                // Fallback on earlier versions
            }
            break;
        default:
            if (@available(iOS 9.0, *)) {
                [self.photoCollectionView cancelInteractiveMovement];
            } else {
                // Fallback on earlier versions
            }
            break;
    }
}

#pragma mark - getter & setter
- (NSMutableArray *)selectedPhotosArray {
    if (_selectedPhotosArray == nil) {
        _selectedPhotosArray = [NSMutableArray array];
    }
    return _selectedPhotosArray;
}



@end
