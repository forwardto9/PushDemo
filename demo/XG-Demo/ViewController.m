//
//  ViewController.m
//  XG-Demo
//
//  Created by tyzual on 28/10/2016.
//  Copyright © 2016 tyzual. All rights reserved.
//

#import "ViewController.h"
#import "XGPush.h"

@interface ViewController ()
@property (nonatomic, strong) UIAlertController *alertCtr;
@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	if (!self.alertCtr) {
		self.alertCtr = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
		UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
		}];
		[self.alertCtr addAction:action];
	}
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void)setTag:(NSString *)tag {
	[XGPush setTag:@"myTag" successCallback:^{
		NSLog(@"[XGDemo] Set tag success");
		[self.alertCtr setMessage:@"Set tag success"];
		[self presentViewController:self.alertCtr animated:YES completion:nil];
	} errorCallback:^{
		NSLog(@"[XGDemo] Set tag error");
		[self.alertCtr setMessage:@"Set tag error"];
		[self presentViewController:self.alertCtr animated:YES completion:nil];
	}];
}

- (void)delTag:(NSString *)tag  {
	[XGPush delTag:@"myTag" successCallback:^{
		NSLog(@"[XGDemo] Del tag success");
		[self.alertCtr setMessage:@"Del tag success"];
		[self presentViewController:self.alertCtr animated:YES completion:nil];
	} errorCallback:^{
		NSLog(@"[XGDemo] Del tag error");
		[self.alertCtr setMessage:@"Del tag error"];
		[self presentViewController:self.alertCtr animated:YES completion:nil];
	}];
}

- (void)setAccount:(NSString *)account {
	[XGPush setAccount:@"myAccount" successCallback:^{
		NSLog(@"[XGDemo] Set account success");
		[self.alertCtr setMessage:@"Set account success"];
		[self presentViewController:self.alertCtr animated:YES completion:nil];
	} errorCallback:^{
		NSLog(@"[XGDemo] Set account error");
		[self.alertCtr setMessage:@"Set account error"];
		[self presentViewController:self.alertCtr animated:YES completion:nil];
	}];
}

- (void)delAccount {
	[XGPush delAccount:^{
		NSLog(@"[XGDemo] Del account success");
		[self.alertCtr setMessage:@"Del account success"];
		[self presentViewController:self.alertCtr animated:YES completion:nil];
	} errorCallback:^{
		NSLog(@"[XGDemo] Del account error");
		[self.alertCtr setMessage:@"Del account error"];
		[self presentViewController:self.alertCtr animated:YES completion:nil];
	}];
}

- (IBAction)onSetTag:(id)sender {
	[self setTag:@"myTag"];
}

- (IBAction)onDelTag:(id)sender {
	[self delTag:@"myTag"];
}

- (IBAction)onSetAccount:(id)sender {
	[self setAccount:@"myAccount"];
}

- (IBAction)onDelAccount:(id)sender {
	[self delAccount];
}

@end
