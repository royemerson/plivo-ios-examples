//
//  Phone.m
//  OutcallWithPod
//
//  Created by Iwan BK on 10/16/13.
//  Copyright (c) 2013 Plivo. All rights reserved.
//

#import "Phone.h"

@implementation Phone {
    PlivoEndpoint *endpoint;
}

- (id) init
{
    self = [super init];
    
    if (self) {
        endpoint = [[PlivoEndpoint alloc] init];
    }
    
    return self;
}

- (void)login
{
#warning Change to valid plivo endpoint username and password.
    NSString *username = @"username";
    NSString *password = @"password";
    [endpoint login:username AndPassword:password];
}

- (PlivoOutgoing *)call:(NSString *)dest
{
    /* construct SIP URI */
    NSString *sipUri = [[NSString alloc]initWithFormat:@"sip:%@@phone.plivo.com", dest];
    
    /* create PlivoOutgoing object */
    PlivoOutgoing *outCall = [endpoint createOutgoingCall];
    
    /* do the call */
    [outCall call:sipUri];
    
    return outCall;
}

- (void)setDelegate:(id)delegate
{
    /* set it as delegate for plivo endpoint */
    [endpoint setDelegate:delegate];
}

@end
