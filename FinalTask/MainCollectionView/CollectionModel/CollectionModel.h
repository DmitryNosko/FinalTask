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

@property (retain, nonatomic) NSString* identifier;
@property (retain, nonatomic) NSString* title;
@property (assign, nonatomic) NSUInteger totalPhoto;
@property (retain, nonatomic) NSURL* mainImageURL;
@property (retain, nonatomic) UIImage* mainImage;
@property (retain, nonatomic) NSURL* rightTopImageURL;
@property (retain, nonatomic) UIImage* rightTopImage;
@property (retain, nonatomic) NSURL* rightBotoomImageURL;
@property (retain, nonatomic) UIImage* rightBotoomImage;
@end
