//
//  Member.h
//  MpulseFramework
//
//  Created by Rahul Verma on 10/07/18.
//  Copyright © 2018 mPulse. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Member : NSObject

@property (strong, nonatomic) NSString *firstname;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *phoneNumber;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSDictionary *otherAttributes;

+(NSDictionary *)getDictionaryFor:(Member *)member;

@end
