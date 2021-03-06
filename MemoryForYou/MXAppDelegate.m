//
//  AppDelegate.m
//  MemoryForYou
//
//  Created by 夏立群 on 2017/9/26.
//  Copyright © 2017年 夏立群. All rights reserved.
//

#import "MXAppDelegate.h"
#import "MXPhotoUtil.h"
#import "MXPhotoUtil.h"


#import "MXAudioPlayViewController.h"
#import "MXImagePickerViewController.h"
#import "MXBaseNavigationController.h"

@interface MXAppDelegate ()
 
@end

@implementation MXAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//    // Override point for customization after application launch.
//    
//    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    
    MXImagePickerViewController *vc = [[MXImagePickerViewController alloc] init];
    MXBaseNavigationController *nav = [[MXBaseNavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
//    [[MXPhotoUtil sharedInstance] updateAuthorization];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
