//
//  CollectionModel.h
//  FinalTask
//
//  Created by USER on 7/21/19.
//  Copyright © 2019 USER. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CollectionModel : NSObject

- (instancetype)initWithDictionary:(NSDictionary*) dictionary;

@property (strong, nonatomic) NSString* identifier;
@property (strong, nonatomic) NSString* title;
@property (assign, nonatomic) NSUInteger totalPhoto;
@property (strong, nonatomic) NSURL* mainImageURL;
@property (strong, nonatomic) UIImage* mainImage;
@property (strong, nonatomic) NSURL* rightTopImageURL;
@property (strong, nonatomic) UIImage* rightTopImage;
@property (strong, nonatomic) NSURL* rightBotoomImageURL;
@property (strong, nonatomic) UIImage* rightBotoomImage;
@end
