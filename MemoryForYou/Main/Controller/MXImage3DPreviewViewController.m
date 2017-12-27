//
//  MXImage3DPreviewViewController.m
//  MemoryForYou
//
//  Created by xialisuper on 2017/11/9.
//  Copyright © 2017年 xialisuper. All rights reserved.
//

#import "MXImage3DPreviewViewController.h"
#import "MXImagePreviewAnimationTransition.h"

#import "MXPhotoUtil.h"
#import <Masonry.h>

@interface MXImage3DPreviewViewController ()
@property(nonatomic, strong) MXImagePreviewAnimationTransition *animatedTransition;
@property(nonatomic, strong) UIPanGestureRecognizer *panGesture;
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
//        _imageView.backgroundColor = [UIColor yellowColor];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.userInteractionEnabled = YES;
        [self.view addSubview:_imageView];
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(self.view);
        }];
        
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
        self.panGesture = panGesture;
        [_imageView addGestureRecognizer:panGesture];

        
    }
    return _imageView;
}

- (void)setModel:(MXImageModel *)model {
    _model = model;
    
    [[MXPhotoUtil sharedInstance] photoUtilFetchOriginImageWith:model.photoAsset
                                                    synchronous:YES
                                                          block:^(UIImage *image) {
        self.imageView.image = image;
    }];
}

- (MXImagePreviewAnimationTransition *)animatedTransition {
    if (_animatedTransition == nil) {
        _animatedTransition = [[MXImagePreviewAnimationTransition alloc] init];
        self.navigationController.delegate = _animatedTransition;
    }
    return _animatedTransition;
}

#pragma mark - method

- (void)handlePanGesture:(UIPanGestureRecognizer *)panGesture {
    
    [self.animatedTransition handleInteractionGesture:panGesture withViewController:self];
    
    CGPoint originImageViewCenter = self.view.center;
    //计算图片缩放
    CGPoint translation = [panGesture translationInView:panGesture.view];
    
    //缩放系数
    CGFloat scale = 1 - (0.3 * translation.y / MXScreenHeight);
    scale = scale > 1 ? 1 : scale;
//    NSLog(@"scale = %f", scale);
    
    //y < 0 向上拖拽
    CGPoint velocityPoint = [panGesture velocityInView:panGesture.view];
    
    switch (panGesture.state) {
        case UIGestureRecognizerStatePossible:
            break;
        case UIGestureRecognizerStateBegan: {
//            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
        case UIGestureRecognizerStateChanged: {
            self.imageView.center = CGPointMake(originImageViewCenter.x + translation.x * scale, originImageViewCenter.y + translation.y * scale);
            self.imageView.transform = CGAffineTransformMakeScale(scale, scale);
        }
            break;
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded: {
            
            if (velocityPoint.y <= 0) {    //向上滑动
                [UIView animateWithDuration:.2f animations:^{
                    self.imageView.center = self.view.center;
                    self.imageView.transform = CGAffineTransformMakeScale(1, 1);
                } completion:^(BOOL finished) {
                    self.imageView.transform = CGAffineTransformIdentity;
                }];
            } else {    //向下滑动
//                __block UIImage *tempImage = nil;
//                [[MXPhotoUtil sharedInstance] photoUtilFetchThumbnailImageWith:self.model.photoAsset WithSize:self.model.cellRect.size synchronous:(BOOL)YES block:^(UIImage *image, NSDictionary *info) {
//                        tempImage = image;
//
//                }];
                [UIView animateWithDuration:.2f animations:^{
                
                    self.imageView.frame = self.model.cellRect;
//                    self.imageView.image  = tempImage;
                } completion:^(BOOL finished) {
                    
                }];
            }
        }
            break;

        default:
            break;
    }
}


@end
