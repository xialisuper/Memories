//
//  MXImagePickerBottomCollectionViewCell.m
//  MemoryForYou
//
//  Created by xialisuper on 2017/11/23.
//  Copyright © 2017年 xialisuper. All rights reserved.
//

#import "MXImagePickerBottomCollectionViewCell.h"
#import "MXPhotoUtil.h"

@interface MXImagePickerBottomCollectionViewCell ()
@property(nonatomic, strong) UIImageView *imageView;
@end

@implementation MXImagePickerBottomCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor darkGrayColor];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.imageView = imageView;
        [self.contentView addSubview:imageView];
    }
    return self;
}

- (void)setModel:(MXImageModel *)model {
    _model = model;
    
    [[MXPhotoUtil sharedInstance] photoUtilFetchThumbnailImageWith:model.photoAsset WithSize:self.contentView.bounds.size synchronous:NO block:^(UIImage *image, NSDictionary *info) {
        self.imageView.image = image;
    }];
}

@end
