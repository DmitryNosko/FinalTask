//
//  PhotoFilterViewController.m
//  FinalTask
//
//  Created by USER on 7/22/19.
//  Copyright © 2019 USER. All rights reserved.
//

#import "PhotoFilterViewController.h"
#import "FilterCollectionViewCell.h"


@interface PhotoFilterViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (retain, nonatomic) UIImageView* imageToFiltr;
@property (weak, nonatomic) UICollectionView* collectionView;
@property (retain, nonatomic) NSArray* filters;
@property (retain, nonatomic) UILabel* imageDescriptionLabel;
@property (retain, nonatomic) UILabel* imageResolutionLabel;
@property (retain, nonatomic) UILabel* imageSizeLabel;
@property (retain, nonatomic) UILabel* imageAuthorLabel;
@end

static NSString* const CELL_IDENTIFIER = @"Cell";
NSString* const PhotoFilterViewControllerPhotoWasUpdatedNotification = @"PhotoFilterViewControllerPhotoWasUpdatedNotification";
NSString* const PhotoFilterViewControllerPhotoWasUpdatedNotificationKey = @"PhotoFilterViewControllerPhotoWasUpdatedNotificationKey";
static NSString* const NO_DESCRIPTION = @"no description";

@implementation PhotoFilterViewController

- (void)dealloc
{
    [_imageToFiltr release];
    [_filters release];
    [_imageDescriptionLabel release];
    [_imageResolutionLabel release];
    [_imageSizeLabel release];
    [_imageAuthorLabel release];
    [_indexPath release];
    [_photoModel release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Image description";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setUp];
    [self collectionViewSetUp];
    [self.collectionView setHidden:YES];
    [self setUpDescription];
    
    
    [self.collectionView registerClass:[FilterCollectionViewCell class] forCellWithReuseIdentifier:CELL_IDENTIFIER];
    
    UIBarButtonItem* editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editImage:)];
    self.navigationItem.rightBarButtonItem = editButton;
    [editButton release];
    
    self.filters = @[@(kCGBlendModeCopy),
                     @(kCGBlendModeOverlay),
                     @(kCGBlendModeColorBurn),
                     @(kCGBlendModeSoftLight),
                     @(kCGBlendModeHardLight),
                     @(kCGBlendModeDifference),
                     @(kCGBlendModeLuminosity),
                     @(kCGBlendModeDestinationAtop),
                     @(kCGBlendModeXOR),
                     @(kCGBlendModePlusDarker),
                     @(kCGBlendModePlusLighter)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.view reloadInputViews];
}

#pragma mark - CollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.filters count];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FilterCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
    
    NSNumber* blend = [self.filters objectAtIndex:indexPath.row];
    cell.imageFilterButton.layer.contents = (id)[self getAvatar:[blend intValue]].CGImage;
    [cell.imageFilterButton addTarget:self action:@selector(addFilter:) forControlEvents:UIControlEventTouchUpInside];
    cell.imageFilterButton.tag = indexPath.row;
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(80, 80);
}

-(UIEdgeInsets) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewFlowLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (void) addFilter:(UIButton*) sender {
    NSNumber* blend = [self.filters objectAtIndex:sender.tag];
    UIImage* image = [self getAvatar:[blend intValue]];
    self.imageToFiltr.image = image;
}

#pragma mark Edit Done

- (void) editImage:(UIBarButtonItem*) sender {

    BOOL isHidden = self.collectionView.isHidden;
    [self.collectionView setHidden:!isHidden];
    [self.imageDescriptionLabel setHidden:isHidden];
    [self.imageResolutionLabel setHidden:isHidden];
    [self.imageSizeLabel setHidden:isHidden];
    [self.imageAuthorLabel setHidden:isHidden];
    
    UIBarButtonSystemItem item = UIBarButtonSystemItemEdit;
    if (!isHidden) {
        NSDictionary* dictionary = [[[NSDictionary alloc] initWithObjectsAndKeys:self.imageToFiltr.image, @"photo", self.indexPath, @"indexPath", nil] autorelease];
        [[NSNotificationCenter defaultCenter] postNotificationName:PhotoFilterViewControllerPhotoWasUpdatedNotification
                                                            object:nil
                                                          userInfo:dictionary];
    }
    
    if (!self.collectionView.isHidden) {
        item = UIBarButtonSystemItemDone;
        self.navigationItem.title = @"Choose filter";
    } else {
        self.navigationItem.title = @"Image description";
    }
    
    UIBarButtonItem* editB = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:item target:self action:@selector(editImage:)];
    [self.navigationItem setRightBarButtonItem:editB animated:YES];
    [editB release];
}

#pragma mark - Filters

//- (UIImage *)convertImageToGrayScale:(UIImage *)image {
//    CGRect imageRect = CGRectMake(0, 0, image.size.width, image.size.height);
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
//    CGContextRef context = CGBitmapContextCreate(nil, image.size.width, image.size.height, 8, 0, colorSpace, kCGImageAlphaNone);
//    CGContextDrawImage(context, imageRect, [image CGImage]);
//    CGImageRef imageRef = CGBitmapContextCreateImage(context);
//    UIImage *newImage = [UIImage imageWithCGImage:imageRef];
//    CGColorSpaceRelease(colorSpace);
//    CGContextRelease(context);
//    CFRelease(imageRef);
//    return newImage;
//
//}


