//
//  MpulseControlPanel.m
//  MpulseFramework
//
//  Created by Rahul Verma on 18/07/18.
//  Copyright © 2018 mPulse. All rights reserved.
//

#import "MpulseControlPanel.h"
#import "MpulseError.h"
#import "ControlPanelManager.h"
#import "Constants.h"
#import "MpulseHelper.h"

@interface MpulseControlPanel()
/* The initializers not available to subclasses or initialise new instance
 only sharedInstance should be used
 */
+ (instancetype _Nonnull) new  NS_UNAVAILABLE;
- (instancetype _Nonnull) init NS_UNAVAILABLE;
@end

@implementation MpulseControlPanel{
    NSString *_accessToken;
}

static id _instance;
+ (instancetype)shared {
    static MpulseControlPanel *shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[super alloc] initPrivate];
    });
    return shareInstance;
}

- (instancetype)initPrivate {
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(void)setAccessToken:(NSString *_Nonnull) accessToken andRefresehToken:(NSString *_Nonnull)refreshToken{
    if (accessToken && accessToken) {
        _accessToken = accessToken;
        self.refreshToken = refreshToken;
    }
}

-(void)renewAccessTokenWithRefreshToken:(NSString *_Nonnull)refreshToken completionHandler: (void (^_Nullable)(BOOL isSuccess, NSError * _Nullable error))completionHandler{
    __block NSString *clientId;
    __block NSString *clientSecret;
    __block NSString *oauthEndoint;
    __block NSDictionary *mpulseDataDict;
    __block NSError *error;
    [MpulseHelper getCPConfiguration:^(NSDictionary * _Nullable dataDict, NSError * _Nullable err) {
        mpulseDataDict = dataDict;
        error = err;
    }];
    if (error) {
        NSLog(@"%@", error.localizedDescription);
        completionHandler(false,error);
    }
    clientId = mpulseDataDict[mPulseClientId];
    clientSecret = mpulseDataDict[mPulseClientSecret];
    oauthEndoint = mpulseDataDict[mPulseControlPanelEndpoint];
    
    if ( clientId  == nil) {
        NSLog(@"%@", (NSString *)[MpulseError returnMpulseErrorWithCode:kNoClientID]);
        completionHandler(false,error);
    }
    if ( clientSecret  == nil) {
        NSLog(@"%@", (NSString *)[MpulseError returnMpulseErrorWithCode:kNoClientSecret]);
        completionHandler(false,error);
    }
    if ( oauthEndoint  == nil) {
        NSLog(@"%@", (NSString *)[MpulseError returnMpulseErrorWithCode:kNoOAuthEndpoint]);
        completionHandler(false,error);
    }
    
    NSString *oauthQueryString =[NSString stringWithFormat:@"grant_type=refresh_token&client_id=%@&client_secret=%@&refresh_token=%@",clientId,clientSecret,refreshToken];
    NSData *postData = [oauthQueryString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    [MpulseHelper makeAPICallToPlatformForURL:[NSURL URLWithString:[oauthEndoint stringByAppendingString:@"/token"]] withMethod:@"POST" headerDict:@{@"content-type":@"application/x-www-form-urlencoded"} andBody:postData completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@", error.localizedDescription);
            completionHandler(false,error);
        } else if (data == nil) {
            NSLog(@"%@", [MpulseError returnMpulseErrorWithCode:kSomeErrorOccured]);
            completionHandler(false,[MpulseError returnMpulseErrorWithCode:kSomeErrorOccured]);
        } else {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
            long responseCode = (long)[httpResponse statusCode];
            if (responseCode == 200 ) {
                NSDictionary *response = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                _accessToken = response[@"access_token"];
                completionHandler(true,nil);
            } else {
                NSLog(@"%@",[NSHTTPURLResponse localizedStringForStatusCode:responseCode]);
                completionHandler(false,[MpulseError returnMpulseErrorWithCode:kSomeErrorOccured]);
            }
        }
    }];
}

-(void)addNewMember:(Member * _Nonnull)member toList:(NSString * _Nullable)listID completionHandler: (void (^_Nullable)(MpulseAudienceResult result, NSString * _Nullable apiMessage, NSError * _Nullable error))completionHandler{
    if (_accessToken == nil) {
        completionHandler(AudienceAPIFailure,nil,[MpulseError returnMpulseErrorWithCode:kNoAccessToken]);
        return;
    }
    ControlPanelManager *cpManager = [[ControlPanelManager alloc] initWithAccessToken:_accessToken];
    [cpManager createNewMember:member inList:listID completionHandler:^(MpulseAudienceResult result, NSString * _Nullable apiMessage, NSError * _Nullable error) {
        completionHandler(result,apiMessage,error);
    }];
}

-(void)updateMemberWithID:(NSString *_Nullable)memberID details:(Member * _Nonnull)member andList:(NSString *_Nullable)listID completionHandler: (void (^_Nullable)(MpulseAudienceResult result, NSString * _Nullable apiMessage, NSError * _Nullable error))completionHandler{
    if (_accessToken == nil) {
        completionHandler(AudienceAPIFailure,nil,[MpulseError returnMpulseErrorWithCode:kNoAccessToken]);
        return;
    }
    ControlPanelManager *cpManager = [[ControlPanelManager alloc] initWithAccessToken:_accessToken];
    [cpManager updateMemberWithID:memberID details:member andList:listID completionHandler:^(MpulseAudienceResult result, NSString * _Nullable apiMessage, NSError * _Nullable error) {
        completionHandler(result,apiMessage,error);
    }];
}

