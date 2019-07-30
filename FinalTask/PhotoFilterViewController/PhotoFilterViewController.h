//
//  PhotoFilterViewController.h
//  FinalTask
//
//  Created by USER on 7/22/19.
//  Copyright © 2019 USER. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoModel.h"

extern NSString* const PhotoFilterViewControllerPhotoWasUpdatedNotification;
extern NSString* const PhotoFilterViewControllerPhotoWasUpdatedNotificationKey;

@interface PhotoFilterViewController : UIViewController
@property (retain, nonatomic) NSIndexPath* indexPath;
@property (retain, nonatomic) PhotoModel* photoModel;
@end

