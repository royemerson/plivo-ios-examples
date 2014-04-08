//
//  OutcallWithPodAppDelegate.h
//  OutcallWithPod
//
//  Created by Iwan BK on 10/16/13.
//  Copyright (c) 2013 Plivo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Phone.h"
#import "OutcallWithPodViewController.h"

@interface OutcallWithPodAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

/* main view controller */
@property (nonatomic, retain) IBOutlet OutcallWithPodViewController* viewController;

/* plivo phone */
@property Phone *phone;


@end
