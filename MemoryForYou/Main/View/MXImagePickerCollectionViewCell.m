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

@interface MXImagePickerCollectionViewCell ()
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
    
    PHAsset *asset = imageModel.photoAsset;
    
    @WeakObj(self);
    [[MXPhotoUtil sharedInstance] photoUtilFetchThumbnailImageWith:asset WithSize:self.contentView.bounds.size synchronous:(BOOL)NO block:^(UIImage *image, NSDictionary *info) {
        @StrongObj(self);
        self.imageView.image = image;
    }];
}

@end
