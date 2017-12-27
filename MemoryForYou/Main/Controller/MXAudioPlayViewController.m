//
//  MXAudioPlayViewController.m
//  MemoryForYou
//
//  Created by 夏立群 on 2017/9/30.
//  Copyright © 2017年 xialisuper. All rights reserved.
//

#import "MXAudioPlayViewController.h"
#import "MXPhotoUtil.h"
#import "MXVideoUtil.h"
#import "LLAVPlayerView.h"
#import <Masonry.h>

@interface MXAudioPlayViewController ()
@property(nonatomic, strong) LLAVPlayerView *avplayerView;

@end

@implementation MXAudioPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self showVideo];
}

#pragma mark - UI


#pragma mark - method

- (void)testPlayVideo {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"rzjt" ofType:@"MP4"];
    NSURL *testUrl = [NSURL fileURLWithPath:filePath];

    [self.avplayerView playWith:testUrl];
    
}

- (void)showVideo {
    if (!self.photoesArray.count) {
        NSLog(@"audioPlayerVc no pohotoArray ");
        return;
    }
    
    [self handlePhotoToVideoWithArray:self.photoesArray withBlock:^(BOOL success) {
        if (!success) {
            NSLog(@"error");
        } else {
            NSLog(@"success");
            dispatch_async(dispatch_get_main_queue(), ^{
                // 更新界面
                NSString *tempPath = [NSTemporaryDirectory() stringByAppendingPathComponent:
                                      [NSString stringWithFormat:@"temp.mp4"]];
                NSURL *videoURL = [NSURL fileURLWithPath:tempPath];
                [self.avplayerView playWith:videoURL];
            });
        }
    }];
}



- (void)handlePhotoToVideoWithArray:(NSArray <MXImageModel *>*)photoArray withBlock:(void (^)(BOOL success))block {
    
    [[MXVideoUtil sharedInstance] writeImageAsMovie:photoArray WithBlock:^(BOOL success) {
        block(success);
    }];
}

#pragma mark - getter & setter

- (LLAVPlayerView *)avplayerView {
    if (_avplayerView == nil) {
        CGRect viewRect = CGRectMake(0, MXSafeAreaTopHeight, MXScreenWidth, MXScreenHeight * 0.5);
        _avplayerView = [[LLAVPlayerView alloc] initWithFrame:viewRect];
        [self.view addSubview:_avplayerView];
        
    }
    return _avplayerView;
}



@end
