//
//  grabPhotosViewController.h
//  swypPhotos
//
//  Created by Alexander List on 12/3/11.
//  Copyright (c) 2011 ExoMachina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ELCImagePickerController.h"
#import <libswyp/libswyp.h>

@class grabPhotosViewController;
@interface grabPhotosViewController : UIViewController <ELCImagePickerControllerDelegate, swypBackedPhotoDataSourceDelegate> {
	
	ELCImagePickerController *		_imagePicker;
	
	swypWorkspaceViewController *	_swypWorkspace;
    
    UIButton                    *   _activateSwypButton;
}
@property (nonatomic, readonly) swypWorkspaceViewController * swypWorkspace;

-(UIImage*)	constrainImage:(UIImage*)image toSize:(CGSize)maxSize;

@end
