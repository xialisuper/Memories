//
//  MXImagePreviewPercentDrivenInteractiveTransition.m
//  MemoryForYou
//
//  Created by xialisuper on 2017/11/15.
//  Copyright © 2017年 xialisuper. All rights reserved.
//

#import "MXImagePreviewPercentDrivenInteractiveTransition.h"

@interface MXImagePreviewPercentDrivenInteractiveTransition ()
@property (nonatomic, weak) id<UIViewControllerContextTransitioning> transitionContext;

@end
@implementation MXImagePreviewPercentDrivenInteractiveTransition

#pragma mark - getter & setter


#pragma mark - method
- (CGFloat)percentForGesture:(UIPanGestureRecognizer *)gesture
{
    
    CGPoint translation = [gesture translationInView:gesture.view];
    
    NSLog(@"translation.y = %f", translation.y);
    
    CGFloat percent = (translation.y / MXScreenHeight);
    
    percent = percent < 0 ? 0 : percent;
    percent = percent > 1 ? 1 :percent;
    
    return percent;
}

- (void)handleInteractionGesture:(UIGestureRecognizer *)gesture withViewController:(UIViewController *)viewController {
    
    UIPanGestureRecognizer *panGesture = (UIPanGestureRecognizer *)gesture;
    //速度
    CGPoint velPoint = [panGesture velocityInView:panGesture.view];
    //百分比
    CGFloat percent = [self percentForGesture:(UIPanGestureRecognizer *)gesture];
    NSLog(@"updateInteractiveTransition : %f", percent);
    
    
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
            
            self.interacting = YES;
            [viewController.navigationController popViewControllerAnimated:YES];
            
            break;
        case UIGestureRecognizerStateChanged:
            [self updateInteractiveTransition:percent];
            
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
            
            self.interacting = NO;
            if (velPoint.y <= 0){
                
                [self cancelInteractiveTransition];
            }
            else{
                
                [self finishInteractiveTransition];
            }
            break;
        default:
            break;
        }
    }
}


@end
