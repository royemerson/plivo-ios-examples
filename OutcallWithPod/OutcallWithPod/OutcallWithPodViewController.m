//
//  OutcallWithPodViewController.m
//  OutcallWithPod
//
//  Created by Iwan BK on 10/16/13.
//  Copyright (c) 2013 Plivo. All rights reserved.
//

#import "OutcallWithPodViewController.h"
#import <ConciseKit.h>


@interface OutcallWithPodViewController ()
@property (weak, nonatomic) IBOutlet UIButton *callBtn;
@property (weak, nonatomic) IBOutlet UIButton *hangupBtn;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITextView *logTextView;
- (IBAction)makeCall:(id)sender;
- (IBAction)hangupCall:(id)sender;

@end

@implementation OutcallWithPodViewController {
    PlivoOutgoing *outCall;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /* disable call & hangup*/
    [self.hangupBtn setEnabled:NO];
    [self.callBtn setEnabled:NO];
    [self.textField setEnabled:NO];
    
    /* set delegate for debug log text view */
    self.logTextView.delegate = self;
    
    /* Login */
    [self.logTextView setText:@"- Logging in\n"];
    [self.phone login];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 * Hide keyboard after user press 'return' key
 */
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    if (theTextField == self.textField) {
        [theTextField resignFirstResponder];
    }
    return YES;
}

/**
 * Hide keyboard when text view being clicked
 */
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return NO;
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
    NSString *toLog = $str(@"%@\n", message);
    
    /* insert message */
    [self.logTextView insertText:toLog];
    
	/* Scroll textview */
	[self.logTextView scrollRangeToVisible:NSMakeRange([self.logTextView.text length], 0)];
}


/**
 * onLogin delegate implementation.
 */
- (void)onLogin
{
    [self logDebug:@"- Login OK"];
    [self logDebug:@"- Ready to make a call"];
    [self enableCallDisableHangup];
}

/**
 * onLoginFailed delegate implementation.
 */
- (void)onLoginFailed
{
    [self logDebug:@"- Login failed. Please check your username and password"];
}

/* make call */
- (IBAction)makeCall:(id)sender {
    /* get destination value */
    NSString *dest = [self.textField text];
    if (dest.length == 0) {
        [self logDebug:@"- Please enter SIP URI or Phone Number"];
        return;
    }
    
    /* log it */
    [self logDebug:$str(@"- Make a call to '%@'", dest)];
    
    /* make the call */
    outCall = [self.phone call:dest];
    
    /* enable hangup and disable call*/
    [self enableHangupDisableCall];
}

/**
 * Hangup the call.
 */
- (IBAction)hangupCall:(id)sender {
    /* log it */
    [self logDebug:@"- Hangup the call"];
    
    /* hang it up */
    [outCall disconnect];
    
    /* disable hangup and enable call*/
    [self enableCallDisableHangup];
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
 * onOutgoingCallAnswered delegate implementation.
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
 * onOutgoingCallRinging delegate implementation.
 */
- (void)onOutgoingCallRinging:(PlivoOutgoing *)call
{
    [self logDebug:@"- On outgoing call ringing"];
}

/**
 * onOutgoingCallRejected delegate implementation.
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


@end
