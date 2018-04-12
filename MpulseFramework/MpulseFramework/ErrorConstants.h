//
//  ErrorConstants.h
//  TestPlatformPN
//
//  Created by Heena Dhawan on 06/04/18.
//  Copyright © 2018 mPulse. All rights reserved.
//

#ifndef ErrorConstants_h
#define ErrorConstants_h
#define mPulseErrorDictionary @{@"5001":@"mPulseServices-Info.plist file not found. Add file to root directory",\
                                @"5002":@"APP_ID is missing from mPulseServices-Info.plist. Please contact mPulse",\
                                @"5003":@"ACCOUNT_ID is missing from mPulseServices-Info.plist. Please contact mPulse",\
                                @"5004":@"ACCESS_KEY is missing from mPulseServices-Info.plist. Please contact mPulse",\
                                @"5005":@"You can not pass a null or empty app member Id.",\
                                @"5006":@"Internet connection appears to be offline, please connect and try again.",\
                                @"5007":@"Some error occured",\
                                @"5008":@"You can not pass a null or empty device token.",\
                                @"5009":@"URL could not be generated, some parameter is wrong.",\
                                @"5010":@"JSON could not be serialised.",\
                                @"5011":@"Bad request, some query parameter is missing or wrong.",\
                                }
#define mPulseNoAppMemberIdConfigured @"App member Id not configured"
#define mPulseNoAppMemberIdConfiguredReason @"Mpulse Handler requires app member Id to be configured, to user any methods related to Mpulse Handler Or Mpulse Inbox View"
#endif /* ErrorConstants_h */
