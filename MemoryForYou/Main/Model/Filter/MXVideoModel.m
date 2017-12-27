//
//  MXVideoModel.m
//  MemoryForYou
//
//  Created by xialisuper on 2017/12/26.
//  Copyright © 2017年 xialisuper. All rights reserved.
//

#import "MXVideoModel.h"
#import "MXBaseFilterModel.h"
#import "MXTransitonFilterModel.h"

static NSTimeInterval const kTransitionDurationTimeInterval = 2.0;

@interface MXVideoModel ()
//总时长
@property(nonatomic, assign) NSTimeInterval totalTime;
//保存每一段滤镜的时间 例如 0, 2.5, 0.5, 2.5, 0.5...
@property(nonatomic, strong) NSMutableArray *timeIntervalArray;
@end

@implementation MXVideoModel

- (instancetype)initNormalModelWithImages:(NSArray<MXImageModel *> *)images {
    if (self = [super init]) {
        __block NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:images.count];
        [images enumerateObjectsUsingBlock:^(MXImageModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            MXTransitonFilterModel *model = [[MXTransitonFilterModel alloc] initWithImageModel:obj
                                                                                          time:2.0
                                                                                      distance:10
                                                                                         scale:1.1
                                                                                     direction:CGPointMake(-10, 10)];
            [tempArray addObject:model];
        }];
        self.modelArray = tempArray;
    }
    return self;
}

- (CIImage *)imageWithTime:(NSTimeInterval)time {
    __block NSTimeInterval currentFilterStartTime = 0;
    __block CIImage *tempImage = nil;
    [self.modelArray enumerateObjectsUsingBlock:^(MXBaseFilterModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (currentFilterStartTime > time) {
            MXTransitonFilterModel *filter = (MXTransitonFilterModel *)self.modelArray[idx - 1];
            
            //当前时间坐标 - 上一次循环的startTime / 时间坐标所在滤镜持续时间
            CGFloat progress = (time - (currentFilterStartTime - obj.duration)) / filter.duration;
            tempImage = [filter imageWithProgress:progress];
            //停止
            *stop = YES;
        }
        currentFilterStartTime += obj.duration;

    }];
    
    
    return tempImage;
}

- (CGFloat)filterProgressWithTime:(NSTimeInterval)time {
    __block CGFloat progress = 0;
    
    [self.timeIntervalArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //每一个滤镜的起始时间
        NSTimeInterval startTime = [obj floatValue];
        if (time < startTime) {
            //当前滤镜的起始和结束时间
            NSTimeInterval currentFilterStartTime = [self.timeIntervalArray[idx - 1] floatValue];
            NSTimeInterval currentFilterEndTime = [self.timeIntervalArray[idx] floatValue];
            //时间比例
            progress = (time - currentFilterStartTime) / (currentFilterEndTime - currentFilterStartTime);
            NSAssert(progress < 0 || progress > 1, @"progress invalid");
        }
    }];
    return progress;
}

#pragma mark - getter & setter

- (void)setModelArray:(NSMutableArray<MXBaseFilterModel *> *)modelArray {
    
    self.totalTime = 0;
    self.timeIntervalArray = [NSMutableArray arrayWithCapacity:self.modelArray.count + 1];
    [self.timeIntervalArray addObject:@(0)];
    _modelArray = modelArray;
    [self.modelArray enumerateObjectsUsingBlock:^(MXBaseFilterModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
        self.totalTime += model.duration;
        [self.timeIntervalArray addObject:@(self.totalTime)];
    }];
}




@end
