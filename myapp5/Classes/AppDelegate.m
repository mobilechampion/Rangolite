/*
 Licensed to the Apache Software Foundation (ASF) under one
 or more contributor license agreements.  See the NOTICE file
 distributed with this work for additional information
 regarding copyright ownership.  The ASF licenses this file
 to you under the Apache License, Version 2.0 (the
 "License"); you may not use this file except in compliance
 with the License.  You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing,
 software distributed under the License is distributed on an
 "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 KIND, either express or implied.  See the License for the
 specific language governing permissions and limitations
 under the License.
 */

//
//  AppDelegate.m
//  myapp5
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright ___ORGANIZATIONNAME___ ___YEAR___. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"

#import <Cordova/CDVPlugin.h>


#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
@implementation AppDelegate

@synthesize window, viewController;

- (id)init
{
    /** If you need to do any extra app-specific initialization, you can do it here
     *  -jm
     **/
    NSHTTPCookieStorage* cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];

    [cookieStorage setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];

    self = [super init];
    return self;
}

#pragma UIApplicationDelegate implementation

/**
 * This is main kick off after the app inits, the views and Settings are setup here. (preferred - iOS4 and up)
 */
- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions
{
    NSURL* url = [launchOptions objectForKey:UIApplicationLaunchOptionsURLKey];
    NSString* invokeString = nil;

    if (url && [url isKindOfClass:[NSURL class]]) {
        invokeString = [url absoluteString];
        NSLog(@"myapp5 launchOptions = %@", url);
    }

    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    self.window = [[[UIWindow alloc] initWithFrame:screenBounds] autorelease];
    self.window.autoresizesSubviews = YES;

    self.viewController = [[[MainViewController alloc] init] autorelease];
    self.viewController.useSplashScreen = YES;
    self.viewController.wwwFolderName = @"www";
    self.viewController.startPage = @"login.html";
    self.viewController.invokeString = invokeString;

    // NOTE: To control the view's frame size, override [self.viewController viewWillAppear:] in your view controller.

    // check whether the current orientation is supported: if it is, keep it, rather than forcing a rotation
    BOOL forceStartupRotation = YES;
    UIDeviceOrientation curDevOrientation = [[UIDevice currentDevice] orientation];

    if (UIDeviceOrientationUnknown == curDevOrientation) {
        // UIDevice isn't firing orientation notifications yet… go look at the status bar
        curDevOrientation = (UIDeviceOrientation)[[UIApplication sharedApplication] statusBarOrientation];
    }

    if (UIDeviceOrientationIsValidInterfaceOrientation(curDevOrientation)) {
        if ([self.viewController supportsOrientation:curDevOrientation]) {
            forceStartupRotation = NO;
        }
    }

    if (forceStartupRotation) {
        UIInterfaceOrientation newOrient;
        if ([self.viewController supportsOrientation:UIInterfaceOrientationPortrait]) {
            newOrient = UIInterfaceOrientationPortrait;
        } else if ([self.viewController supportsOrientation:UIInterfaceOrientationLandscapeLeft]) {
            newOrient = UIInterfaceOrientationLandscapeLeft;
        } else if ([self.viewController supportsOrientation:UIInterfaceOrientationLandscapeRight]) {
            newOrient = UIInterfaceOrientationLandscapeRight;
        } else {
            newOrient = UIInterfaceOrientationPortraitUpsideDown;
        }

        NSLog(@"AppDelegate forcing status bar to: %d from: %d", newOrient, curDevOrientation);
        [[UIApplication sharedApplication] setStatusBarOrientation:newOrient];
    }
    

    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    
//    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
//     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes: (UIRemoteNotificationTypeBadge
                                                                                              |UIRemoteNotificationTypeSound
                                                                                              |UIRemoteNotificationTypeAlert) categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    } else {
        //register to receive notifications
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    }

    return YES;
}

