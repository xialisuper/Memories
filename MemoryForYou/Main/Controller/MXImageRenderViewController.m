//
//  MXImageRenderViewController.m
//  MemoryForYou
//
//  Created by xialisuper on 2017/12/22.
//  Copyright © 2017年 xialisuper. All rights reserved.
//

#import "MXImageRenderViewController.h"
#import "MXFilterUtil.h"
#import "MXTransitonFilterModel.h"
#import "MXVideoModel.h"

static NSInteger const kFPS = 60;
static NSUInteger const kPhotoShowFrameCount = 2 * kFPS;
static NSUInteger const kPhotoTransitonFrameCount = kFPS / 2;

@interface MXImageRenderViewController ()
@property(nonatomic, strong) CIContext *ciContext;
@property(nonatomic, strong) EAGLContext *eaglContext;
//当前帧的时间轴定位 单位:秒
@property(nonatomic, assign) NSTimeInterval currentTime;
//当前帧显示的图片bn
@property(nonatomic, strong) CIImage *currentImage;
//当前播放的视频模型
@property(nonatomic, strong) MXVideoModel *videoModel;

@end

@implementation MXImageRenderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self initGLKView];
    self.preferredFramesPerSecond = kFPS;
    self.eaglContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    self.ciContext = [CIContext
                      contextWithEAGLContext:self.eaglContext
                      options: @{kCIContextWorkingColorSpace:[NSNull null]} ];
    
    GLKView *view = (GLKView *)self.view;
    view.context = self.eaglContext;
    
    [EAGLContext setCurrentContext:self.eaglContext];
    
    self.currentTime = 0;
}



- (void)update {
//    NSTimeInterval currentTime = self.timeSinceFirstResume;
//    [self glkView:(GLKView *)self.view drawInRect:self.view.bounds];
    //0.000000 0.050123 0.000000 0.049994
//    NSLog(@"%f %f %f %f ", currentTime, self.timeSinceLastDraw, self.timeSinceLastResume, self.timeSinceLastUpdate);
    _currentTime += self.timeSinceLastUpdate;
    
    //确定是哪一张图 是什么动画
    _currentImage = [self.videoModel imageWithTime:_currentTime];
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
//    glClearColor(150.0/255.0, 200.0/255.0, 255.0/255.0, 1.0);
//    glClear(GL_COLOR_BUFFER_BIT);
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_async(queue, ^{
//
//        // 遷移前後の画像をtimeによって切り替える
//        float t = 0.4 * ([NSDate timeIntervalSinceReferenceDate] - base);
//
//        CIImage *image = [self imageForTransitionAtTime:t];
//
//        // 描画領域を示す矩形
//        CGFloat scale = [[UIScreen mainScreen] scale];
//        CGRect destRect = CGRectMake(0, self.bounds.size.height * scale - imageRect.size.height,
//                                     imageRect.size.width,
//                                     imageRect.size.height);
//
//        dispatch_async(dispatch_get_main_queue(), ^{
//
//            [self.myContext drawImage:image
//                               inRect:destRect
//                             fromRect:imageRect];
//        });
//    });

    glClear(GL_COLOR_BUFFER_BIT);
    [self.ciContext drawImage:self.currentImage
                       inRect:CGRectMake(0, 0, MXScreenWidth * ScreenScale, MXScreenHeight * ScreenScale)
                     fromRect:CGRectMake(0, 0, MXScreenWidth * ScreenScale, MXScreenHeight * ScreenScale)];
}

#pragma mark - getter & setter
- (void)setPhotoArray:(NSArray<MXImageModel *> *)photoArray {
    _photoArray = photoArray;
    self.videoModel = [[MXVideoModel alloc] initNormalModelWithImages:photoArray];
    
    NSLog(@"%@", self.videoModel.modelArray);
}








@end
