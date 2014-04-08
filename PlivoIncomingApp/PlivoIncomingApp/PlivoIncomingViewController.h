//
//  PlivoIncomingViewController.h
//  PlivoIncomingApp
//
//  Created by Iwan BK on 10/3/13.
//  Copyright (c) 2013 Plivo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Phone.h"

@interface PlivoIncomingViewController : UIViewController<PlivoEndpointDelegate, UITextViewDelegate>

@property Phone *phone;

@end
