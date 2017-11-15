//
//  MXImagePickerCollectionViewCell.h
//  MemoryForYou
//
//  Created by 夏立群 on 2017/11/2.
//  Copyright © 2017年 xialisuper. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MXImageModel;

@interface MXImagePickerCollectionViewCell : UICollectionViewCell
@property(nonatomic, strong) MXImageModel *imageModel;
//转场动画需要暴露属性.其他不要操纵.
@property(nonatomic, strong) UIImageView *imageView;
@end
