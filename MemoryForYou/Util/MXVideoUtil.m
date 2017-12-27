//
//  MXVideoUtil.m
//  MemoryForYou
//
//  Created by xialisuper on 2017/12/6.
//  Copyright © 2017年 xialisuper. All rights reserved.
//

#import "MXVideoUtil.h"
#import "MXImageModel.h"
#import "MXPhotoUtil.h"

//重新定义的时间
static NSUInteger const kFps = 20;
static NSUInteger const kPhotoTransitionFrameCount = 2 * kFps;
static NSUInteger const kPhotoShowFrameCount = 2 * kFps;

static double const kFadeScale = 0.1;
static double const kFadeTransfer = 10;;

@interface MXVideoUtil ()
@property(nonatomic, strong) CIContext *myContext;
@end

@implementation MXVideoUtil

+ (instancetype)sharedInstance {
    
    static MXVideoUtil *util;
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        
        util = [MXVideoUtil new];
    });
    
    return util;
}

- (void)writeImageAsMovie:(NSArray <MXImageModel *>*)array
                WithBlock:(SuccessBlock)callBackBlock {
    
    __block NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:array.count];
    for (MXImageModel *model in array) {
        [[MXPhotoUtil sharedInstance] photoUtilFetchThumbnailImageWith:model.photoAsset
                                                              WithSize:CGSizeMake(MXScreenWidth, MXScreenHeight)
                                                           synchronous:YES
                                                                 block:^(UIImage *image, NSDictionary *info) {
            [tempArray addObject:image];
                                                                     NSLog(@"%@", NSStringFromCGSize(image.size));
        }];
    }
    
    [self writeImageAsMovie:tempArray
                     toPath:nil
                       size:CGSizeMake(MXScreenWidth, MXScreenHeight)
                        fps:kFps
         animateTransitions:YES
          withCallbackBlock:^(BOOL success) {
        callBackBlock(success);
    }];
}

