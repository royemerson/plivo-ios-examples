//
//  Phone.h
//  PlivoIncomingApp
//
//  Created by Iwan BK on 10/3/13.
//  Copyright (c) 2013 Plivo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlivoEndpoint.h"

@interface Phone : NSObject {
    PlivoEndpoint *endpoint;
}

/* login to plivo */
- (void)login;

/* set delegate of plivo endpoint object */
- (void)setDelegate:(id)delegate;

/* send keepalive data to plivo server*/
- (void)keepAlive;

@end
