//
//  MainCollectionViewController.h
//  FinalTask
//
//  Created by USER on 7/21/19.
//  Copyright © 2019 USER. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UnsplashHttpClient.h"

@interface MainCollectionViewController : UICollectionViewController
@property (strong, nonatomic) UnsplashHttpClient* unsplashHttpCllient;
@end
