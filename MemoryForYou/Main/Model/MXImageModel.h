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

@property(nonatomic, assign) CGRect cellRect;

//用来标记当前数据模型是否为选中状态. 与系统cell选中区分开来.
@property(nonatomic, assign, getter=isSelected) BOOL selected;

- (instancetype)initWithPhAsset:(PHAsset *)asset;

/**
 返回origin图片以全屏幕为基础的frame

 @return frame
 */
- (CGRect)mainScreenFrame;


@end
