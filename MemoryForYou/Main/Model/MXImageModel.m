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
        self.selected = NO;
    }
    return self;
}

- (CGRect)mainScreenFrame {
    if (self.photoAsset == nil) {
        return CGRectZero;
    }
    
    NSInteger imageHeight = self.photoAsset.pixelHeight;
    NSInteger imageWidth = self.photoAsset.pixelWidth;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    CGFloat x;
    CGFloat y;
    CGFloat width;
    CGFloat height;
    
    //横的图片
    if ((imageWidth * 1.0 / imageHeight) > (screenWidth / screenHeight)) {
        width = screenWidth;
        height = screenWidth * imageHeight / imageWidth;
        x = 0 ;
        y = 0.5 * (screenHeight - height);
    } else {    //竖的图片
        width = screenHeight * imageWidth / imageHeight;
        height = screenHeight;
        x = 0.5 * (screenWidth - width);
        y = 0;
    }
    
    return CGRectMake(x, y, width, height);
}



@end
