//
//  MXImagePreviewPercentDrivenInteractiveTransition.h
//  MemoryForYou
//
//  Created by xialisuper on 2017/11/15.
//  Copyright © 2017年 xialisuper. All rights reserved.
//

#import "MXBaseNavPercentDrivenInteractiveTransition.h"

@interface MXImagePreviewPercentDrivenInteractiveTransition : MXBaseNavPercentDrivenInteractiveTransition

//是否在手势中
@property(nonatomic, assign) BOOL interacting;

- (void)handleInteractionGesture:(UIGestureRecognizer *)gesture withViewController:(UIViewController *)viewController;

@end
