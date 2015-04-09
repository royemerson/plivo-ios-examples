//
//  PlivoViewController.h
//  PlivoLoginAndCall
//
//  Created by Iwan BK on 10/7/13.
//  Copyright (c) 2013 Plivo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Phone.h"

@interface PlivoViewController : UIViewController<PlivoEndpointDelegate, PlivoRestDelegate>

@property Phone *phone;

@end
