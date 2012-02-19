//
//  grabPhotosViewController.m
//  swypPhotos
//
//  Created by Alexander List on 12/3/11.
//  Copyright (c) 2011 ExoMachina. All rights reserved.
//

#import "KBViewController.h"

// To deal with rotation madness
@interface UIApplication (AppDimensions)
+(CGSize) currentSize;
+(CGSize) sizeInOrientation:(UIInterfaceOrientation)orientation;
@end

@implementation UIApplication (AppDimensions)

+(CGSize) currentSize
{
    return [UIApplication sizeInOrientation:[UIApplication sharedApplication].statusBarOrientation];
}

+(CGSize) sizeInOrientation:(UIInterfaceOrientation)orientation
{
    CGSize size = [UIScreen mainScreen].bounds.size;
    UIApplication *application = [UIApplication sharedApplication];
    if (UIInterfaceOrientationIsLandscape(orientation))
    {
        size = CGSizeMake(size.height, size.width);
    }
    if (application.statusBarHidden == NO)
    {
        size.height -= MIN(application.statusBarFrame.size.width, application.statusBarFrame.size.height);
    }
    return size;
}

@end

// The main show

@implementation KBViewController
@synthesize swypWorkspace = _swypWorkspace;

- (id)init{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(swypWorkspaceViewController *)swypWorkspace{
	if (_swypWorkspace == nil){
		_swypWorkspace	=	[[swypWorkspaceViewController alloc] init];
		[_swypWorkspace.view setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
		[_swypWorkspace.view setFrame:self.view.bounds];

		[[[self swypWorkspace] contentManager] setContentDataSource:self];
	}
    
	return _swypWorkspace;
}

-(void) activateSwypButtonPressed:(id)sender{
	[[self swypWorkspace] presentContentWorkspaceAtopViewController:self];
}

-(void)frameActivateButtonWithSize:(CGSize)theSize {
    [_activateSwypButton setFrame:CGRectMake((([UIApplication currentSize].width)-theSize.width)/2, [UIApplication currentSize].height-theSize.height, theSize.width, theSize.height)];
}

#pragma mark - View lifecycle
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
- (void)viewDidLoad{
    [super viewDidLoad];
	
	_activateSwypButton	=	[UIButton buttonWithType:UIButtonTypeCustom];
	UIImage *	swypActivateImage	=	[UIImage imageNamed:@"swypPhotosHud"];
	[_activateSwypButton setBackgroundImage:swypActivateImage forState:UIControlStateNormal];
	[self frameActivateButtonWithSize:swypActivateImage.size];
	[_activateSwypButton addTarget:self action:@selector(activateSwypButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UISwipeGestureRecognizer *swipeUpRecognizer = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(activateSwypButtonPressed:)] autorelease];
    swipeUpRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
    
    [_activateSwypButton addGestureRecognizer:swipeUpRecognizer];
    
	[self.view addSubview:_activateSwypButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self frameActivateButtonWithSize:_activateSwypButton.size];
}

- (void)viewDidUnload{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    _activateSwypButton.alpha = 0;
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [self frameActivateButtonWithSize:_activateSwypButton.size];
    _activateSwypButton.alpha = 1;
}

#pragma mark - Swyp


@end
