//
//  MXVideoUtil.h
//  MemoryForYou
//
//  Created by xialisuper on 2017/12/6.
//  Copyright © 2017年 xialisuper. All rights reserved.
//


#import <AVFoundation/AVFoundation.h>
#import <CoreVideo/CoreVideo.h>
#import <CoreFoundation/CoreFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <CoreImage/CoreImage.h>
#import <UIKit/UIKit.h>

typedef void(^SuccessBlock)(BOOL success);

@class MXImageModel;
@interface MXVideoUtil : NSObject

+ (instancetype)sharedInstance;


/**
 从图片导出视频

 @param array 图片array
 @param path 导出路径
 @param size 视频范围size
 @param fps 默认60帧
 @param shouldAnimateTransitions 是否需要动画 默认需要
 @param callbackBlock 成功回调
 */
- (void)writeImageAsMovie:(NSArray *)array
                     toPath:(NSString*)path
                       size:(CGSize)size
                        fps:(int)fps
         animateTransitions:(BOOL)shouldAnimateTransitions
        withCallbackBlock:(SuccessBlock)callbackBlock;


/**
 更简略的导出目标

 @param array MXIMageModel组成的array
 @param callBackBlock 回调
 */
- (void)writeImageAsMovie:(NSArray <MXImageModel *>*)array
                WithBlock:(SuccessBlock)callBackBlock;

@end
