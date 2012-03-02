//
//  KBView.m
//  swyp
//
//  Created by Ethan Sherbondy on 2/18/12.
//  Copyright (c) 2012 MIT. All rights reserved.
//

#import "KBView.h"
#import "UIViewAdditions.h"
#import <QuartzCore/QuartzCore.h>

@implementation KBView

@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _symbolButton = [[KBButton alloc] init];
        [_symbolButton setTitle:@"!#?*" forState:UIControlStateNormal];
        [_symbolButton addTarget:self action:@selector(toggleSymbols) forControlEvents:UIControlEventTouchUpInside];
        _isShowingSymbols = NO;
    }
    return self;
}

- (void)makeKeyboard:(NSArray *)kbArray withSpaceBar:(BOOL)hasSpacebar {
    [self removeAllSubviews];
    
    int row = 0;
    int WIDTH = 60;
    int HEIGHT = 108;
    int H_SPACE =8;
    int V_SPACE = 8;
    
    for (NSString *chars in kbArray){        
        for (int i = 0; i < chars.length; i++){
            unichar character = [chars characterAtIndex:i];
            
            NSString *charString = [NSString stringWithCharacters:&character length:1];
            KBButton *key = [[KBButton alloc] initWithFrame:CGRectMake(i*(WIDTH+H_SPACE)-H_SPACE, row*(HEIGHT+V_SPACE)-V_SPACE, WIDTH, HEIGHT)];
            [key setTitle:charString forState:UIControlStateNormal];
            [key addTarget:self.delegate action:@selector(screenKeyPressed:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:key];
        }
        row += 1;
    }
    
    
    CGFloat symbolX = 0;
    if (_isRightKB){
        symbolX = self.width - WIDTH;
    }
    _symbolButton.frame = CGRectMake(symbolX, (row*(HEIGHT+V_SPACE)+V_SPACE), WIDTH, HEIGHT);
    [self addSubview:_symbolButton];
    
    if (hasSpacebar){
        CGFloat spaceX;
        CGFloat spaceWidth = 2*(WIDTH+H_SPACE);
        if (_isRightKB){
            spaceX = 0;
        } else {
            spaceX = self.frame.size.width-spaceWidth;
        }
        
        KBButton *spaceBar = [[KBButton alloc] initWithFrame:CGRectMake(spaceX, (row*(HEIGHT+V_SPACE)+V_SPACE), spaceWidth, HEIGHT)];
        [spaceBar setTitle:@" " forState:UIControlStateNormal];
        [spaceBar addTarget:self.delegate action:@selector(screenKeyPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:spaceBar];
    }
}

- (void)makeLeftKeyboard {
    NSArray *leftKB = @[@"qwert", @"asdfg", @"^zxcv"];
    _isRightKB = NO;
    [self makeKeyboard:leftKB withSpaceBar:YES];
}
- (void)makeRightKeyboard {
    NSArray *rightKB = @[@"yuiop",@"hjkl\n", @"bnm,.^"];
    _isRightKB = YES;
    [self makeKeyboard:rightKB withSpaceBar:YES];
}

- (void)toggleSymbols {
    _isShowingSymbols = !_isShowingSymbols;
    if (_isShowingSymbols){
        [_symbolButton setTitle:@"abc" forState:UIControlStateNormal];
        NSArray *symbolKB = @[@"12345",@"67890",@"+-*=/"];
        [self makeKeyboard:symbolKB withSpaceBar:NO];
    } else {
        [_symbolButton setTitle:@"!#?*" forState:UIControlStateNormal];
        _isRightKB ? [self makeRightKeyboard] : [self makeLeftKeyboard];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
