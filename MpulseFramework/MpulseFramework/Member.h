//
//  Member.h
//  MpulseFramework
//
//  Created by Rahul Verma on 10/07/18.
//  Copyright © 2018 mPulse. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Member : NSObject

@property (strong, nonatomic) NSString *_Nullable firstname;
@property (strong, nonatomic) NSString *_Nullable lastName;
@property (strong, nonatomic) NSString *_Nullable phoneNumber;
@property (strong, nonatomic) NSString *_Nullable email;
@property (strong, nonatomic) NSDictionary *_Nullable otherAttributes;

/**
 @method initWithFirstName:lastName:email:phoneNumber
 @param firstName the first name of new member
 @param lastName the last name of new member
 @param email the email of new member
 @param phoneNumber the phone number of new member
 @param otherAttributes other attributes of new member; Attributes must be present on the Mpulse platform
 @returns Member for using with addNewMember:toList:completionHandler
 @discussion This is the designated to let mPulse client create a new member instance
 */
-(id _Nonnull )initWithFirstName:(NSString *_Nullable)firstName lastName:(NSString *_Nullable)lastName email:(NSString *_Nullable)email phoneNumber:(NSString *_Nullable)phoneNumber otherAttributes:(NSDictionary *_Nullable)otherAttributes;

-(id _Nonnull )init;

@end
