//
//  MpulseError.m
//  TestPlatformPN
//
//  Created by Heena Dhawan on 06/04/18.
//  Copyright © 2018 mPulse. All rights reserved.
//

#import "MpulseError.h"
#import "ErrorConstants.h"
#import "Constants.h"

@implementation MpulseError
+(NSError *) returnMpulseErrorWithCode:(NSInteger) code{
    NSString *key = [NSString stringWithFormat:@"%ld", (long)code];
    NSDictionary *userInfoDict = @{NSLocalizedDescriptionKey : mPulseErrorDictionary[key]};
    NSError *error = [[NSError alloc] initWithDomain:@"mpulse" code:code userInfo:userInfoDict];
    return error;
}
@end
