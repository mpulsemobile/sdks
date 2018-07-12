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
    NSString* authorizationHeader;
}

-(id)init {
    self = [super init];
    if (self) {
        NSString * username = @"user";
        NSString * accessKey = @"pass";
        NSString * loginString = [NSString stringWithFormat:@"%@:%@",username,accessKey];
        NSData * loginData = [loginString dataUsingEncoding:NSUTF8StringEncoding];
        authorizationHeader = [loginData base64EncodedStringWithOptions:0];
    }
    
    return self;
}

- (void)shouldUpdateMemberWithID:(NSString * _Nonnull)memberID details:(Member *_Nonnull)member andLists:(NSArray* _Nonnull)lists completionHandler: (void (^_Nonnull)(MpulsePNResult result, NSString* _Nullable apiMessage, NSError * _Nullable error))completionHandler{
    __block NSError *error;
    __block MpulsePNResult res;
    [MpulseHelper  getControlPanelAPIUrlForAction:UpdateMember resultAs:^(NSURL *mpulseURL, NSError *err) {
        if(mpulseURL) {
            // check here later
            mpulseURL = [mpulseURL URLByAppendingPathComponent:[NSString stringWithFormat:@"/%@",memberID]];
            NSDictionary *headerDict = @{mPulseUserAgentFromHeaderKey: mPulseSDKRequest, mPulseAccessKeyHeaderKey: authorizationHeader};
            NSMutableDictionary *jsonRequest = [NSMutableDictionary dictionary];
            NSDictionary *memberJson = [Member getDictionaryFor:member];
            [jsonRequest setValue:memberJson forKey:@"member"];
            [jsonRequest setValue:lists forKey:@"listid"];

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

- (void)shouldCreateNewMember:(Member * _Nonnull)member inLists:(NSArray* _Nonnull)lists completionHandler: (void (^_Nonnull)(MpulsePNResult result, NSString* _Nullable apiMessage, NSError * _Nullable error))completionHandler{
    __block NSError *error;
    __block MpulsePNResult res;
    [MpulseHelper  getControlPanelAPIUrlForAction:AddMember resultAs:^(NSURL *mpulseURL, NSError *err) {
        if(mpulseURL) {
            // check here later
            NSDictionary *headerDict = @{mPulseUserAgentFromHeaderKey: mPulseSDKRequest, mPulseAccessKeyHeaderKey: authorizationHeader};
            NSMutableDictionary *jsonRequest = [NSMutableDictionary dictionary];
            NSDictionary *memberJson = [Member getDictionaryFor:member];
            [jsonRequest setValue:memberJson forKey:@"member"];
            [jsonRequest setValue:lists forKey:@"listid"];
            
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


-(void)updateMemberWithID:(NSString *_Nonnull)memberID details:(Member *_Nonnull)member andLists:(NSArray*_Nonnull)lists completionHandler: (void (^_Nonnull)(MpulsePNResult result, NSString* _Nullable apiMessage, NSError * _Nullable error))completionHandler {
    [self shouldUpdateMemberWithID:memberID details:member andLists:lists completionHandler:^(MpulsePNResult result, NSString * _Nullable apiMessage, NSError * _Nullable error) {
        completionHandler(result, apiMessage, error);
    }];
}

-(void)createNewMember:(Member* _Nonnull)member inLists:(NSArray* _Nonnull)lists completionHandler: (void (^_Nonnull)(MpulsePNResult result, NSString* _Nullable apiMessage, NSError * _Nullable error))completionHandler {
    [self  shouldCreateNewMember:member
                          inLists:lists
               completionHandler:^(MpulsePNResult result, NSString * _Nullable apiMessage, NSError * _Nullable error) {
                   completionHandler(result, apiMessage, error);
               }];
}

@end
