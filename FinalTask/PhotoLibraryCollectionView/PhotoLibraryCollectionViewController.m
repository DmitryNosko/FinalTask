//
//  PhotoLibraryCollectionViewController.m
//  FinalTask
//
//  Created by USER on 7/20/19.
//  Copyright © 2019 USER. All rights reserved.
//

#import "PhotoLibraryCollectionViewController.h"
#import "PhotoCollectionViewCell.h"
#import "PhotoModel.h"
#import "UnsplashHttpClient.h"
#import "PhotoFilterViewController.h"

@interface PhotoLibraryCollectionViewController () <UICollectionViewDelegateFlowLayout>
@property (assign, nonatomic) CGFloat numberOfColumns;
@property (assign, nonatomic) CGFloat collectionViewWidth;
@property (assign, nonatomic) CGFloat xInsets;
@property (assign, nonatomic) CGFloat cellSpacing;
@property (strong, nonatomic) NSMutableArray<PhotoModel*>* photos;
@property (strong, nonatomic) UnsplashHttpClient* unsplashHttpCllient;
@property (assign, nonatomic) BOOL fetchingMore;
@property (assign, nonatomic) NSUInteger currentPage;
@property (strong, nonatomic) NSCache* photosCache;
@property (assign, nonatomic) BOOL isButtomDirection;
@property (strong, nonatomic) NSMutableArray* displayedPages;
@end

@implementation PhotoLibraryCollectionViewController

static NSString * const reuseIdentifier = @"Cell";
static NSString * const reuseLoadingIdentifier = @"loadingCell";
static NSUInteger const cellHeight = 155;
static NSUInteger const cellAmount = 15;
static NSUInteger const insets = 10;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.unsplashHttpCllient = [[UnsplashHttpClient alloc] initWithURLSession:[NSURLSession sharedSession]];
    self.title = @"Photos";
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.photos = [NSMutableArray new];
    self.xInsets = 10;
    self.cellSpacing = 5;
    self.collectionViewWidth = self.collectionView.frame.size.width;
    self.numberOfColumns = 2;
    [self.collectionView registerClass:[PhotoCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    self.isButtomDirection = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(collectionImageWasLoadNotification:)
                                                 name:UnsplashHttpClientCollectionImageWasLoaded
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(collectionWasPrepareNotification:)
                                                 name:UnsplashHttpClientCollectionImageWasLoadedNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(photoWasUpdatedNotification:)
                                                 name:PhotoFilterViewControllerPhotoWasUpdatedNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(photoWasLoadingErrorNotification:)
                                                 name:UnsplashHttpClientCollectionImageWasLoadingError
                                               object:nil];
    
    self.currentPage = 1;
    self.photosCache = [NSCache new];
    self.displayedPages = [NSMutableArray new];
    
    NSLog(@"he = %@", @(self.collectionView.frame.size.height));
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([self.photos count] == 0) {
        [self.unsplashHttpCllient getPhotoes:self.identificator page:self.currentPage perPage:@"30"];
    }
}

#pragma mark - Notifications

- (void) photoWasLoadingErrorNotification:(NSNotification*) notification {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error during loading"
                                                                   message:[NSString stringWithFormat:@"Try to restart the app."]
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    [alert addAction:defaultAction];
    [self.navigationController presentViewController:alert animated:YES completion:nil];
}

- (void) collectionImageWasLoadNotification:(NSNotification*) notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
}

