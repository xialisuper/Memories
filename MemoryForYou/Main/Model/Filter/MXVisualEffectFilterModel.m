//
//  MXVisualEffectFilterModel.m
//  MemoryForYou
//
//  Created by xialisuper on 2017/12/27.
//  Copyright © 2017年 xialisuper. All rights reserved.
//

#import "MXVisualEffectFilterModel.h"

@implementation MXVisualEffectFilterModel

- (instancetype)initWithCIImageFromImage:(CIImage *)fromImage ToImage:(CIImage *)toImage type:(MXVisualEffectFilterType)type duration:(NSTimeInterval)duration {
    
    if (self = [super init]) {
        switch (type) {
            case MXVisualEffectFilterTypeDissolve:
                self.fromImage = fromImage;
                self.toImage = toImage;
                self.duration = duration;
                self.type = MXVisualEffectFilterTypeDissolve;
                
                break;
                
            default:
                break;
        }
    }
    return self;
}

- (CIImage *)imageWithProgress:(CGFloat)progress {
#warning todo
    return nil;
}

@end
