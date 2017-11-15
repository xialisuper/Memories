//
//  MXImagePreviewAnimator.m
//  MemoryForYou
//
//  Created by xialisuper on 2017/11/14.
//  Copyright © 2017年 xialisuper. All rights reserved.
//

#import "MXImagePreviewAnimator.h"
#import "MXImagePickerViewController.h"
#import "MXImage3DPreviewViewController.h"
#import "MXImagePickerCollectionViewCell.h"

#import "MXImageModel.h"
#import "MXPhotoUtil.h"

@implementation MXImagePreviewAnimator

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext{
    return MXNavigationTransitionDuration;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    //获取动画前后两个VC 和 发生的容器containerView
    MXImagePickerViewController *fromVC = (MXImagePickerViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    MXImage3DPreviewViewController *toVC = (MXImage3DPreviewViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    
    //控制器的view
    UIView *toView = toVC.view;
    toView.hidden = YES;
    UIView *fromView = fromVC.view;
    [containerView addSubview:fromView];
    [containerView addSubview:toView];
    
    //被选中的cell
    MXImagePickerCollectionViewCell *cell =(MXImagePickerCollectionViewCell *)[fromVC.photoCollectionView cellForItemAtIndexPath:[[fromVC.photoCollectionView indexPathsForSelectedItems] firstObject]];
    
    //覆盖被选中cell的假白色view (图片被移走的假象)
    UIView *whiteCellFakeView = [[UIView alloc] initWithFrame:cell.frame];
    //此处白色 红色调试
    whiteCellFakeView.backgroundColor = [UIColor redColor];
    [containerView addSubview:whiteCellFakeView];
    
    //覆盖fromVC的白色背景view 会随着拖动渐变透明度
    UIView *whiteContainFakeView = [[UIView alloc] initWithFrame:containerView.bounds];
    //黑色调试
    whiteContainFakeView.backgroundColor = [UIColor whiteColor];
    whiteContainFakeView.alpha = 0;
    [containerView addSubview:whiteContainFakeView];
    
    //过度图片
    [[MXPhotoUtil sharedInstance] photoUtilFetchThumbnailImageWith:cell.imageModel.photoAsset WithSize:[cell.imageModel mainScreenFrame].size block:^(UIImage *image, NSDictionary *info) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImageView *transitionImageView = [[UIImageView alloc] initWithImage:image];
            transitionImageView.frame = cell.frame;
            [containerView addSubview:transitionImageView];
            
            //动画
            [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:0.3 options:UIViewAnimationOptionCurveLinear animations:^{
                
                transitionImageView.frame = [cell.imageModel mainScreenFrame] ;
                whiteContainFakeView.alpha = 1;
                
            } completion:^(BOOL finished) {
                
                toView.hidden = NO;
                
                [whiteCellFakeView removeFromSuperview];
                [whiteContainFakeView removeFromSuperview];
                [transitionImageView removeFromSuperview];
                
                BOOL wasCancelled = [transitionContext transitionWasCancelled];
                //设置transitionContext通知系统动画执行完毕
                [transitionContext completeTransition:!wasCancelled];
            }];
        });
        
        
    }];
    
}
@end
