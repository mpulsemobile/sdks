//
//  Event.m
//  MpulseFramework
//
//  Created by Rahul Verma on 16/07/18.
//  Copyright © 2018 mPulse. All rights reserved.
//

#import "Event.h"

@implementation Event
+(NSDictionary *)getDictionaryFor:(Event *)event {
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue:event.name forKey:@"name"];
    [dictionary setValue:event.scheduledOn forKey:@"scheduled_on"];
    [dictionary setValue:event.evaluationScope forKey:@"evaluation_scope"];
    [dictionary setValue:event.timezone forKey:@"timezone"];
    [dictionary setValue:event.memberid forKey:@"memberid"];
    [dictionary setValue:event.correlationid forKey:@"correlationid"];
    for(id key in event.customAttributes) {
        [dictionary setValue:[event.customAttributes objectForKey:key] forKey:key];
    }
    return dictionary;
}
@end
