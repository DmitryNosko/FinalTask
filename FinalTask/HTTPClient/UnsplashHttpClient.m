//
//  UnsplashHttpClient.m
//  FinalTask
//
//  Created by USER on 7/21/19.
//  Copyright © 2019 USER. All rights reserved.
//

#import "UnsplashHttpClient.h"

@interface UnsplashHttpClient ()
@property (strong, nonatomic) NSURLSession* session;
@property (strong, nonatomic) NSCache* cache;
@end

static NSString* const COLLECTIONS_URL_FORMAT = @"https://api.unsplash.com/collections?page=%@&per_page=%@";
static NSString* const PHOTOES_URL_FORMAT = @"https://api.unsplash.com/collections/%@/photos?page=%@&per_page=%@";
static NSString* const CLIENT_ID = @"Client-ID da0b960d950900e581b575f7fe1ad7f94ae2102ce77c3cea911b87d3eb8fb999";
static NSString* const AUTHORIZATION_HEADER_FIELD = @"Authorization";

NSString* const UnsplashHttpClientCollectionInfosWasLoaded = @"UnsplashHttpClientCollectionsWasLoaded";
NSString* const UnsplashHttpClientCollectionModelWasPrepared = @"UnsplashHttpClientCollectionModelWasPrepared";

NSString* const UnsplashHttpClientCollectionImageWasLoaded = @"UnsplashHttpClientCollectionImageWasLoaded";
NSString* const UnsplashHttpClientCollectionImageWasLoadedNotification = @"UnsplashHttpClientCollectionImageWasLoadedNotification";

NSString* const UnsplashHttpClientCollectionWasLoadingError = @"UnsplashHttpClientCollectionWasLoadingError";
NSString* const UnsplashHttpClientCollectionImageWasLoadingError = @"UnsplashHttpClientCollectionImageWasLoadingError";

@implementation UnsplashHttpClient

- (instancetype)initWithURLSession:(NSURLSession*) session
{
    self = [super init];
    if (self) {
        self.session = session;
    }
    return self;
}

- (void) getPhotoCollections:(NSUInteger) page perPage:(NSUInteger) perPage {
    NSString* urlString = [NSString stringWithFormat:COLLECTIONS_URL_FORMAT, @(page), @(perPage)];
    NSURL* url = [NSURL URLWithString:urlString];
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setValue:CLIENT_ID forHTTPHeaderField:AUTHORIZATION_HEADER_FIELD];
    [request setHTTPMethod:@"GET"];
    
    [[self.session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            [[NSNotificationCenter defaultCenter] postNotificationName:UnsplashHttpClientCollectionWasLoadingError object:nil];
        } else {
            
            NSArray* responseArr =[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSMutableArray* collections = [NSMutableArray new];
            for (NSDictionary* dic in responseArr) {
                CollectionModel* cm = [[CollectionModel alloc] initWithDictionary:dic];
                [collections addObject:cm];
                
                [[self.session dataTaskWithURL:cm.mainImageURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                    UIImage* image = [UIImage imageWithData:data];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        cm.mainImage = image;
                        [[NSNotificationCenter defaultCenter] postNotificationName:UnsplashHttpClientCollectionInfosWasLoaded object:nil];
                    });
                }] resume];
                
                [[self.session dataTaskWithURL:cm.rightTopImageURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                    UIImage* image = [UIImage imageWithData:data];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        cm.rightTopImage = image;
                        [[NSNotificationCenter defaultCenter] postNotificationName:UnsplashHttpClientCollectionInfosWasLoaded object:nil];
                    });
                }] resume];
                
                [[self.session dataTaskWithURL:cm.rightBotoomImageURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                    UIImage* image = [UIImage imageWithData:data];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        cm.rightBotoomImage = image;
                        [[NSNotificationCenter defaultCenter] postNotificationName:UnsplashHttpClientCollectionInfosWasLoaded object:nil];
                    });
                }] resume];
            }
            NSDictionary* dictionary = [NSDictionary dictionaryWithObjectsAndKeys:collections, @"collections", @(page), @"page", @(perPage), @"perPage", nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:UnsplashHttpClientCollectionModelWasPrepared
                                                                object:nil
                                                              userInfo:dictionary];
        }
    }]resume];
    
}

- (void) getPhotoes:(NSString *)collectionId page:(NSUInteger) page perPage:(NSString *)perPage {
    NSString* urlString = [NSString stringWithFormat:PHOTOES_URL_FORMAT, collectionId, @(page), perPage];
    NSURL* url = [NSURL URLWithString:urlString];
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setValue:CLIENT_ID forHTTPHeaderField:AUTHORIZATION_HEADER_FIELD];
    [request setHTTPMethod:@"GET"];
    
    [[self.session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            [[NSNotificationCenter defaultCenter] postNotificationName:UnsplashHttpClientCollectionImageWasLoadingError object:nil];
        } else {
            NSArray* responseArr =[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSMutableArray* photos = [NSMutableArray new];
            for (NSDictionary* dic in responseArr) {
                PhotoModel* photoModel = [[PhotoModel  alloc] initWithDictionary:dic];
                [photos addObject:photoModel];
                
                [[self.session dataTaskWithURL:photoModel.thumbURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                    UIImage* image = [UIImage imageWithData:data];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        photoModel.thumbImage = image;
                        [[NSNotificationCenter defaultCenter] postNotificationName:UnsplashHttpClientCollectionImageWasLoaded object:nil];
                    });
                }] resume];
            }
            
            NSMutableDictionary* dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:photos, @"photoes", @(page), @"page", nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:UnsplashHttpClientCollectionImageWasLoadedNotification
                                                                object:nil
                                                              userInfo:dictionary];
        }
        
    }]resume];
}



@end
