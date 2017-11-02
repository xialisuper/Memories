//
//  MXPhotoUtil.m
//  MemoryForYou
//
//  Created by 夏立群 on 2017/9/30.
//  Copyright © 2017年 xialisuper. All rights reserved.
//

#import "MXPhotoUtil.h"
#import <Photos/Photos.h>

@implementation MXPhotoUtil

+ (instancetype)sharedInstance {
    
    static MXPhotoUtil *util;
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        
        util = [MXPhotoUtil new];
        
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

- (void)fetchAllPhotosWithResults {
    // 列出所有相册智能相册
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum
                                                                          subtype:PHAssetCollectionSubtypeAlbumRegular
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
                }
            }
            
        } else {
            NSAssert(NO, @"Fetch collection not PHCollection: %@", collection);
        }
    }
}
@end
