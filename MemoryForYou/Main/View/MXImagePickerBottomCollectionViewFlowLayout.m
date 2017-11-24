//
//  MXImagePickerBottomCollectionViewFlowLayout.m
//  MemoryForYou
//
//  Created by xialisuper on 2017/11/23.
//  Copyright © 2017年 xialisuper. All rights reserved.
//

#import "MXImagePickerBottomCollectionViewFlowLayout.h"

static CGFloat const kCellWidth = 44.0;
static NSInteger const kMargin = 2;

@implementation MXImagePickerBottomCollectionViewFlowLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.itemSize = CGSizeMake(kCellWidth, kCellWidth);
        self.minimumInteritemSpacing = kMargin;
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return self;
}


- (void)prepareLayout {
    [super prepareLayout];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 2;
}


//滑动吸附效果
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    //1.计算scrollview最后停留的范围
    CGRect lastRect ;
    lastRect.origin = proposedContentOffset;
    lastRect.size = self.collectionView.frame.size;
    
    //2.取出这个范围内的所有属性
    NSArray *array = [self layoutAttributesForElementsInRect:lastRect];
    
    //起始的x值，也即默认情况下要停下来的x值
    CGFloat startX = proposedContentOffset.x;
    
    //3.遍历所有的属性
    CGFloat adjustOffsetX = MAXFLOAT;
    for (UICollectionViewLayoutAttributes *attrs in array) {
        CGFloat attrsX = CGRectGetMinX(attrs.frame);
        CGFloat attrsW = CGRectGetWidth(attrs.frame) ;
        
        if (startX - attrsX  < attrsW/2) {
            adjustOffsetX = -(startX - attrsX + kMargin);
        }else{
            adjustOffsetX = attrsW - (startX - attrsX);
        }
        
        break ;//只循环数组中第一个元素即可，所以直接break了
    }
    return CGPointMake(proposedContentOffset.x + adjustOffsetX, proposedContentOffset.y);

}

@end
