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
    self.paused = YES;
    
    //设置导航控制 播放全屏
    self.navigationController.hidesBarsOnTap = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.hidesBarsOnTap = NO;
}

- (void)update {
    //0.000000 0.050123 0.000000 0.049994
//    NSLog(@"%f %f %f %f ", currentTime, self.timeSinceLastDraw, self.timeSinceLastResume, self.timeSinceLastUpdate);
    _currentTime += self.timeSinceLastUpdate;
    
    //确定是哪一张图 是什么动画
    _currentImage = [self.videoModel imageWithTime:_currentTime];
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
//    glClearColor(150.0/255.0, 200.0/255.0, 255.0/255.0, 1.0);
//    glClear(GL_COLOR_BUFFER_BIT);

    if (self.currentImage == nil) {
        self.paused = YES;
        
    } else {
        glClear(GL_COLOR_BUFFER_BIT);
        [self.ciContext drawImage:self.currentImage
                           inRect:CGRectMake(0, 0, MXScreenWidth * ScreenScale, MXScreenHeight * ScreenScale)
                         fromRect:CGRectMake(0, 0, MXScreenWidth * ScreenScale, MXScreenHeight * ScreenScale)];

    }
}

#pragma mark - getter & setter
- (void)setPhotoArray:(NSArray<MXImageModel *> *)photoArray {
    _photoArray = photoArray;
    
    [[MXVideoModel alloc] loadDataWithImages:photoArray style:MXVideoModelStyleDissolve completionBlock:^(MXVideoModel *model) {
        self.videoModel = model;
        
        self.paused = NO;
        
    }];
    
}

- (void)setPaused:(BOOL)paused {
    [super setPaused:paused];
    if (paused) {
        NSLog(@"渲染暂停");
    } else {
        NSLog(@"开始渲染");
    }
}







@end
