//
//  Event.h
//  MpulseFramework
//
//  Created by Rahul Verma on 16/07/18.
//  Copyright © 2018 mPulse. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Event : NSObject

@property (strong, nonatomic) NSString *_Nonnull name;
@property (strong, nonatomic) NSString *_Nonnull scheduledOn;
@property (strong, nonatomic) NSString *_Nonnull evaluationScope;
@property (strong, nonatomic) NSString *_Nonnull timezone;
@property (strong, nonatomic) NSString *_Nonnull memberid;
@property (strong, nonatomic) NSString *_Nullable correlationid;
@property (strong, nonatomic) NSDictionary *_Nullable customAttributes;

/**
 @method initWithName:scheduledOn:evaluationScope:timezone:memberID:correlationID:customAttributes
 @param name the name of the Event in the mPulse Platform
 @param scheduledOn the date string at which event has to be triggered
 Accepted formats: YYYY-MM-DD HH:MM | +HH:MM.
 It Supports scheduling messages at a specified date and time(YYYY-MM-DD HH:MM)or relative to when the request is processed(+HH:MM).
 -Valid values for HH:Integers in the range from 0 to 24.
 -Value values for MM: Integers in the range from0 to 59.
 -If `scheduled_on` = “2018-01-01 09:30”, then the message will be scheduled for January 1, 2018 at 9:30 AM.
 -If `scheduled_on` = “+02:30”, then the message will be schedule for 2 hours and 30 minutes after the Event Instance is processed.
 -If `scheduled_on` = “+00:00”, then the message will be sent immediately after the request is processed
 @param scope the scope of the event
 Accepted values:no_rule | with_rule | all.
 -no_rule: Only messages with Custom Event triggers thatonly specify an Event Definition Name will be considered for processing.
 -with_rule: Only messages with Custom Event triggers that specify both an Event Definition Name and a rule based on an Event Attribute will be considered for processing.
 -all: All messages with Custom Event triggers for the given Event Definition Name will be considered for processing
 @param timezone the timezone of the event
 @param memberID id of the member receiving the event
 @param correlationID the tag of the event. The value provided can be used to retrieve information using theMessage Delivery Report API about Messages that were scheduled because of an Event
 @param customAttributes attributes of the event that are set as "Required" in event definition on control panel. It is used in the rule for the Custom Event riggered message you want to schedule
 @returns Event for using with triggerEvent:toMembers:inList:completionHandler
 @discussion This is the designated to let mPulse client create a new event instance
 */
-(id _Nonnull)initWithName:(NSString *_Nonnull)name scheduledOn:(NSString *_Nonnull)scheduledOn evaluationScope:(NSString *_Nonnull)scope timezone:(NSString *_Nonnull)timezone memberID:(NSString *_Nonnull)memberID correlationID:(NSString *_Nullable)correlationID customAttributes:(NSDictionary *_Nullable)customAttributes;

-(id _Nonnull )init;

@end
