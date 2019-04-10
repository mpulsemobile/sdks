//
//  Member.m
//  MpulseFramework
//
//  Created by Rahul Verma on 10/07/18.
//  Copyright © 2018 mPulse. All rights reserved.
//

#import "Member.h"

@implementation Member

-(id)initWithFirstName:(NSString *_Nullable)firstName lastName:(NSString *_Nullable)lastName email:(NSString *_Nullable)email phoneNumber:(NSString *_Nullable)phoneNumber otherAttributes:(NSDictionary *_Nullable)otherAttributes{
    self = [super init];
    if (self) {
        self.firstname = firstName;
        self.lastName  = lastName;
        self.email  = email;
        self.phoneNumber  = phoneNumber;
        self.otherAttributes = otherAttributes;
    }
    return self;
}

-(id _Nonnull )init{
    self = [super init];
    if (self) {
        return self;
    }
    return nil;
}

@end
