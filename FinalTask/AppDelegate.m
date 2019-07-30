//
//  AppDelegate.m
//  FinalTask
//
//  Created by USER on 7/20/19.
//  Copyright © 2019 USER. All rights reserved.
//

#import "AppDelegate.h"
#import "MainCollectionViewController.h"
#import "Reachability.h"
#import "StartViewController.h"


@interface AppDelegate ()
@property (retain, nonatomic) Reachability* checker;
@property (retain, nonatomic) UINavigationController* navigationController;
@property (retain, nonatomic) StartViewController* startVC;
@end

@implementation AppDelegate

- (void)dealloc
{
    [_checker release];
    [_navigationController release];
    [_startVC release];
    [super dealloc];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
    StartViewController* sc = [[[StartViewController alloc] init] autorelease];
    [self.window setRootViewController:sc];
    self.startVC = sc;
    
    MainCollectionViewController* pc = [[[MainCollectionViewController alloc] initWithCollectionViewLayout:[[UICollectionViewFlowLayout alloc] init]] autorelease];
    pc.unsplashHttpCllient = [[[UnsplashHttpClient alloc] initWithURLSession:[NSURLSession sharedSession]] autorelease];
    UINavigationController* nc  = [[[UINavigationController alloc] initWithRootViewController:pc] autorelease];
    self.navigationController = nc;
    
    _checker = [Reachability reachabilityWithHostname:@"unsplash.com"];
    
    NSUInteger memoryCapacity = 10 * 1024 * 1024;
    NSUInteger diskCapacity = 10 * 1024 * 1024;
    NSURLCache* urlCache = [[NSURLCache alloc] initWithMemoryCapacity:memoryCapacity diskCapacity:diskCapacity diskPath:nil];
    [NSURLCache setSharedURLCache:urlCache];
    [self.window makeKeyAndVisible];
    
    return YES;
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    NetworkStatus status = [_checker currentReachabilityStatus];
    if (status == NotReachable) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Not Reachable"
                                                                       message:[NSString stringWithFormat:@"Check your inthernet connection."]
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self.window setRootViewController:self.startVC];
        [self.startVC presentViewController:alert animated:YES completion:nil];
    } else {
        [self.window setRootViewController:self.navigationController];
    }
}


@end
