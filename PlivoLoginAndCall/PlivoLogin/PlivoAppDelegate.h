//
//  PlivoAppDelegate.h
//  PlivoLoginAndCall
//
//  Created by Iwan BK on 10/7/13.
//  Copyright (c) 2013 Plivo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Phone.h"
#import "PlivoViewController.h"

@interface PlivoAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

/**
 * Main view controller
 */
@property (nonatomic, retain) IBOutlet PlivoViewController* viewController;

/**
 * Our plivo phone object
 */
@property Phone *phone;

@end
