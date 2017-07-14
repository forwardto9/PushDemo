//
//  AppDelegate.m
//  XG-Demo
//
//  Created by tyzual on 28/10/2016.
//  Copyright © 2016 tyzual. All rights reserved.
//

#import "AppDelegate.h"
#import "XGPush.h"
#import "XGSetting.h"

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0

#import <UserNotifications/UserNotifications.h>
@interface AppDelegate() <UNUserNotificationCenterDelegate>
@end
#endif

@interface AppDelegate ()

@end

@implementation AppDelegate



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

	[[XGSetting getInstance] enableDebug:YES];
	[XGPush startApp:2200022728 appKey:@"IMJ34Y25JN4I"];

	[XGPush isPushOn:^(BOOL isPushOn) {
		NSLog(@"[XGDemo] Push Is %@", isPushOn ? @"ON" : @"OFF");
	}];

	[self registerAPNS];

	[XGPush handleLaunching:launchOptions successCallback:^{
		NSLog(@"[XGDemo] Handle launching success");
	} errorCallback:^{
		NSLog(@"[XGDemo] Handle launching error");
	}];

    
    [[UNUserNotificationCenter currentNotificationCenter] getDeliveredNotificationsWithCompletionHandler:^(NSArray<UNNotification *> * _Nonnull notifications) {
        for (UNNotification *notification in notifications) {
            NSLog(@"%@", [notification date]);
        }
    }];
    
    
    application.applicationIconBadgeNumber = 0;
    
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
	// Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {

	NSString *deviceTokenStr = [XGPush registerDevice:deviceToken account:@"myAccount" successCallback:^{
		NSLog(@"[XGDemo] register push success");
	} errorCallback:^{
		NSLog(@"[XGDemo] register push error");
	}];
	NSLog(@"[XGDemo] device token is %@", deviceTokenStr);
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
	NSLog(@"[XGDemo] register APNS fail.\n[XGDemo] reason : %@", error);
}


/**
 收到通知的回调

 @param application  UIApplication 实例
 @param userInfo 推送时指定的参数
 */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
	NSLog(@"[XGDemo] receive Notification");
	[XGPush handleReceiveNotification:userInfo
	successCallback:^{
		 NSLog(@"[XGDemo] Handle receive success");
	 } errorCallback:^{
		 NSLog(@"[XGDemo] Handle receive error");
	 }];
}


/**
 收到静默推送的回调

 @param application  UIApplication 实例
 @param userInfo 推送时指定的参数
 @param completionHandler 完成回调
 */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
	NSLog(@"[XGDemo] receive slient Notification");
	NSLog(@"[XGDemo] userinfo %@", userInfo);
	[XGPush handleReceiveNotification:userInfo
	successCallback:^{
		NSLog(@"[XGDemo] Handle receive success");
	} errorCallback:^{
		NSLog(@"[XGDemo] Handle receive error");
	}];

	completionHandler(UIBackgroundFetchResultNewData);
}

// iOS 10 新增 API
// iOS 10 会走新 API, iOS 10 以前会走到老 API
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
// App 用户点击通知的回调
// 无论本地推送还是远程推送都会走这个回调
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler {
	NSLog(@"[XGDemo] click notification");
    
    if ([response.actionIdentifier isEqualToString:@"xg000001"]) {
        NSLog(@"click from Action1");
    } else if ([response.actionIdentifier isEqualToString:@"xg000002"]) {
        NSLog(@"click from Action2");
    } else if ([response.actionIdentifier isEqualToString:@"xg000003"]) {
        NSLog(@"click from Action3");
    }
    
    
	[XGPush handleReceiveNotification:response.notification.request.content.userInfo
	successCallback:^{
		 NSLog(@"[XGDemo] Handle receive success");
	 } errorCallback:^{
		 NSLog(@"[XGDemo] Handle receive error");
	 }];

	completionHandler();
}

// App 在前台弹通知需要调用这个接口
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler {

	completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
}
#endif

- (void)registerAPNS {
	float sysVer = [[[UIDevice currentDevice] systemVersion] floatValue];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
	if (sysVer >= 10) {
		// iOS 10
		[self registerPush10];
	} else if (sysVer >= 8) {
		// iOS 8-9
		[self registerPush8to9];
	} else {
		// before iOS 8
		[self registerPushBefore8];
	}
#else
	if (sysVer < 8) {
		// before iOS 8
		[self registerPushBefore8];
	} else {
		// iOS 8-9
		[self registerPush8to9];
	}
#endif
}

- (void)registerPush10{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
	UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
	center.delegate = self;
    
    
    [[UNUserNotificationCenter currentNotificationCenter] getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
        switch (settings.authorizationStatus) {
            case UNAuthorizationStatusNotDetermined:
            {
                NSLog(@"not determined");
                break;
            }
                case UNAuthorizationStatusDenied:
            {
                NSLog(@"Denied");
                break;
            }
                
            case UNAuthorizationStatusAuthorized:
            {
                NSLog(@"Authorized");
                break;
            }
                
            default:
                break;
        }
    }];
    
    
	[center requestAuthorizationWithOptions:UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert completionHandler:^(BOOL granted, NSError * _Nullable error) {
		if (granted) {
            UNNotificationAction *action1 = [UNNotificationAction actionWithIdentifier:@"xg000001" title:@"xgAction1" options:UNNotificationActionOptionForeground|UNNotificationActionOptionDestructive];
            UNNotificationAction *action2 = [UNNotificationAction actionWithIdentifier:@"xg000002" title:@"xgAction2" options:UNNotificationActionOptionNone];
            UNNotificationAction *action3 = [UNNotificationAction actionWithIdentifier:@"xg000003" title:@"xgAction3" options:UNNotificationActionOptionDestructive];
            UNTextInputNotificationAction *action4 = [UNTextInputNotificationAction actionWithIdentifier:@"xg000004" title:@"xgAction4" options:UNNotificationActionOptionAuthenticationRequired textInputButtonTitle:@"xgTextInput" textInputPlaceholder:@"xgdemo"];
            
            UNNotificationCategory *category = [UNNotificationCategory categoryWithIdentifier:@"xgCategory" actions:@[action1, action2, action3, action4] intentIdentifiers:@[] options:UNNotificationCategoryOptionNone];
            [center setNotificationCategories:[NSSet setWithObject:category]];
		}
	}];
	[[UIApplication sharedApplication] registerForRemoteNotifications];
#endif
}

- (void)registerPush8to9 {
	UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    
    
    UIMutableUserNotificationCategory *category = [[UIMutableUserNotificationCategory alloc] init];
    [category setIdentifier:@"xgCategory"];
    
    UIMutableUserNotificationAction *action = [UIMutableUserNotificationAction new];
    [action setIdentifier:@"xgAction001"];
    [action setTitle:@"xgAction"];
    [action setActivationMode:UIUserNotificationActivationModeBackground];
    [action setAuthenticationRequired:YES];
    [action setDestructive:YES];
    
    [category setActions:@[action] forContext:UIUserNotificationActionContextDefault];
    
	UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:[NSSet setWithObject:category]];
    
	[[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
	[[UIApplication sharedApplication] registerForRemoteNotifications];
}

- (void)registerPushBefore8{
	[[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
}

@end
