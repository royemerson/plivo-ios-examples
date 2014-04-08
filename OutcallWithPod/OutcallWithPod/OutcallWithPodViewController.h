//
//  OutcallWithPodViewController.h
//  OutcallWithPod
//
//  Created by Iwan BK on 10/16/13.
//  Copyright (c) 2013 Plivo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Phone.h"

@interface OutcallWithPodViewController : UIViewController<PlivoEndpointDelegate, UITextViewDelegate>

@property Phone *phone;

@end
