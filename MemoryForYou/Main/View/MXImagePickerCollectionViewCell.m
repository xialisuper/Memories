//
//  MXImagePickerCollectionViewCell.m
//  MemoryForYou
//
//  Created by 夏立群 on 2017/11/2.
//  Copyright © 2017年 xialisuper. All rights reserved.
//

#import "MXImagePickerCollectionViewCell.h"
#import "MXPhotoUtil.h"
#import "MXImageModel.h"
#import <ReactiveCocoa.h>

#define selectedColor COLOR_W(255, 0.5)
#define deselectedColor [UIColor clearColor]

@interface MXImagePickerCollectionViewCell ()
@property(nonatomic, strong) UIView *coverView;

@end

@implementation MXImagePickerCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initImageView];
        self.contentView.backgroundColor = [UIColor darkGrayColor];
        //监听数据model的属性. 变化UI.
//        @WeakObj(self);
//        RACSignal *signal = [RACObserve(self.imageModel, selected) deliverOnMainThread];
//        [signal subscribeNext:^(NSNumber *selected){
//            
//            @StrongObj(self);
//            [self updateSelectedUI:[selected intValue]];
//        }];
    }
    return self;
}

- (void)initImageView {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
    self.imageView = imageView;
    [self.contentView addSubview:imageView];
    
    //照片上的蒙版 选中模式为半透明 非选中模式为透明
    UIView *coverView = [[UIView alloc] initWithFrame:self.contentView.bounds];
    self.coverView = coverView;
    [imageView addSubview:coverView];
    coverView.backgroundColor = deselectedColor;
    
}

- (void)setImageModel:(MXImageModel *)imageModel {
    _imageModel = imageModel;
    
    [self updateSelectedUI:imageModel.isSelected];
    PHAsset *asset = imageModel.photoAsset;

    @WeakObj(self);
    
    [[MXPhotoUtil sharedInstance] photoUtilFetchThumbnailImageWith:asset WithSize:self.contentView.bounds.size synchronous:(BOOL)NO block:^(UIImage *image, NSDictionary *info) {
        @StrongObj(self);
        self.imageView.image = image;
    }];
}

- (void)updateSelectedUI:(BOOL)selected {
    //显示被选中的白色半透明蒙版
    if (selected) {
        self.coverView.backgroundColor = selectedColor;
    } else {
        self.coverView.backgroundColor = deselectedColor;
    }
}



@end
