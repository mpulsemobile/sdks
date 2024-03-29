//
//  MpulseHandler.m
//  MpulseFramework
//
//  Created by mPulse Team on 09/04/18.
//  Copyright © 2018 mPulse. All rights reserved.
//

#import "MpulseHandler.h"
#import "MpulsePNRegister.h"
#import "MpulseInboxView.h"
#import "MpulseManager.h"
#import "Constants.h"
#import "ControlPanelManager.h"
#import "MpulseError.h"
#import "MpulseHelper.h"

@interface MpulseHandler()
/* The initializers not available to subclasses or initialise new instance
 only sharedInstance should be used
 */
+ (instancetype _Nonnull) new  NS_UNAVAILABLE;
- (instancetype _Nonnull) init NS_UNAVAILABLE;
@end

@implementation MpulseHandler
static id _instance;
NSString *_appMemberId = nil;

+ (instancetype)shared {
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
    NSString *appMember = [[NSUserDefaults standardUserDefaults] valueForKey:mPulseAppMemberIdValue];
    if(appMember != withAppMemberId){
        //App memeber id changed
        [[NSUserDefaults standardUserDefaults] setBool:false forKey:mPulseTracking];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    _appMemberId = withAppMemberId;
    [self trackApp];
    [[NSUserDefaults standardUserDefaults] setValue:withAppMemberId forKey:mPulseAppMemberIdValue];
    
}

-(void)registerForPushNotificationWithDeviceToken:(NSString*_Nonnull) withDeviceToken completionHandler: (void (^_Nullable)(MpulsePNResult result, NSString * _Nullable apiMessage, NSError * _Nullable error))completionHandler{
    [MpulsePNRegister registerForPushNotificationWithDeviceToken:withDeviceToken appMemberId:_appMemberId completionHandler:^(MpulsePNResult result, NSString * _Nullable apiMessage, NSError * _Nullable error) {
        completionHandler(result,apiMessage,error);
    }];
}

-(void)unregisterForPushNotificationWithDeviceToken:(NSString*_Nonnull) withDeviceToken completionHandler: (void (^_Nullable)(MpulsePNResult result, NSString * _Nullable apiMessage, NSError * _Nullable error))completionHandler{
    [MpulsePNRegister unregisterForPushNotificationWithDeviceToken:withDeviceToken appMemberId:_appMemberId completionHandler:^(MpulsePNResult result, NSString * _Nullable apiMessage, NSError * _Nullable error) {
        completionHandler(result,apiMessage,error);
    }];
}

-(void)trackPushNotificationOpenedWithTrackingId:(NSString*_Nonnull) trackingId deliveryTimeStamp: (NSString*_Nonnull)deliveryTimeStamp actionTimeStamp: (NSString*_Nonnull)actionTimeStamp completionHandler: (void (^_Nullable)(MpulsePNResult result, NSString*_Nullable apiMessage, NSError * _Nullable error))completionHandler {
    [MpulsePNRegister trackPushNotificationOpenedWithTrackingId:trackingId deliveryTimeStamp:deliveryTimeStamp actionTimeStamp:actionTimeStamp completionHandler:^(MpulsePNResult result, NSString * _Nullable apiMessage, NSError * _Nullable error) {
        completionHandler(result,apiMessage,error);
    }];
}

-(MpulseInboxView*_Nonnull)inboxView{
    return [[MpulseInboxView alloc]init];
}

-(void)getInboxMessageCount:(void (^_Nullable)(NSDictionary* json, NSError * _Nullable error))completionHandler{
    [MpulseManager getMessageCountForAppMemberId:_appMemberId completionHandler:^(NSDictionary * _Nullable jsonData, NSError * _Nullable error) {
        completionHandler(jsonData, error);
    }];
}

-(void)trackApp{
    if(!([[NSUserDefaults standardUserDefaults] boolForKey:mPulseTracking])){
        [MpulseManager trackAppUsageFor:_appMemberId];
    }
}

@end
