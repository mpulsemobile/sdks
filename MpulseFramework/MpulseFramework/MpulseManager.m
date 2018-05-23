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
#import <UIKit/UIKit.h>

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
            if(error){
                completionHandler(nil , error);
            }else{
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
            }
        }];
    }
    else{
        error= [MpulseError returnMpulseErrorWithCode:kSomeErrorOccured];
        completionHandler(nil, error);
        return;
    }
}

+(void)trackAppUsageFor:(NSString * _Nonnull) appMemberId{
    __block NSError *error;
    __block NSMutableDictionary *dataDictionary;
    
    __block NSURL* generatedURL;
    
    [MpulseHelper getDictValues:^(NSDictionary * _Nullable dataDict, NSError * _Nullable err) {
        error = err;
        dataDictionary = (NSMutableDictionary *) dataDict;
    }];
    if (error) {
        [[NSUserDefaults standardUserDefaults] setBool:false forKey:mPulseTracking];
        return;
    }
    NSMutableDictionary *postDataDict = [[NSMutableDictionary alloc] init];
    postDataDict[mPulseOS] = [[UIDevice currentDevice] systemVersion];
    postDataDict[mPulseDeviceType] = [[UIDevice currentDevice] model];
    postDataDict[mPulseAppMemberId] = appMemberId;
    postDataDict[mPulseAppId] = dataDictionary[mPulseAppId];
    postDataDict[mPulseAccountId] = dataDictionary[mPulseAccountId];
    postDataDict[mPulseAppVersion] = [[[NSBundle mainBundle] infoDictionary] objectForKey:mPulseAppBundleVersion];
    NSString *queryStringForAppTracking = [NSString stringWithFormat:@"%@/%@/%@",  mPulseAPI,postDataDict[mPulseAccountId],mPulseTrackingAPI];
    NSData *postdata = [NSJSONSerialization dataWithJSONObject:postDataDict options:0 error:&error];
    [MpulseHelper getURLFormPulseServicewithQueryParams:queryStringForAppTracking resultAs:^(NSURL * _Nullable mpulseURL, NSError * _Nullable err) {
        generatedURL = mpulseURL;
        error = err;
    }];
    
    if (error) {
        [[NSUserDefaults standardUserDefaults] setBool:false forKey:mPulseTracking];
        return;
    }
    
    NSString *accessKey = dataDictionary[mPulseAccessKey];
    if (accessKey == nil ) {
        error = [MpulseError returnMpulseErrorWithCode:kNoAccessKey];
        [[NSUserDefaults standardUserDefaults] setBool:false forKey:mPulseTracking];
        return;
    }
    NSDictionary *headerDict = @{mPulseUserAgentFromHeaderKey: mPulseSDKRequest, mPulseAccessKeyHeaderKey: accessKey, mPulseContentType: mPulseContentTypeValue};
    [MpulseHelper makeAPICallToPlatformForURL:generatedURL withMethod:@"POST" headerDict:headerDict andBody:postdata completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(error){
            [[NSUserDefaults standardUserDefaults] setBool:false forKey:mPulseTracking];
        }else{
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
            NSString *apiMsg;
            if (data){
                apiMsg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            }
            long responseCode = (long)[httpResponse statusCode];
            if (responseCode >= 200 && responseCode <=300) {
                [[NSUserDefaults standardUserDefaults] setBool:true forKey:mPulseTracking];
            }
            if(error){
                [[NSUserDefaults standardUserDefaults] setBool:false forKey:mPulseTracking];
            }
        }
    }];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

@end

