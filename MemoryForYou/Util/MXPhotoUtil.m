//
//  MXPhotoUtil.m
//  MemoryForYou
//
//  Created by 夏立群 on 2017/9/30.
//  Copyright © 2017年 xialisuper. All rights reserved.
//

#import "MXPhotoUtil.h"
#import "MXImageModel.h"
#import <Photos/Photos.h>

@interface MXPhotoUtil ()
@property(nonatomic, strong) PHCachingImageManager *manager;

@end
@implementation MXPhotoUtil

+ (instancetype)sharedInstance {
    
    static MXPhotoUtil *util;
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        
        util = [MXPhotoUtil new];
        
        PHCachingImageManager *manager = [[PHCachingImageManager alloc] init];
        util.manager = manager;
    });
    
    return util;
}


#pragma mark - method

- (PHAuthorizationStatus)updateAuthorization {
    __block PHAuthorizationStatus currentStatus;
    [self requestAuthorizationStatusWithBlock:^(PHAuthorizationStatus status) {
        currentStatus = status;
    }];
    return currentStatus;
}

- (void)requestAuthorizationStatusWithBlock:(void (^)(PHAuthorizationStatus))block {
    
    if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusNotDetermined) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            block(status);
        }];
    }else {
        block([PHPhotoLibrary authorizationStatus]);
    }
}

- (void)fetchAllAlbums {
    // 列出所有相册智能相册
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum
                                                                          subtype:PHAssetCollectionSubtypeAlbumRegular
                                                                          options:nil];
    
    // 列出所有用户创建的相册
    PHFetchResult *topLevelUserCollections = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    
    // 获取所有资源的集合，并按资源的创建时间排序
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    PHFetchResult *assetsFetchResults = [PHAsset fetchAssetsWithOptions:options];

}

- (void)fetchAllPhotosWithResultsWithBlock:(void (^)(NSArray<MXImageModel *> *))block {
    // 列出所有相册智能相册
    __block NSMutableArray *assetsArray = [NSMutableArray array];
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum
                                                                          subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary
                                                                          options:nil];
    
    // 这时 smartAlbums 中保存的应该是各个智能相册对应的 PHAssetCollection
    for (NSInteger i = 0; i < smartAlbums.count; i++) {
        // 获取一个相册（PHAssetCollection）
        PHCollection *collection = smartAlbums[i];
        if ([collection isKindOfClass:[PHAssetCollection class]]) {
            PHAssetCollection *assetCollection = (PHAssetCollection *)collection;
            // 从每一个智能相册中获取到的 PHFetchResult 中包含的才是真正的资源（PHAsset）
            NSLog(@" %ld, %ld", assetCollection.assetCollectionType, assetCollection.assetCollectionSubtype);
            // 获取所有资源的集合，并按资源的创建时间排序
            PHFetchOptions *options = [[PHFetchOptions alloc] init];
            options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate"
                                                                      ascending:YES]];
            
            PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection
                                                                       options:options];
            // 这时 assetsFetchResults 中包含的，应该就是各个资源（PHAsset）
            for (NSInteger i = 0; i < fetchResult.count; i++) {
                // 获取一个资源（PHAsset）
                PHAsset *asset = fetchResult[i];
                if (asset.mediaType == PHAssetMediaTypeImage) {
                    NSLog(@"%@", asset);
                    MXImageModel *model = [[MXImageModel alloc] initWithPhAsset:asset];
                    [assetsArray addObject:model];
                }
            }
            
        } else {
            NSAssert(NO, @"Fetch collection not PHCollection: %@", collection);
        }
    }
    block(assetsArray);
    
}

- (UIImage *)photoUtilFetchOriginImageWith:(PHAsset *)asset {
    __block UIImage *resultImage = nil;

    PHImageRequestOptions *phImageRequestOptions = [[PHImageRequestOptions alloc] init];
    phImageRequestOptions.synchronous = YES;
    [self.manager requestImageForAsset:asset
                            targetSize:PHImageManagerMaximumSize
                           contentMode:PHImageContentModeDefault
                               options:phImageRequestOptions
                         resultHandler:^(UIImage *result, NSDictionary *info) {
                             NSLog(@"photoUtilFetchOriginImageWith info: %@", info);
                             resultImage = result;

                         }];
    return resultImage;
}

