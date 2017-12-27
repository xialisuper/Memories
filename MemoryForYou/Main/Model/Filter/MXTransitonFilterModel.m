//
//  MXTransitonFilterModel.m
//  MemoryForYou
//
//  Created by xialisuper on 2017/12/26.
//  Copyright © 2017年 xialisuper. All rights reserved.
//

#import "MXTransitonFilterModel.h"
#import "MXImageModel.h"
#import "MXPhotoUtil.h"

@implementation MXTransitonFilterModel

- (instancetype)initWithImageModel:(MXImageModel *)model
                              time:(NSTimeInterval)duration
                          distance:(NSInteger)distance
                             scale:(CGFloat)scale
                         direction:(CGPoint)directionPoint {
    if (self = [super init]) {
//        [[MXPhotoUtil sharedInstance] photoUtilFetchOriginImageWith:model.photoAsset synchronous:YES block:^(UIImage *image) {
//            self.image = image;
//        }];
        [[MXPhotoUtil sharedInstance] photoUtilFetchThumbnailImageWith:model.photoAsset WithSize:CGSizeMake(MXScreenWidth, MXScreenHeight) synchronous:YES block:^(UIImage *image, NSDictionary *info) {
            self.image = image;
        }];
        self.duration = duration;
        self.distance = distance;
        self.scale = scale;
        self.directionPoint = directionPoint;
    }
    return self;
}

- (CIImage *)imageWithProgress:(CGFloat)progress {
    CIImage *inputImage = [[CIImage alloc] initWithImage:self.image];
    
    inputImage = [inputImage imageByApplyingTransform:CGAffineTransformMakeScale(1 + (self.scale - 1) * progress, 1 + (self.scale - 1) * progress)];
    inputImage = [inputImage imageByApplyingTransform:CGAffineTransformMakeTranslation(self.directionPoint.x * progress, self.directionPoint.y * progress)];
//    NSLog(@"%f %f", 1 + (self.scale - 1) * progress ,self.directionPoint.x * progress);
    return inputImage;
}

@end
