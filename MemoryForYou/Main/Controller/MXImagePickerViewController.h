//
//  MXImagePickerViewController.h
//  MemoryForYou
//
//  Created by 夏立群 on 2017/11/2.
//  Copyright © 2017年 xialisuper. All rights reserved.
//

#import "MXBaseViewController.h"

@class MXImageModel;
@protocol MXImagePickerViewControllerDelegate <NSObject>
@optional

/**
 选中数组被更新

 @param selectedPhotosArray 选中的模型数组
 */
- (void)imagePickerViewControllerDidChangeSelectedPhotosArray:(NSMutableArray<MXImageModel *> *)selectedPhotosArray;

/**
 增加选中图片

 @param model 被选中的model
 */
- (void)imagePickerViewControllerAddModel:(MXImageModel *)model;

/**
 移除图片

 @param model 被移除的model
 */
- (void)imagePickerViewControllerRemoveModel:(MXImageModel *)model;

@end

@interface MXImagePickerViewController : MXBaseViewController

@property(nonatomic, strong) UICollectionView *photoCollectionView;
@property(nonatomic, strong, readonly) NSIndexPath *currentSelectedIndexPath;
@property(nonatomic, weak) id <MXImagePickerViewControllerDelegate> delegate;

@end
