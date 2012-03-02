//
//  grabPhotosViewController.h
//  swypPhotos
//
//  Created by Alexander List on 12/3/11.
//  Copyright (c) 2011 ExoMachina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <libswyp/libswyp.h>
#import "KBView.h"

@class KBViewController;
@interface KBViewController : UIViewController <UITextViewDelegate, KBViewDelegate,
swypConnectionSessionDataDelegate, swypContentDataSourceProtocol> {
		
	swypWorkspaceViewController *	_swypWorkspace;
    swypScreenEdgeType lastEdge;
    KBView *_keyboard;
    UIButton                    *   _activateSwypButton;
    NSDictionary *_lastKeyPress;
    double _connectionTime;
}
@property (nonatomic, readonly) swypWorkspaceViewController * swypWorkspace;
@property (nonatomic, retain) UITextView *textView;
@property (nonatomic, retain) NSString *certainText;
@property (nonatomic, retain) NSMutableArray *uncertainText;

-(void)screenKeyPressed:(id)sender;

@end
