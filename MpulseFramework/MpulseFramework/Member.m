//
//  Member.m
//  MpulseFramework
//
//  Created by Rahul Verma on 10/07/18.
//  Copyright © 2018 mPulse. All rights reserved.
//

#import "Member.h"

@implementation Member

+(NSDictionary *)getDictionaryFor:(Member *)member {
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue:member.firstname forKey:@"firstname"];
    [dictionary setValue:member.lastName forKey:@"lastname"];
    [dictionary setValue:member.email forKey:@"email"];
    [dictionary setValue:member.phoneNumber forKey:@"mobilephone"];
    for(id key in member.otherAttributes) {
        [dictionary setValue:[member.otherAttributes objectForKey:key] forKey:key];
    }
    return dictionary;
}

@end
