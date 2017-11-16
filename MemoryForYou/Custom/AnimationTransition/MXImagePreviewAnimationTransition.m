//
//  MXImagePreviewAnimationTransition.m
//  MemoryForYou
//
//  Created by xialisuper on 2017/11/14.
//  Copyright © 2017年 xialisuper. All rights reserved.
//

#import "MXImagePreviewAnimationTransition.h"
#import "MXImagePreviewAnimator.h"
#import "MXImagePreviewPopAnimator.h"
#import "MXImagePreviewPercentDrivenInteractiveTransition.h"

@interface MXImagePreviewAnimationTransition ()
@property(nonatomic, strong) MXImagePreviewAnimator *imageAnimator;
@property(nonatomic, strong) MXImagePreviewPopAnimator *imagePopAnimator;
@property(nonatomic, strong) <#type#> *<#name#>
@end

@implementation MXImagePreviewAnimationTransition

#pragma mark - UINavigationControllerDelegate
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    if (operation == UINavigationControllerOperationPush) {
        
        return self.imageAnimator;
    } else if (operation == UINavigationControllerOperationPop) {
        return self.imagePopAnimator;
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

- (MXImagePreviewPopAnimator *)imagePopAnimator {
    if (_imagePopAnimator == nil) {
        _imagePopAnimator = [[MXImagePreviewPopAnimator alloc] init];
    }
    return _imagePopAnimator;
}

@end
