//
//  UnsplashHttpClient.h
//  FinalTask
//
//  Created by USER on 7/21/19.
//  Copyright © 2019 USER. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CollectionModel.h"
#import "PhotoModel.h"

extern NSString* const UnsplashHttpClientCollectionInfosWasLoaded;
extern NSString* const UnsplashHttpClientCollectionImageWasLoaded;
extern NSString* const UnsplashHttpClientCollectionModelWasPrepared;
extern NSString* const UnsplashHttpClientCollectionImageWasLoadedNotification;
extern NSString* const UnsplashHttpClientCollectionWasLoadingError;
extern NSString* const UnsplashHttpClientCollectionImageWasLoadingError;

@interface UnsplashHttpClient : NSObject
- (void) getPhotoCollections:(NSUInteger) page perPage:(NSUInteger) perPage;
- (void) getPhotoes:(NSString*) collectionId page:(NSUInteger) page perPage:(NSString*) perPage;
- (instancetype)initWithURLSession:(NSURLSession*) session;
@end
