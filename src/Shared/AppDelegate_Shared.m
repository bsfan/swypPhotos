//
//  AppDelegate_Shared.m
//  swypPhotos
//
//  Created by Alexander List on 8/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate_Shared.h"


@implementation AppDelegate_Shared
@synthesize window;

#pragma mark -
#pragma mark Application lifecycle

-(BOOL) application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    kbVC	=	[[KBViewController alloc] init];
	[[kbVC view] setFrame:self.window.frame];
    
    self.window.autoresizesSubviews = YES;	
    self.window.backgroundColor = [UIColor blackColor];
	[self.window setRootViewController:kbVC];
    [self.window makeKeyAndVisible];
    SRELS(kbVC);
    
	return TRUE;
}

/**
 Save changes in the application's managed object context before the application terminates.
 */
- (void)applicationWillTerminate:(UIApplication *)application {
}

-(void)applicationDidBecomeActive:(UIApplication *)application{

}

- (void)applicationWillEnterForeground:(UIApplication *)application {

	[[[kbVC swypWorkspace] connectionManager] startServices];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
	[[[kbVC swypWorkspace] connectionManager] stopServices];
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    SRELS(kbVC);
	
    [window release];
    [super dealloc];
}


@end

