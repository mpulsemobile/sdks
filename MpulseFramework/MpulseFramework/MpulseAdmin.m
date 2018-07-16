//
//  MpulseAdmin.m
//  MpulseFramework
//
//  Created by Rahul Verma on 06/07/18.
//  Copyright © 2018 mPulse. All rights reserved.
//

#import "MpulseAdmin.h"
#import "MpulseHelper.h"
#import "Constants.h"
#import "MpulseError.h"
#import "Member.h"

@implementation MpulseAdmin {
    NSString* _accessToken;
}

-(id _Nonnull)initWithAccessToken:(NSString *_Nonnull)accessToken {
    self = [super init];
    if (self) {
        _accessToken = accessToken;
    }
    return self;
}

- (void)shouldUpdateMemberWithID:(NSString * _Nullable)memberID details:(Member *_Nonnull)member andList:(NSString* _Nullable)listID completionHandler: (void (^_Nonnull)(MpulsePNResult result, NSString* _Nullable apiMessage, NSError * _Nullable error))completionHandler{
    __block NSError *error;
    __block MpulsePNResult res;
    [MpulseHelper  getControlPanelAPIUrlForAction:UpdateMember resultAs:^(NSURL *mpulseURL, NSError *err) {
        if(mpulseURL) {
            NSDictionary *headerDict = @{mPulseUserAgentFromHeaderKey: mPulseSDKRequest, mPulseAccessKeyHeaderKey: _accessToken};
            NSMutableDictionary *jsonRequest = [NSMutableDictionary dictionary];
            NSDictionary *memberJson = [Member getDictionaryFor:member];
            NSMutableDictionary *mutableMemberJson = [NSMutableDictionary dictionaryWithDictionary:memberJson];
            
            [mutableMemberJson setValue:memberID forKey:@"memberid"];
            
            [jsonRequest setValue:mutableMemberJson forKey:@"member"];
            [jsonRequest setValue:listID forKey:@"listid"];

            NSData *postdata = [NSJSONSerialization dataWithJSONObject:@{@"body":jsonRequest} options:0 error:&error];
            
            [MpulseHelper makeAPICallToPlatformForURL:mpulseURL withMethod:@"POST" headerDict:headerDict andBody:postdata completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                if(error){
                    res = Failure;
                    completionHandler(res, nil , error);
                }else{
                    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                    NSString *apiMsg;
                    if (data){
                        apiMsg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    }
                    long responseCode = (long)[httpResponse statusCode];
                    if (responseCode == 200) {
                        res = Success;
                        completionHandler(res, apiMsg, nil);
                    }else if(responseCode == 202){
                        res = Failure;
                        completionHandler(res, apiMsg, nil);
                    }else if(responseCode ==417){
                        res = Failure;
                        completionHandler(res, apiMsg, nil);
                    }
                    else{
                        res = Failure;
                        completionHandler(res,nil,error);
                    }
                }
            }];
        } else {
            error = [MpulseError returnMpulseErrorWithCode:kSomeErrorOccured];
            completionHandler(Failure,nil, error);
        }
    }];
    
}

- (void)shouldCreateNewMember:(Member * _Nonnull)member inList:(NSString* _Nullable)listID completionHandler: (void (^_Nonnull)(MpulsePNResult result, NSString* _Nullable apiMessage, NSError * _Nullable error))completionHandler{
    __block NSError *error;
    __block MpulsePNResult res;
    [MpulseHelper  getControlPanelAPIUrlForAction:AddMember resultAs:^(NSURL *mpulseURL, NSError *err) {
        if(mpulseURL) {
            // check here later
            NSDictionary *headerDict = @{mPulseUserAgentFromHeaderKey: mPulseSDKRequest, mPulseAccessKeyHeaderKey: _accessToken};
            NSMutableDictionary *jsonRequest = [NSMutableDictionary dictionary];
            NSDictionary *memberJson = [Member getDictionaryFor:member];
            [jsonRequest setValue:memberJson forKey:@"member"];
            [jsonRequest setValue:listID forKey:@"listid"];
            
            NSData *postdata = [NSJSONSerialization dataWithJSONObject:@{@"body":jsonRequest} options:0 error:&error];
            
            [MpulseHelper makeAPICallToPlatformForURL:mpulseURL withMethod:@"POST" headerDict:headerDict andBody:postdata completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                if(error){
                    res = Failure;
                    completionHandler(res, nil , error);
                }else{
                    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                    NSString *apiMsg;
                    if (data){
                        apiMsg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    }
                    long responseCode = (long)[httpResponse statusCode];
                    if (responseCode == 200) {
                        res = Success;
                        completionHandler(res, apiMsg, nil);
                    }else if(responseCode == 202){
                        res = Failure;
                        completionHandler(res, apiMsg, nil);
                    }else if(responseCode ==417){
                        res = Failure;
                        completionHandler(res, apiMsg, nil);
                    }
                    else{
                        res = Failure;
                        completionHandler(res,nil,error);
                    }
                }
            }];
        } else {
            error = [MpulseError returnMpulseErrorWithCode:kSomeErrorOccured];
            completionHandler(Failure,nil, error);
        }
    }];
    
}