- (void)photoUtilFetchThumbnailImageWith:(PHAsset *)asset WithSize:(CGSize)size block:(void (^)(UIImage *image, NSDictionary *info))handler {
    PHImageRequestOptions *phImageRequestOptions = [[PHImageRequestOptions alloc] init];
    phImageRequestOptions.resizeMode = PHImageRequestOptionsResizeModeExact;
    // 在 PHImageManager 中，targetSize 等 size 都是使用 px 作为单位，因此需要对targetSize 中对传入的 Size 进行处理，宽高各自乘以 ScreenScale，从而得到正确的图片
    [self.manager requestImageForAsset:asset
                            targetSize:CGSizeMake(size.width * ScreenScale, size.height * ScreenScale)
                           contentMode:PHImageContentModeAspectFill options:phImageRequestOptions
                         resultHandler:^(UIImage *result, NSDictionary *info) {
                             handler(result, info);
                         }];
}

/*
 - (UIImage *)originImage {
 if (_originImage) {
 return _originImage;
 }
 __block UIImage *resultImage;
 if (_usePhotoKit) {
 PHImageRequestOptions *phImageRequestOptions = [[PHImageRequestOptions alloc] init];
 phImageRequestOptions.synchronous = YES;
 [[[QMUIAssetsManager sharedInstance] phCachingImageManager] requestImageForAsset:_phAsset
 targetSize:PHImageManagerMaximumSize
 contentMode:PHImageContentModeDefault
 options:phImageRequestOptions
 resultHandler:^(UIImage *result, NSDictionary *info) {
 resultImage = result;
 }];
 } else {
 CGImageRef fullResolutionImageRef = [_alAssetRepresentation fullResolutionImage];
 // 通过 fullResolutionImage 获取到的的高清图实际上并不带上在照片应用中使用“编辑”处理的效果，需要额外在 AlAssetRepresentation 中获取这些信息
 NSString *adjustment = [[_alAssetRepresentation metadata] objectForKey:@"AdjustmentXMP"];
 if (adjustment) {
 // 如果有在照片应用中使用“编辑”效果，则需要获取这些编辑后的滤镜，手工叠加到原图中
 NSData *xmpData = [adjustment dataUsingEncoding:NSUTF8StringEncoding];
 CIImage *tempImage = [CIImage imageWithCGImage:fullResolutionImageRef];
 
 NSError *error;
 NSArray *filterArray = [CIFilter filterArrayFromSerializedXMP:xmpData
 inputImageExtent:tempImage.extent
 error:&error];
 CIContext *context = [CIContext contextWithOptions:nil];
 if (filterArray && !error) {
 for (CIFilter *filter in filterArray) {
 [filter setValue:tempImage forKey:kCIInputImageKey];
 tempImage = [filter outputImage];
 }
 fullResolutionImageRef = [context createCGImage:tempImage fromRect:[tempImage extent]];
 }
 }
 // 生成最终返回的 UIImage，同时把图片的 orientation 也补充上去
 resultImage = [UIImage imageWithCGImage:fullResolutionImageRef scale:[_alAssetRepresentation scale] orientation:(UIImageOrientation)[_alAssetRepresentation orientation]];
 }
 _originImage = resultImage;
 return resultImage;
 }
 
 - (NSInteger)requestOriginImageWithCompletion:(void (^)(UIImage *, NSDictionary *))completion withProgressHandler:(PHAssetImageProgressHandler)phProgressHandler {
 if (_usePhotoKit) {
 if (_originImage) {
 // 如果已经有缓存的图片则直接拿缓存的图片
 if (completion) {
 completion(_originImage, nil);
 }
 return 0;
 } else {
 PHImageRequestOptions *imageRequestOptions = [[PHImageRequestOptions alloc] init];
 imageRequestOptions.networkAccessAllowed = YES; // 允许访问网络
 imageRequestOptions.progressHandler = phProgressHandler;
 return [[[QMUIAssetsManager sharedInstance] phCachingImageManager] requestImageForAsset:_phAsset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeDefault options:imageRequestOptions resultHandler:^(UIImage *result, NSDictionary *info) {
 // 排除取消，错误，低清图三种情况，即已经获取到了高清图时，把这张高清图缓存到 _originImage 中
 BOOL downloadFinined = ![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey] && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue];
 if (downloadFinined) {
 _originImage = result;
 }
 if (completion) {
 completion(result, info);
 }
 }];
 }
 } else {
 if (completion) {
 completion([self originImage], nil);
 }
 return 0;
 }
 }
 
 */

