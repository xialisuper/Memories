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
#import "MXImageModel+MXCellFrame.h"
#import "MXImagePickerBottomView.h"
#import <Masonry.h>
//#import <ReactiveCocoa.h>

static NSString * const kImagePickerCollectionViewCell = @"kImagePickerCollectionViewCell";
static NSString * const kSelectedPhotosArray = @"selectedPhotosArray";

@interface MXImagePickerViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UIGestureRecognizerDelegate, UIViewControllerPreviewingDelegate>
@property (nonatomic, strong) NSMutableArray<MXImageModel *> *dataArray;

//长按移动手势
@property(nonatomic, strong) UILongPressGestureRecognizer *longPressGesture;
//此控制器push的转场动画
@property(nonatomic, strong) MXImagePreviewAnimationTransition *animatedTransiton;
//当前是否是选择模式
@property(nonatomic, assign, getter=isSelectingPhotos) BOOL selectingPhotos;
//纪录被选中的cell的model
@property(nonatomic, strong) NSMutableArray *selectedPhotosArray;

//底部动条
@property(nonatomic, strong) MXImagePickerBottomView *bottomView;

@end

@implementation MXImagePickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self conmmonConfig];
    [self initDataSource];
    [self initNavBar];
    [self initPhotoCollectionView];
    [self initGestureRecognizers];
    
}

//
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.delegate = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:kSelectedPhotosArray];
}

#pragma mark - UI
- (void)initNavBar {
    
    //监听数据model的属性. 变化UI.
    //vc标题
    self.title = NSLocalizedString(@"照片", nil);
    [self addObserver:self forKeyPath:kSelectedPhotosArray options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld  context:NULL];
    
    //右侧按钮变化
    UIBarButtonItem *selectButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"选择", nil) style:UIBarButtonItemStyleDone target:self action:@selector(handleSelectBarButtonClickEvent:)];
    self.navigationItem.rightBarButtonItem = selectButton;
}

- (void)initPhotoCollectionView {
    
    MXPhotoPickerCollectionViewFlowLayout *layout = [[MXPhotoPickerCollectionViewFlowLayout alloc] init];
    
    UICollectionView *photoCollectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    [self.view addSubview:photoCollectionView];
    
    photoCollectionView.backgroundColor = [UIColor whiteColor];
    photoCollectionView.dataSource = self;
    photoCollectionView.delegate = self;
    photoCollectionView.alwaysBounceHorizontal = NO;
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
    self.currentSelectedIndexPath = indexPath;
    MXImageModel *selectModel = [self.dataArray objectAtIndex:indexPath.row];
    //赋值model frame
    MXImagePickerCollectionViewCell *cell = (MXImagePickerCollectionViewCell *)[self.photoCollectionView cellForItemAtIndexPath:indexPath];
    //吧cell.frame转换到当前屏幕的位置而不是collectionView的位置.
    selectModel.cellRect = [self.view convertRect:cell.frame fromView:self.photoCollectionView];
    
    //点击单图预览 以及多选模式
    if (self.isSelectingPhotos) {
        selectModel.selected = !selectModel.isSelected;
        
        if (selectModel.selected) {
            [self selectPhotosArrayAddObject:selectModel];
        } else {
            [self selectPhotosArrayRemoveObject:selectModel];
        }
        
    } else {
        
        MXImage3DPreviewViewController *previewVc = [[MXImage3DPreviewViewController alloc] init];
        previewVc.model = selectModel;
        self.navigationController.delegate = self.animatedTransiton;
        [self.navigationController pushViewController:previewVc animated:YES];
    }
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

- (MXImagePickerBottomView *)bottomView {
    if (_bottomView == nil) {
        _bottomView = [[MXImagePickerBottomView alloc] init];
        self.delegate = _bottomView;
    }
    return _bottomView;
}

- (MXImagePreviewAnimationTransition *)animatedTransiton {
    if (_animatedTransiton == nil) {
        _animatedTransiton = [[MXImagePreviewAnimationTransition alloc] init];
    }
    return _animatedTransiton;
}


- (NSMutableArray *)selectedPhotosArray {
    if (_selectedPhotosArray == nil) {
        _selectedPhotosArray = [NSMutableArray array];
    }
    return _selectedPhotosArray;
}

- (void)setCurrentSelectedIndexPath:(NSIndexPath *)currentSelectedIndexPath {
    _currentSelectedIndexPath = currentSelectedIndexPath;
}

#pragma mark - method

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context {
    
    if ([keyPath isEqualToString:kSelectedPhotosArray]) {
        //根据照片数组数量变化vc标题
        if (self.selectedPhotosArray.count) {
            self.title = [NSString stringWithFormat:NSLocalizedString(@"已选择%zd张照片", nil), self.selectedPhotosArray.count];
           
        } else {
            self.title = NSLocalizedString(@"选择项目", nil);
        }
        
        //处理弹出bottomView
        //NSKeyValueChangeInsertion增加 NSKeyValueChangeRemoval减少
        if ([change[@"kind"] integerValue] == NSKeyValueChangeInsertion && self.selectedPhotosArray.count == 1) {
            [self.bottomView showBottomViewFromView:self.view];
        }
        if ([change[@"kind"] integerValue] == NSKeyValueChangeRemoval && self.selectedPhotosArray.count == 0) {
            [self.bottomView hideHideBottomViewFromView:self.view];
        }
        
        
    }
}

- (void)conmmonConfig {
    self.selectingPhotos = NO;
}

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

- (void)selectPhotosArrayAddObject:(MXImageModel *)model {
    
    [[self mutableArrayValueForKey:kSelectedPhotosArray] addObject:model];
    if ([self.delegate respondsToSelector:@selector(imagePickerViewControllerAddModel:)]) {
        [self.delegate imagePickerViewControllerAddModel:model];
    }
}

- (void)selectPhotosArrayRemoveObject:(MXImageModel *)model {
    
    [[self mutableArrayValueForKey:kSelectedPhotosArray] removeObject:model];
    if ([self.delegate respondsToSelector:@selector(imagePickerViewControllerRemoveModel:)]) {
        [self.delegate imagePickerViewControllerRemoveModel:model];
    }
}

#pragma mark - action
- (void)handleSelectBarButtonClickEvent:(UIBarButtonItem *)sender {
    self.selectingPhotos = !self.isSelectingPhotos;
    if (self.isSelectingPhotos) {
        sender.title = NSLocalizedString(@"取消", nil);
        self.title = NSLocalizedString(@"选择项目", nil);
    } else {
        sender.title = NSLocalizedString(@"选择", nil);
        //取消选择之后移除所有已选中的cell样式 清理model数据.
        [self.dataArray enumerateObjectsUsingBlock:^(MXImageModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.selected = NO;
        }];
        [[self mutableArrayValueForKeyPath:kSelectedPhotosArray] removeAllObjects];
        if ([self.delegate respondsToSelector:@selector(imagePickerViewControllerRemoveAllObjects)]) {
            [self.delegate imagePickerViewControllerRemoveAllObjects];
        }
        self.title = NSLocalizedString(@"照片", nil);
    }
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