-(Member *_Nonnull)createMemberWithFirstName:(NSString *_Nullable)firstName lastName:(NSString *_Nullable)lastName email:(NSString *_Nullable)email phoneNumber:(NSString *_Nullable)phoneNumber  otherAttributes:(NSDictionary *_Nullable)otherAttributes {
    Member *member = [[Member alloc] init];
    member.firstname = firstName;
    member.lastName  = lastName;
    member.email  = email;
    member.phoneNumber  = phoneNumber;
    member.otherAttributes = otherAttributes;
    return member;
}

-(Event *_Nonnull)createEventWithName:(NSString *_Nonnull)name scheduledOn:(NSString *_Nonnull)scheduledOn evaluationScope:(NSString *_Nonnull)scope timezone:(NSString *_Nonnull)timezone memberID:(NSString *_Nonnull)memberID correlationID:(NSString *_Nullable)correlationID customAttributes:(NSDictionary *_Nullable)customAttributes {
    Event *event = [[Event alloc] init];
    event.name = name;
    event.scheduledOn = scheduledOn;
    event.evaluationScope = scope;
    event.timezone = timezone;
    event.memberid = memberID;
    event.correlationid = correlationID;
    event.customAttributes = customAttributes;
    return event;
}

-(void)triggerEvent:(Event *_Nonnull)event inList:(NSString *_Nonnull)listID completionHandler: (void (^_Nullable)(MpulseEventUploadResult result, NSString * _Nullable apiMessage, NSError * _Nullable error))completionHandler {
    if (_accessToken == nil) {
        completionHandler(EventAPIFailure,nil,[MpulseError returnMpulseErrorWithCode:kNoAccessToken]);
        return;
    }
    ControlPanelManager *cpManager = [[ControlPanelManager alloc] initWithAccessToken:_accessToken];
    [cpManager sendEvent:event inList:listID completionHandler:^(MpulseEventUploadResult result, NSString * _Nullable apiMessage, NSError * _Nullable error) {
        completionHandler(result,apiMessage,error);
    }];
}

- (void)logInWithOauthUsername:(NSString *_Nonnull)username andPassword:(NSString *_Nonnull)password  completionHandler:(void (^_Nullable)(BOOL isSuccess, NSError * _Nullable error))completionHandler  {
    __block NSString *clientId;
    __block NSString *clientSecret;
    __block NSString *oauthEndoint;
    __block NSDictionary *mpulseDataDict;
    __block NSError *error;
    [MpulseHelper getCPConfiguration:^(NSDictionary * _Nullable dataDict, NSError * _Nullable err) {
        mpulseDataDict = dataDict;
        error = err;
    }];
    if (error) {
        NSLog(@"%@", error.localizedDescription);
        completionHandler(false,error);
    }
    clientId = mpulseDataDict[mPulseClientId];
    clientSecret = mpulseDataDict[mPulseClientSecret];
    oauthEndoint = mpulseDataDict[mPulseControlPanelEndpoint];
    
    if ( clientId  == nil) {
        NSLog(@"%@", (NSString *)[MpulseError returnMpulseErrorWithCode:kNoClientID]);
        completionHandler(false,error);
    }
    if ( clientSecret  == nil) {
        NSLog(@"%@", (NSString *)[MpulseError returnMpulseErrorWithCode:kNoClientSecret]);
        completionHandler(false,error);
    }
    if ( oauthEndoint  == nil) {
        NSLog(@"%@", (NSString *)[MpulseError returnMpulseErrorWithCode:kNoOAuthEndpoint]);
        completionHandler(false,error);
    }
    
    NSString *oauthQueryString =[NSString stringWithFormat:@"grant_type=password&client_id=%@&client_secret=%@&username=%@&password=%@",clientId,clientSecret,username,password];
    NSData *postData = [oauthQueryString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    [MpulseHelper makeAPICallToPlatformForURL:[NSURL URLWithString:[oauthEndoint stringByAppendingString:@"/token"]] withMethod:@"POST" headerDict:@{@"content-type":@"application/x-www-form-urlencoded"} andBody:postData completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@", error.localizedDescription);
            completionHandler(false,error);
        } else if (data == nil) {
            NSLog(@"%@", [MpulseError returnMpulseErrorWithCode:kSomeErrorOccured]);
            completionHandler(false,[MpulseError returnMpulseErrorWithCode:kSomeErrorOccured]);
        } else {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
            long responseCode = (long)[httpResponse statusCode];
            if (responseCode == 200 ) {
                NSDictionary *response = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                [self setAccessToken:response[@"access_token"] andRefresehToken:response[@"refresh_token"]];
                completionHandler(true,nil);
            } else {
                NSLog(@"%@",[NSHTTPURLResponse localizedStringForStatusCode:responseCode]);
                [self clearSession];
                completionHandler(false,[MpulseError returnMpulseErrorWithCode:kSomeErrorOccured]);
            }
        }
    }];
}

- (void)clearSession {
    _accessToken = nil;
    self.refreshToken = nil;
}

@end
