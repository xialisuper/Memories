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
    
    //collectionView在最底层
    UIView *toView = toVC.view;
    [containerView addSubview:toView];
    
    //图片的白色遮挡
    MXImageModel *currentModel = fromVC.model;
    UIView *whiteCellFakeView = [[UIView alloc] initWithFrame:currentModel.cellRect];
    [containerView addSubview:whiteCellFakeView];
    
    //整体的白色渐变背景
    UIView *whiteContainFakeView = [[UIView alloc] initWithFrame:containerView.bounds];
    whiteContainFakeView.backgroundColor = [UIColor whiteColor];
    whiteContainFakeView.alpha = 1;
    [containerView addSubview:whiteContainFakeView];
    
    
    
    [[MXPhotoUtil sharedInstance] photoUtilFetchThumbnailImageWith:fromVC.model.photoAsset WithSize:fromVC.model.cellRect.size synchronous:(BOOL)YES block:^(UIImage *image, NSDictionary *info) {
        
        
        UIImageView *transitionImageView = [[UIImageView alloc] initWithImage:fromVC.imageView.image];
        transitionImageView.frame = [currentModel mainScreenFrame];
        [containerView addSubview:transitionImageView];
        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:0.3 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            //container的bounds包括导航栏.
//            transitionImageView.frame = CGRectMake(fromVC.model.cellRect.origin.x, fromVC.model.cellRect.origin.y + MXSafeAreaTopHeight, fromVC.model.cellRect.size.width, fromVC.model.cellRect.size.height);
            transitionImageView.image = image;
            transitionImageView.frame = fromVC.model.cellRect;
            whiteContainFakeView.alpha = 0;
            
        } completion:^(BOOL finished) {
            [whiteCellFakeView removeFromSuperview];
            [whiteContainFakeView removeFromSuperview];
            [transitionImageView removeFromSuperview];
            
            BOOL wasCancelled = [transitionContext transitionWasCancelled];
            //设置transitionContext通知系统动画执行完毕
            [transitionContext completeTransition:!wasCancelled];
        }];
    }];
    
    
}




@end
