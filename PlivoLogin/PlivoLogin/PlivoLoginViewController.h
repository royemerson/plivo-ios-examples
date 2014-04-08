//
//  PlivoLoginViewController.h
//  PlivoLogin
//
//  Created by Iwan BK on 10/7/13.
//  Copyright (c) 2013 Plivo. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Phone.h"

@interface PlivoLoginViewController : UIViewController<PlivoEndpointDelegate, PlivoRestDelegate>

@property Phone *phone;

@end
