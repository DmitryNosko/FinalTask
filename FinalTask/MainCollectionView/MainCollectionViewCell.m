//
//  MainCollectionViewCell.m
//  FinalTask
//
//  Created by USER on 7/21/19.
//  Copyright © 2019 USER. All rights reserved.
//

#import "MainCollectionViewCell.h"

@implementation MainCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void) setUp {
    self.preViewMainImage = [[UIImageView alloc] init];
    [self.contentView addSubview:self.preViewMainImage];
    self.preViewMainImage.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
                                              [self.preViewMainImage.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:30],
                                              [self.preViewMainImage.topAnchor constraintEqualToAnchor:self.contentView.topAnchor],
                                              [self.preViewMainImage.heightAnchor constraintEqualToConstant:100],
                                              [self.preViewMainImage.widthAnchor constraintEqualToConstant:200]
                                              ]];
    
    self.preViewRightTopImage = [[UIImageView alloc] init];
    [self.contentView addSubview:self.preViewRightTopImage];
    self.preViewRightTopImage.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
                                              [self.preViewRightTopImage.leadingAnchor constraintEqualToAnchor:self.preViewMainImage.trailingAnchor constant:5],
                                              [self.preViewRightTopImage.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-30],
                                              [self.preViewRightTopImage.topAnchor constraintEqualToAnchor:self.contentView.topAnchor],
                                              [self.preViewRightTopImage.heightAnchor constraintEqualToConstant:47.5f]
                                              ]];
    
    self.preViewRightBottomImage = [[UIImageView alloc] init];
    [self.contentView addSubview:self.preViewRightBottomImage];
    self.preViewRightBottomImage.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
                                              [self.preViewRightBottomImage.leadingAnchor constraintEqualToAnchor:self.preViewRightTopImage.leadingAnchor],
                                              [self.preViewRightBottomImage.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-30],
                                              [self.preViewRightBottomImage.topAnchor constraintEqualToAnchor:self.preViewRightTopImage.bottomAnchor constant:5],
                                              [self.preViewRightBottomImage.heightAnchor constraintEqualToConstant:47.5f]
                                              ]];
    
    self.collectionName = [[UILabel alloc] init];
    [self.contentView addSubview:self.collectionName];
    self.collectionName.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
                                              [self.collectionName.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:30],
                                              [self.collectionName.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-30],
                                              [self.collectionName.topAnchor constraintEqualToAnchor:self.preViewMainImage.bottomAnchor],
                                              [self.collectionName.heightAnchor constraintEqualToConstant:30]
                                              ]];
    
    self.totalPhoto = [[UILabel alloc] init];
    [self.contentView addSubview:self.totalPhoto];
    self.totalPhoto.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
                                              [self.totalPhoto.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:30],
                                              [self.totalPhoto.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-30],
                                              [self.totalPhoto.topAnchor constraintEqualToAnchor:self.collectionName.bottomAnchor],
                                              [self.totalPhoto.heightAnchor constraintEqualToConstant:30]
                                              ]];
    
    
}

@end
