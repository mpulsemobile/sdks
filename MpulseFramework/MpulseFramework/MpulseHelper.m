//
//  MpulseHelper.m
//  MpulseFramework
//
//  Created by mPulse Team on 02/04/18.
//  Copyright © 2018 mPulse. All rights reserved.
//

#import "MpulseHelper.h"
#import "Constants.h"
#import "MpulseError.h"
#import "ErrorConstants.h"
#import "Reachability.h"

@implementation MpulseHelper

+ (void)getDictValues:(void (^)(NSDictionary* dataDict, NSError* err))result{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource: mPulseConfigFile ofType: mPulseConfigFileType];
    if ([[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
        NSDictionary *mainDictionary = [NSDictionary dictionaryWithContentsOfFile:plistPath];
        result(mainDictionary,nil);
        return;
    }
    else{
        NSError *error = [MpulseError returnMpulseErrorWithCode:kNoPlist];
        result(nil,error);
        return;
    }
}

+(void)generateQueryStringWithBaseParametersAndAppMemberId:(NSString*_Nonnull)appMemberId result:(void (^_Nonnull)(NSString* _Nullable urlStr, NSError* _Nullable err))result{
    __block NSDictionary *mPulseDataDict;
    __block NSError *error;
    if (appMemberId == nil || [appMemberId length] == 0) {
        error = [MpulseError returnMpulseErrorWithCode:kNoAppMemberId];
        result(nil,error);
        return;
    }
    [self getDictValues:^(NSDictionary * _Nullable dataDict, NSError * _Nullable err) {
        mPulseDataDict = dataDict;
        error = err;
    }];
    if (error) {
        result(nil, error);
        return;
    }else{
        NSString *appId = mPulseDataDict[mPulseAppId];
        if(appId == nil){
            //Error - No app Id found in plist dictionary
            error = [MpulseError returnMpulseErrorWithCode:kNoAppId];
            result(nil,error);
            return;
        }
        //Create Query String and encode with base 64
        NSString *queryString = [NSString stringWithFormat:@"appId=%@&platform=ios&appmemberid=%@&version=1.0",appId,appMemberId];
        result(queryString, nil);
    }
}

+(void)generateQueryStringWithAccountIdBaseParametersAndAppMemberId:(NSString*_Nonnull)appMemberId result:(void (^_Nonnull)(NSString* _Nullable urlStr, NSError* _Nullable err))result{
    __block NSString *queryString;
    __block NSError *error;
    __block NSDictionary *mPulseDataDict;
    [self getDictValues:^(NSDictionary * _Nullable dataDict, NSError * _Nullable err) {
        mPulseDataDict = dataDict;
        error = err;
    }];
    if (error) {
        result(nil, error);
        return;
    }
    //Get account ID
    NSString *accountId = mPulseDataDict[mPulseAccountId];
    if(accountId == nil){
        //Error - No account Id found in plist dictionary
        error = [MpulseError returnMpulseErrorWithCode:kNoAccountId];
        result(nil,error);
        return;
    }
    //Get Query string with appId=%@&platform=ios&appmemberid=%@
    [self generateQueryStringWithBaseParametersAndAppMemberId:appMemberId result:^(NSString *urlStr, NSError *err) {
        queryString = urlStr;
        error = err;
    }];
    if (error) {
        result(nil, error);
        return;
    }
    //Create Query String with accountId
    queryString = [NSString stringWithFormat:@"%@&accountId=%@",queryString,accountId];
    result(queryString, nil);
}

+(void)generateQueryStringWithAccountIdBaseParametersAndAppMemberId:(NSString*_Nonnull)appMemberId andDeviceToken:(NSString*_Nonnull)deviceToken result:(void (^_Nonnull)(NSString* _Nullable urlStr, NSError* _Nullable err))result{
    __block NSString *queryString;
    __block NSError *error;
    if (deviceToken == nil) {
        //Error - No app member Id passed
        error = [MpulseError returnMpulseErrorWithCode:kNoDeviceId];
        result(nil,error);
        return;
    }
    [self generateQueryStringWithAccountIdBaseParametersAndAppMemberId:appMemberId result:^(NSString *urlStr, NSError *err) {
        queryString = urlStr;
        error = err;
    }];
    if (error) {
        result(nil, error);
        return;
    }
    //Create Query String with accountId
    queryString = [NSString stringWithFormat:@"%@&deviceToken=%@",queryString,deviceToken];
    result(queryString, nil);
}

+ (void) getURLFormPulseServicewithQueryParams:(NSString* ) queryString resultAs:(void (^)(NSURL* mpulseURL, NSError* err))result{
    __block NSDictionary *mpulseDataDict;
    __block NSError *error;
    NSURL *mpulseURL;
    [self getDictValues:^(NSDictionary * _Nullable dataDict, NSError * _Nullable err) {
        mpulseDataDict = dataDict;
        error = error;
    }];
    if(mpulseDataDict){
        NSString * mPulseURLString = mpulseDataDict[mPulseAPIURL];
        NSString *endPointURL = [NSString stringWithFormat:@"%@/%@",mPulseURLString,queryString];
        endPointURL = [endPointURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        mpulseURL = [NSURL URLWithString:endPointURL];
        if (mpulseURL == nil) {
            NSError *error = [MpulseError returnMpulseErrorWithCode:kCouldNotGenerateURL];
            result(nil,error);
            return;
        }
        result(mpulseURL,error);
    }else{
        NSError *error = [MpulseError returnMpulseErrorWithCode:kSomeErrorOccured];
        result(nil,error);
        return;
    }
}

+(NSMutableURLRequest*_Nonnull) urlRequestForURL:(NSURL*_Nonnull)url withMethod:(NSString*_Nullable)method headerDict:(NSDictionary*_Nullable)headerDict andBody:(NSData*_Nullable)body{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    //Set method
    if(method){
        [request setHTTPMethod:method];
    }else{
        [request setHTTPMethod:@"GET"];
    }
    //Set headers if any
    if (headerDict) {
        for (id key in headerDict){
            [request setValue:headerDict[key] forHTTPHeaderField:key];
        }
    }
    //Set body if any
    if (body){
        [request setHTTPBody:body];
    }
    return request;
}

+ (void)makeAPICallToPlatformForURL:(NSURL*)url withMethod:(NSString*)method headerDict:(NSDictionary*)headerDict andBody:(NSData*)body completionHandler: (void (^)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error))completionHandler{
    if([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable){
        NSError *error = [MpulseError returnMpulseErrorWithCode:kNoInternet];
        completionHandler(nil, nil, error);
        return;
    }
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    NSMutableURLRequest *request = [self urlRequestForURL:url withMethod:method headerDict:headerDict andBody:body];
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        completionHandler(data, response, error);
    }];
    [postDataTask resume];
}

