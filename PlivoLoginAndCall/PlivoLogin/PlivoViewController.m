//
//  PlivoViewController.m
//  PlivoLoginAndCall
//
//  Created by Iwan BK on 10/7/13.
//  Copyright (c) 2013 Plivo. All rights reserved.
//

#import "PlivoViewController.h"

@interface PlivoViewController ()
@property (weak, nonatomic) IBOutlet UIButton *createLoginBtn;
@property (weak, nonatomic) IBOutlet UIButton *logoutDestroyBtn;
@property (weak, nonatomic) IBOutlet UITextView *logTextView;
@property (weak, nonatomic) IBOutlet UITextView *resultView;
@property (weak, nonatomic) IBOutlet UIButton *callBtn;
@property (weak, nonatomic) IBOutlet UIButton *hangupBtn;
@property (weak, nonatomic) IBOutlet UITextField *textField;

- (IBAction)createAndLogin:(id)sender;
- (IBAction)logoutAndDestroy:(id)sender;
- (IBAction)makeCall:(id)sender;
- (IBAction)hangupCall:(id)sender;

@end

@implementation PlivoViewController {
    PlivoOutgoing *outCall;
    NSString *theUsername;
    NSString *thePassword;
    NSString *theAlias;
    NSString *endpointId;
    NSString *createEndpointIdentifier;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.logTextView setText:@"- Initializing app\n"];
    
    theUsername = [self genRandStringLength:10];
    theAlias = theUsername;
    
    /* string identifier for creating endpoint Plivo REST API */
    createEndpointIdentifier = @"Endpoint/CREATE";
    [_logoutDestroyBtn setHidden:YES];
    [_callBtn setHidden:YES];
    [_hangupBtn setHidden:YES];
    [_textField setHidden:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/**
 * This delegate will be called when plivo REST API call succeed.
 */
- (void)successWithResponse:(NSDictionary *)response andIdentifier:(NSString *)identifier
{
    if ([identifier isEqual:createEndpointIdentifier]) { /* it is a reply to create endpoint*/
        [self logDebug:@"- Endpoint created"];
        
        /* get endpoint id and username */
        endpointId = [response objectForKey:@"endpoint_id"];
        NSString *generatedUsername = [response objectForKey:@"username"];
        
        /* log */
        NSString *logMsg = [[NSString alloc] initWithFormat:@"- Username = %@.\n- Endpoint id = %@", generatedUsername, endpointId];
        [self logDebug:logMsg];
        
        /* show it above 'create and login' button */
        NSString *msg = [[NSString alloc] initWithFormat:@"Endpoint created = sip:%@@phone.plivo.com", generatedUsername];
        [self.resultView setText:msg];
        
        /* login */
        [self logDebug:@"- Logging in"];
        [_createLoginBtn setHidden:YES];
        [_logoutDestroyBtn setHidden:NO];
        [_callBtn setHidden:NO];
        [_hangupBtn setHidden:NO];
        [_textField setHidden:NO];
        [self.phone loginWithUsername:generatedUsername andPassword:thePassword];
    } else {
        [self logDebug:@"- Endpoint destroyed"];
        
        /* clear result view */
        [self.resultView setText:@""];
    }
}

/**
 * This delegate will be called when Plivo REST API call failed
 */
- (void)failureWithError:(NSError *)error andIdentifier:(NSString *)identifier
{
    NSLog(@"failuteWithError.identifier = %@.error=%@", identifier, error);
    if ([identifier isEqual:createEndpointIdentifier]) {
        [self logDebug:@"- Create endpoint failed"];
    } else {
        [self logDebug:@"- Delete endpoint failed"];
    }
}

/**
 * This delegate gets called when registration to an endpoint is successful.
 */
- (void)onLogin
{
    [self logDebug:@"- Logged in"];
}

/**
 * This delegate gets called when unregistration to an endpoint is successful.
 */
- (void)onLogout
{
    [self logDebug:@"- Logged out"];
    [self logDebug:@"- Destroying endpoint"];
    [self.phone deleteEndpoint:endpointId];
}

/**
 * Create endpoint.
 * We will login if endpoint creation success
 */
- (IBAction)createAndLogin:(id)sender {
    [self logDebug:@"- Creating endpoint"];
    
    [self logDebug:@"- Generating random password"];
    thePassword = [self genRandStringLength:10];
    
    [self.phone createEndpointWithUsername:theUsername andPassword:thePassword andAlias:theAlias];
}

/**
 * Logout from Plivo.
 * We will destroy endpoint when it is logged out.
 */
- (IBAction)logoutAndDestroy:(id)sender {
    [self logDebug:@"- Logging out"];
    [self.phone logout];
    [_createLoginBtn setHidden:NO];
    [_logoutDestroyBtn setHidden:YES];
    [_callBtn setHidden:YES];
    [_hangupBtn setHidden:YES];
    [_textField setHidden:YES];
}

/**
 * Enable call UI and disable hangup UI
 */
- (void)enableCallDisableHangup
{
    [self.hangupBtn setEnabled:NO];
    [self.callBtn setEnabled:YES];
    [self.textField setEnabled:YES];
}

/**
 * Enable hangup UI and disable call UI
 */
- (void)enableHangupDisableCall
{
    [self.hangupBtn setEnabled:YES];
    [self.callBtn setEnabled:NO];
    [self.textField setEnabled:NO];
}

/**
 * Make a call
 */
- (IBAction)makeCall:(id)sender {
    /* get destination value */
    NSString *dest = [self.textField text];
    
    /* check if user already entered the destinantion number */
    if (dest.length == 0) {
        [self logDebug:@"- Please enter SIP URI or Phone Number"];
        return;
    }
    
    /* set extra headers */
    NSDictionary *extraHeaders = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  @"Value1", @"X-PH-Header1",
                                  @"Value2", @"X-PH-Header2",
                                  nil];
    
    /* log it */
    NSString *debugStr = [[NSString alloc]initWithFormat:@"- Make a call to '%@'", dest];
    [self logDebug:debugStr];
    
    /* make the call */
    outCall = [self.phone callWithDest:dest andHeaders:extraHeaders];
    
    /* enable hangup and disable call*/
    [self enableHangupDisableCall];
}

