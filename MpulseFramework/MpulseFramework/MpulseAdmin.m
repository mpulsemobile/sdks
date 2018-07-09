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

- (void)shouldCreateNewMember:(NSDictionary * _Nonnull)memberDetails completionHandler: (void (^_Nonnull)(MpulsePNResult result, NSString* _Nullable apiMessage, NSError * _Nullable error))completionHandler{
    __block NSError *error;
    __block MpulsePNResult res;
    [MpulseHelper  getControlPanelAPIUrlForAction:AddMember resultAs:^(NSURL *mpulseURL, NSError *err) {
        if(mpulseURL) {
            // check here later
            NSDictionary *headerDict = @{mPulseUserAgentFromHeaderKey: mPulseSDKRequest, mPulseAccessKeyHeaderKey: authorizationHeader};
            NSData *postdata = [NSJSONSerialization dataWithJSONObject:memberDetails options:0 error:&error];
            
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

-(void)createNewMember:(NSDictionary* _Nonnull)memberDetails completionHandler: (void (^_Nonnull)(MpulsePNResult result, NSString* _Nullable apiMessage, NSError * _Nullable error))completionHandler{
    [self  shouldCreateNewMember:memberDetails
               completionHandler:^(MpulsePNResult result, NSString * _Nullable apiMessage, NSError * _Nullable error) {
                   completionHandler(result, apiMessage, error);
               }];
}

@end
