//
//  MXImagePreviewPopAnimator.m
//  MemoryForYou
//
//  Created by xialisuper on 2017/11/15.
//  Copyright © 2017年 xialisuper. All rights reserved.
//

#import "MXImagePreviewPopAnimator.h"
#import "MXImagePickerViewController.h"
#import "MXImage3DPreviewViewController.h"
#import "MXImagePickerCollectionViewCell.h"

#import "MXImageModel+MXCellFrame.h"
#import "MXPhotoUtil.h"


@implementation MXImagePreviewPopAnimator


- (void)animateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext {
    
    //获取动画前后两个VC 和 发生的容器containerView
    MXImagePickerViewController *toVC = (MXImagePickerViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    MXImage3DPreviewViewController *fromVC = (MXImage3DPreviewViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    
    //即将恢复的cell
    MXImagePickerCollectionViewCell *cell =(MXImagePickerCollectionViewCell *)[toVC.photoCollectionView cellForItemAtIndexPath:[[toVC.photoCollectionView indexPathsForSelectedItems] firstObject]];
    
    MXImageModel *currentModel = fromVC.model;
    
    cell.imageView.hidden = YES;
    [containerView addSubview:toVC.view];
    [containerView addSubview:fromVC.view];
    
    if (transitionContext.isInteractive) {    //手势交互
        
        //
        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:0.3 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            fromVC.view.backgroundColor = COLOR_RGB(0, 0, 0, 0);
        } completion:^(BOOL finished) {
            BOOL wasCancelled = [transitionContext transitionWasCancelled];
            //设置transitionContext通知系统动画执行完毕
            [transitionContext completeTransition:!wasCancelled];
            
            if ([transitionContext transitionWasCancelled]) {    //手势取消
                
            } else {
                cell.imageView.hidden = NO;
            }
        }];
    } else {    //非手势
        
        __block UIImageView *transitionImageView = [[UIImageView alloc] initWithFrame:[currentModel mainScreenFrame]];
        [containerView addSubview:transitionImageView];
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:0.3 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            [[MXPhotoUtil sharedInstance] photoUtilFetchThumbnailImageWith:fromVC.model.photoAsset WithSize:fromVC.model.cellRect.size synchronous:(BOOL)YES block:^(UIImage *image, NSDictionary *info) {
                transitionImageView.image = image;
                
            }];
            transitionImageView.frame = fromVC.model.cellRect;
            fromVC.view.alpha = 0;
            
        } completion:^(BOOL finished) {
            [transitionImageView removeFromSuperview];
            cell.imageView.hidden = NO;
            
            //设置transitionContext通知系统动画执行完毕
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
    }
}

- (void)interactiveAnimateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext {
    
}


@end
