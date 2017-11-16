//
//  MXImage3DPreviewViewController.h
//  MemoryForYou
//
//  Created by xialisuper on 2017/11/9.
//  Copyright © 2017年 xialisuper. All rights reserved.
//

#import "MXBaseViewController.h"
@class MXImageModel;
@interface MXImage3DPreviewViewController : MXBaseViewController

@property(nonatomic, strong) MXImageModel *model;
@property(nonatomic, strong) UIImageView *imageView;

@end
