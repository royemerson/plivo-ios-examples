# Plivo iOS SDK

This SDK lets you develop apps which will use Plivo [SIP Endpoints](https://plivo.com/docs/api/endpoint/).

## Instructions
- Copy the static library libPlivoEndpoint.a into your xcode project, make sure you include this in your Build Phase->Link Binary With Libraries section.
- In the Build Settings tab, include the Headers folder recursively in the Header Search Paths
- Create a new [endpoint](https://plivo.com/endpoint) or use an existing Plivo endpoint.
- Check out the example PlivoCall xcode project for working code.

## Limitations
This SDK is a first cut and should be considered alpha and some of the APIs are likely to change in the future

## Documentation

### PlivoEndpoint.h
PlivoEndpoint class allows you to register a Plivo SIP Endpoint. Once an endpoint is registered, calls can be made or received using the same.

    -(void) registerEndpoint: (NSString*) username AndPassword: (NSString*) password;
This method is used to register an endpoint. If the endpoint is successfully registered a notification would be sent to the delegate `registerSuccess`. In case of a failure a notification is sent to the delegate `registerFailure`.

@param username The username of the endpoint created on Plivo

@param password The password of the endpoint created on Plivo

@returns None

    -(void) unRegisterEndpoint;
This method is used to unregister an endpoint.

@param None

@returns None

    -(PlivoOutgoing*) createOutgoingCall;
Calling this method would return an PlivoOutgoing object, linked to the registered endpoint. Calling this method on an unregistered PlivoEndpoint object would return an empty object.

@param None

@returns PlivoOutgoing object which can be used to make outbound calls

### PlivoIncoming.h
PlivoIncoming class contains methods to handle incoming call. An object of this class will be received on the `-(void)incomingCall:(PlivoIncoming*) incoming;` delegate.

    -(void) answer;
This method is used to answer an incoming call. 

@param None

@returns None

    -(void) mute;
This method is used to mute the call.

@param None

@returns None

    -(void) unmute;
This method is used to unmute the call. Calling this method on an already unmuted call won't have any effect.

@param None

@returns None

    -(void) sendDigits: (NSString*) digits;
Calling this method on the PlivoIncoming object with the digits would send DTMF on that call.

@param digits The digits to be sent as a NSString

@returns None

    -(void) disconnect;
Calling this method on the PlivoIncoming object would disconnect the call.

@param None

@returns None

    -(void) reject;
Calling this method would reject the incoming call.

@param None

@returns None

### PlivoOutgoing.h
PlivoOutgoing class contains methods to make and control an outbound call. 

    -(void) makeCall: (NSString*) sipURI;
This method would make a call to the sipURI.

@param sipURI The sipURI to make a call to.

@returns None

    - (void)mute;
Calling this method on the PlivoOutgoing object would mute the call.

@param None

@returns None

    - (void)unmute;
Calling this method on the PlivoOutgoing object would unmute the call.

@param None

@returns None

    - (void)sendDigits:(NSString*)digits;
Calling this method on the PlivoOutgoing object with the digits would send DTMF on that call.

@param digits A string of digits which needs to be sent

@returns None

    - (void)disconnect;
Calling this method on the PlivoOutgoing object would disconnect the call.

@param None

@returns None


### PlivoEndpoint.h delegates
    - (void)registerSuccess;
This delegate gets called when registration to an endpoint is successful.

    - (void)registerFailure;
This delegate gets called when registration to an endpoint fails.

    - (void)incomingCall:(PlivoIncoming*)incoming;
On an incoming call to a registered endpoint, this delegate receives a PlivoIncoming object.

    - (void)incomingCallReject:(PlivoIncoming*)incoming;
On an incoming call, if the call is disconnected by the caller, this delegate would be triggered with the PlivoIncoming object.

    - (void)incomingCallHangup:(PlivoIncoming*)incoming;
On an incoming call, if the call is disconnected by the caller after being answered, this delegate would be triggered with the PlivoIncoming object.

    - (void)incomingDigit:(NSString*)digit;
On an active endpoint, this delegate would be called with the digit received on the call.

    - (void)outgoingCallAnswered:(PlivoOutgoing*)call;
When an outgoing call is answered, this delegate would be called with the PlivoOutgoing object.

    - (void)outgoingCallRinging:(PlivoOutgoing*)call;
When an outgoing call is ringing, this delegate would be called with the PlivoOutgoing object.

    - (void)outgoingCallRejected:(PlivoOutgoing*)call;
When an outgoing call is rejected by the called number, this delegate would be called with the PlivoOutgoing object.

    - (void)outgoingCallHangup:(PlivoOutgoing*)call;
When an outgoing call is disconnected by the called number after the call has been answered.
 

