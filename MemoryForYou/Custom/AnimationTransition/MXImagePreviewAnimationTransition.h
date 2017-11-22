//
//  MXImagePreviewAnimationTransition.h
//  MemoryForYou
//
//  Created by xialisuper on 2017/11/14.
//  Copyright © 2017年 xialisuper. All rights reserved.
//

#import "MXBaseNavAnimationTransition.h"

@interface MXImagePreviewAnimationTransition : MXBaseNavAnimationTransition

- (void)handleInteractionGesture:(UIGestureRecognizer *)gesture withViewController:(UIViewController *)viewController;

@end
