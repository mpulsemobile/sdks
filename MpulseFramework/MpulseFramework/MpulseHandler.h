//
//  MpulseHandler.h
//  MpulseFramework
//
//  Created by mPulse Team on 10/04/18.
//  Copyright © 2018 mPulse. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Member.h"

@class MpulseInboxView;

/**
 *  MpulseHandler is convenience routines that registers and unregisters
 *  device token to appmemberId of a particular client's account
 *  to revceive/stop push notifications from mpulse platform
 *  Also it gives a inbox view for secure mail inbox of app member
 *  And the count of messages in secure mail inbox
 *
 *  Configure it with app memberId that is registered with mpulse platfrom
 *
 */

#pragma mark *** MpulsePNResult - Enum ***
/*
 MpulsePNResult gives Success or Failure
 as result of register/unregister with Push Notification on mpulse platform
 */
typedef enum
{
    Success,
    Failure
} MpulsePNResult;

/*
 MpulseAdminActionType lets SDK know which action to perform as Admin
 */
typedef enum
{
    AddMember,
    UpdateMember,
    TriggerEvent
} MpulseAdminActionType;

#pragma mark *** MpulseHandler ***
@interface MpulseHandler : NSObject

/*
 *   appMemberId is read-only property
 *   You can get it any time from shared instance of this class
 */
@property (readonly, nonatomic)NSString* _Nullable appMemberId;

/*  @method shared
 *  @discussion This gives gives shared instance of this class as a singleton
 *  The initializers not available to subclasses or initialise new instance
 *  only sharedInstance should be used
 */
+ (instancetype _Nonnull)shared;

/*
 *  @method configure:withAppMemberId
 *  @param withAppMemberId the memberId that is registered with mpulse
 *  @discussion This is the designated to configure MpulseHandler with appMemberId that can be used for all functionality
 */
-(void)configure:(NSString* _Nonnull) withAppMemberId;

/**
 @method registerForPushNotificationWithDeviceToken:withDeviceToken:completionHandler
 @param withDeviceToken the token that identifies the device to APNs. which you get in AppDelegate's didRegisterForRemoteNotificationsWithDeviceToken
 @param completionHandler the response with MpulsePNResult as Success or Failure, api message from backend if any and error if there is any
 @discussion This is the designated to register device token for app member id to mpulse platform to recieve push notifications from platform.
 */
-(void)registerForPushNotificationWithDeviceToken:(NSString* _Nonnull) withDeviceToken completionHandler:(void (^_Nullable)(MpulsePNResult result, NSString * _Nullable apiMessage, NSError * _Nullable error)) completionHandler;

/**
 @method unregisterForPushNotificationWithDeviceToken:withDeviceToken:completionHandler
 @param withDeviceToken the token that identifies the device to APNs. which you get in AppDelegate's didRegisterForRemoteNotificationsWithDeviceToken
 @param completionHandler the response with MpulsePNResult as Success or Failure, api message from backend if any and error if there is any
 @discussion This is the designated to un-register device token for app member id to mpulse platform to stop recieving push notifications from platform.
 */
-(void)unregisterForPushNotificationWithDeviceToken:(NSString* _Nonnull) withDeviceToken completionHandler:(void (^_Nullable)(MpulsePNResult result, NSString * _Nullable apiMessage, NSError * _Nullable error)) completionHandler;

/**
 @method inboxView
 @returns MpulseInboxView for secure message inbox for configured appmemberId in MpulseHandler
 @discussion This is the designated to get inbox view of secure mail messages for app member id in mpulse platform
 */
-(MpulseInboxView* _Nonnull)inboxView;

/**
 @method getInboxMessageCount:completionHandler
 @param completionHandler the response with JSON with count of read, unread, deleted, undeleted inbox messages and error if any
 @discussion This is the designated to get message count of secure mail inbox for app member id in mpulse platform
 */
-(void)getInboxMessageCount:(void (^_Nullable)(NSDictionary * _Nullable json, NSError * _Nullable error)) completionHandler;

/**
 @method addNewMember:toLists:completionHandler
 @param member the details of new member
 @param lists array of list IDs to which member has to be added
 @param completionHandler the response with MpulsePNResult as Success or Failure, api message from backend if any and error if there is any
 @discussion This is the designated to let mPulse client add a new member to the specified list
 */
-(void)addNewMember:(Member * _Nonnull)member toLists:(NSArray *_Nonnull)lists completionHandler: (void (^_Nullable)(MpulsePNResult result, NSString * _Nullable apiMessage, NSError * _Nullable error))completionHandler;

/**
 @method updateMemberWithID:details:andLists:completionHandler
 @param memberID id of the member
 @param member the details of member
 @param lists the array of list IDs for the member
 @param completionHandler the response with MpulsePNResult as Success or Failure, api message from backend if any and error if there is any
 @discussion This is the designated to let mPulse client add a new member to the specified list
 */
-(void)updateMemberWithID:(NSString *_Nonnull)memberID details:(Member * _Nonnull)member andLists:(NSArray *_Nonnull)lists completionHandler: (void (^_Nullable)(MpulsePNResult result, NSString * _Nullable apiMessage, NSError * _Nullable error))completionHandler;

/**
 @method createMemberWithFirstName:lastName:email:phoneNumber
 @param firstName the first name of new member
 @param lastName the last name of new member
 @param email the email of new member
 @param phoneNumber the phone number of new member
 @returns Member for using with addNewMember:toList:completionHandler
 @discussion This is the designated to let mPulse client create a new member instance
 */
-(Member *_Nonnull)createMemberWithFirstName:(NSString *_Nullable)firstName lastName:(NSString *_Nullable)lastName email:(NSString *_Nullable)email phoneNumber:(NSString *_Nullable)phoneNumber;

@end

