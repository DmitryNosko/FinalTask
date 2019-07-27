//
//  PhotoModelTests.m
//  FinalTaskTests
//
//  Created by USER on 7/27/19.
//  Copyright © 2019 USER. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PhotoModel.h"

@interface PhotoModelTests : XCTestCase
@end

@implementation PhotoModelTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)test_InitWithDictionary {
    NSDictionary* initData = @{@"id" : @"testId",
                        @"description" : @"testDescription",
                        @"alt_description" : @"testAltDescription",
                        @"urls" : @{@"thumb" : @"testThumb"},
                        @"user" : @{@"username" : @"testUsername"},
                        @"width" : @(111),
                        @"height" : @(222)
                        };
    
    PhotoModel* expectedResult = [[PhotoModel alloc] init];
    expectedResult.identifier = @"testId";
    expectedResult.name = @"testDescription";
    expectedResult.altDescription = @"testAltDescription";
    expectedResult.thumbURL = [NSURL URLWithString:@"testThumb"];
    expectedResult.userName = @"testUsername";
    expectedResult.width = @(111);
    expectedResult.height = @(222);
    
    PhotoModel* actualResult = [[PhotoModel alloc] initWithDictionary:initData];
    
    XCTAssertNotNil(actualResult);
    XCTAssertTrue([actualResult isEqual:expectedResult]);
    
}

- (void)test_InitWithDictionary_nils {
    NSDictionary* initData = @{@"urls" : @{},
                               @"user" : @{},
                               };
    
    PhotoModel* actualResult = [[PhotoModel alloc] initWithDictionary:initData];
    
    XCTAssertNotNil(actualResult);
    XCTAssertNil(actualResult.identifier);
    XCTAssertNil(actualResult.name);
    XCTAssertNil(actualResult.altDescription);
    XCTAssertNil(actualResult.thumbURL);
    XCTAssertNil(actualResult.userName);
    XCTAssertNil(actualResult.width);
    XCTAssertNil(actualResult.height);
}

- (void)test_InitWithDictionary_Empty {
    NSDictionary* initData = @{};
    
    PhotoModel* actualResult = [[PhotoModel alloc] initWithDictionary:initData];
    
    XCTAssertNotNil(actualResult);
    XCTAssertNil(actualResult.identifier);
    XCTAssertNil(actualResult.name);
    XCTAssertNil(actualResult.altDescription);
    XCTAssertNil(actualResult.thumbURL);
    XCTAssertNil(actualResult.userName);
    XCTAssertNil(actualResult.width);
    XCTAssertNil(actualResult.height);
}


@end
