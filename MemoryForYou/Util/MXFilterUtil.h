//
//  MXFilterUtil.h
//  MemoryForYou
//
//  Created by xialisuper on 2017/12/22.
//  Copyright © 2017年 xialisuper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreImage/CoreImage.h>



typedef NS_ENUM(NSUInteger, kMXFilterType) {
    kMXFilterTypeDissolve,
};

@interface MXFilterUtil : NSObject

+ (CIFilter *)filterWithType:(kMXFilterType)type
                      extent:(CIVector *)extent;

@end
