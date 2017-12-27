//
//  MXVisualEffectFilterModel.h
//  MemoryForYou
//
//  Created by xialisuper on 2017/12/27.
//  Copyright © 2017年 xialisuper. All rights reserved.
//

#import "MXBaseFilterModel.h"

typedef NS_ENUM(NSUInteger, MXVisualEffectFilterType) {
    MXVisualEffectFilterTypeDissolve,
};


@class MXImageModel;
@interface MXVisualEffectFilterModel : MXBaseFilterModel
@property(nonatomic, strong) CIImage *fromImage;
@property(nonatomic, strong) CIImage *toImage;
@property(nonatomic, assign) MXVisualEffectFilterType type;

- (instancetype)initWithFromImage:(MXImageModel *)fromImageModel
                          ToImage:(MXImageModel *)toImageModel
                             type:(MXVisualEffectFilterType)type
                         duration:(NSTimeInterval)duration;

- (instancetype)initWithCIImageFromImage:(CIImage *)fromImage
                                 ToImage:(CIImage *)toImage
                                    type:(MXVisualEffectFilterType)type
                                duration:(NSTimeInterval)duration;

@end
