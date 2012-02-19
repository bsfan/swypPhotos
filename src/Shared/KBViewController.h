//
//  grabPhotosViewController.h
//  swypPhotos
//
//  Created by Alexander List on 12/3/11.
//  Copyright (c) 2011 ExoMachina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <libswyp/libswyp.h>

@class KBViewController;
@interface KBViewController : UIViewController <swypBackedPhotoDataSourceDelegate> {
		
	swypWorkspaceViewController *	_swypWorkspace;
    
    UIButton                    *   _activateSwypButton;
}
@property (nonatomic, readonly) swypWorkspaceViewController * swypWorkspace;

@end
