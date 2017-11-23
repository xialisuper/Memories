//
//  MXImagePickerViewController.h
//  MemoryForYou
//
//  Created by 夏立群 on 2017/11/2.
//  Copyright © 2017年 xialisuper. All rights reserved.
//

#import "MXBaseViewController.h"

@interface MXImagePickerViewController : MXBaseViewController

@property(nonatomic, strong) UICollectionView *photoCollectionView;
@property(nonatomic, strong, readonly) NSIndexPath *currentSelectedIndexPath;
@end
