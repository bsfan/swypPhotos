//
//  AppDelegate_Shared.h
//  swypPhotos
//
//  Created by Alexander List on 8/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "KBViewController.h"


NSString * const swypPhotosWorkspaceIdentifier;

@interface AppDelegate_Shared : NSObject <UIApplicationDelegate> {
	
    UIWindow *window;
    
	KBViewController	* kbVC;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end

