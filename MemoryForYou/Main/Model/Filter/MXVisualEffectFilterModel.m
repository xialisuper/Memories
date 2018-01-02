//
//  MXVisualEffectFilterModel.m
//  MemoryForYou
//
//  Created by xialisuper on 2017/12/27.
//  Copyright © 2017年 xialisuper. All rights reserved.
//

#import "MXVisualEffectFilterModel.h"

@interface MXVisualEffectFilterModel ()
@property(nonatomic, strong) CIFilter *dissolveFilter;

@end

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
    CIImage *image = nil;
    switch (self.type) {
        case MXVisualEffectFilterTypeDissolve: {
            [self.dissolveFilter setValue:self.fromImage forKey:@"inputImage"];
            [self.dissolveFilter setValue:self.toImage forKey:@"inputTargetImage"];
            [self.dissolveFilter setValue:@(progress) forKey:@"inputTime"];
            image = self.dissolveFilter.outputImage;
            break;
        }
            
        default:
            break;
    }
    
    return image;
}

#pragma mark - getter & setter
- (CIFilter *)dissolveFilter {
    if (_dissolveFilter == nil) {
        _dissolveFilter = [CIFilter filterWithName:@"CIDissolveTransition"];
    }
    return _dissolveFilter;
}



@end
