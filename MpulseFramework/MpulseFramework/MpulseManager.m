//
//  MpulseManager.m
//  MpulseFramework
//
//  Created by Heena Dhawan on 12/04/18.
//  Copyright © 2018 mPulse. All rights reserved.
//

#import "MpulseManager.h"
#import "MpulseHelper.h"
#import "MpulseError.h"
#import "Constants.h"

@implementation MpulseManager

+ (void)queryStringForMessageCountWithMemberId:(NSString*) appMemberId result:(void (^)(NSString *urlStr, NSError* err))result{
    __block NSString *queryString;
    __block NSError *error;
    //Generate app/counter
    NSDictionary * serviceDict = mPulseServiceDictionary;
    NSString *serviceURLString = serviceDict[mPulseMsgCounterService];
    NSString *accountURLString = [NSString stringWithFormat:@"%@", serviceURLString];
    
    //Create Query String
    [MpulseHelper generateQueryStringWithBaseParametersAndAppMemberId:appMemberId result:^(NSString * _Nullable urlStr, NSError * _Nullable err) {
        queryString = urlStr;
        error = err;
    }];
    if(error){
        result(nil,error);
        return;
    }
    //change appId to appid in query string since it is small in api
    
    queryString = [queryString stringByReplacingOccurrencesOfString:@"appId"
                                                         withString:@"appid"];
    
    NSString* urlString = [NSString stringWithFormat:@"%@?%@", accountURLString, queryString];
    if (urlString == nil ) {
        error = [MpulseError returnMpulseErrorWithCode:kSomeErrorOccured];
        result(urlString,error);
        return;
    }
    result(urlString,error);
    
}

+(void)getMessageCountForAppMemberId:(NSString* _Nonnull)appMemberId completionHandler:(void (^_Nonnull)(NSDictionary * _Nullable jsonData, NSError * _Nullable error))completionHandler{
    //https://qa2-appmail.mpulsemobile.com/app/counter?appmemberid=heena&appid=TestPlatformPN&platform=ios
    __block NSError *error;
    __block NSString *queryStringForPN;
    __block NSURL* generatedURL;
    [self queryStringForMessageCountWithMemberId:appMemberId result:^(NSString *urlStr, NSError *err) {
        queryStringForPN = urlStr;
        error = err;
    }];
    if (error) {
        completionHandler(nil, error);
        return;
    }
    [MpulseHelper getURLFormPulseServicewithQueryParams:queryStringForPN resultAs:^(NSURL * _Nullable mpulseURL, NSError * _Nullable err) {
        generatedURL = mpulseURL;
        error = err;
    }];
    if (error) {
        completionHandler(nil, error);
        return;
    }
    if(generatedURL != nil){
        [MpulseHelper makeAPICallToPlatformForURL:generatedURL withMethod:@"GET" headerDict:nil andBody:nil completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
            NSError *responseError;
            long responseCode = (long)[httpResponse statusCode];
            if(responseCode >= 200 || responseCode <= 300){
                NSDictionary *jsonDict =  [NSJSONSerialization JSONObjectWithData:data options:0 error:&responseError];
                if (responseError) {
                    //Could not serialize json data
                    responseError = [MpulseError returnMpulseErrorWithCode:kJSONSerialisationError];
                    completionHandler(nil, responseError);
                }
                completionHandler(jsonDict, nil);
            }else{
                responseError = [MpulseError returnMpulseErrorWithCode:kBadRequest];
                completionHandler(nil, responseError);
            }
        }];
    }
    else{
        error= [MpulseError returnMpulseErrorWithCode:kSomeErrorOccured];
        completionHandler(nil, error);
        return;
    }
}

@end