/**
 * Hangup the call
 */
- (IBAction)hangupCall:(id)sender {
    /* log it */
    [self logDebug:@"- Hangup the call"];
    
    /* hang it up */
    [outCall hangup];
    
    /* disable hangup and enable call*/
    [self enableCallDisableHangup];
}

/**
 * Print debug log to textview in the bottom of the view screen
 */
- (void)logDebug:(NSString *)message
{
    /**
     * Check if this code is executed from main thread.
     * Only main thread that can update the GUI.
     * Our plivo endpoint run in it's own thread
     */
    if ( ![NSThread isMainThread] )
	{
        /* if it is not executed from main thread, give this to main thread and return */
        [self performSelectorOnMainThread:@selector(logDebug:) withObject:message waitUntilDone:NO];
		return;
	}
    
    /* add newline to end of the message */
    NSString *toLog = [[NSString alloc] initWithFormat:@"%@\n",message];
    
    /* insert message */
    [self.logTextView insertText:toLog];
    
	/* Scroll textview */
	[self.logTextView scrollRangeToVisible:NSMakeRange([self.logTextView.text length], 0)];
}


/**
 * onOutgoingCallAnswered delegate implementation
 */
- (void)onOutgoingCallAnswered:(PlivoOutgoing *)call
{
    [self logDebug:@"- On outgoing call answered"];
}

/**
 * onOutgoingCallHangup delegate implementation.
 */
- (void)onOutgoingCallHangup:(PlivoOutgoing *)call
{
    [self logDebug:@"- On outgoing call hangup"];
    
    [self enableCallDisableHangup];
}

/**
 * onCalling delegate implementation.
 */
- (void)onCalling:(PlivoOutgoing *)call
{
    [self logDebug:@"- On calling"];
}

/**
 * onOutgoingCallRinging delegate implementation.
 */
- (void)onOutgoingCallRinging:(PlivoOutgoing *)call
{
    [self logDebug:@"- On outgoing call ringing"];
}

/**
 * onOutgoingCallrejected delegate implementation.
 */
- (void)onOutgoingCallRejected:(PlivoOutgoing *)call
{
    [self logDebug:@"- On outgoing call rejected"];
    
    [self enableCallDisableHangup];
}

/**
 * onOutgoingCallInvalid delegate implementation.
 */
- (void)onOutgoingCallInvalid:(PlivoOutgoing *)call
{
    [self logDebug:@"- On outgoing call invalid"];
    
    [self enableCallDisableHangup];
}

/**
 * generate random strings
 */
NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

-(NSString *) genRandStringLength: (int) len {
    
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random() % [letters length]]];
    }
    
    return randomString;
}


@end