- (UIImage*) getAvatar:(CGBlendMode) blendMode {
    CGSize size = CGSizeMake(50, 50);
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetShadow(context, CGSizeMake(1.0, 1.0), 1.0); // mesto teni
    CGRect imageRect = CGRectMake(0, 0, 50, 50);
    CGContextSetBlendMode(context, blendMode);
    CGContextTranslateCTM(context, 0, imageRect.origin.y + imageRect.size.height);
    CGContextScaleCTM(context, 1, -1);
    //CGContextSetAlpha(context, 0.1);
    //CGContextSetShadow(context, CGSizeMake(0, 0), 0.5);
    CGContextDrawImage(context, CGRectOffset(imageRect, 0, -imageRect.origin.y), self.photoModel.thumbImage.CGImage);
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - SetUp's

- (void) collectionViewSetUp {
    CGRect frame = self.view.bounds;
    frame.origin = CGPointZero;
    UICollectionViewFlowLayout* fl = [[UICollectionViewFlowLayout alloc] init];
    [fl setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    UICollectionView* collectionView = [[[UICollectionView alloc] initWithFrame:frame collectionViewLayout:fl] autorelease];
    [self.view addSubview:collectionView];
    
    self.collectionView = collectionView;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
                                              [self.collectionView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
                                              [self.collectionView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
                                              [self.collectionView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:-50],
                                              [self.collectionView.heightAnchor constraintEqualToConstant:100]
                                              ]];
    [fl release];
}


- (void) setUp {
    self.imageToFiltr = [[UIImageView alloc] initWithImage:self.photoModel.thumbImage];
    [self.view addSubview:self.imageToFiltr];
    
    self.imageToFiltr.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
                                              [self.imageToFiltr.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:15],
                                              [self.imageToFiltr.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-15],
                                              [self.imageToFiltr.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:79],
                                              [self.imageToFiltr.heightAnchor constraintEqualToConstant:250]
                                              ]];
    [self.imageToFiltr release];
}

//- (UIImage*) multiplyImageByConstantColor:(UIImage*)image color:(UIColor*) color {
//
//    CGSize backgroundSize = image.size;
//    UIGraphicsBeginImageContext(backgroundSize);
//
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
//
//    CGRect backgroundRect;
//    backgroundRect.size = backgroundSize;
//    backgroundRect.origin.x = 0;
//    backgroundRect.origin.y = 0;
//
//    CGFloat r,g,b,a;
//    [color getRed:&r green:&g blue:&b alpha:&a];
//    CGContextSetRGBFillColor(ctx, r, g, b, a);
//    CGContextFillRect(ctx, backgroundRect);
//
//    CGRect imageRect;
//    imageRect.size = image.size;
//    imageRect.origin.x = (backgroundSize.width - image.size.width)/2;
//    imageRect.origin.y = (backgroundSize.height - image.size.height)/2;
//
//    // Unflip the image
//    CGContextTranslateCTM(ctx, 0, backgroundSize.height);
//    CGContextScaleCTM(ctx, 1.0, -1.0);
//
//    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
//    CGContextDrawImage(ctx, imageRect, image.CGImage);
//
//    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
//
//    UIGraphicsEndImageContext();
//
//    return newImage;
//}

- (void) setUpDescription {

    UILabel* description = [[UILabel alloc] init];
    description.backgroundColor = [UIColor whiteColor];
    description.numberOfLines = 0;
    
    if (![self.photoModel.name isEqual:[NSNull null]]) {
        description.text = [NSString stringWithFormat:@"Description: %@", self.photoModel.name];
    } else if (![self.photoModel.altDescription isEqual:[NSNull null]]) {
        description.text = [NSString stringWithFormat:@"Description: %@", self.photoModel.altDescription];
    } else {
        description.text = [NSString stringWithFormat:@"Description: %@", NO_DESCRIPTION];
    }
    
    [self.view addSubview:description];
    self.imageDescriptionLabel = description;
    self.imageDescriptionLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
                                            [self.imageDescriptionLabel.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:15],
                                            [self.imageDescriptionLabel.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-15],
                                            [self.imageDescriptionLabel.topAnchor constraintEqualToAnchor:self.imageToFiltr.bottomAnchor constant:20],
                                            ]];
    [description release];
   
    UILabel* resolution = [[UILabel alloc] init];
    resolution.backgroundColor = [UIColor whiteColor];
    resolution.numberOfLines = 0;
    resolution.text = [NSString stringWithFormat:@"Image resolution - %@x%@", self.photoModel.width, self.photoModel.height];
    [self.view addSubview:resolution];
    self.imageResolutionLabel = resolution;
    
    self.imageResolutionLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
                                              [self.imageResolutionLabel.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:15],
                                              [self.imageResolutionLabel.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-15],
                                              [self.imageResolutionLabel.topAnchor constraintEqualToAnchor:self.imageDescriptionLabel.bottomAnchor constant:15],
                                              ]];
    [resolution release];
    
    UILabel* author = [[UILabel alloc] init];
    author.backgroundColor = [UIColor whiteColor];
    author.numberOfLines = 0;
    author.text = [NSString stringWithFormat:@"Author userName - %@", self.photoModel.userName];
    [self.view addSubview:author];
    self.imageAuthorLabel = author;
    
    self.imageAuthorLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
                                              [self.imageAuthorLabel.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:15],
                                              [self.imageAuthorLabel.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-15],
                                              [self.imageAuthorLabel.topAnchor constraintEqualToAnchor:self.imageResolutionLabel.bottomAnchor constant:15],
                                              ]];
    [author release];
}


@end







































