//
//  MXPhotoPickerCollectionViewFlowLayout.m
//  MemoryForYou
//
//  Created by 夏立群 on 2017/11/2.
//  Copyright © 2017年 xialisuper. All rights reserved.
//

#import "MXPhotoPickerCollectionViewFlowLayout.h"

@implementation MXPhotoPickerCollectionViewFlowLayout

- (instancetype)init {
    if (self = [super init]) {
        self.itemSize = CGSizeMake(150, 150);
//        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return self;
}

@end