/*
 - (UIImage *)thumbnailWithSize:(CGSize)size {
 if (_thumbnailImage) {
 return _thumbnailImage;
 }
 __block UIImage *resultImage;
 if (_usePhotoKit) {
 PHImageRequestOptions *phImageRequestOptions = [[PHImageRequestOptions alloc] init];
 phImageRequestOptions.resizeMode = PHImageRequestOptionsResizeModeExact;
 // 在 PHImageManager 中，targetSize 等 size 都是使用 px 作为单位，因此需要对targetSize 中对传入的 Size 进行处理，宽高各自乘以 ScreenScale，从而得到正确的图片
 [[[QMUIAssetsManager sharedInstance] phCachingImageManager] requestImageForAsset:_phAsset
 targetSize:CGSizeMake(size.width * ScreenScale, size.height * ScreenScale)
 contentMode:PHImageContentModeAspectFill options:phImageRequestOptions
 resultHandler:^(UIImage *result, NSDictionary *info) {
 resultImage = result;
 }];
 } else {
 CGImageRef thumbnailImageRef = [_alAsset thumbnail];
 if (thumbnailImageRef) {
 resultImage = [UIImage imageWithCGImage:thumbnailImageRef];
 }
 }
 _thumbnailImage = resultImage;
 return resultImage;
 }
 
 - (NSInteger)requestThumbnailImageWithSize:(CGSize)size completion:(void (^)(UIImage *, NSDictionary *))completion {
 if (_usePhotoKit) {
 if (_thumbnailImage) {
 if (completion) {
 completion(_thumbnailImage, nil);
 }
 return 0;
 } else {
 PHImageRequestOptions *imageRequestOptions = [[PHImageRequestOptions alloc] init];
 imageRequestOptions.resizeMode = PHImageRequestOptionsResizeModeExact;
 // 在 PHImageManager 中，targetSize 等 size 都是使用 px 作为单位，因此需要对targetSize 中对传入的 Size 进行处理，宽高各自乘以 ScreenScale，从而得到正确的图片
 return [[[QMUIAssetsManager sharedInstance] phCachingImageManager] requestImageForAsset:_phAsset targetSize:CGSizeMake(size.width * ScreenScale, size.height * ScreenScale) contentMode:PHImageContentModeAspectFill options:imageRequestOptions resultHandler:^(UIImage *result, NSDictionary *info) {
 // 排除取消，错误，低清图三种情况，即已经获取到了高清图时，把这张高清图缓存到 _thumbnailImage 中
 BOOL downloadFinined = ![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey] && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue];
 if (downloadFinined) {
 _thumbnailImage = result;
 }
 if (completion) {
 completion(result, info);
 }
 }];
 }
 } else {
 if (completion) {
 completion([self thumbnailWithSize:size], nil);
 }
 return 0;
 }
 }
 */

/*
 - (UIImage *)previewImage {
 if (_previewImage) {
 return _previewImage;
 }
 __block UIImage *resultImage;
 if (_usePhotoKit) {
 PHImageRequestOptions *imageRequestOptions = [[PHImageRequestOptions alloc] init];
 imageRequestOptions.synchronous = YES;
 [[[QMUIAssetsManager sharedInstance] phCachingImageManager] requestImageForAsset:_phAsset
 targetSize:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT)
 contentMode:PHImageContentModeAspectFill
 options:imageRequestOptions
 resultHandler:^(UIImage *result, NSDictionary *info) {
 resultImage = result;
 }];
 } else {
 CGImageRef fullScreenImageRef = [_alAssetRepresentation fullScreenImage];
 resultImage = [UIImage imageWithCGImage:fullScreenImageRef];
 }
 _previewImage = resultImage;
 return resultImage;
 }
 
 - (NSInteger)requestPreviewImageWithCompletion:(void (^)(UIImage *, NSDictionary *))completion withProgressHandler:(PHAssetImageProgressHandler)phProgressHandler {
 if (_usePhotoKit) {
 if (_previewImage) {
 // 如果已经有缓存的图片则直接拿缓存的图片
 if (completion) {
 completion(_previewImage, nil);
 }
 return 0;
 } else {
 PHImageRequestOptions *imageRequestOptions = [[PHImageRequestOptions alloc] init];
 imageRequestOptions.networkAccessAllowed = YES; // 允许访问网络
 imageRequestOptions.progressHandler = phProgressHandler;
 return [[[QMUIAssetsManager sharedInstance] phCachingImageManager] requestImageForAsset:_phAsset targetSize:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT) contentMode:PHImageContentModeAspectFill options:imageRequestOptions resultHandler:^(UIImage *result, NSDictionary *info) {
 // 排除取消，错误，低清图三种情况，即已经获取到了高清图时，把这张高清图缓存到 _previewImage 中
 BOOL downloadFinined = ![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey] && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue];
 if (downloadFinined) {
 _previewImage = result;
 }
 if (completion) {
 completion(result, info);
 }
 }];
 }
 } else {
 if (completion) {
 completion([self previewImage], nil);
 }
 return 0;
 }
 }
 */

@end
