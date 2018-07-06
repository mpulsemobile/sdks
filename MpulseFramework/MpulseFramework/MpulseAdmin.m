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

-(void)createNewMember:(NSDictionary* _Nonnull)memberDetails completionHandler: (void (^_Nonnull)(MpulsePNResult result, NSString* _Nullable apiMessage, NSError * _Nullable error))completionHandler{
    __block NSError *error;
    [MpulseHelper  getControlPanelAPIUrlForAction:AddMember resultAs:^(NSURL *mpulseURL, NSError *err) {
        if(mpulseURL) {
            // check here later
            NSDictionary *headerDict = @{mPulseUserAgentFromHeaderKey: mPulseSDKRequest, mPulseAccessKeyHeaderKey: authorizationHeader};
            NSData *postdata = [NSJSONSerialization dataWithJSONObject:memberDetails options:0 error:&error];

            [MpulseHelper makeAPICallToPlatformForURL:mpulseURL withMethod:@"POST" headerDict:headerDict andBody:postdata completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                if(error){
                    completionHandler(Failure, nil , error);
                }else{
                    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                    NSString *apiMsg;
                    if (data){
                        apiMsg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    }
                    long responseCode = (long)[httpResponse statusCode];
                    if (responseCode == 200) {
                        MpulsePNResult res = Success;
                        completionHandler(res, apiMsg, nil);
                    }else if(responseCode == 202){
                        MpulsePNResult res = Failure;
                        completionHandler(res, apiMsg, nil);
                    }else if(responseCode ==417){
                        MpulsePNResult res = Failure;
                        completionHandler(res, apiMsg, nil);
                    }
                    else{
                        MpulsePNResult res = Failure;
                        completionHandler(res,nil,error);
                    }
                }
            }];
        } else {
            error= [MpulseError returnMpulseErrorWithCode:kSomeErrorOccured];
            completionHandler(Failure,nil, error);
        }
    }];
}

@end
