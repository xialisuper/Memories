//
//  MXImage3DPreviewViewController.m
//  MemoryForYou
//
//  Created by xialisuper on 2017/11/9.
//  Copyright © 2017年 xialisuper. All rights reserved.
//

#import "MXImage3DPreviewViewController.h"

#import "MXPhotoUtil.h"
#import <Masonry.h>

@interface MXImage3DPreviewViewController ()
@end

@implementation MXImage3DPreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - getter
- (UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.view addSubview:_imageView];
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(10, 10, 10, 10));
            make.top.left.right.bottom.equalTo(self.view);
        }];
    }
    return _imageView;
}

- (void)setModel:(MXImageModel *)model {
    _model = model;
//    [[MXPhotoUtil sharedInstance] photoUtilFetchThumbnailImageWith:model.photoAsset
//                                                          WithSize:self.view.bounds.size
//                                                             block:^(UIImage *image, NSDictionary *info) {
//        self.imageView.image = image;
//    }];
    
    [[MXPhotoUtil sharedInstance] photoUtilFetchOriginImageWith:model.photoAsset synchronous:YES block:^(UIImage *image) {
        self.imageView.image = image;
    }];
}

@end
