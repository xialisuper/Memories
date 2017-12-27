//
//  MXVideoModel.h
//  MemoryForYou
//
//  Created by xialisuper on 2017/12/26.
//  Copyright © 2017年 xialisuper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class MXBaseFilterModel, MXImageModel;
@interface MXVideoModel : NSObject

@property(nonatomic, strong) NSMutableArray<MXBaseFilterModel *> *modelArray;

- (instancetype)initNormalModelWithImages:(NSArray<MXImageModel *> *)images;
- (void)loadDataWithImages:(NSArray<MXImageModel *> *)images withBlock:(void(^)(MXVideoModel *model))completion;

/**
 总时长的某个坐标获取当前时刻的滤镜progress

 @param time 时间轴坐标
 @return 时刻的滤镜progress
 */
- (CGFloat)filterProgressWithTime:(NSTimeInterval)time;

/**
 根据当前时间坐标获取需要被渲染的CIImage

 @param time 时间轴坐标
 @return 被渲染图片
 */
- (CIImage *)imageWithTime:(NSTimeInterval)time;


@end