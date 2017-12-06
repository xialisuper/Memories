//
//  MXVideoUtil.m
//  MemoryForYou
//
//  Created by xialisuper on 2017/12/6.
//  Copyright © 2017年 xialisuper. All rights reserved.
//

#import "MXVideoUtil.h"
#import <AVFoundation/AVFoundation.h>

@implementation MXVideoUtil

//- (void)createVideoWithArrayImages:(NSMutableArray*)images size:(CGSize)size time:(float)time output:(NSURL*)output {
//    //getting a random path
//    NSError *error;
//
//    AVAssetWriter *videoWriter  = [[AVAssetWriter alloc] initWithURL:output fileType:AVFileTypeMPEG4 error: &error];
//    NSDictionary *videoSettings = [NSDictionary dictionaryWithObjectsAndKeys: AVVideoCodecH264, AVVideoCodecKey,
//                                   [NSNumber numberWithInt:size.width], AVVideoWidthKey,
//                                   [NSNumber numberWithInt:size.height], AVVideoHeightKey,
//                                   nil];
//
//    AVAssetWriterInput* videoWriterInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo outputSettings:videoSettings];
//
//    AVAssetWriterInputPixelBufferAdaptor *adaptor = [AVAssetWriterInputPixelBufferAdaptor  assetWriterInputPixelBufferAdaptorWithAssetWriterInput: videoWriterInput sourcePixelBufferAttributes:nil];
//
//    videoWriterInput.expectsMediaDataInRealTime = YES;
//    [videoWriter addInput: videoWriterInput];
//    [videoWriter startWriting];
//    [videoWriter startSessionAtSourceTime:kCMTimeZero];
//
//
//    CVPixelBufferRef buffer = NULL;
//    //convert uiimage to CGImage.
//
//    //convert uiimage to CGImage.
//    NSInteger fps   = 30;
//    int frameCount  = 0;
//
//    for(UIImage *img  in images) {
//        //for(VideoFrame * frm in imageArray)
//        NSLog(@"**************************************************");
//        //UIImage * img = frm._imageFrame;
//        buffer                          = [self videoPixelBufferFromCGImage:[img CGImage] andSize:size andAngle:(int)[images indexOfObject:img]];
//        double numberOfSecondsPerFrame  = time / images.count;
//        double frameDuration            = fps * numberOfSecondsPerFrame;
//
//        BOOL append_ok  = NO;
//        int j           = 0;
//
//        while (!append_ok && j < fps) {
//            if (adaptor.assetWriterInput.readyForMoreMediaData) {
//                //print out status:
//                NSLog(@"Processing video frame (%d,%d)",frameCount,(int)[images count]);
//
//                CMTime frameTime    = CMTimeMake(frameCount * frameDuration,(int32_t) fps);
//                NSLog(@"Frame Time  : %f", CMTimeGetSeconds(frameTime));
//                append_ok           = [adaptor appendPixelBuffer:buffer withPresentationTime:frameTime];
//                if(!append_ok) {
//                    NSError *error = videoWriter.error;
//                    if(error!=nil) {
//                        NSLog(@"Unresolved error %@,%@.", error, [error userInfo]);
//                    }
//                }
//            }
//            else {
//                printf("adaptor not ready %d, %d\n", frameCount, j);
//                [NSThread sleepForTimeInterval:0.1];
//            }
//            j++;
//        }
//        if (!append_ok) {
//            printf("error appending image %d times %d\n, with error.", frameCount, j);
//        }
//        frameCount++;
//        NSLog(@"**************************************************");
//    }
//
//    [videoWriterInput markAsFinished];
//    [videoWriter finishWriting];
//
//    videoWriter = nil;
//    if(buffer != NULL)
//        CVPixelBufferRelease(buffer);
//    NSLog(@"************ write standard video successful ************");
//}
//
//- (CVPixelBufferRef)videoPixelBufferFromCGImage: (CGImageRef) image andSize:(CGSize) size andAngle:(int)angle {
//    NSDictionary *options       = [NSDictionary dictionaryWithObjectsAndKeys: [NSNumber numberWithBool:YES], kCVPixelBufferCGImageCompatibilityKey, [NSNumber numberWithBool:YES],kCVPixelBufferCGBitmapContextCompatibilityKey, nil];
//
//    CVPixelBufferRef pxbuffer   = NULL;
//    CVReturn status             = CVPixelBufferCreate(kCFAllocatorDefault, size.width, size.height, kCVPixelFormatType_32ARGB, (__bridge CFDictionaryRef) options, &pxbuffer);
//
//    NSParameterAssert(status == kCVReturnSuccess && pxbuffer != NULL);
//
//    CVPixelBufferLockBaseAddress(pxbuffer, 0);
//    void *pxdata = CVPixelBufferGetBaseAddress(pxbuffer);
//    NSParameterAssert(pxdata != NULL);
//
//    CGColorSpaceRef rgbColorSpace   = CGColorSpaceCreateDeviceRGB();
//    CGContextRef context            = CGBitmapContextCreate(pxdata, size.width, size.height, 8, 4*size.width, rgbColorSpace, kCGImageAlphaPremultipliedFirst);
//    NSParameterAssert(context);
//    CGContextConcatCTM(context, CGAffineTransformMakeRotation(0));
//    CGContextDrawImage(context, CGRectMake(0, 0, size.width, size.height), image);
//    CGColorSpaceRelease(rgbColorSpace);
//    CGContextRelease(context);
//    CVPixelBufferUnlockBaseAddress(pxbuffer, 0);
//
//    return pxbuffer;
//}
//
//{
//    AVMutableAudioMix *exportAudioMix = [AVMutableAudioMix audioMix];
//    AVAssetTrack *assetTrack = [[asset tracksWithMediaType:AVMediaTypeAudio]objectAtIndex:0];
//    AVMutableAudioMixInputParameters *exportAudioMixInputParameters = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:assetTrack];
//    exportAudioMixInputParameters.trackID = [[[asset tracksWithMediaType:AVMediaTypeAudio]objectAtIndex:0] trackID];
//    NSMutableArray* inputParameters = [NSMutableArray arrayWithCapacity:1];
//
//    CMTime startFadeInTime = start;
//    CMTime endFadeInTime = CMTimeMake((startTime+2)*100, 100);
//    CMTime startFadeOutTime = CMTimeMake((time-2)*100, 100);
//    CMTime endFadeOutTime = CMTimeMake(time*100, 100);
//
//    CMTimeRange fadeInTimeRange = CMTimeRangeFromTimeToTime(startFadeInTime, endFadeInTime);
//    CMTimeRange fadeOutTimeRange = CMTimeRangeFromTimeToTime(startFadeOutTime, endFadeOutTime);
//    [exportAudioMixInputParameters setVolumeRampFromStartVolume:0.0 toEndVolume:1.0 timeRange:fadeInTimeRange];
//    [exportAudioMixInputParameters setVolumeRampFromStartVolume:1.0 toEndVolume:0.0 timeRange:fadeOutTimeRange];
//
//    [inputParameters insertObject:exportAudioMixInputParameters atIndex:0];
//}

@end
