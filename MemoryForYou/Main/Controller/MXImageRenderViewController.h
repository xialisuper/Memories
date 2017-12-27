//
//  MXImageRenderViewController.h
//  MemoryForYou
//
//  Created by xialisuper on 2017/12/22.
//  Copyright © 2017年 xialisuper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>
@class MXImageModel;
@interface MXImageRenderViewController : GLKViewController
@property(nonatomic, strong) NSArray <MXImageModel *>*photoArray;

@end
