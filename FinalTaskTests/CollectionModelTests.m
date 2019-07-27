//
//  CollectionModelTests.m
//  FinalTaskTests
//
//  Created by USER on 7/27/19.
//  Copyright © 2019 USER. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CollectionModel.h"

@interface CollectionModelTests : XCTestCase

@end

@implementation CollectionModelTests

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
                               @"title" : @"testTitle",
                               @"total_photos" : @1,
                               @"preview_photos" : @[
                                       @{@"urls" : @{@"thumb" : @"testThumb0"}},
                                       @{@"urls" : @{@"thumb" : @"testThumb1"}},
                                       @{@"urls" : @{@"thumb" : @"testThumb2"}}
                                       ],
                               };
    
    CollectionModel* expectedResult = [[CollectionModel alloc] init];
    expectedResult.identifier = @"testId";
    expectedResult.title = @"testTitle";
    expectedResult.totalPhoto = 1;
    expectedResult.mainImageURL = [NSURL URLWithString:@"testThumb0"];
    expectedResult.rightTopImageURL = [NSURL URLWithString:@"testThumb1"];
    expectedResult.rightBotoomImageURL = [NSURL URLWithString:@"testThumb2"];
    
    CollectionModel* actualResult = [[CollectionModel alloc] initWithDictionary:initData];
    
    XCTAssertNotNil(actualResult);
    XCTAssertTrue([actualResult isEqual:expectedResult]);
    
}

- (void)test_InitWithDictionary_nils {
    NSDictionary* initData = @{@"preview_photos" :@[@{},
                                                    @{},
                                                    @{}
                                                    ]
                               };
    
    CollectionModel* actualResult = [[CollectionModel alloc] initWithDictionary:initData];
    
    XCTAssertNotNil(actualResult);
    XCTAssertNil(actualResult.identifier);
    XCTAssertNil(actualResult.title);
    XCTAssertNil(actualResult.mainImageURL);
    XCTAssertNil(actualResult.rightTopImageURL);
    XCTAssertNil(actualResult.rightBotoomImageURL);
}

- (void)test_InitWithDictionary_Empty {
    NSDictionary* initData = @{};
    
    CollectionModel* actualResult = [[CollectionModel alloc] initWithDictionary:initData];
    
    XCTAssertNotNil(actualResult);
    XCTAssertNil(actualResult.identifier);
    XCTAssertNil(actualResult.title);
    XCTAssertNil(actualResult.mainImageURL);
    XCTAssertNil(actualResult.rightTopImageURL);
    XCTAssertNil(actualResult.rightBotoomImageURL);
}


@end
