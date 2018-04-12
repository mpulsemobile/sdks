//
//  MpulseInboxView.m
//  MpulseFramework
//
//  Created by mPulse Team on 05/04/18.
//  Copyright © 2018 mPulse. All rights reserved.
//

#import "MpulseInboxView.h"
#import "Constants.h"
#import "MpulseHelper.h"
#import <WebKit/WebKit.h>
#import "Reachability.h"
#import "MpulseError.h"
#import "ErrorConstants.h"
#import "MpulseHandler.h"

@interface MpulseInboxView()<WKNavigationDelegate>
@property (nonatomic, strong) WKWebView *inboxWebView;
@property (nonatomic, strong) Reachability *internetReachability;
@end

@implementation MpulseInboxView
@synthesize inboxWebView;
@synthesize delegate;
@synthesize internetReachability;

-(void) loadInbox{
    WKWebViewConfiguration*  webConfiguration = [[WKWebViewConfiguration alloc]init];
    inboxWebView = [[WKWebView alloc] initWithFrame:self.frame configuration:webConfiguration];
    inboxWebView.navigationDelegate = self;
    [self addSubview:inboxWebView];
    [self setBackgroundColor:[UIColor grayColor]];
    NSString* appMemberId = [MpulseHandler shared].appMemberId;
    if(appMemberId != nil){
        [self getmPulseSecureMailInboxVCForMemberId:appMemberId];
    }else{
       NSError* error = [MpulseError returnMpulseErrorWithCode:kNoAppMemberId];
        NSLog(@"%@",[error localizedDescription]);
        return;
    }
}

- (void)queryStringForSecureAppmailWithMemberId:(NSString*) appMemberId result:(void (^)(NSString *urlStr, NSError* err))result{
    __block NSDictionary *mPulseDataDict;
    __block NSString *queryString;
    __block NSError *error;
    [MpulseHelper getDictValues:^(NSDictionary * _Nullable dataDict, NSError * _Nullable err) {
        mPulseDataDict = dataDict;
        error = err;
    }];
    if (error) {
        result(nil, error);
        return;
    }else{
        NSString *accountId = mPulseDataDict[mPulseAccountId];
        NSString *urlString;
        
        if(accountId == nil){
            //Error - No account Id found in plist dictionary
            error = [MpulseError returnMpulseErrorWithCode:kNoAccountId];
            result(urlString,error);
            return;
        }
        //Generate api/{accountId}/webview eg. api/1232/webview
        NSDictionary * serviceDict = mPulseServiceDictionary;
        NSString *serviceURLString = serviceDict[mPulseSecureMsgService];
        NSString *accountURLString = [NSString stringWithFormat:@"api/%@/%@", accountId, serviceURLString];
        
        //Create Query String and encode with base 64
        [MpulseHelper generateQueryStringWithAccountIdBaseParametersAndAppMemberId:appMemberId result:^(NSString * _Nullable urlStr, NSError * _Nullable err) {
            queryString = urlStr;
            error = err;
        }];
        NSData* queryData = [queryString dataUsingEncoding: NSUTF8StringEncoding];
        NSString* base64queryString= [queryData base64EncodedStringWithOptions:0];
        //Combine generated URL and base64 encoded string
        urlString = [NSString stringWithFormat:@"%@?req=%@", accountURLString, base64queryString];
        if (urlString == nil ) {
            error = [MpulseError returnMpulseErrorWithCode:kSomeErrorOccured];
            result(urlString,error);
            return;
        }
        result(urlString,error);
    }
}

-(void) getmPulseSecureMailInboxVCForMemberId:(NSString*) appMemberId{
    NSLog(@"getmPulseSecureMailInboxVCForMemberId");
    __block NSError *error;
    __block NSString *queryStringForSecureMail;
    __block NSDictionary *mPulseDataDict;
    __block NSURL *secureMailURL;
    [MpulseHelper getDictValues:^(NSDictionary * _Nullable dataDict, NSError * _Nullable err) {
        mPulseDataDict = dataDict;
        error = err;
    }];
    if (error) {
        [delegate inboxViewDidFailLoadingWithError:error];
        return;
    }
    NSString *accessKey = mPulseDataDict[mPulseAccessKey];
    if (accessKey == nil ) {
        error = [MpulseError returnMpulseErrorWithCode:kNoAccessKey];
        [delegate inboxViewDidFailLoadingWithError:error];
        return;
    }
    NSDictionary *headerDict = @{mPulseUserAgentFromHeaderKey: mPulseUserAgentFromHeaderValue, mPulseAccessKeyHeaderKey: accessKey};
    
    //Generate query string base 64 encoded
    [self queryStringForSecureAppmailWithMemberId:appMemberId result:^(NSString *urlStr, NSError *err) {
        error = err;
        queryStringForSecureMail = urlStr;
    }];
    if (error) {
        [delegate inboxViewDidFailLoadingWithError:error];
        return;
    }
    //Generate URL
    [MpulseHelper getURLFormPulseServicewithQueryParams:queryStringForSecureMail resultAs:^(NSURL * _Nullable mpulseURL, NSError * _Nullable err) {
        error = err;
        secureMailURL = mpulseURL;
    }];
    if (error) {
        [delegate inboxViewDidFailLoadingWithError:error];
        return;
    }
    //Generate URL request
    NSMutableURLRequest *request = [MpulseHelper urlRequestForURL:secureMailURL withMethod:nil headerDict:headerDict andBody:nil];
    if(request){
        if([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable){
            error = [MpulseError returnMpulseErrorWithCode:kNoInternet];
            [delegate inboxViewDidFailLoadingWithError:error];
            return;
        }
        else{
            [inboxWebView loadRequest:request];
        }
    }else{
        error = [MpulseError returnMpulseErrorWithCode:kSomeErrorOccured];
        [delegate inboxViewDidFailLoadingWithError:error];
        return;
    }
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    [delegate inboxViewDidStartLoading];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    [delegate inboxViewDidFinishLoading];
}

-(void)didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    [delegate inboxViewDidFailLoadingWithError:error];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    [delegate inboxViewDidFailLoadingWithError:error];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse *)navigationResponse.response;
    NSInteger statusCode = [HTTPResponse statusCode];
    if(HTTPResponse && statusCode){
        decisionHandler(WKNavigationResponsePolicyAllow);
        return;
    }
    if(statusCode >= 400){
        //ERROR
        NSError *error = [MpulseError returnMpulseErrorWithCode:kSomeErrorOccured];
        [delegate inboxViewDidFailLoadingWithError:error];
    }
    decisionHandler(WKNavigationResponsePolicyAllow);
}

- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation{
}
@end

