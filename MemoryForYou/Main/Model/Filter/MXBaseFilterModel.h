//
//  MXBaseFilterModel.h
//  MemoryForYou
//
//  Created by xialisuper on 2017/12/25.
//  Copyright © 2017年 xialisuper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreImage/CoreImage.h>
#import <UIKit/UIKit.h>

@interface MXBaseFilterModel : NSObject

//图片
@property(nonatomic, strong) UIImage *image;
//滤镜
@property(nonatomic, strong) CIFilter *filter;
// *持续* 时间
@property(nonatomic, assign) NSTimeInterval duration;


//交给子类重写
- (CIImage *)imageWithProgress:(CGFloat)progress;

@end