- (void)shoudlSendEvent:(Event *_Nonnull)event inList:(NSString *_Nonnull)listID completionHandler: (void (^_Nullable)(MpulsePNResult result, NSString * _Nullable apiMessage, NSError * _Nullable error))completionHandler {
    __block NSError *error;
    __block MpulsePNResult res;
    [MpulseHelper  getControlPanelAPIUrlForAction:TriggerEvent resultAs:^(NSURL *mpulseURL, NSError *err) {
        if(mpulseURL) {
            NSDictionary *headerDict = @{mPulseUserAgentFromHeaderKey: mPulseSDKRequest, mPulseAccessKeyHeaderKey: _accessToken};
            
            NSMutableDictionary *jsonRequest = [NSMutableDictionary dictionary];
            NSMutableDictionary *eventDictionary = [NSMutableDictionary dictionary];
            [eventDictionary setValue:event.name forKey:@"name"];
            [eventDictionary setValue:[Event getDictionaryFor:event] forKey:@"event"];
            [jsonRequest setValue:eventDictionary forKey:@"events"];
            
            NSData *postdata = [NSJSONSerialization dataWithJSONObject:@{@"body":jsonRequest} options:0 error:&error];
            
            [MpulseHelper makeAPICallToPlatformForURL:mpulseURL withMethod:@"POST" headerDict:headerDict andBody:postdata completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                if(error){
                    res = Failure;
                    completionHandler(res, nil , error);
                }else{
                    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                    NSString *apiMsg;
                    if (data){
                        apiMsg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    }
                    long responseCode = (long)[httpResponse statusCode];
                    if (responseCode == 200) {
                        res = Success;
                        completionHandler(res, apiMsg, nil);
                    }else if(responseCode == 202){
                        res = Failure;
                        completionHandler(res, apiMsg, nil);
                    }else if(responseCode ==417){
                        res = Failure;
                        completionHandler(res, apiMsg, nil);
                    }
                    else{
                        res = Failure;
                        completionHandler(res,nil,error);
                    }
                }
            }];
        } else {
            error = [MpulseError returnMpulseErrorWithCode:kSomeErrorOccured];
            completionHandler(Failure,nil, error);
        }
    }];
}

-(void)updateMemberWithID:(NSString *_Nullable)memberID details:(Member *_Nonnull)member andList:(NSString*_Nullable)listID completionHandler: (void (^_Nonnull)(MpulsePNResult result, NSString* _Nullable apiMessage, NSError * _Nullable error))completionHandler {
    [self shouldUpdateMemberWithID:memberID details:member andList:listID completionHandler:^(MpulsePNResult result, NSString * _Nullable apiMessage, NSError * _Nullable error) {
        completionHandler(result, apiMessage, error);
    }];
}

-(void)createNewMember:(Member* _Nonnull)member inList:(NSString* _Nullable)listID completionHandler: (void (^_Nonnull)(MpulsePNResult result, NSString* _Nullable apiMessage, NSError * _Nullable error))completionHandler {
    [self  shouldCreateNewMember:member
                          inList:listID
               completionHandler:^(MpulsePNResult result, NSString * _Nullable apiMessage, NSError * _Nullable error) {
                   completionHandler(result, apiMessage, error);
               }];
}

-(void)sendEvent:(Event *_Nonnull)event inList:(NSString *_Nonnull)listID completionHandler: (void (^_Nullable)(MpulsePNResult result, NSString * _Nullable apiMessage, NSError * _Nullable error))completionHandler{
    [self shoudlSendEvent:event
                   inList:listID
        completionHandler:^(MpulsePNResult result, NSString * _Nullable apiMessage, NSError * _Nullable error) {
            completionHandler(result, apiMessage, error);
        }];
}

@end
