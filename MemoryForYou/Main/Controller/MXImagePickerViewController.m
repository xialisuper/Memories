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
#import "MXImage3DPreviewViewController.h"
#import "MXPhotoUtil.h"
#import "MXImagePreviewAnimationTransition.h"
#import <Masonry.h>

static NSString * const kImagePickerCollectionViewCell = @"kImagePickerCollectionViewCell";
@interface MXImagePickerViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UIGestureRecognizerDelegate, UIViewControllerPreviewingDelegate>
@property (nonatomic, strong) NSMutableArray<MXImageModel *> *dataArray;

//长按移动手势
@property(nonatomic, strong) UILongPressGestureRecognizer *longPressGesture;
//此控制器push的转场动画
@property(nonatomic, strong) MXImagePreviewAnimationTransition *animatedTransiton;
@end

@implementation MXImagePickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initDataSource];
    [self initNavBar];
    [self initPhotoCollectionView];
    [self initGestureRecognizers];
//    [self init3DTouch];
    
}

//
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.delegate = nil;
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
    
    [photoCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.view);
    }];
}

//横竖屏适配
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    if (size.width > size.height) {
        NSLog(@"横屏");
    } else {
        NSLog(@"竖屏");
    }
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
    
//    if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
//        [self registerForPreviewingWithDelegate:self sourceView:cell];
//    } else {
//        NSLog(@"3D Touch 无效");
//    }
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"点击了item:%ld", (long)indexPath.row);
    
    MXImageModel *selectModel = [self.dataArray objectAtIndex:indexPath.row];
    MXImage3DPreviewViewController *previewVc = [[MXImage3DPreviewViewController alloc] init];
    previewVc.model = selectModel;
    self.navigationController.delegate = self.animatedTransiton;
    [self.navigationController pushViewController:previewVc animated:YES];
    
    NSLog(@"%@", NSStringFromCGRect(selectModel.mainScreenFrame));
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
- (MXImagePreviewAnimationTransition *)animatedTransiton {
    if (_animatedTransiton == nil) {
        _animatedTransiton = [[MXImagePreviewAnimationTransition alloc] init];
    }
    return _animatedTransiton;
}


#pragma mark - method

- (void)init3DTouch {
    // 如果开启了3D touch
    if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
        [self registerForPreviewingWithDelegate:(id)self sourceView:self.photoCollectionView];
    }
}

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

#pragma mark - UIViewControllerPreviewingDelegate

- (void)previewingContext:(nonnull id<UIViewControllerPreviewing>)previewingContext commitViewController:(nonnull UIViewController *)viewControllerToCommit {
    [self showDetailViewController:viewControllerToCommit sender:self];
}

- (nullable UIViewController *)previewingContext:(nonnull id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location {
    MXImage3DPreviewViewController *detailVc = [[MXImage3DPreviewViewController alloc] init];
    MXImagePickerCollectionViewCell *touchingCell = (MXImagePickerCollectionViewCell *)[previewingContext sourceView];

    //设置非虚化区域.
    CGRect cellFrame = touchingCell.frame;
    NSLog(@"%@", NSStringFromCGRect(cellFrame));
    previewingContext.sourceRect = cellFrame;
//
    //获取cell图片
    NSIndexPath *touchingIndexPath = [self.photoCollectionView indexPathForCell:touchingCell];
    MXImageModel *model = self.dataArray[touchingIndexPath.row];
    detailVc.model = model;
    
    return detailVc;
}



@end
