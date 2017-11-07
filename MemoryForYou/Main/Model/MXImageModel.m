//
//  MXImageModel.m
//  MemoryForYou
//
//  Created by xialisuper on 2017/11/6.
//  Copyright © 2017年 xialisuper. All rights reserved.
//

#import "MXImageModel.h"

@implementation MXImageModel

- (instancetype)initWithPhAsset:(PHAsset *)asset {
    if (self = [super init]) {
        self.photoAsset = asset;
    }
    return self;
}

@end
