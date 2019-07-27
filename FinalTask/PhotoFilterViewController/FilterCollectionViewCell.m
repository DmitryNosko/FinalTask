//
//  FilterCollectionViewCell.m
//  FinalTask
//
//  Created by USER on 7/26/19.
//  Copyright © 2019 USER. All rights reserved.
//

#import "FilterCollectionViewCell.h"

@implementation FilterCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void) setUp {
    self.imageFilterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.imageFilterButton.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:self.imageFilterButton];
    
    self.imageFilterButton.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
                                              [self.imageFilterButton.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor],
                                              [self.imageFilterButton.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor],
                                              [self.imageFilterButton.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor],
                                              [self.imageFilterButton.topAnchor constraintEqualToAnchor:self.contentView.topAnchor]
                                              ]];
    
}

@end
