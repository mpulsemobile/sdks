//
//  MpulseManager.h
//  MpulseFramework
//
//  Created by Heena Dhawan on 12/04/18.
//  Copyright © 2018 mPulse. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MpulseManager : NSObject

/**
 @method getMessageCountForAppMemberId:appMemberId:completionHandler
 @param appMemberId the appMemberId that is registered with mpulse
 @param completionHandler the response as Dictionary with JSON that has count of messages like unread, read, deteted, undeleted and error if any
 @discussion This is designated to get count of secure messages that are there in user's inbox
 */
+(void)getMessageCountForAppMemberId:(NSString * _Nonnull) appMemberId completionHandler:(void (^_Nonnull)(NSDictionary * _Nullable jsonData, NSError * _Nullable error)) completionHandler;

/**
 @method trackAppUsage:appMemberId:completionHandler
 @param appMemberId the appMemberId that is registered with mpulse
 @discussion This is to track app usage, if user does not use any other capability like, PN or secure mail.
 */
+(void)trackAppUsageFor:(NSString * _Nonnull) appMemberId;

@end

