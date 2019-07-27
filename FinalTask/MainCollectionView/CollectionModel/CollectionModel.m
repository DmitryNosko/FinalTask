//
//  CollectionModel.m
//  FinalTask
//
//  Created by USER on 7/21/19.
//  Copyright © 2019 USER. All rights reserved.
//

#import "CollectionModel.h"

@implementation CollectionModel

- (instancetype)initWithDictionary:(NSDictionary*) dictionary
{
    self = [super init];
    if (self) {
        self.identifier = dictionary[@"id"];
        self.title = dictionary[@"title"];
        self.totalPhoto = [dictionary[@"total_photos"] unsignedIntegerValue];
        NSArray* previews = dictionary[@"preview_photos"];
        NSDictionary* preview = previews[0];
        NSDictionary* urls = preview[@"urls"];
        self.mainImageURL = [NSURL URLWithString:urls[@"thumb"]];
        
        NSDictionary* preview2 = previews[1];
        NSDictionary* urls2 = preview2[@"urls"];
        self.rightTopImageURL = [NSURL URLWithString:urls2[@"thumb"]];
        
        NSDictionary* preview3 = previews[2];
        NSDictionary* urls3 = preview3[@"urls"];
        self.rightBotoomImageURL = [NSURL URLWithString:urls3[@"thumb"]];
        
    }
    return self;
}

- (BOOL)isEqual:(id)object {
    
    CollectionModel* o = (CollectionModel*)object;
    if (o == self) {
        return YES;
    }
    if (!o || ![o isKindOfClass:[self class]]){
        return NO;
    }
    
    return  [self.identifier isEqualToString:o.identifier] &&
    [self.title isEqualToString:o.title] &&
    self.totalPhoto == o.totalPhoto &&
    [self.mainImageURL isEqual:o.mainImageURL] &&
    [self.rightTopImageURL isEqual:o.rightTopImageURL] &&
    [self.rightBotoomImageURL isEqual:o.rightBotoomImageURL];
}



- (NSUInteger)hash  {
    NSUInteger prime = 31;
    NSUInteger result = 1;
    result = prime * result + [self.identifier hash];
    result = result * prime + [self.title hash];
    result = result * prime + self.totalPhoto;
    result = result * prime + [self.mainImageURL hash];
    result = result * prime + [self.rightTopImageURL hash];
    result = result + prime + [self.rightBotoomImageURL hash];
    return result;
}

@end
