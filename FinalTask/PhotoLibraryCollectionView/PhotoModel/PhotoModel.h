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
@property (strong, nonatomic) NSString* identifier;
@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSString* altDescription;
@property (strong, nonatomic) NSURL* thumbURL;
@property (strong, nonatomic) UIImage* thumbImage;
@property (strong, nonatomic) NSString* userName;
@property (strong, nonatomic) NSNumber*  height;
@property (strong, nonatomic) NSNumber*  width;

- (instancetype)initWithDictionary:(NSDictionary*) dictionary;

@end
