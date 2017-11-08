//
//  MXImagePickerViewController.m
//  MemoryForYou
//
//  Created by 夏立群 on 2017/11/2.
//  Copyright © 2017年 xialisuper. All rights reserved.
//

#import "MXImagePickerViewController.h"
#import "MXPhotoPickerCollectionViewFlowLayout.h"
#import "MXImagePickerCollectionViewCell.h"
#import "MXPhotoUtil.h"

static NSString * const kImagePickerCollectionViewCell = @"kImagePickerCollectionViewCell";
@interface MXImagePickerViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UIGestureRecognizerDelegate>

@property(nonatomic, strong) UICollectionView *photoCollectionView;
@property (nonatomic, strong) NSMutableArray<MXImageModel *> *dataArray;

//长按移动手势
@property(nonatomic, strong) UILongPressGestureRecognizer *longPressGesture;
@end

@implementation MXImagePickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initDataSource];
    [self initNavBar];
    [self initPhotoCollectionView];
    [self initGestureRecognizers];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UI
- (void)initNavBar {
    self.title = NSLocalizedString(@"图片选择", nil);
}

- (void)initPhotoCollectionView {
    
    MXPhotoPickerCollectionViewFlowLayout *layout = [[MXPhotoPickerCollectionViewFlowLayout alloc] init];
    
    UICollectionView *photoCollectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    [self.view addSubview:photoCollectionView];
    
    photoCollectionView.backgroundColor = [UIColor whiteColor];
    photoCollectionView.dataSource = self;
    photoCollectionView.delegate = self;
    photoCollectionView.alwaysBounceHorizontal = NO;
    [self.view addSubview:photoCollectionView];
    self.photoCollectionView = photoCollectionView;
    
    [photoCollectionView registerClass:[MXImagePickerCollectionViewCell class] forCellWithReuseIdentifier:kImagePickerCollectionViewCell];
}

#pragma mark - DataSource
- (void)initDataSource {
    [[MXPhotoUtil sharedInstance] fetchAllPhotosWithResultsWithBlock:^(NSArray<MXImageModel *> *assetsArray) {
        if (assetsArray.count) {
            self.dataArray = [NSMutableArray arrayWithArray:assetsArray];
        }
    }];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MXImagePickerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kImagePickerCollectionViewCell forIndexPath:indexPath];
    cell.imageModel = self.dataArray[indexPath.row];
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"您点击了item:%ld", (long)indexPath.row);
    [collectionView cellForItemAtIndexPath:indexPath].backgroundColor = [UIColor redColor];
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath{
    //返回YES允许其item移动
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath {
    //取出源item数据
    id objc = [self.dataArray objectAtIndex:sourceIndexPath.item];
    //从资源数组中移除该数据
    [self.dataArray removeObject:objc];
    //将数据插入到资源数组中的目标位置上
    [self.dataArray insertObject:objc atIndex:destinationIndexPath.item];
}

#pragma mark - getter & setter
//- (UILongPressGestureRecognizer *)longPressGesture {
//    if (_longPressGesture == nil) {
//        _longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
//        _longPressGesture.minimumPressDuration = 0.3;
//        _longPressGesture.delegate = self;
//        [self.photoCollectionView addGestureRecognizer:_longPressGesture];
//
//    }
//    return _longPressGesture;
//}

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

#pragma mark - UIGestureRecognizerDelegate

@end
