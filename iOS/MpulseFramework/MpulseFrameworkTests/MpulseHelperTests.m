//
//  MpulseHelperTests.m
//  MpulseFrameworkTests
//
//  Created by mPulse Team on 11/04/18.
//  Copyright © 2018 mPulse. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MpulseHelper.h"
#import "ErrorConstants.h"
#import "MpulseError.h"

@interface MpulseHelperTests : XCTestCase

@end

@implementation MpulseHelperTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testGenerateQueryStringWithBaseParametersAndAppMemberId_NIL_appmemberid{
    [MpulseHelper generateQueryStringWithBaseParametersAndAppMemberId:nil result:^(NSString * _Nullable urlStr, NSError * _Nullable err) {
        XCTAssertEqual(err.code, kNoAppMemberId , "AppMemberId - Error code is not same");
    }];
}
- (void)testGenerateQueryStringWithBaseParametersAndAppMemberId_NIL_deviceToken{
    [MpulseHelper generateQueryStringWithAccountIdBaseParametersAndAppMemberId:@"hi" andDeviceToken:nil result:^(NSString * _Nullable urlStr, NSError * _Nullable err) {
        XCTAssertEqual(err.code, kNoDeviceId , "DeviceToken - Error code is not same");
    }];
}
-(void) testgenerateQueryStringWithAccountIdBaseParametersAndAppMemberId{
    [MpulseHelper generateQueryStringWithAccountIdBaseParametersAndAppMemberId:@"h" result:^(NSString * _Nullable urlStr, NSError * _Nullable err) {
        XCTAssertEqual(err.code, kNoPlist , "Plist - Error code is not same");
    }];
}



@end
