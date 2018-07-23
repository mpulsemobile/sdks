//
//  MpulseControlPanel.h
//  MpulseFramework
//
//  Created by Rahul Verma on 18/07/18.
//  Copyright © 2018 mPulse. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Member;
@class Event;
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

@property (strong, nonatomic) NSString *_Nullable refreshToken;

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
- (void)logInWithOauthUsername:(NSString *_Nonnull)username andPassword:(NSString *_Nonnull)password  completionHandler:(void (^_Nullable)(BOOL isSuccess, NSError * _Nullable error))completionHandler;

@end
