//
//  Phone.m
//  PlivoIncomingApp
//
//  Created by Iwan BK on 10/3/13.
//  Copyright (c) 2013 Plivo. All rights reserved.
//

#import "Phone.h"

@implementation Phone

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
    NSString *username = @"Your SIP Endpoint Username";
    NSString *password = @"Your SIP Endpoint Password";
    [endpoint login:username AndPassword:password];    
}

- (void)setDelegate:(id)delegate
{
    [endpoint setDelegate:delegate];
}

- (void)keepAlive
{
    [endpoint keepAlive];
}

@end
