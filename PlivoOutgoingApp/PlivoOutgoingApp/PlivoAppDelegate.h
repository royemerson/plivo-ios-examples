//
//  PlivoAppDelegate.h
//  PlivoOutgoingApp
//
//  Created by Iwan BK on 10/2/13.
//  Copyright (c) 2013 Plivo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlivoViewController.h"
#import "Phone.h"

@interface PlivoAppDelegate : UIResponder <UIApplicationDelegate>

/* main view controller of this app */
@property (nonatomic, retain) IBOutlet PlivoViewController* viewController;

/* our plivo phone object */
@property Phone *phone;

@property int started;

@property (strong, nonatomic) UIWindow *window;

@end
