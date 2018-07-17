//
//  MpulseHandler.h
//  MpulseFramework
//
//  Created by mPulse Team on 10/04/18.
//  Copyright © 2018 mPulse. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Member.h"
#import "Event.h"

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

#pragma mark *** MpulsePNResult, MpulseAudienceResult, MpulseEventUploadResult - Enum ***
/*
 MpulsePNResult gives Success or Failure
 as result of register/unregister with Push Notification on mpulse platform
 
 MpulseAudienceResult gives Success or Failure
 as result of adding or updating members on mpulse platform
 
 MpulseEventUploadResult gives Success or Failure
 as result of triggering events to audience
 */
typedef enum
{
    Success,
    Failure
} MpulsePNResult, MpulseAudienceResult, MpulseEventUploadResult;

/*
 MpulseAdminActionType lets SDK know which action to perform as Admin
 */
typedef enum
{
    AddMember,
    UpdateMember,
    TriggerEvent
} MpulseAdminActionType;


@interface MpulseControlPanel : NSObject

@property (strong, nonatomic) NSString *_Nonnull refreshToken;
/**
 @method renewAccessTokenWithRefreshToken:completionHandler
 @param refreshToken token used to renew access token
 @param completionHandler the response with isSuccess as True or Fail and error if there is any
 @discussion This is the designated to let mPulse client renew the access token in case it expires
 */
-(void)renewAccessTokenWithRefreshToken:(NSString *_Nonnull)refreshToken completionHandler: (void (^_Nullable)(BOOL isSuccess, NSError * _Nullable error))completionHandler;

/**
 @method initWithAccessToken
 @param accessToken token obtained in exchange of OAuth credentials
 @discussion This is the designated to let mPulse client obtain an access token in order to access the Control Panel
 */
-(MpulseControlPanel *_Nullable)initWithAccessToken:(NSString *_Nonnull) accessToken andRefresehToken:(NSString *_Nonnull)refreshToken;

/**
 @method addNewMember:toList:completionHandler
 @param member the details of new member
 @param listID ID of the list to which member has to be added
 @param completionHandler the response with MpulseAudienceResult as Success or Failure, api message from backend if any and error if there is any
 @discussion This is the designated to let mPulse client add a new member to specified lists
 */
-(void)addNewMember:(Member * _Nonnull)member toList:(NSString *_Nullable)listID completionHandler: (void (^_Nullable)(MpulseAudienceResult result, NSString * _Nullable apiMessage, NSError * _Nullable error))completionHandler;

/**
 @method updateMemberWithID:details:andList:completionHandler
 @param memberID id of the member
 @param member the details of member
 @param listID ID of the list
 @param completionHandler the response with MpulseAudienceResult as Success or Failure, api message from backend if any and error if there is any
 @discussion This is the designated to let mPulse client update an existing member and his lists
 */
-(void)updateMemberWithID:(NSString *_Nullable)memberID details:(Member * _Nonnull)member andList:(NSString *_Nullable)listID completionHandler: (void (^_Nullable)(MpulseAudienceResult result, NSString * _Nullable apiMessage, NSError * _Nullable error))completionHandler;

/**
 @method createMemberWithFirstName:lastName:email:phoneNumber
 @param firstName the first name of new member
 @param lastName the last name of new member
 @param email the email of new member
 @param phoneNumber the phone number of new member
 @param otherAttributes other attributes of new member; Attributes must be present on the Mpulse platform
 @returns Member for using with addNewMember:toList:completionHandler
 @discussion This is the designated to let mPulse client create a new member instance
 */
-(Member *_Nonnull)createMemberWithFirstName:(NSString *_Nullable)firstName lastName:(NSString *_Nullable)lastName email:(NSString *_Nullable)email phoneNumber:(NSString *_Nullable)phoneNumber otherAttributes:(NSDictionary *_Nullable)otherAttributes;

/**
 @method createEventWithName:scheduledOn:evaluationScope:timezone:memberID:correlationID:customAttributes
 @param name the name of the Event in the mPulse Platform
 @param scheduledOn the date string at which event has to be triggered
 Accepted formats: YYYY-MM-DD HH:MM | +HH:MM.
 It Supports scheduling messagesat a specifieddate and time(YYYY-MM-DD HH:MM)orrelative to when the request is processed(+HH:MM).
 -Valid values for HH:Integers in the range from 0 to 24.
 -Value values for MM: Integers in the range from0 to 59.
 -If `scheduled_on` = “2018-01-01 09:30”, then the message will be scheduled for January 1, 2018 at 9:30 AM.
 -If `scheduled_on` = “+02:30”, then the message will be schedule for2 hours and 30 minutes after the Event Instance is processed.
 -If `scheduled_on` = “+00:00”, then the message will be sentimmediately after the requestis processed
 @param scope the scope of the event
 Accepted values:no_rule | with_rule | all.
 -no_rule: Only messages with Custom Event triggers thatonly specify an Event Definition Name will be considered for processing.
 -with_rule: Only messages with Custom Event triggers that specify both an Event Definition Name and a rule based on an Event Attribute will be considered for processing.
 -all: All messages with Custom Event triggersfor the given Event Definition Name will be considered for processing
 @param timezone the timezone of the event
 @param memberID id of the member receiving the event
 @param correlationID the tag of the event. The value provided can be used to retrieve information using theMessage Delivery Report API about Messages that were scheduled because of an Event
 @param customAttributes attributes of the event that are set as "Required" in event definition on control panel. It is used in the rule for the Custom Event riggered message you want to schedule
 @returns Event for using with triggerEvent:toMembers:inList:completionHandler
 @discussion This is the designated to let mPulse client create a new event instance
 */
-(Event *_Nonnull)createEventWithName:(NSString *_Nonnull)name scheduledOn:(NSString *_Nonnull)scheduledOn evaluationScope:(NSString *_Nonnull)scope timezone:(NSString *_Nonnull)timezone memberID:(NSString *_Nonnull)memberID correlationID:(NSString *_Nullable)correlationID customAttributes:(NSDictionary *_Nullable)customAttributes;

/**
 @method triggerEvent:inList:completionHandler
 @param event the details of event
 @param listID a valid List ID created in your Control Panel Account. Members included in the event must be subscribed to thelist
 @param completionHandler the response with MpulseEventUploadResult as Success or Failure, api message from backend if any and error if there is any
 @discussion This is the designated to let mPulse client trigger events to the audience
 */
-(void)triggerEvent:(Event *_Nonnull)event inList:(NSString *_Nonnull)listID completionHandler: (void (^_Nullable)(MpulseEventUploadResult result, NSString * _Nullable apiMessage, NSError * _Nullable error))completionHandler;
@end

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
 @method logIntoControlPanelWithOauthUsername:andPassword
 @param username the username of client obtained from Mpulse platform
 @param password the password of client obtained from Mpulse platform @discussion This is the designated to obtain an access token and intitialize MpulseControlPanel instance
 */
+ (MpulseControlPanel *_Nullable)logIntoControlPanelWithOauthUsername:(NSString *_Nonnull)username andPassword:(NSString *_Nonnull)password;
@end
