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
#import "MpulseAdmin.h"
#import "MpulseError.h"

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

+ (MpulseControlPanel *_Nullable)logIntoControlPanelWithOauthUsername:(NSString *_Nonnull)username andPassword:(NSString *_Nonnull)password {
    __block MpulseControlPanel *controlPanel;
    dispatch_semaphore_t sem = dispatch_semaphore_create(0);
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        sleep(4);
        controlPanel = [[MpulseControlPanel alloc] initWithAccessToken:@"token heye heh he"];
        dispatch_semaphore_signal(sem);
    });
    dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
    return controlPanel;
}

@end

@implementation MpulseControlPanel {
    NSString *_accessToken;
}

-(MpulseControlPanel *)initWithAccessToken:(NSString *_Nonnull) accessToken {
    self = [super init];
    if (self && accessToken) {
        _accessToken = accessToken;
        return self;
    }
    return NULL;
}

-(void)addNewMember:(Member * _Nonnull)member toList:(NSString * _Nullable)listID completionHandler: (void (^_Nullable)(MpulsePNResult result, NSString * _Nullable apiMessage, NSError * _Nullable error))completionHandler{
    if (_accessToken == nil) {
        completionHandler(Failure,nil,[MpulseError returnMpulseErrorWithCode:kNoAccessToken]);
        return;
    }
    MpulseAdmin *mPulseAdmin = [[MpulseAdmin alloc] initWithAccessToken:_accessToken];
    [mPulseAdmin createNewMember:member inList:listID completionHandler:^(MpulsePNResult result, NSString * _Nullable apiMessage, NSError * _Nullable error) {
        completionHandler(result,apiMessage,error);
    }];
}

-(void)updateMemberWithID:(NSString *_Nullable)memberID details:(Member * _Nonnull)member andList:(NSString *_Nullable)listID completionHandler: (void (^_Nullable)(MpulsePNResult result, NSString * _Nullable apiMessage, NSError * _Nullable error))completionHandler{
    if (_accessToken == nil) {
        completionHandler(Failure,nil,[MpulseError returnMpulseErrorWithCode:kNoAccessToken]);
        return;
    }
    MpulseAdmin *mPulseAdmin = [[MpulseAdmin alloc] initWithAccessToken:_accessToken];
    [mPulseAdmin updateMemberWithID:memberID details:member andList:listID completionHandler:^(MpulsePNResult result, NSString * _Nullable apiMessage, NSError * _Nullable error) {
        completionHandler(result,apiMessage,error);
    }];
}

-(Member *_Nonnull)createMemberWithFirstName:(NSString *_Nullable)firstName lastName:(NSString *_Nullable)lastName email:(NSString *_Nullable)email phoneNumber:(NSString *_Nullable)phoneNumber  otherAttributes:(NSDictionary *_Nullable)otherAttributes {
    Member *member = [[Member alloc] init];
    member.firstname = firstName;
    member.lastName  = lastName;
    member.email  = email;
    member.phoneNumber  = phoneNumber;
    member.otherAttributes = otherAttributes;
    return member;
}

-(Event *_Nonnull)createEventWithName:(NSString *_Nonnull)name scheduledOn:(NSString *_Nonnull)scheduledOn evaluationScope:(NSString *_Nonnull)scope timezone:(NSString *_Nonnull)timezone memberID:(NSString *_Nonnull)memberID correlationID:(NSString *_Nullable)correlationID customAttributes:(NSDictionary *_Nullable)customAttributes {
    Event *event = [[Event alloc] init];
    event.name = name;
    event.scheduledOn = scheduledOn;
    event.evaluationScope = scope;
    event.timezone = timezone;
    event.memberid = memberID;
    event.correlationid = correlationID;
    event.customAttributes = customAttributes;
    return event;
}

-(void)triggerEvent:(Event *_Nonnull)event inList:(NSString *_Nonnull)listID completionHandler: (void (^_Nullable)(MpulsePNResult result, NSString * _Nullable apiMessage, NSError * _Nullable error))completionHandler {
    if (_accessToken == nil) {
        completionHandler(Failure,nil,[MpulseError returnMpulseErrorWithCode:kNoAccessToken]);
        return;
    }
    MpulseAdmin *mPulseAdmin = [[MpulseAdmin alloc] initWithAccessToken:_accessToken];
    [mPulseAdmin sendEvent:event inList:listID completionHandler:^(MpulseEventUploadResult result, NSString * _Nullable apiMessage, NSError * _Nullable error) {
        completionHandler(result,apiMessage,error);
    }];
}

@end

