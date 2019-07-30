//
//  StartViewController.m
//  FinalTask
//
//  Created by USER on 7/27/19.
//  Copyright © 2019 USER. All rights reserved.
//

#import "StartViewController.h"

@interface StartViewController ()
@property (retain, nonatomic) UILabel* notReachableLabel;
@end

@implementation StartViewController

- (void)dealloc
{
    [_notReachableLabel release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    UILabel* notReachableLabel = [[[UILabel alloc] init] autorelease];
    notReachableLabel.backgroundColor = [UIColor whiteColor];
    notReachableLabel.numberOfLines = 0;
    notReachableLabel.text = @"Check your inthernet connection.";
    notReachableLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:notReachableLabel];
    self.notReachableLabel = notReachableLabel;
    
    self.notReachableLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
                                              [self.notReachableLabel.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:50],
                                              [self.notReachableLabel.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-50],
                                              [self.notReachableLabel.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
                                              [self.notReachableLabel.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor]
                                              ]];
}

@end
