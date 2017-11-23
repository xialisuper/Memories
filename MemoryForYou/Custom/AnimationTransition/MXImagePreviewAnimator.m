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

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    //获取动画前后两个VC 和 发生的容器containerView
    MXImagePickerViewController *fromVC = (MXImagePickerViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    MXImage3DPreviewViewController *toVC = (MXImage3DPreviewViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    
    //被选中的cell
    MXImagePickerCollectionViewCell *cell =(MXImagePickerCollectionViewCell *)[fromVC.photoCollectionView cellForItemAtIndexPath:fromVC.currentSelectedIndexPath];
    
    CGRect containerCellRect = [containerView convertRect:cell.frame fromView:fromVC.photoCollectionView];
    
    //过度图片
    __block UIImageView *transitionImageView = [[UIImageView alloc] initWithFrame:containerCellRect];
    transitionImageView.backgroundColor = [UIColor lightGrayColor];
    
    //覆盖被选中cell的假白色view (图片被移走的假象)
    cell.imageView.hidden = YES;
    toVC.view.alpha = 0;
    toVC.imageView.hidden = YES;
    
    [containerView addSubview:toVC.view];
    [containerView addSubview:transitionImageView];
//
    [[MXPhotoUtil sharedInstance] photoUtilFetchThumbnailImageWith:cell.imageModel.photoAsset WithSize:[cell.imageModel mainScreenFrame].size synchronous:(BOOL)NO block:^(UIImage *image, NSDictionary *info) {
        dispatch_async(dispatch_get_main_queue(), ^{
            transitionImageView.image = image;
        });
    }];
    
    //动画
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:0.3 options:UIViewAnimationOptionCurveLinear animations:^{
        transitionImageView.frame = [cell.imageModel mainScreenFrame] ;
        toVC.view.alpha = 1;
        
    } completion:^(BOOL finished) {
        transitionImageView.hidden = YES;
        toVC.imageView.hidden = NO;
//        BOOL wasCancelled = [transitionContext transitionWasCancelled];
        //设置transitionContext通知系统动画执行完毕
        [transitionContext completeTransition:YES];
    }];
    
}
@end