#ifdef __IPHONE_8_0
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:   (UIUserNotificationSettings *)notificationSettings
{
    //register to receive notifications
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString   *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
    //handle the actions
    if ([identifier isEqualToString:@"declineAction"]){
    }
    else if ([identifier isEqualToString:@"answerAction"]){
    }
}
#endif
// this happens while we are running ( in the background, or from within our own app )
// only valid if myapp5-Info.plist specifies a protocol to handle
- (BOOL)application:(UIApplication*)application handleOpenURL:(NSURL*)url
{
    if (!url) {
        return NO;
    }

    // calls into javascript global function 'handleOpenURL'
    NSString* jsString = [NSString stringWithFormat:@"handleOpenURL(\"%@\");", url];
    [self.viewController.webView stringByEvaluatingJavaScriptFromString:jsString];

    // all plugins will get the notification, and their handlers will be called
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:CDVPluginHandleOpenURLNotification object:url]];

    return YES;
}

- (NSUInteger)application:(UIApplication*)application supportedInterfaceOrientationsForWindow:(UIWindow*)window
{
    // iPhone doesn't support upside down by default, while the iPad does.  Override to allow all orientations always, and let the root view controller decide what's allowed (the supported orientations mask gets intersected).
    NSUInteger supportedInterfaceOrientations = (1 << UIInterfaceOrientationPortrait) | (1 << UIInterfaceOrientationLandscapeLeft) | (1 << UIInterfaceOrientationLandscapeRight) | (1 << UIInterfaceOrientationPortraitUpsideDown);

    return supportedInterfaceOrientations;
}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
	
    NSString *str = [NSString stringWithFormat:@"Device Token=%@",deviceToken];
	
    
    
	
    NSLog(@"str %@",str);
	
    
    str=[str substringWithRange:NSMakeRange(14, 71)];
    NSLog(@"str %@",str);
    str=[str stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    
    
    
    if(![[[NSUserDefaults standardUserDefaults]objectForKey:@"token"] isEqualToString:str]){
        
        
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"tokenChanged"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
    }
    
    
    
    
	[[NSUserDefaults standardUserDefaults] setObject:str forKey:@"token"];
	[[NSUserDefaults standardUserDefaults] synchronize];
    NSLog(@"str %@",str);
	
	
	
    
	
	
}
    
- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    
    NSString *str = [NSString stringWithFormat: @"Error: %@", err];
    
	
	UIAlertView *alert=[[UIAlertView alloc]initWithTitle:str message:nil delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
	[alert show];
	[alert release];
	
	
	
	
	
}
- (void)applicationDidBecomeActive:(UIApplication *)application{
    //[[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
	
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    NSString *trimmed;
    
    NSString *pushMessage;
    
    
    for (id key in userInfo) {
        
        
        
        NSArray *splitArray=[[[userInfo objectForKey:key]objectForKey:@"alert"]componentsSeparatedByString:@"~:~"];

        
        
        if([splitArray count]>1){
            
            pushMessage=[splitArray objectAtIndex:0];
            
            trimmed =[splitArray objectAtIndex:1];
        }
        else {
            trimmed =[[userInfo objectForKey:key]objectForKey:@"alert"] ;
            
        }
        
        
        
        
        
        
        
        
        
        trimmed=[trimmed stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        
        
        NSLog(@" trimmm: %@", trimmed);
        
        [[NSUserDefaults standardUserDefaults] setObject:[[userInfo objectForKey:key]objectForKey:@"alert"] forKey:@"message"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
        
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"gotMessage"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
        
        
        NSLog(@"key: %@, value: %@", key, [userInfo objectForKey:key]);
        NSLog(@" value: %@", [[userInfo objectForKey:key]objectForKey:@"alert"]);
        NSLog(@" value: %@", trimmed);
        NSLog(@" value: %@", [[NSUserDefaults standardUserDefaults]objectForKey:@"message"]);
    }
	
    
    //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:trimmed]];
    
    
    
    
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Couse Talk" message: [[NSUserDefaults standardUserDefaults]objectForKey:@"message"] delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
    [alert show];
   // [alert release];
    
    
    
    
    
    
    
    NSLog(@"hello");
    
    
    
}


@end
