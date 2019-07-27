//
//  PhotoModel.m
//  FinalTask
//
//  Created by USER on 7/20/19.
//  Copyright © 2019 USER. All rights reserved.
//

#import "PhotoModel.h"

@implementation PhotoModel

- (instancetype)initWithDictionary:(NSDictionary*) dictionary
{
    self = [super init];
    if (self) {
        self.identifier = dictionary[@"id"];
        self.name = dictionary[@"description"];
        self.altDescription = dictionary[@"alt_description"];
        NSDictionary* urls = dictionary[@"urls"];
        self.thumbURL = [NSURL URLWithString:urls[@"thumb"]];
        NSDictionary* user = dictionary[@"user"];
        self.userName = user[@"username"];
        self.width = dictionary[@"width"];
        self.height = dictionary[@"height"];
        
    }
    return self;
}

- (BOOL)isEqual:(id)object {
    
    PhotoModel* o = (PhotoModel*)object;
    if (o == self) {
        return YES;
    }
    if (!o || ![o isKindOfClass:[self class]]){
        return NO;
    }
    
    return  [self.identifier isEqualToString:o.identifier] &&
            [self.name isEqualToString:o.name] &&
            [self.altDescription isEqualToString:o.altDescription] &&
            [self.thumbURL isEqual:o.thumbURL] &&
            [self.userName isEqualToString:o.userName] &&
            [self.width isEqual:o.width] &&
            [self.height isEqual:o.height];
}



- (NSUInteger)hash  {
    NSUInteger prime = 31;
    NSUInteger result = 1;
    result = prime * result + [self.identifier hash];
    result = result * prime + [self.name hash];
    result = result * prime + [self.altDescription hash];
    result = result * prime + [self.thumbURL hash];
    result = result * prime + [self.userName hash];
    result = result + prime + [self.width unsignedIntegerValue];
    result = result + prime + [self.height unsignedIntegerValue];
    return result;
}

@end
