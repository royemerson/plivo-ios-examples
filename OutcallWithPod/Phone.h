//
//  Phone.h
//  OutcallWithPod
//
//  Created by Iwan BK on 10/16/13.
//  Copyright (c) 2013 Plivo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlivoEndpoint.h"

@interface Phone : NSObject

/* Login to plivo */
- (void)login;

/* make outgoing call */
- (PlivoOutgoing *)call:(NSString *)dest;

/* set delegate for our phone */
- (void)setDelegate:(id)delegate;


@end