- (void) collectionWasPrepareNotification:(NSNotification*) notification {
    self.fetchingMore = NO;

    if (self.isButtomDirection) {
        NSMutableArray* photos = [notification.userInfo objectForKey:@"photoes"];
        if ([photos count] > 0) {
            NSNumber* currentPage = [notification.userInfo objectForKey:@"page"];
            if ([currentPage unsignedIntegerValue] != 1) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.collectionView setContentOffset:CGPointMake(0, cellHeight * cellAmount - self.collectionView.frame.size.height + insets)];
                });
            }
            
            [self.displayedPages addObject:currentPage];
            [self.displayedPages removeObject:@([currentPage unsignedIntegerValue] - 2)];
            
            [self.photosCache setObject:photos forKey:currentPage];
            [self.photosCache removeObjectForKey:@([currentPage unsignedIntegerValue] - 2)];
            NSMutableArray<PhotoModel*>* array = [NSMutableArray new];
            
            NSMutableArray* prevPage = [self.photosCache objectForKey:@([currentPage unsignedIntegerValue] - 1)];
            if (prevPage) {
                [array addObjectsFromArray:prevPage];
            }
            
            [array addObjectsFromArray:photos];
            
            self.photos = array;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.collectionView reloadData];
            });
        }
    } else {
        NSMutableArray* photos = [notification.userInfo objectForKey:@"photoes"];
        if ([photos count] > 0) {
            NSNumber* currentPage = [notification.userInfo objectForKey:@"page"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.collectionView setContentOffset:CGPointMake(0, cellHeight * cellAmount - 90 + insets)];
                });
            
            self.displayedPages = [NSMutableArray arrayWithObjects:currentPage, @([currentPage unsignedIntegerValue] + 1), nil];

            [self.photosCache setObject:photos forKey:currentPage];
            [self.photosCache removeObjectForKey:@([currentPage unsignedIntegerValue] + 2)];
            
            NSMutableArray<PhotoModel*>* array = [NSMutableArray new];
            
            [array addObjectsFromArray:photos];
            
            NSMutableArray* prevPage = [self.photosCache objectForKey:@([currentPage unsignedIntegerValue] + 1)];
            if (prevPage) {
                [array addObjectsFromArray:prevPage];
            }
            
            self.photos = array;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.collectionView reloadData];
            });
        }
    }
}

- (void) photoWasUpdatedNotification:(NSNotification*) notification {
    UIImage* updatedImage = [notification.userInfo objectForKey:@"photo"];
    NSIndexPath* indexPath = [notification.userInfo objectForKey:@"indexPath"];
    
    PhotoModel* pm = [self.photos objectAtIndex:indexPath.row];
    pm.thumbImage = updatedImage;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.photos count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    PhotoModel* photoModel = [self.photos objectAtIndex:indexPath.item];
    cell.image.image = photoModel.thumbImage;
    return cell;
}

#pragma mark - Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoFilterViewController* pc = [[PhotoFilterViewController alloc] init];
    PhotoModel* photoModel = [self.photos objectAtIndex:indexPath.item];
    pc.photoModel = photoModel;
    pc.indexPath = indexPath;
    [self.navigationController pushViewController:pc animated:YES];
}


#pragma mark - <UICollectionViewDelegateFlowLayout>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((self.collectionViewWidth / self.numberOfColumns) - (self.xInsets + self.cellSpacing), (self.collectionViewWidth / self.numberOfColumns) - (self.xInsets + self.cellSpacing));
}

-(UIEdgeInsets) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewFlowLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat scrollViewHeight = scrollView.frame.size.height;
    CGFloat scrollContentSizeHeight = scrollView.contentSize.height;
    CGFloat scrollOffset = scrollView.contentOffset.y;
    
    if (scrollOffset < 0 && self.currentPage != 1 && !self.fetchingMore) {
        NSNumber* first = [self.displayedPages firstObject];
        NSUInteger topPage = [first unsignedIntegerValue];
        if (topPage != 1) {
            self.currentPage = --topPage;
            self.isButtomDirection = NO;
            [self beginBatchFetch];
        }
    }
    
    if (scrollOffset + scrollViewHeight == scrollContentSizeHeight && !self.fetchingMore) {
        NSNumber* last = [self.displayedPages lastObject];
        NSUInteger buttomPage = [last unsignedIntegerValue];
        self.currentPage = ++buttomPage;
        self.isButtomDirection = YES;
        [self beginBatchFetch];
    }
}

- (void) beginBatchFetch {
    self.fetchingMore = YES;
    [self.unsplashHttpCllient getPhotoes:self.identificator page:self.currentPage perPage:@"30"];
}

@end


















