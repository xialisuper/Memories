//
//  MXImagePreviewAnimationTransition.m
//  MemoryForYou
//
//  Created by xialisuper on 2017/11/14.
//  Copyright © 2017年 xialisuper. All rights reserved.
//

#import "MXImagePreviewAnimationTransition.h"
#import "MXImagePreviewAnimator.h"

@interface MXImagePreviewAnimationTransition ()
@property(nonatomic, strong) MXImagePreviewAnimator *imageAnimator;
@end

@implementation MXImagePreviewAnimationTransition

#pragma mark - UINavigationControllerDelegate
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    if (operation == UINavigationControllerOperationPush) {
        
        return self.imageAnimator;
    }
    return nil;
}

#pragma mark - getter & setter
- (MXImagePreviewAnimator *)imageAnimator {
    if (_imageAnimator == nil) {
        _imageAnimator = [[MXImagePreviewAnimator alloc] init];
    }
    return _imageAnimator;
}

@end
