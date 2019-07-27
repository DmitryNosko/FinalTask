//
//  LoadingCollectionViewCell.m
//  FinalTask
//
//  Created by USER on 7/25/19.
//  Copyright © 2019 USER. All rights reserved.
//

#import "LoadingCollectionViewCell.h"

@implementation LoadingCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor blackColor];
        [self setUp];
    }
    return self;
}

- (void) setUp {
    self.loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.contentView addSubview:self.loadingView];
    
    self.loadingView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
                                              [self.loadingView.centerXAnchor constraintEqualToAnchor:self.contentView.centerXAnchor],
                                              [self.loadingView.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor],
                                              [self.loadingView.widthAnchor constraintEqualToConstant:100],
                                              [self.loadingView.heightAnchor constraintEqualToConstant:100]
                                              ]];
}


@end
