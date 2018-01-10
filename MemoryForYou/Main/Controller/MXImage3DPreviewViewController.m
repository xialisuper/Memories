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
@property(nonatomic, strong) UIImageView *fakeImageView;
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

- (UIImageView *)fakeImageView {
    if (_fakeImageView == nil) {
        _fakeImageView = [[UIImageView alloc] init];
        [self.view addSubview:_fakeImageView];
        _fakeImageView.contentMode = UIViewContentModeScaleAspectFill;
        _fakeImageView.clipsToBounds = YES;
    }
    return _fakeImageView;
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
//            NSLog(@"开始拖拽的frame %@ %@", NSStringFromCGRect(self.imageView.frame), NSStringFromCGRect(self.view.frame));
            
            self.imageView.hidden = YES;
            self.fakeImageView.hidden = NO;
            self.fakeImageView.frame = [self.model mainScreenFrame];
            
//            [[MXPhotoUtil sharedInstance] photoUtilFetchThumbnailImageWith:self.model.photoAsset WithSize:self.model.cellRect.size synchronous:(BOOL)YES block:^(UIImage *image, NSDictionary *info) {
//                self.fakeImageView.image = image;
//
//            }];
            self.fakeImageView.image = self.imageView.image;
        }
            break;
        case UIGestureRecognizerStateChanged: {
        
            
            CGAffineTransform moveTransform = CGAffineTransformTranslate(CGAffineTransformIdentity, translation.x * scale, translation.y * scale);
            CGAffineTransform scaleTransform = CGAffineTransformMakeScale(scale, scale);
            CGAffineTransform combineTransform = CGAffineTransformConcat(moveTransform, scaleTransform);
            self.fakeImageView.transform = combineTransform;
            
//            self.imageView.center = CGPointMake(originImageViewCenter.x + translation.x * scale, originImageViewCenter.y + translation.y * scale);
//            self.imageView.transform = CGAffineTransformMakeScale(scale, scale);
//            NSLog(@"%@", NSStringFromCGAffineTransform(self.imageView.transform));
        }
            break;
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded: {
            
            if (velocityPoint.y <= 0) {    //向上滑动 取消动画
                [UIView animateWithDuration:.2f animations:^{
                    self.fakeImageView.center = self.imageView.center;
                    self.fakeImageView.transform = CGAffineTransformMakeScale(1, 1);
                } completion:^(BOOL finished) {
                    self.fakeImageView.transform = CGAffineTransformIdentity;
                    self.fakeImageView.hidden = YES;
                    self.imageView.hidden = NO;
                }];
            } else {    //向下滑动
                
                
                [UIView animateWithDuration:.2f animations:^{
                    
//                    [[MXPhotoUtil sharedInstance] photoUtilFetchThumbnailImageWith:self.model.photoAsset WithSize:self.model.cellRect.size synchronous:(BOOL)YES block:^(UIImage *image, NSDictionary *info) {
//                        self.imageView.image = image;
//
//                    }];
                    
                    self.fakeImageView.frame = self.model.cellRect;
                } completion:^(BOOL finished) {
//                    self.fakeImageView.hidden = YES;
//                    self.imageView.hidden = NO;
                }];
                
            }
        }
            break;

        default:
            break;
    }
}


- (CGRect)convertRect:(CGRect)rect withTransform:(CGAffineTransform)transform {
    double xMin = rect.origin.x;
    double xMax = rect.origin.x + rect.size.width;
    double yMin = rect.origin.y;
    double yMax = rect.origin.y + rect.size.height;
    
    NSArray *points = @[
                        @(CGPointApplyAffineTransform(CGPointMake(xMin, yMin), transform)),
                        @(CGPointApplyAffineTransform(CGPointMake(xMin, yMax), transform)),
                        @(CGPointApplyAffineTransform(CGPointMake(xMax, yMin), transform)),
                        @(CGPointApplyAffineTransform(CGPointMake(xMax, yMax), transform))
                        ];
    
    double newXMin =  INFINITY;
    double newXMax = -INFINITY;
    double newYMin =  INFINITY;
    double newYMax = -INFINITY;
    
    for (int i = 0; i < 4; i++) {
        newXMax = MAX(newXMax, [points[i] CGPointValue].x);
        newYMax = MAX(newYMax, [points[i] CGPointValue].y);
        newXMin = MIN(newXMin, [points[i] CGPointValue].x);
        newYMin = MIN(newYMin, [points[i] CGPointValue].y);
    }
    
    CGRect result = CGRectMake(newXMin, newYMin, newXMax - newXMin, newYMax - newYMin);
    return result;
}


@end
