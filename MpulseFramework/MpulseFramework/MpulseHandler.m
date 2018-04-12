//
//  MpulseServices.m
//  TestPlatformPN
//
//  Created by Heena Dhawan on 09/04/18.
//  Copyright © 2018 mPulse. All rights reserved.
//

#import "MpulseHandler.h"
#import "MpulsePNRegister.h"
#import "MpulseInboxView.h"

@implementation MpulseHandler
static id _instance;
NSString *_appMemberId = nil;

+ (instancetype)shareInstance {
    static MpulseHandler *shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[super alloc] initPrivate];
    });
    return shareInstance;
}

- (instancetype)initPrivate {
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(NSString*) appMemberId{
    return _appMemberId;
}

-(void)configure:(NSString*_Nonnull) withAppMemberId{
    _appMemberId = withAppMemberId;
}

-(void)registerForPushNotificationWithDeviceToken:(NSString*_Nonnull) withDeviceToken completionHandler: (void (^_Nullable)(Result result, NSString * _Nullable apiMessage, NSError * _Nullable error))completionHandler{
    [MpulsePNRegister registerForPushNotificationWithDeviceToken:withDeviceToken appMemberId:_appMemberId completionHandler:^(Result result, NSString * _Nullable apiMessage, NSError * _Nullable error) {
        completionHandler(result,apiMessage,error);
    }];
}

-(void)unregisterForPushNotificationWithDeviceToken:(NSString*_Nonnull) withDeviceToken completionHandler: (void (^_Nullable)(Result result, NSString * _Nullable apiMessage, NSError * _Nullable error))completionHandler{
    [MpulsePNRegister unregisterForPushNotificationWithDeviceToken:withDeviceToken appMemberId:_appMemberId completionHandler:^(Result result, NSString * _Nullable apiMessage, NSError * _Nullable error) {
        completionHandler(result,apiMessage,error);
    }];
}

-(MpulseInboxView*_Nonnull)getInboxView{
    return [[MpulseInboxView alloc]init];
}

-(void)getMessageCount:(void (^_Nullable)(NSDictionary* json, NSError * _Nullable error))completionHandler{
    [MpulseInboxView getMessageCountForAppMemberId:_appMemberId completionHandler:^(NSDictionary * _Nullable jsonData, NSError * _Nullable error) {
        completionHandler(jsonData, error);
    }];
}
@end