- (void)writeImageAsMovie:(NSArray *)array
                   toPath:(NSString*)path
                     size:(CGSize)size
                      fps:(int)fps
       animateTransitions:(BOOL)shouldAnimateTransitions
        withCallbackBlock:(SuccessBlock)callbackBlock
{

    NSString *tempPath = [NSTemporaryDirectory() stringByAppendingPathComponent:
                          [NSString stringWithFormat:@"temp.mp4"]];
    [[NSFileManager defaultManager] removeItemAtPath:tempPath error:NULL];
    
    NSError *error = nil;
    AVAssetWriter *videoWriter = [[AVAssetWriter alloc] initWithURL:[NSURL fileURLWithPath:tempPath]
                                                           fileType:AVFileTypeMPEG4
                                                              error:&error];
    if (error) {
        if (callbackBlock) {
            callbackBlock(NO);
        }
        return;
    }
    NSParameterAssert(videoWriter);
    
    NSDictionary *videoSettings = @{AVVideoCodecKey: AVVideoCodecH264,
                                    AVVideoWidthKey: [NSNumber numberWithInt:size.width],
                                    AVVideoHeightKey: [NSNumber numberWithInt:size.height]};
    
    AVAssetWriterInput* writerInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo
                                                                         outputSettings:videoSettings];
    
    AVAssetWriterInputPixelBufferAdaptor *adaptor = [AVAssetWriterInputPixelBufferAdaptor assetWriterInputPixelBufferAdaptorWithAssetWriterInput:writerInput
                                                                                                                     sourcePixelBufferAttributes:nil];
    NSParameterAssert(writerInput);
    NSParameterAssert([videoWriter canAddInput:writerInput]);
    [videoWriter addInput:writerInput];
    
    //Start a session:
    [videoWriter startWriting];
    [videoWriter startSessionAtSourceTime:kCMTimeZero];
    
    __block CVPixelBufferRef buffer;
    CVPixelBufferPoolCreatePixelBuffer(NULL, adaptor.pixelBufferPool, &buffer);
    
    //i代表第几张图片
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_apply([array count], queue, ^(size_t index) {
//
//        //入场图片
//        CIImage *filterInputImage = [[CIImage alloc] initWithImage:array[index]];
//        NSAssert(filterInputImage, @"filterInputImage");
//        filterInputImage = [filterInputImage imageByApplyingTransform:CGAffineTransformMakeScale(0.5, 0.5)];
//
//        //出场图片
//        UIImage *nextImage = [UIImage imageNamed:@"sample2"];
//        CIImage *nextCIImage = [CIImage imageWithCGImage:nextImage.CGImage];
//        nextCIImage = [nextCIImage imageByApplyingTransform:CGAffineTransformMakeScale(0.5, 0.5)];
//
//        if (writerInput.isReadyForMoreMediaData) {
//            buffer = [self normalFadeInOutWithCIImage:filterInputImage
//                                          destCIImage:nextCIImage
//                                               atSize:CGSizeMake(MXScreenWidth, MXScreenHeight)
//                                         WithProgress:0];
//            if (buffer) {
//
//                //先拼一张图片
//                CMTime presentTime = CMTimeMake((kPhotoShowFrameCount + kPhotoTransitionFrameCount) * index, kFps);
//                BOOL appendSuccess = [self appendToAdapter:adaptor
//                                               pixelBuffer:buffer
//                                                    atTime:presentTime
//                                                 withInput:writerInput];
//
//                NSAssert(appendSuccess, @"Failed to append");
//
//
//                dispatch_apply(kPhotoTransitionFrameCount, queue, ^(size_t count) {
//                    CMTime currentPresentTime = CMTimeMake(index * (kPhotoShowFrameCount + kPhotoTransitionFrameCount) + count, kFps);
//
//                    NSLog(@"%zd  %zd    currentPresentTime = %f", index, count, CMTimeGetSeconds(currentPresentTime));
//                    buffer = [self normalFadeInOutWithCIImage:filterInputImage
//                                                  destCIImage:nextCIImage atSize:CGSizeMake(MXScreenWidth, MXScreenHeight)
//                                                 WithProgress:1.0 * count/kPhotoShowFrameCount];
//
////                    NSLog(@"%@", currentPresentTime);
//                    BOOL appendSuccess = [self appendToAdapter:adaptor
//                                                   pixelBuffer:buffer
//                                                        atTime:currentPresentTime
//                                                     withInput:writerInput];
//
//                    NSAssert(appendSuccess, @"Failed to append");
//                });
//            }
//
//        }
//
//
//    });

    
    for (int i = 0; i < array.count; i++) {
        //入场图片
        CIImage *filterInputImage = [[CIImage alloc] initWithImage:array[i]];
        NSAssert(filterInputImage, @"filterInputImage");
        filterInputImage = [filterInputImage imageByApplyingTransform:CGAffineTransformMakeScale(0.5, 0.5)];

        //出场图片
        UIImage *nextImage = [UIImage imageNamed:@"sample2"];
        CIImage *nextCIImage = [CIImage imageWithCGImage:nextImage.CGImage];
        nextCIImage = [nextCIImage imageByApplyingTransform:CGAffineTransformMakeScale(0.5, 0.5)];

        if(writerInput.isReadyForMoreMediaData){

            buffer = [self normalFadeInOutWithCIImage:filterInputImage
                                          destCIImage:nextCIImage atSize:CGSizeMake(MXScreenWidth, MXScreenHeight) WithProgress:0];

            if (buffer) {
                //append buffer
                CMTime presentTime = CMTimeMake((kPhotoShowFrameCount + kPhotoTransitionFrameCount) * i, kFps);
                //先拼一张图片
                BOOL appendSuccess = [self appendToAdapter:adaptor
                                               pixelBuffer:buffer
                                                    atTime:presentTime
                                                 withInput:writerInput];

                NSAssert(appendSuccess, @"Failed to append");
//                CMTime kFpsTime = CMTimeMake(1, kFps);

//                for (int b = 0; b < kPhotoShowFrameCount; b++) {
//                    presentTime = CMTimeAdd(presentTime, kFpsTime);
//                }
                
                for (double j = 1; j < kPhotoShowFrameCount; j++) {
                    presentTime = CMTimeMake(i * (kPhotoShowFrameCount + kPhotoTransitionFrameCount) + j, kFps);
                    buffer = [self normalFadeInOutWithCIImage:filterInputImage
                                                  destCIImage:nextCIImage atSize:CGSizeMake(MXScreenWidth, MXScreenHeight)
                                                 WithProgress:1.0 * j/kPhotoShowFrameCount];

                    BOOL appendSuccess = [self appendToAdapter:adaptor
                                                   pixelBuffer:buffer
                                                        atTime:presentTime
                                                     withInput:writerInput];
                    CMTime fadeTime = CMTimeMake(1, kFps);
                    presentTime = CMTimeAdd(presentTime, fadeTime);

                    NSAssert(appendSuccess, @"Failed to append");
                }

            }

        }

    }
    //Finish the session:
    [writerInput markAsFinished];
    
    NSLog(@"begin export");
    [videoWriter finishWritingWithCompletionHandler:^{
        NSLog(@"Successfully closed video writer");
        if (videoWriter.status == AVAssetWriterStatusCompleted) {
            if (callbackBlock) {
                callbackBlock(YES);
                UISaveVideoAtPathToSavedPhotosAlbum(tempPath, self, nil, nil);
            }
        } else {
            if (callbackBlock) {
                callbackBlock(NO);
            }
        }
        
        CVPixelBufferPoolRelease(adaptor.pixelBufferPool);
        
        NSLog (@"Done");
    }];
}

- (BOOL)appendToAdapter:(AVAssetWriterInputPixelBufferAdaptor*)adaptor
            pixelBuffer:(CVPixelBufferRef)buffer
                 atTime:(CMTime)presentTime
              withInput:(AVAssetWriterInput*)writerInput
{
//    NSLog(@"seconds = %f", CMTimeGetSeconds(presentTime));
    while (!writerInput.isReadyForMoreMediaData) {
        //        usleep(0.1);
    }
    BOOL flag = [adaptor appendPixelBuffer:buffer withPresentationTime:presentTime];
    
    NSAssert(flag, @"Failed to append");
    if (buffer) {
        CVBufferRelease(buffer);
    }
    return flag;
}

- (CGAffineTransform)GetCGAffineTransformRotateAroundPointWithContextCenterX:(float)centerX CenterY:(float)centerY PointX:(float)x PointY:(float)y angle:(float)angle  {
    x = x - centerX; //计算(x,y)从(0,0)为原点的坐标系变换到(CenterX ，CenterY)为原点的坐标系下的坐标
    y = y - centerY; //(0，0)坐标系的右横轴、下竖轴是正轴,(CenterX,CenterY)坐标系的正轴也一样
    
    CGAffineTransform  trans = CGAffineTransformMakeTranslation(x, y);
    trans = CGAffineTransformRotate(trans,angle);
    trans = CGAffineTransformTranslate(trans,-x, -y);
    return trans;
}

//最普通的 渐隐切换 同时展示时使用镜头放大或缩小 以及平移
- (CVPixelBufferRef)normalFadeInOutWithCIImage:(CIImage *)inputImage
                                   destCIImage:(CIImage *)destImage
                                      atSize:(CGSize)imageSize
                                WithProgress:(CGFloat)progress {
    
    NSDictionary *options = @{(id)kCVPixelBufferCGImageCompatibilityKey: @YES,
                              (id)kCVPixelBufferCGBitmapContextCompatibilityKey: @YES};
    CVPixelBufferRef pxbuffer = NULL;
    CVReturn status = CVPixelBufferCreate(kCFAllocatorDefault, imageSize.width,
                                          imageSize.height, kCVPixelFormatType_32ARGB, (__bridge CFDictionaryRef) options,
                                          &pxbuffer);
    NSParameterAssert(status == kCVReturnSuccess && pxbuffer != NULL);
    
    CVPixelBufferLockBaseAddress(pxbuffer, 0);
    void *pxdata = CVPixelBufferGetBaseAddress(pxbuffer);
    NSParameterAssert(pxdata != NULL);
    
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    
    //第一组滤镜 渐变
    CIFilter *transitionFilter = [CIFilter filterWithName:@"CIDissolveTransition"];
    [transitionFilter setValue:inputImage forKey:@"inputImage"];
    [transitionFilter setValue:destImage forKey:@"inputTargetImage"];
    [transitionFilter setValue:@(progress) forKey:@"inputTime"];
    CIImage *result = transitionFilter.outputImage;
    
    //第二组 移动
    CIFilter *moveFilter = [CIFilter filterWithName:@"CIAffineTransform"];
    [moveFilter setValue:result forKey:kCIInputImageKey];
    CGAffineTransform xform = CGAffineTransformMakeTranslation(0, kFadeTransfer * progress);
    CGAffineTransform secondForm = CGAffineTransformScale(xform, kFadeScale * progress + 1, kFadeScale * progress + 1);
    [moveFilter setValue:[NSValue valueWithBytes:&secondForm objCType:@encode(CGAffineTransform)] forKey:kCIInputTransformKey];
    result = moveFilter.outputImage;
    
    [self.myContext render:result toCVPixelBuffer:pxbuffer bounds:result.extent colorSpace:rgbColorSpace];
    
    CGColorSpaceRelease(rgbColorSpace);
    CVPixelBufferUnlockBaseAddress(pxbuffer, 0);
    return pxbuffer;

}

#pragma mark - Getter & setter

- (CIContext *)myContext {
    if (_myContext == nil) {
        _myContext = [CIContext contextWithOptions:nil];
    }
    return _myContext;
}

@end