+ (void)getControlPanelAPIUrlForAction:(MpulseAdminActionType)action  resultAs:(void (^)(NSURL* mpulseURL, NSError* err))result{
    // First get query string [it further uses getDict to fetch plist parameters]  else error
    // Then check if base url is available in plist else again error
    __block NSString *mpulseURLString;
    __block NSString *controlPanelPath;
    __block NSError *error;
    __block NSDictionary *mpulseDataDict;
    [self getDictValues:^(NSDictionary * _Nullable dataDict, NSError * _Nullable err) {
        mpulseDataDict = dataDict;
        error = error;
    }];
    
    if(mpulseDataDict){
        mpulseURLString = mpulseDataDict[mPulseAPIURL];
        NSString *endPointURL = [NSString stringWithFormat:@"%@/",mpulseURLString];
        mpulseURLString = endPointURL;
        if (mpulseURLString == nil) {
            NSError *error = [MpulseError returnMpulseErrorWithCode:kCouldNotGenerateURL];
            result(nil,error);
            return;
        }
    }else{
        NSError *error = [MpulseError returnMpulseErrorWithCode:kSomeErrorOccured];
        result(nil,error);
        return;
    }
    
    [self getControlPanelAccessPathWithCompletion:^(NSString * _Nullable path, NSError * _Nullable err) {
        controlPanelPath = path;
        error = err;
    }];
    
    if(controlPanelPath != nil ) {
        mpulseURLString = [NSString stringWithFormat:@"%@%@",mpulseURLString, controlPanelPath];
        switch (action) {
            case AddMember:{
                mpulseURLString = [NSString stringWithFormat:@"%@%@",mpulseURLString,@"/members"];
            }
                break;
            default:
                break;
        }
        mpulseURLString = [mpulseURLString  stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        if (mpulseURLString == nil) {
            NSError *error = [MpulseError returnMpulseErrorWithCode:kCouldNotGenerateURL];
            result(nil,error);
            return;
        } else {
            result([NSURL URLWithString:mpulseURLString],nil);
        }
    }else{
        NSError *error = [MpulseError returnMpulseErrorWithCode:kSomeErrorOccured];
        result(nil,error);
        return;
    }
    
    result([NSURL URLWithString:@""],nil);
}

+ (void)getControlPanelAccessPathWithCompletion:(void (^_Nonnull)(NSString* _Nullable urlStr, NSError* _Nullable err))result{
    __block NSString *queryString;
    __block NSError *error;
    __block NSDictionary *mPulseDataDict;
    [self getDictValues:^(NSDictionary * _Nullable dataDict, NSError * _Nullable err) {
        mPulseDataDict = dataDict;
        error = err;
    }];
    if (error) {
        result(nil, error);
        return;
    }else{
        /*
         NSString *appId = mPulseDataDict[mPulseAppId];
         if(appId == nil){
         //Error - No app Id found in plist dictionary
         error = [MpulseError returnMpulseErrorWithCode:kNoAppId];
         result(nil,error);
         return;
         }
         */
        NSString *accountId = mPulseDataDict[mPulseAccountId];
        if(accountId == nil){
            //Error - No account Id found in plist dictionary
            error = [MpulseError returnMpulseErrorWithCode:kNoAccountId];
            result(nil,error);
            return;
        }
        queryString = [NSString stringWithFormat:@"account/%@",accountId];
        result(queryString, nil);
    }
}

@end
