//
//  MpulseHelper.h
//  MpulseFramework
//
//  Created by mPulse Team on 02/04/18.
//  Copyright © 2018 mPulse. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MpulseHandler.h"
#import "MpulseControlPanel.h"
@interface MpulseHelper : NSObject

+ (void)getDictValues:(void (^_Nullable)(NSDictionary* _Nullable dataDict, NSError* _Nullable err))result;

+ (void)getCPConfiguration:(void (^_Nullable)(NSDictionary* _Nullable dataDict, NSError* _Nullable err))result;

+(void)generateQueryStringWithBaseParametersAndAppMemberId:(NSString*_Nonnull)appMemberId result:(void (^_Nonnull)(NSString* _Nullable urlStr, NSError* _Nullable err))result;

+(void)generateQueryStringWithAccountIdBaseParametersAndAppMemberId:(NSString*_Nonnull)appMemberId result:(void (^_Nonnull)(NSString* _Nullable urlStr, NSError* _Nullable err))result;

+(void)generateQueryStringWithAccountIdBaseParametersAndAppMemberId:(NSString*_Nonnull)appMemberId andDeviceToken:(NSString*_Nonnull)deviceToken result:(void (^_Nonnull)(NSString* _Nullable urlStr, NSError* _Nullable err))result;

+ (void) getURLFormPulseServicewithQueryParams:(NSString* _Nullable ) queryString resultAs:(void (^_Nullable)(NSURL* _Nullable mpulseURL, NSError* _Nullable err))result;

+ (void) makeAPICallToPlatformForURL:(NSURL* _Nonnull)url withMethod:(NSString*_Nonnull)method headerDict:(NSDictionary*_Nullable)headerDict andBody:(NSData*_Nullable)body completionHandler: (void (^_Nullable)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error))completionHandler;

+(NSMutableURLRequest*_Nonnull) urlRequestForURL:(NSURL*_Nonnull)url withMethod:(NSString*_Nullable)method headerDict:(NSDictionary*_Nullable)headerDict andBody:(NSData*_Nullable)body;

+ (void)getControlPanelAPIUrlForAction:(MpulseAdminActionType)action resultAs:(void (^_Nullable)(NSURL* _Nullable mpulseURL, NSError* _Nullable err))result;
@end
