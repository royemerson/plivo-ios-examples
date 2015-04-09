//
//  PlivoIncomingViewController.m
//  PlivoIncomingApp
//
//  Created by Iwan BK on 10/3/13.
//  Copyright (c) 2013 Plivo. All rights reserved.
//

#import "PlivoIncomingViewController.h"

@interface PlivoIncomingViewController ()
@property (weak, nonatomic) IBOutlet UIButton *answerBtn;
@property (weak, nonatomic) IBOutlet UIButton *hangupBtn;
@property (weak, nonatomic) IBOutlet UIButton *muteBtn;
@property (weak, nonatomic) IBOutlet UITextView *logTextView;
@property (weak, nonatomic) IBOutlet UILabel *callLbl;

- (IBAction)answerCall:(id)sender;
- (IBAction)hangupCall:(id)sender;
- (IBAction)muteCall:(id)sender;


@property PlivoIncoming *incCall;

@end

@implementation PlivoIncomingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

	/* Login */
    [self.logTextView setText:@"- Logging in\n"];
    [self.phone login];

    // [self resetUI];
    
    /* set delegate for debug log text view */
    self.logTextView.delegate = self;
    [self.callLbl setText:@""];
    [self.muteBtn setHidden:YES];
    [self.answerBtn setHidden:YES];
    [self.hangupBtn setHidden:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    /* add newline to end of the message for better formatting */
    NSString *toLog = [[NSString alloc] initWithFormat:@"%@\n",message];
    
    /* insert message */
    [self.logTextView insertText:toLog];
    
	/* Scroll textview */
	[self.logTextView scrollRangeToVisible:NSMakeRange([self.logTextView.text length], 0)];
}

/**
 * Reset call UI to initial state:
 * - answer button disabled
 * - Hangup button disabled
 * - clear call status label
 */
- (void)resetUI
{
    /* disable answer & hangup button */
    [self.answerBtn setEnabled:NO];
    [self.hangupBtn setEnabled:NO];
    
    /* clear callLbl */
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self.callLbl setText:@""];
    }];
}

/**
 * onLogin delegate implementation
 */
- (void)onLogin
{
    NSLog(@"- Login OK");
    [self logDebug:@"- Login OK"];
    [self logDebug:@"- Ready to receive a call"];
}

/**
 * onLoginFailed delegate implementation.
 */
- (void)onLoginFailed
{
    [self logDebug:@"- Login failed. Please check your username and password"];
}

/**
 * onIncomingCall delegate implementation
 */
- (void)onIncomingCall:(PlivoIncoming *)incoming
{
     /* display caller name in call status label */
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self.callLbl setText:incoming.fromContact];
        [self.answerBtn setHidden:NO];
        [self.hangupBtn setHidden:NO];
        [self.answerBtn setEnabled:YES];
        [self.hangupBtn setEnabled:YES];

    }];
    
    /* log it */
    NSString *logMsg = [[NSString alloc]initWithFormat:@"- Call from %@", incoming.fromContact];
    [self logDebug:logMsg];
    
    /* assign incCall var */
    self.incCall = incoming;
    
    
    /* print extra header */
    if (incoming.extraHeaders.count > 0) {
        [self logDebug:@"- Extra headers:"];
        for (NSString *key in incoming.extraHeaders) {
            NSString *val = [incoming.extraHeaders objectForKey:key];
            NSString *keyVal = [[NSString alloc] initWithFormat:@"-- %@ => %@", key, val];
            [self logDebug:keyVal];
        }
    }
}

/**
 * onIncomingCallHangup delegate implementation.
 */
- (void)onIncomingCallHangup:(PlivoIncoming *)incoming
{
    /* log it */
    [self logDebug:@"- Incoming call ended"];
    
    [self resetUI];
}

/**
 * onIncomingCallRejected implementation.
 */
- (void)onIncomingCallRejected:(PlivoIncoming *)incoming
{
    /* log it */
    [self logDebug:@"- Incoming call rejected"];
    
    [self resetUI];
}

/**
 * Answer incoming call
 */
- (IBAction)answerCall:(id)sender {
    /* log it */
    [self logDebug:@"- Answering call"];
    
    /* answer the call */
    if (self.incCall) {
        [self.incCall answer];
        [self.answerBtn setHidden:YES];
        [self.muteBtn setHidden:NO];
    }
    
}

/**
 * Hangup incoming call.
 */
- (IBAction)hangupCall:(id)sender {
    [self logDebug:@"- Hangup call"];
    if (self.incCall) {
        [self.incCall hangup];
    }
    [self resetUI];
    [self.muteBtn setHidden:YES];
    [self.answerBtn setHidden:YES];
    [self.hangupBtn setHidden:YES];
}

/**
 * Mute a call.
 */
- (IBAction)muteCall:(id)sender {
    
    if ([_muteBtn.currentTitle  isEqual: @"Mute"]) {
        [self logDebug:@"- Mute a call"];
        if (self.incCall) {
            [self.incCall mute];
        }
        [self.muteBtn setTitle:@"Unmute" forState:UIControlStateNormal];
    }
    else {
        [self logDebug:@"- Unmute a call"];
        if (self.incCall) {
            [self.incCall unmute];
        }
        [self.muteBtn setTitle:@"Mute" forState:UIControlStateNormal];
    }
    
}

@end


