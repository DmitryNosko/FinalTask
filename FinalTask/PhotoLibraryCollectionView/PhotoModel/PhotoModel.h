//
//  PhotoModel.h
//  FinalTask
//
//  Created by USER on 7/20/19.
//  Copyright © 2019 USER. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PhotoModel : NSObject
@property (retain, nonatomic) NSString* identifier;
@property (retain, nonatomic) NSString* name;
@property (retain, nonatomic) NSString* altDescription;
@property (retain, nonatomic) NSURL* thumbURL;
@property (retain, nonatomic) UIImage* thumbImage;
@property (retain, nonatomic) NSString* userName;
@property (retain, nonatomic) NSNumber*  height;
@property (retain, nonatomic) NSNumber*  width;

- (instancetype)initWithDictionary:(NSDictionary*) dictionary;

@end
