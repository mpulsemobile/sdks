//
//  mPulsePnRegister.h
//  mpulseFramework_ObjectiveC
//
//  Created by Heena Dhawan on 27/03/18.
//  Copyright © 2018 mPulse. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MpulseHandler.h"

@interface MpulsePNRegister : NSObject

+(void)registerForPushNotificationWithDeviceToken:(NSString*_Nonnull) deviceToken appMemberId:(NSString*_Nonnull)memberId completionHandler: (void (^_Nullable)(Result result, NSString* _Nullable apiMessage, NSError * _Nullable error))completionHandler;
+(void)unregisterForPushNotificationWithDeviceToken:(NSString*_Nonnull) deviceToken appMemberId:(NSString*_Nonnull)memberId completionHandler: (void (^_Nullable)(Result result, NSString* _Nullable apiMessage, NSError * _Nullable error))completionHandler;

@end

