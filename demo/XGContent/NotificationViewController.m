//
//  NotificationViewController.m
//  XGContent
//
//  Created by uwei on 22/06/2017.
//  Copyright © 2017 tyzual. All rights reserved.
//

#import "NotificationViewController.h"
#import <UserNotifications/UserNotifications.h>
#import <UserNotificationsUI/UserNotificationsUI.h>

@interface NotificationViewController () <UNNotificationContentExtension>

@property IBOutlet UILabel *label;

@end

@implementation NotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any required interface initialization here.
    self.preferredContentSize = CGSizeMake(CGRectGetWidth(self.view.bounds), 100);
}

- (void)didReceiveNotification:(UNNotification *)notification {
    self.label.text = notification.request.content.body;
}

- (void)didReceiveNotificationResponse:(UNNotificationResponse *)response completionHandler:(void (^)(UNNotificationContentExtensionResponseOption))completion {
    if ([response.actionIdentifier isEqualToString:@"xg000001"]) {
        self.label.text = @"点击了1";
    } else if ([response.actionIdentifier isEqualToString:@"xg000002"]) {
        self.label.text = @"点击了2";
    } else if ([response.actionIdentifier isEqualToString:@"xg000003"]) {
        self.label.text = @"点击了3";
    } else if ([response.actionIdentifier isEqualToString:@"xg000004"]) {
//        self.label.text = [response valueForKeyPath:@"userText"]; // ok
        self.label.text = [(UNTextInputNotificationResponse*)response userText];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        completion(UNNotificationContentExtensionResponseOptionDismissAndForwardAction);
    });
}


@end
