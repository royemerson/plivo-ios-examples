//
//  PlivoLoginAppDelegate.h
//  PlivoLogin
//
//  Created by Iwan BK on 10/7/13.
//  Copyright (c) 2013 Plivo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Phone.h"
#import "PlivoLoginViewController.h"

@interface PlivoLoginAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

/**
 * Main view controller
 */
@property (nonatomic, retain) IBOutlet PlivoLoginViewController* viewController;

/**
 * Our plivo phone object
 */
@property Phone *phone;

@end
