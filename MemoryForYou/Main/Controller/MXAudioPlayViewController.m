//
//  MXAudioPlayViewController.m
//  MemoryForYou
//
//  Created by 夏立群 on 2017/9/30.
//  Copyright © 2017年 xialisuper. All rights reserved.
//

#import "MXAudioPlayViewController.h"
#import "MXPhotoUtil.h"

@interface MXAudioPlayViewController ()

@end

@implementation MXAudioPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[MXPhotoUtil sharedInstance] requestAuthorizationStatusWithBlock:^(PHAuthorizationStatus status) {
        if (status == PHAuthorizationStatusAuthorized) {
            NSLog(@"获得了相册权限");
            
            [[MXPhotoUtil sharedInstance] fetchAllPhotosWithResultsWithBlock:^(NSArray<PHAsset *> *assetsArray) {
                NSLog(@"assetsArray.count %lu", (unsigned long)assetsArray.count);
            }];
        }
        
        
        
    }];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

@end
