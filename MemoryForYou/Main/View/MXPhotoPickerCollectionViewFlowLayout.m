//
//  MXPhotoPickerCollectionViewFlowLayout.m
//  MemoryForYou
//
//  Created by 夏立群 on 2017/11/2.
//  Copyright © 2017年 xialisuper. All rights reserved.
//

#import "MXPhotoPickerCollectionViewFlowLayout.h"

static NSInteger const kNumOfCellsInRow = 4;
static NSInteger const kMargin = 2;

@implementation MXPhotoPickerCollectionViewFlowLayout

- (instancetype)init {
    if (self = [super init]) {
        //同比与系统默认相册 上下间距都是2.
        CGFloat width = (MXScreenWidth - (kNumOfCellsInRow - 1) * 2) / 4;
        self.itemSize = CGSizeMake(width, width);
        self.minimumLineSpacing = kMargin;
        self.minimumInteritemSpacing = kMargin;
        
    }
    return self;
}

@end
