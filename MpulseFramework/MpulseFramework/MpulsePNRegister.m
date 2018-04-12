//
//  mPulsePnRegister.m
//  mpulseFramework_ObjectiveC
//
//  Created by Heena Dhawan on 27/03/18.
//  Copyright © 2018 mPulse. All rights reserved.
//

#import "MpulsePNRegister.h"
#import "Constants.h"
#import "MpulseHelper.h"
#import "MpulseError.h"

@implementation MpulsePNRegister

+(void)generateQueryStringForPNForMemberId:(NSString*)appMemberId withDeviceToken:(NSString* )deviceToken result:(void (^)(NSString* urlStr, NSError* err))result{
    __block NSString *queryString;
    __block NSError *error;
    [MpulseHelper generateQueryStringWithAccountIdBaseParametersAndAppMemberId:appMemberId andDeviceToken:deviceToken result:^(NSString * _Nullable urlStr, NSError * _Nullable err) {
        queryString = urlStr;
        error = err;
    }];
    if(error){
        result(nil,error);
        return;
    }
    
    NSDictionary * serviceDict = mPulseServiceDictionary;
    NSString *serviceURLString = serviceDict[mPulsePNService];
    
    //Combine generated URL
    NSString* urlString = [NSString stringWithFormat:@"%@?%@",serviceURLString, queryString];
    if (urlString == nil ) {
        error = [MpulseError returnMpulseErrorWithCode:kSomeErrorOccured];
        result(urlString,error);
        return;
    }
    result(urlString,error);
}

+(void)shouldregisterForPushNotification:(BOOL)registerforPN WithDeviceToken:(NSString*_Nonnull) deviceToken appMemberId:(NSString* _Nonnull)memberId completionHandler: (void (^_Nullable)(Result result, NSString* _Nullable apiMessage, NSError * _Nullable error))completionHandler{
    __block NSError *error;
    __block NSString *queryStringForPN;
    __block NSURL* generatedURL;
    Result result = Failure;
    [self generateQueryStringForPNForMemberId:memberId withDeviceToken:deviceToken result:^(NSString *urlStr, NSError *err) {
        queryStringForPN = urlStr;
        error = err;
    }];
    if (error) {
        completionHandler(result, nil, error);
        return;
    }
    [MpulseHelper getURLFormPulseServicewithQueryParams:queryStringForPN resultAs:^(NSURL * _Nullable mpulseURL, NSError * _Nullable err) {
        generatedURL = mpulseURL;
        error = err;
    }];
    if (error) {
        completionHandler(result, nil ,error);
        return;
    }
    if(generatedURL != nil){
        NSString *actionHeaderValues = registerforPN ? mPulseRegisterActionHeaderValue : mPulseUnRegisterActionHeaderValue;
        NSDictionary *headerDict = @{mPulseUserAgentHeaderKey: mPulseUserAgentHeaderValue, mPulseActionHeaderKey: actionHeaderValues};
        [MpulseHelper makeAPICallToPlatformForURL:generatedURL withMethod:@"GET" headerDict:headerDict andBody:nil completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
            NSString *apiMsg;
            if (data){
                apiMsg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            }
            long responseCode = (long)[httpResponse statusCode];
            if (responseCode == 200) {
                Result res = Success;
                completionHandler(res, apiMsg, nil);
            }else if(responseCode == 202){
                Result res = Failure;
                completionHandler(res, apiMsg, nil);
            }else if(responseCode ==417){
                Result res = Failure;
                completionHandler(res, apiMsg, nil);
            }
            else{
                Result res = Failure;
                completionHandler(res,nil,error);
            }
        }];
    }else{
        error= [MpulseError returnMpulseErrorWithCode:kSomeErrorOccured];
        completionHandler(result, nil , error);
        return;
    }
}

+(void)registerForPushNotificationWithDeviceToken:(NSString*_Nonnull) deviceToken appMemberId:(NSString*_Nonnull)memberId completionHandler: (void (^_Nullable)(Result result, NSString* _Nullable apiMessage, NSError * _Nullable error))completionHandler{
    [self shouldregisterForPushNotification:true WithDeviceToken:deviceToken appMemberId:memberId completionHandler:^(Result result, NSString * _Nullable apiMessage, NSError * _Nullable error) {
        completionHandler(result,apiMessage,error);
    }];
}

+(void)unregisterForPushNotificationWithDeviceToken:(NSString*_Nonnull) deviceToken appMemberId:(NSString*_Nonnull)memberId completionHandler: (void (^_Nullable)(Result result, NSString* _Nullable apiMessage, NSError * _Nullable error))completionHandler{
    NSString *replaceToken = [NSString stringWithFormat:@"%@_%@", deviceToken, memberId];
    [self shouldregisterForPushNotification:true WithDeviceToken:replaceToken appMemberId:memberId completionHandler:^(Result result, NSString * _Nullable apiMessage, NSError * _Nullable error) {
        completionHandler(result,apiMessage,error);
    }];
}



@end

