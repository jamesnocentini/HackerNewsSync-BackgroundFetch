//
//  AppDelegate.m
//  HackerNewsSync+BackgroundFetch
//
//  Created by James Nocentini on 05/03/2015.
//  Copyright (c) 2015 James Nocentini. All rights reserved.
//

#import "AppDelegate.h"
#import <CouchbaseLite/CouchbaseLite.h>

#define kSyncGatewayUrl @"http://localhost:4984/todos"

@interface AppDelegate ()

@property (strong, nonatomic) CBLReplication *pull;
@property (copy, nonatomic) void (^backgroundFetchCompletionHandler)(UIBackgroundFetchResult result);

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSLog(@"Application launching...");
    
    [application setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    [self setDatabase];
    
    return YES;
}

- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    NSLog(@"Perform background fetch...");
    self.backgroundFetchCompletionHandler = completionHandler;
    [self startReplication];
}

- (void) startReplication {
    NSURL *syncURL = [[NSURL alloc] initWithString:kSyncGatewayUrl];
    self.pull = [self.database createPullReplication:syncURL];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateReplication:)
                                                 name:kCBLReplicationChangeNotification
                                               object:self.pull];
    
    [self.pull start];
}

- (void) updateReplication:(NSNotification *)notification {
    if (self.pull.status == kCBLReplicationStopped && self.backgroundFetchCompletionHandler != nil) {
        self.backgroundFetchCompletionHandler(UIBackgroundFetchResultNewData);
    }
}

- (void) setDatabase {
    CBLManager *manager = [CBLManager sharedInstance];
    _database = [manager databaseNamed:@"hackernews" error:nil];
}

@end
