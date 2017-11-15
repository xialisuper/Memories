//
//  MXBaseNavAnimator.m
//  MemoryForYou
//
//  Created by xialisuper on 2017/11/15.
//  Copyright © 2017年 xialisuper. All rights reserved.
//

#import "MXBaseNavAnimator.h"


@implementation MXBaseNavAnimator

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext{
    return MXNavigationTransitionDuration;
}

//交给子类去重写.
- (void)animateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext {
    
}




@end
