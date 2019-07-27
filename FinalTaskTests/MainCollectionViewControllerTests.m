//
//  MainCollectionViewControllerTests.m
//  FinalTaskTests
//
//  Created by USER on 7/27/19.
//  Copyright © 2019 USER. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MainCollectionViewController.h"
#import "UnsplashHttpClient.h"

@interface UnsplashHttpClientMock : UnsplashHttpClient
@end

@implementation UnsplashHttpClientMock
- (void) getPhotoCollections:(NSUInteger) page perPage:(NSUInteger) perPage {
    
}
- (void) getPhotoes:(NSString*) collectionId page:(NSUInteger) page perPage:(NSString*) perPage {
    
}
- (instancetype)initWithURLSession:(NSURLSession*) session {
    return nil;
}

@end


@interface MainCollectionViewControllerTests : XCTestCase
@property (strong, nonatomic) MainCollectionViewController* mc;
@end

@implementation MainCollectionViewControllerTests

- (void)setUp {
    [super setUp];
    self.mc = [[MainCollectionViewController alloc] init];
    self.mc.unsplashHttpCllient = [[UnsplashHttpClientMock alloc] init];
}

- (void)tearDown {
    [super tearDown];
}

- (void)test_beginBatchFetch {
    
}


@end
