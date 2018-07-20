//
//  Event.h
//  MpulseFramework
//
//  Created by Rahul Verma on 16/07/18.
//  Copyright © 2018 mPulse. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Event : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *scheduledOn;
@property (strong, nonatomic) NSString *evaluationScope;
@property (strong, nonatomic) NSString *timezone;
@property (strong, nonatomic) NSString *memberid;
@property (strong, nonatomic) NSString *correlationid;
@property (strong, nonatomic) NSDictionary *customAttributes;

+(NSDictionary *)getDictionaryFor:(Event *)event;
@end
