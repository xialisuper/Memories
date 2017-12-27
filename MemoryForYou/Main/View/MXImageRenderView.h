//
//  MXImageRenderView.h
//  MemoryForYou
//
//  Created by xialisuper on 2017/12/22.
//  Copyright © 2017年 xialisuper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>

typedef NS_ENUM(NSUInteger, kMXImageAnimationType) {
    kMXImageAnimationTypeNormal,
};

@class MXImageModel;
@interface MXImageRenderView : GLKView


/**
 使用图片模型数组 进行动画渲染

 @param imagesArray 图片模型数组
 @param type 图片模型数组进行的动画过程类型
 */
- (void)startRenderWithImages:(NSArray <MXImageModel *>*)imagesArray
                     WithType:(kMXImageAnimationType)type;

@end
