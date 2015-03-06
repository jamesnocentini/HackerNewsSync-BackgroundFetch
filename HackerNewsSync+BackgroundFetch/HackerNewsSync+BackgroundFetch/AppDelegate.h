//
//  AppDelegate.h
//  HackerNewsSync+BackgroundFetch
//
//  Created by James Nocentini on 05/03/2015.
//  Copyright (c) 2015 James Nocentini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CouchbaseLite/CouchbaseLite.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic, readonly) CBLDatabase *database;

@end

