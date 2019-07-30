//
//  MainCollectionViewController.m
//  FinalTask
//
//  Created by USER on 7/21/19.
//  Copyright © 2019 USER. All rights reserved.
//

#import "MainCollectionViewController.h"
#import "MainCollectionViewCell.h"
#import "CollectionModel.h"
#import "PhotoLibraryCollectionViewController.h"

@interface MainCollectionViewController ()
@property (assign, nonatomic) CGFloat numberOfColumns;
@property (assign, nonatomic) CGFloat collectionViewWidth;
@property (assign, nonatomic) CGFloat xInsets;
@property (assign, nonatomic) CGFloat cellSpacing;
@property (retain, nonatomic) NSArray<CollectionModel*>* collections;
@property (assign, nonatomic) BOOL fetchingMore;
@property (assign, nonatomic) NSUInteger currentPage;
@property (retain, nonatomic) NSCache* collectionsCache;
@property (assign, nonatomic) BOOL isButtomDirection;
@property (retain, nonatomic) NSMutableArray* displayedPages;
@end



@implementation MainCollectionViewController

static NSString * const reuseIdentifier = @"Cell";
static NSUInteger const cellHeight = 170;
static NSUInteger const cellAmount = 30;

- (void)dealloc
{
    [_unsplashHttpCllient release];
    [_collections release];
    [_collectionsCache release];
    [_displayedPages release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Collections";
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[MainCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    self.xInsets = 10;
    self.cellSpacing = 5;
    self.collectionViewWidth = self.collectionView.frame.size.width;
    self.numberOfColumns = 1;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(imageWasLoadNotification:)
                                                 name:UnsplashHttpClientCollectionInfosWasLoaded
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(collectionWasPrepareNotification:)
                                                 name:UnsplashHttpClientCollectionModelWasPrepared
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(collectionWasLoadingError:)
                                                 name:UnsplashHttpClientCollectionWasLoadingError
                                               object:nil];
    
    self.isButtomDirection = YES;
    self.currentPage = 1;
    self.collectionsCache = [[NSCache new] autorelease];
    self.displayedPages = [[NSMutableArray new] autorelease];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([self.collections count] == 0) {
        [self.unsplashHttpCllient getPhotoCollections:self.currentPage perPage:30];
    }
}

#pragma mark - Notifications

- (void) collectionWasLoadingError:(NSNotification*) notification {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error during loading"
                                                                   message:[NSString stringWithFormat:@"Try to restart the app."]
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    [alert addAction:defaultAction];
    [self.navigationController presentViewController:alert animated:YES completion:nil];
}

- (void) imageWasLoadNotification:(NSNotification*) notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
}

- (void) collectionWasPrepareNotification:(NSNotification*) notification {
    self.fetchingMore = NO;
    
    if (self.isButtomDirection) {
        NSMutableArray* collections = [notification.userInfo objectForKey:@"collections"];;
        if ([collections count] > 0) {
            NSNumber* currentPage = [notification.userInfo objectForKey:@"page"];
            if ([currentPage unsignedIntegerValue] != 1) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.collectionView setContentOffset:CGPointMake(0, cellHeight * cellAmount - self.collectionView.frame.size.height)];
                });
            }
            
            [self.displayedPages addObject:currentPage];
            [self.displayedPages removeObject:@([currentPage unsignedIntegerValue] - 2)];
            
            [self.collectionsCache setObject:collections forKey:currentPage];
            [self.collectionsCache removeObjectForKey:@([currentPage unsignedIntegerValue] - 2)];
            
            NSMutableArray<CollectionModel*>* array = [[NSMutableArray new] autorelease];
            NSMutableArray* prevPage = [self.collectionsCache objectForKey:@([currentPage unsignedIntegerValue] - 1)];
            if (prevPage) {
                [array addObjectsFromArray:prevPage];
            }
            
            [array addObjectsFromArray:collections];
            self.collections = array;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.collectionView reloadData];
            });
        }
        
    } else {
        NSMutableArray* collections = [notification.userInfo objectForKey:@"collections"];
        if ([collections count] > 0) {
            NSNumber* currentPage = [notification.userInfo objectForKey:@"page"];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.collectionView setContentOffset:CGPointMake(0, cellAmount * cellHeight - 90)];
            });
            
            self.displayedPages = [NSMutableArray arrayWithObjects:currentPage, @([currentPage unsignedIntegerValue] + 1), nil];
            
            [self.collectionsCache setObject:collections forKey:currentPage];
            [self.collectionsCache removeObjectForKey:@([currentPage unsignedIntegerValue] + 2)];
            
            NSMutableArray<CollectionModel*>* array = [[NSMutableArray new] autorelease];
            [array addObjectsFromArray:collections];
            NSMutableArray* prevPage = [self.collectionsCache objectForKey:@([currentPage unsignedIntegerValue] + 1)];
            if (prevPage) {
                [array addObjectsFromArray:prevPage];
            }
            
            self.collections = array;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.collectionView reloadData];
            });
        }
    }
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.collections count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MainCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    CollectionModel* collectionModel = [self.collections objectAtIndex:indexPath.item];
    cell.collectionName.text = [NSString stringWithFormat:@"Description: %@", collectionModel.title];
    cell.totalPhoto.text = [NSString stringWithFormat:@"Total photo: %@", @(collectionModel.totalPhoto)];
    cell.preViewMainImage.image = collectionModel.mainImage;
    cell.preViewRightTopImage.image = collectionModel.rightTopImage;
    cell.preViewRightBottomImage.image = collectionModel.rightBotoomImage;
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoLibraryCollectionViewController* pc = [[PhotoLibraryCollectionViewController alloc] initWithCollectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
    pc.identificator = [self.collections objectAtIndex:indexPath.item].identifier;
    [self.navigationController pushViewController:pc animated:YES];
    [pc release];
}

-(UIEdgeInsets) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewFlowLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((self.collectionViewWidth / self.numberOfColumns) - (self.xInsets + self.cellSpacing), 160);
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
    [self.unsplashHttpCllient getPhotoCollections:self.currentPage perPage:30];
}


@end
