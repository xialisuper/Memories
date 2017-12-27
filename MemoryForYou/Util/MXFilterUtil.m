//
//  MXFilterUtil.m
//  MemoryForYou
//
//  Created by xialisuper on 2017/12/22.
//  Copyright © 2017年 xialisuper. All rights reserved.
//

#import "MXFilterUtil.h"

@implementation MXFilterUtil

+ (CIFilter *)filterWithType:(kMXFilterType)type extent:(CIVector *)extent {
    CIFilter *filter;
    switch (type) {
        case kMXFilterTypeDissolve:
            filter = [CIFilter filterWithName: @"CIDissolveTransition"];

            break;
            
        default:
            break;
    }
    
    return filter;
}



@end
