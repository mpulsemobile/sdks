//
//  MpulseControlPanel.h
//  MpulseFramework
//
//  Created by Rahul Verma on 18/07/18.
//  Copyright © 2018 mPulse. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Member.h"
#import "Event.h"
#import "MpulseHandler.h"
@interface MpulseControlPanel : NSObject
/*
 MpulseAdminActionType lets SDK know which action to perform as Admin
 */
typedef enum
{
    AddMember,
    UpdateMember,
    TriggerEvent
} MpulseAdminActionType;

#pragma mark *** MpulseAudienceResult, MpulseEventUploadResult - Enum ***
/*
 MpulseAudienceResult gives AudienceAPISuccess or AudienceAPIFailure
 as result of adding or updating members on mpulse platform
 
 MpulseEventUploadResult gives EventAPISuccess or EventAPIFailure
 as result of triggering events to audience
 */
typedef enum
{
    AudienceAPISuccess,
    AudienceAPIFailure
} MpulseAudienceResult;

typedef enum
{
    EventAPISuccess,
    EventAPIFailure
}MpulseEventUploadResult;

@property (strong, nonatomic) NSString *_Nonnull refreshToken;

/*  @method shared
 *  @discussion This gives gives shared instance of this class as a singleton
 *  The initializers not available to subclasses or initialise new instance
 *  only sharedInstance should be used
 */
+ (instancetype _Nonnull)shared;

/**
 @method renewAccessTokenWithRefreshToken:completionHandler
 @param refreshToken token used to renew access token
 @param completionHandler the response with isSuccess as True or False and error if there is any
 @discussion This is the designated to let mPulse client renew the access token in case it expires
 */
-(void)renewAccessTokenWithRefreshToken:(NSString *_Nonnull)refreshToken completionHandler: (void (^_Nullable)(BOOL isSuccess, NSError * _Nullable error))completionHandler;

/**
 @method setAccessToken:andRefresehToken
 @param accessToken token obtained in exchange of OAuth credentials
 @param refreshToken token used later to get new access token
 @discussion This is the designated to let mPulse client obtain an access token in order to access the Control Panel
 */
-(void)setAccessToken:(NSString *_Nonnull) accessToken andRefresehToken:(NSString *_Nonnull)refreshToken;

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

/**
 @method logInWithOauthUsername:andPassword
 @param username the username of client obtained from Mpulse platform
 @param password the password of client obtained from Mpulse platform
 @param completionHandler  the response with isSuccess as True or False and error if there is any
 @discussion This is the designated to obtain an access token and intitialize MpulseControlPanel instance
 */
- (void)logInWithOauthUsername:(NSString *_Nonnull)username andPassword:(NSString *_Nonnull)password  completionHandler:(void (^_Nullable)(BOOL isSuccess, NSError * _Nullable error))completionHandler ;
@end
