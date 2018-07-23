//
//  Event.m
//  MpulseFramework
//
//  Created by Rahul Verma on 16/07/18.
//  Copyright © 2018 mPulse. All rights reserved.
//

#import "Event.h"

@implementation Event

- (id)initWithName:(NSString *_Nonnull)name scheduledOn:(NSString *_Nonnull)scheduledOn evaluationScope:(NSString *_Nonnull)scope timezone:(NSString *_Nonnull)timezone memberID:(NSString *_Nonnull)memberID correlationID:(NSString *_Nullable)correlationID customAttributes:(NSDictionary *_Nullable)customAttributes {
    self = [super init];
    if (self) {
        self.name = name;
        self.scheduledOn = scheduledOn;
        self.evaluationScope = scope;
        self.timezone = timezone;
        self.memberid = memberID;
        self.correlationid = correlationID;
        self.customAttributes = customAttributes;
    }
    return self;
}

- (id)init {
    self = [super init];
    if (self) {
        return self;
    }
    return nil;
}

@end
