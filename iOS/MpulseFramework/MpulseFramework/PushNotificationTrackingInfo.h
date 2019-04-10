//
//  PushNotificationTrackingInfo.h
//  MpulseFramework
//
//  Created by Deepanshi Gupta on 29/10/18.
//  Copyright © 2018 mPulse. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PushNotificationTrackingInfo : NSObject

@property (strong, nonatomic) NSString *_Nonnull trackingId;
@property (strong, nonatomic) NSString *_Nullable deliveryTimeStamp;
@property (strong, nonatomic) NSString *_Nonnull actionTimeStamp;
@property (strong, nonatomic) NSString *_Nonnull appId;
@property (strong, nonatomic) NSString *_Nonnull platform;
@property (strong, nonatomic) NSString *_Nonnull accountId;
@property (assign, nonatomic) NSInteger action;

/**
 @method initWithTrackingId:deliveryTimeStamp:actionTimeStamp:appId:accountId
 @param trackingId the tracking id of the push notification in the mPulse platform
 @param deliveryTimeStamp the date and time string at which push notification was delivered on iPhone
 Accepted format: YYYY-MM-DD HH:MM:SS
 @param actionTimeStamp the date and time string at which push notification was opened by user
 Accepted format: YYYY-MM-DD HH:MM:SS
 @param appId the app id of a particular client's app recieving push notification
 @param accountId id the account id of a particular client's account recieving push notification
 @returns PushNotificationTrackingInfo for using with trackPushNotificationOpenedWithTrackingInfo: pushNotificationTrackingURL: completionHandler
 @discussion This is the designated to send push notification info to mPulse platform to track push notification is opened
 */
-(instancetype _Nonnull)initWithTrackingId:(NSString *_Nonnull)trackingId deliveryTimeStamp:(NSString *_Nullable)deliveryTimeStamp actionTimeStamp:(NSString *_Nonnull)actionTimeStamp appId:(NSString *_Nonnull)appId accountId:(NSString *_Nonnull)accountId;

-(instancetype _Nonnull )init;

- (NSDictionary *) JSONObject;

@end

NS_ASSUME_NONNULL_END


