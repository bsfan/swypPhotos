//
//  grabPhotosViewController.m
//  swypPhotos
//
//  Created by Alexander List on 12/3/11.
//  Copyright (c) 2011 ExoMachina. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "KBViewController.h"
#import <libSwyp/swyp.h>

static NSString *kbType = @"kbType";

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
@synthesize textView = _textView;

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
    
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.view.backgroundColor  = [UIColor redColor];
        
    self.textView = [[UITextView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.textView setAutoresizingMask:UIViewAutoresizingFlexibleWidth| UIViewAutoresizingFlexibleHeight];
    self.textView.delegate = self;
    [self.textView setFont:[UIFont systemFontOfSize:24]];
    [self.view addSubview:self.textView];
    
    _activateSwypButton	=	[UIButton buttonWithType:UIButtonTypeCustom];
	UIImage *	swypActivateImage	=	[UIImage imageNamed:@"swypPhotosHud"];
	[_activateSwypButton setBackgroundImage:swypActivateImage forState:UIControlStateNormal];
	[self frameActivateButtonWithSize:swypActivateImage.size];
	[_activateSwypButton addTarget:self action:@selector(activateSwypButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UISwipeGestureRecognizer *swipeUpRecognizer = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(activateSwypButtonPressed:)] autorelease];
    swipeUpRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
    [_activateSwypButton addGestureRecognizer:swipeUpRecognizer];
    
	[self.view addSubview:_activateSwypButton];
    
    _uncertainText = [NSMutableArray new];
    _certainText = @"";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connected) name:@"connected" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleSwyp:) name:@"swypin" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleSwyp:) name:@"swypout" object:nil];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self frameActivateButtonWithSize:_activateSwypButton.size];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    return NO;
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
    _activateSwypButton.alpha = 1;
}

- (void)screenKeyPressed:(id)sender {
    UIButton *theButton = (UIButton *)sender;
    NSLog(@"%@", theButton.currentTitle);
    NSString *letter = theButton.currentTitle;
    double currentTime = CACurrentMediaTime();
    NSNumber *elapsedTime = [NSNumber numberWithDouble:(currentTime-_connectionTime)];
    
    _lastKeyPress = @{ @"letter" : letter, @"time" :  elapsedTime};
    // [_uncertainText addObject:@[elapsedTime, letter]];
    // [self updateText];
    _textView.text = [_textView.text stringByAppendingString:letter];

    //@TODO: fix this... anyobject...
    swypConnectionSession *session = [[[_swypWorkspace connectionManager] activeConnectionSessions] anyObject];
    [[_swypWorkspace contentManager] sendContentWithID:letter throughConnectionSession:session];
}

- (void)updateText {
    
    NSString *uncertainString = @"";
    for (NSArray *item in _uncertainText){
        uncertainString = [uncertainString stringByAppendingString:[item objectAtIndex:1]];
    }
    if (!_certainText) _certainText = @"";
    _textView.text = [_certainText stringByAppendingString:uncertainString];
}

#pragma mark - Swyp out

- (NSArray *)idsForAllContent {
	return nil;
}
- (NSArray *)supportedFileTypesForContentWithID:(NSString *)contentID {
    return @[kbType];
}

- (UIImage *)iconImageForContentWithID:(NSString *)contentID ofMaxSize:(CGSize)maxIconSize {
    return nil;
}

- (NSData*)	dataForContentWithID:(NSString *)contentID fileType:(swypFileTypeString *)type{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_lastKeyPress];
    return data;
}

#pragma mark - Swyp

-(NSArray*)supportedFileTypesForReceipt {
	return @[kbType];
}

-(void)	yieldedData:(NSData *)streamData ofType:(NSString *)streamType 
fromDiscernedStream:(swypDiscernedInputStream *)discernedStream 
inConnectionSession:(swypConnectionSession *)session{
	EXOLog(@" datasource received data of type: %@",[discernedStream streamType]);
	
	if ([streamType isEqualToString:kbType]){
        NSDictionary *data = [NSKeyedUnarchiver unarchiveObjectWithData:streamData];
        NSLog(@"%@", data);
        
        _textView.text = [_textView.text stringByAppendingString:[data objectForKey:@"letter"]];

        /*
        NSString *newCertainText = @"";
        for (int i = 0; i < _uncertainText.count; i++){
            if ([data objectForKey:@"time"] > [[_uncertainText objectAtIndex:i] objectAtIndex:0]){
                for (int j = 0; j < i; j++){
                    newCertainText = [newCertainText stringByAppendingString:[[_uncertainText objectAtIndex:j] objectAtIndex:1]];
                }
                [_uncertainText removeObjectsInRange:NSMakeRange(0, i)];
                break;
            }
        }
        newCertainText = [newCertainText stringByAppendingString:[data objectForKey:@"letter"]];
        _certainText = [_certainText stringByAppendingString:newCertainText];
        [self updateText];
         */
	}
}

- (void)handleSwyp:(NSNotification *)notification {
    swypInfoRef *swypInfo = [[notification userInfo] objectForKey:@"swyp"];
    lastEdge = [swypInfo screenEdgeOfSwyp];
}

- (void)connected {
    [self dismissModalViewControllerAnimated:YES];
    _activateSwypButton.hidden = YES;
    _keyboard = [[KBView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _keyboard.delegate = self;
    if (lastEdge == swypScreenEdgeTypeLeft){
        [_keyboard makeRightKeyboard];
    } else if (lastEdge == swypScreenEdgeTypeRight){
        [_keyboard makeLeftKeyboard];
    } else {
        NSLog(@"Unexpected keyboard type.");
    }
    [self.view addSubview:_keyboard];
    
    _connectionTime = CACurrentMediaTime();
    EXOLog(@"%f", _connectionTime);
}


@end
