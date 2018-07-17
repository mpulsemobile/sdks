//
//  MpulseError.h
//  MpulseFramework
//
//  Created by mPulse Team on 06/04/18.
//  Copyright © 2018 mPulse. All rights reserved.
//

#import <Foundation/Foundation.h>

enum mpulseErrorCode {kNoPlist=5001,\
    kNoAppId,\
    kNoAccountId,\
    kNoAccessKey,\
    kNoAppMemberId,\
    kNoClientID,\
    kNoClientSecret,\
    kNoInternet,\
    kSomeErrorOccured,\
    kNoDeviceId,\
    kCouldNotGenerateURL,\
    kJSONSerialisationError,\
    kNoAccessToken,\
    kInvalidRefreshToken,\
    kNoOAuthEndpoint,\
    kBadRequest
};

@interface MpulseError : NSObject
+(NSError *) returnMpulseErrorWithCode:(NSInteger) code;
@end
