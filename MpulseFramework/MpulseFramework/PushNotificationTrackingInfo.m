//
//  PushNotificationTrackingInfo.m
//  MpulseFramework
//
//  Created by Deepanshi Gupta on 29/10/18.
//  Copyright © 2018 mPulse. All rights reserved.
//

#import "PushNotificationTrackingInfo.h"
#import "NSDictionary+SafeAccess.h"
#import "Constants.h"

@implementation PushNotificationTrackingInfo

- (instancetype)initWithTrackingId:(NSString *_Nonnull)trackingId deliveryTimeStamp:(NSString *_Nullable)deliveryTimeStamp actionTimeStamp:(NSString *_Nonnull)actionTimeStamp appId:(NSString *_Nonnull)appId accountId:(NSString *_Nonnull)accountId {
    self = [super init];
    if (self) {
        self.trackingId = trackingId;
        self.deliveryTimeStamp = deliveryTimeStamp;
        self.actionTimeStamp = actionTimeStamp;
        self.action = 0;
        self.platform = mPulsePlatformValue;
        self.appId = appId;
        self.accountId = accountId;
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    return self;
}

//!returns object in JSON format
- (NSDictionary *) JSONObject {
    NSMutableDictionary *json = [[NSMutableDictionary alloc] init];
    
    [json setString:self.deliveryTimeStamp forKey:mPulseDeliveryTimeStamp];
    [json setString:self.actionTimeStamp forKey:mPulseActionTimeStamp];
    [json setString:self.trackingId forKey:mPulseTrackingId];
    [json setInteger:self.action forKey:mPulseAction];
    [json setString:self.platform forKey:mPulsePlatform];
    [json setString:self.appId forKey:mPulseAppIdKey];
    [json setString:self.accountId forKey:mPulseAccountIdKey];

    return json;
}

@end
