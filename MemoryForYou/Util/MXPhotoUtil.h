//
//  MXPhotoUtil.h
//  MemoryForYou
//
//  Created by 夏立群 on 2017/9/30.
//  Copyright © 2017年 xialisuper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@interface MXPhotoUtil : NSObject

@property(nonatomic, assign, readonly) PHAuthorizationStatus status;

+ (instancetype)sharedInstance;
- (void)fetchAllPhotosWithResults;


/**
 刷新当前相册授权状态

 @return 返回当前相册授权状态
 */
- (PHAuthorizationStatus)updateAuthorization;

/**
 请求相册权限

 @param block 返回状态
 */
- (void)requestAuthorizationStatusWithBlock:(void (^)(PHAuthorizationStatus status))block;


@end
