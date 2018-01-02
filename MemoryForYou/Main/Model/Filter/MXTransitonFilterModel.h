//
//  MXTransitonFilterModel.h
//  MemoryForYou
//
//  Created by xialisuper on 2017/12/26.
//  Copyright © 2017年 xialisuper. All rights reserved.
//

#import "MXBaseFilterModel.h"

@class MXImageModel;
@interface MXTransitonFilterModel : MXBaseFilterModel

//位移距离
@property(nonatomic, assign) NSInteger distance;
//放大缩小比例
@property(nonatomic, assign) CGFloat scale;
//位移方向 eg:(10, -20)
@property(nonatomic, assign) CGPoint directionPoint;


/**
 创建平移类型的滤镜模型

 @param model 图片数据模型
 @param duration 平移持续时间
 @param distance 位移(废弃)
 @param scale 位移同时放大或者缩小
 @param directionPoint 位移的矢量方向(代替distance)
 @return 返回模型
 */
- (instancetype)initWithImageModel:(MXImageModel *)model
                              time:(NSTimeInterval)duration
                          distance:(NSInteger)distance
                             scale:(CGFloat)scale
                         direction:(CGPoint)directionPoint;



//交给子类重写
//- (CIImage *)imageWithProgress:(CGFloat)progress;
@end
