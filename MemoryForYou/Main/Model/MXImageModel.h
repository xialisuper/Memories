//
//  MXImageModel.h
//  MemoryForYou
//
//  Created by xialisuper on 2017/11/6.
//  Copyright © 2017年 xialisuper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@interface MXImageModel : NSObject

@property (nonatomic, strong) PHAsset *photoAsset;
- (instancetype)initWithPhAsset:(PHAsset *)asset;

@end
