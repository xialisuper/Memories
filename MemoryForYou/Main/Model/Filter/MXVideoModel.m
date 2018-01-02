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
#import "MXVisualEffectFilterModel.h"
#import "MXPhotoUtil.h"

static NSTimeInterval const kTransitionDurationTimeInterval = 1.5;
static NSTimeInterval const kDissolveDurationTimeInterval = 0.2;

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
                                                                                          time:kTransitionDurationTimeInterval
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
            MXBaseFilterModel *filter = self.modelArray[idx - 1];
            
            CGFloat progress = [self filterProgressWithTime:time];
            tempImage = [filter imageWithProgress:progress];
            //停止
            *stop = YES;
        }
        currentFilterStartTime += obj.duration;

        if (idx == self.modelArray.count - 1 && currentFilterStartTime < time) {
            tempImage = nil;
        }
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
//            NSAssert(progress < 0 || progress > 1, @"progress invalid");
            *stop = YES;
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

- (void)loadDataWithImages:(NSArray<MXImageModel *> *)images withBlock:(void (^)(MXVideoModel *model))completion {
    
    __block NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:images.count];
    
    
    [images enumerateObjectsUsingBlock:^(MXImageModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        MXTransitonFilterModel *model = [[MXTransitonFilterModel alloc] initWithImageModel:obj
                                                                                      time:kTransitionDurationTimeInterval
                                                                                  distance:10
                                                                                     scale:1.1
                                                                                 direction:CGPointMake(-10, 10)];
        [tempArray addObject:model];
    }];
    self.modelArray = tempArray;

    completion(self);

}

- (void)loadDataWithImages:(NSArray<MXImageModel *> *)images
                     style:(MXVideoModelStyle)style
           completionBlock:(void (^)(MXVideoModel *))completion {
    
     __block NSMutableArray *tempArray = [NSMutableArray array];
    
    switch (style) {
        case MXVideoModelStyleNormal: {
            [images enumerateObjectsUsingBlock:^(MXImageModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                MXTransitonFilterModel *model = [[MXTransitonFilterModel alloc] initWithImageModel:obj
                                                                                              time:kTransitionDurationTimeInterval
                                                                                          distance:10
                                                                                             scale:1.1
                                                                                         direction:CGPointMake(-10, 10)];
                [tempArray addObject:model];
            }];
            
            break;
        }
        case MXVideoModelStyleDissolve: {
            __block UIImage *tempNextImage = nil;
            [images enumerateObjectsUsingBlock:^(MXImageModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                //位移模型
                MXTransitonFilterModel *model = [[MXTransitonFilterModel alloc] initWithImageModel:obj
                                                                                              time:kTransitionDurationTimeInterval
                                                                                          distance:10
                                                                                             scale:1.1
                                                                                         direction:CGPointMake(-10, 10)];
                
                //以位移模型的最后一帧画面为基础 渐变模型
                CIImage *fromImage = [model imageWithProgress:1];
                
                [tempArray addObject:model];
                //最后一张图片不再渐变
                if (idx == images.count - 1) {
                    return;
                }
                
                //从下一个数据模型 获取UIImage
                MXImageModel *nextModel = images[idx + 1];
                [[MXPhotoUtil sharedInstance] photoUtilFetchThumbnailImageWith:nextModel.photoAsset WithSize:CGSizeMake(MXScreenWidth, MXScreenHeight) synchronous:YES block:^(UIImage *image, NSDictionary *info) {
                    tempNextImage = image;
                }];
                
                
                MXVisualEffectFilterModel *disolveFilterModel = [[MXVisualEffectFilterModel alloc] initWithCIImageFromImage:[model imageWithProgress:1]  ToImage:[[CIImage alloc] initWithImage:tempNextImage] type:MXVisualEffectFilterTypeDissolve duration:kDissolveDurationTimeInterval];
                
                [tempArray addObject:disolveFilterModel];
            }];
            
            break;
        }
            
            
        default:
            break;
    }
    
    self.modelArray = tempArray;
    completion(self);
    
}


@end
