//
//  MpulseErrorTests.m
//  MpulseFrameworkTests
//
//  Created by mPulse Team on 11/04/18.
//  Copyright © 2018 mPulse. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MpulseError.h"
@interface MpulseErrorTests : XCTestCase

@end

@implementation MpulseErrorTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testMpulseError{
    NSError *err = [MpulseError returnMpulseErrorWithCode:kNoPlist];
    XCTAssertEqual(err.code, kNoPlist, @"Error codes are not same");
}


@end
