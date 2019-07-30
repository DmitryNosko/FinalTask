//
//  PhotoCollectionViewCell.m
//  FinalTask
//
//  Created by USER on 7/20/19.
//  Copyright © 2019 USER. All rights reserved.
//

#import "PhotoCollectionViewCell.h"

@implementation PhotoCollectionViewCell

- (void)dealloc
{
    [_image release];
    [super dealloc];
}

- (instancetype)initWithFrame:(CGRect)frame

{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void) setUp {
    self.image = [[UIImageView alloc] init];
    [self.contentView addSubview:self.image];
    
    self.image.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
                                              [self.image.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor],
                                              [self.image.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor],
                                              [self.image.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor],
                                              [self.image.topAnchor constraintEqualToAnchor:self.contentView.topAnchor]
                                              ]];
    [self.image release];
    
}

@end
