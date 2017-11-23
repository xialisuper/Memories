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

@interface MXImagePickerCollectionViewCell ()
@property(nonatomic, strong) UIView *coverWhiteView;
@end

@implementation MXImagePickerCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initImageView];
        self.contentView.backgroundColor = [UIColor darkGrayColor];
    }
    return self;
}

- (void)initImageView {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
    self.imageView = imageView;
    [self.contentView addSubview:imageView];
}

- (void)setImageModel:(MXImageModel *)imageModel {
    _imageModel = imageModel;
    
    [self updateSelectedUI:imageModel.isSelected];
    PHAsset *asset = imageModel.photoAsset;

    @WeakObj(self);
    
    //监听数据model的属性. 变化UI.
    RACSignal *signal = [RACObserve(imageModel, selected) deliverOnMainThread];
    [signal subscribeNext:^(NSNumber *selected){
        
        @StrongObj(self);
        [self updateSelectedUI:[selected intValue]];
    }];
    
    [[MXPhotoUtil sharedInstance] photoUtilFetchThumbnailImageWith:asset WithSize:self.contentView.bounds.size synchronous:(BOOL)NO block:^(UIImage *image, NSDictionary *info) {
        @StrongObj(self);
        self.imageView.image = image;
    }];
}

- (void)updateSelectedUI:(BOOL)selected {
    //显示被选中的白色半透明蒙版
    if (selected) {
        UIView *coverWhiteView = [[UIView alloc] initWithFrame:self.contentView.bounds];
        self.coverWhiteView = coverWhiteView;
        [self.contentView addSubview:coverWhiteView];
        coverWhiteView.backgroundColor = COLOR_W(255, 0.5);
    } else {
        [self.coverWhiteView removeFromSuperview];
    }
}



@end
