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

- (instancetype)initWithImageModel:(MXImageModel *)model
                              time:(NSTimeInterval)duration
                          distance:(NSInteger)distance
                             scale:(CGFloat)scale
                         direction:(CGPoint)directionPoint;



//交给子类重写
- (CIImage *)imageWithProgress:(CGFloat)progress;
@end
