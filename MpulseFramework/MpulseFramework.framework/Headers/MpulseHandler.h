//
//  MpulseManager.h
//  mPulseFramework
//
//  Created by Heena Dhawan on 10/04/18.
//  Copyright © 2018 mPulse. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MpulseInboxView.h"
/**
 * MpulseHandler is convenience routines registers and unregisters
 * APNS device token to appmemberId of a particular client's account
 * to revcieve/stop push notifications from mpulse platform
 * Also it gives a inbox view for secure mail inbox of app member
 * And the count of messages in secure mail inbox
 *
 * Need to configure shared instance with app member Id
 *
 */
#pragma mark *** Result - Enum ***
/**
 * Result of register/unregister with Push Notification will give result as Success or Failure
 */
typedef enum
{
    Success,
    Failure
} Result;

#pragma mark *** MpulseHandler ***
@interface MpulseHandler : NSObject

/* appMemberId is read-only property, can get it any time from sharedInstance
 */
@property (readonly, nonatomic, copy) NSString* _Nullable appMemberId;

/* The initializers not available to subclasses or initialise new instance
   only sharedInstance should be used
 */
+ (instancetype _Nonnull ) new  NS_UNAVAILABLE;
- (instancetype _Nonnull ) init NS_UNAVAILABLE;

/* sharedInstance for a single object of the class
 */
+ (instancetype _Nonnull )shareInstance;

/* configure object with app member id to use it for all methods
 */
-(void)configure:(NSString*_Nonnull) WithAppMemberId;


/**
 @method registerForPushNotificationWithDeviceToken:deviceToken:completionHandler
 @param withDeviceToken the device token from APNS
 @param completionHandler the response with Result, api message and error
 @discussion This is the designated to register device token for app member id to mpulse platform to recieve push notifications from platform.
 */
-(void)registerForPushNotificationWithDeviceToken:(NSString*_Nonnull) withDeviceToken completionHandler: (void (^_Nullable)(Result result, NSString * _Nullable apiMessage, NSError * _Nullable error))completionHandler;

/**
 @method unregisterForPushNotificationWithDeviceToken:deviceToken:completionHandler
 @param withDeviceToken the device token from APNS
 @param completionHandler the response with Result, api message and error
 @discussion This is the designated to unregister device token for app member id to mpulse platform to recieve push notifications from platform.
 */
-(void)unregisterForPushNotificationWithDeviceToken:(NSString*_Nonnull) withDeviceToken completionHandler: (void (^_Nullable)(Result result, NSString * _Nullable apiMessage, NSError * _Nullable error))completionHandler;

/**
 @method getMessageCount:completionHandler
 @returns MpulseInboxView for secure message inbox
 @discussion This is the designated to get inbox of secure mail messages for app member id
 */
-(MpulseInboxView*_Nonnull)getInboxView;

/**
 @method getMessageCount:completionHandler
 @param completionHandler the response with JSON and error
 @discussion This is the designated to get message count of secure mail inbox for app member id
 */
-(void)getMessageCount:(void (^_Nullable)(NSDictionary* _Nullable json, NSError * _Nullable error))completionHandler;

@end
