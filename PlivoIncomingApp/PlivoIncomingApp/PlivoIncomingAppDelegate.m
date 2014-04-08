//
//  PlivoIncomingAppDelegate.m
//  PlivoIncomingApp
//
//  Created by Iwan BK on 10/3/13.
//  Copyright (c) 2013 Plivo. All rights reserved.
//

#import "PlivoIncomingAppDelegate.h"

@implementation PlivoIncomingAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    /* initializing plivo phone */
    self.phone = [[Phone alloc]init];
    
    /* get main view controller object */
    self.viewController = (PlivoIncomingViewController *)self.window.rootViewController;
    
    self.viewController.phone = self.phone;
    
    /* set main view controller as delegate to our phone */
    [self.phone setDelegate:self.viewController];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    /**
     * When application entering background mode, we need to send keep alive data every 600 seconds.
     * It is following Apple suggestion as described here:
     * https://developer.apple.com/library/ios/documentation/iphone/conceptual/iphoneosprogrammingguide/AdvancedAppTricks/AdvancedAppTricks.html#//apple_ref/doc/uid/TP40007072-CH7-SW16
     */
    [self.phone keepAlive];
    [[UIApplication sharedApplication] setKeepAliveTimeout:600 handler:^{
        [self.phone keepAlive];
    }];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
