//
//  PlivoIncomingAppDelegate.h
//  PlivoIncomingApp
//
//  Created by Iwan BK on 10/3/13.
//  Copyright (c) 2013 Plivo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlivoIncomingViewController.h"
#import "Phone.h"

@interface PlivoIncomingAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

/** main view controller */
@property (nonatomic, retain) IBOutlet PlivoIncomingViewController* viewController;

/** plivo phone object **/
@property Phone *phone;

@end
