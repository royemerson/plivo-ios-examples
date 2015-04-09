//
//  Phone.m
//  PlivoLogin
//
//  Created by Iwan BK on 10/7/13.
//  Copyright (c) 2013 Plivo. All rights reserved.
//

#import "Phone.h"

@implementation Phone {
    PlivoEndpoint *endpoint;
    PlivoRest *restClient;
}

- (id)init
{
#warning change to your actual auth id and auth token
    NSString *authID = @"MAYMFHYZJKMJG0NJG4OG";
    NSString *authToken = @"ZDZlNzI1ZDVkNDkzYWIxMzk5NjU1ODkzZWYyZmEx";

    self = [super init];
    
    if (self) {
        /* create plivo endpoint */
        endpoint = [[PlivoEndpoint alloc]initWithDebug:YES];
        
        /* create rest client */
        restClient = [[PlivoRest alloc] initWithAuthId:authID andAuthToken:authToken];

    }
    return self;
}

- (void)createEndpointWithUsername:(NSString *)username andPassword:(NSString *)password andAlias:(NSString *)alias
{
    
    /* create endpoint */
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:username, @"username",
                            password, @"password",
                            alias, @"alias",
                            nil];
    
    [restClient endpointCreate:params];
}

- (void)loginWithUsername:(NSString *)username andPassword:(NSString *)password
{
    [endpoint login:username AndPassword:password];
}

- (void)deleteEndpoint:(NSString *)endpointId
{
    [restClient endpointDelete:endpointId];
    
}

- (PlivoOutgoing *)callWithDest:(NSString *)dest andHeaders:(NSDictionary *)headers
{
    /* construct SIP URI */
    NSString *sipUri = [[NSString alloc]initWithFormat:@"sip:%@@phone.plivo.com", dest];
    
    /* create PlivoOutgoing object */
    PlivoOutgoing *outCall = [endpoint createOutgoingCall];
    
    /* do the call */
    [outCall call:sipUri headers:headers];
    
    return outCall;
}

- (void)logout
{
    [endpoint logout];
}

- (void)setDelegate:(id)delegate
{
    endpoint.delegate = delegate;
    restClient.delegate = delegate;
}

@end
