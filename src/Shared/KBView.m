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
    }
    return self;
}

- (void)makeKeyboard:(NSArray *)kbArray{
    int row = 0;
    int WIDTH = 54;
    int HEIGHT = 124;
    int H_SPACE = 8;
    int V_SPACE = 8;
    
    for (NSString *chars in kbArray){        
        for (int i = 0; i < chars.length; i++){
            unichar character = [chars characterAtIndex:i];
            NSLog(@"%@", [NSString stringWithCharacters:&character length:1]);
            
            NSString *charString = [NSString stringWithCharacters:&character length:1];
            
            UIButton *key = [UIButton buttonWithType:UIButtonTypeCustom];
            key.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.25];
            key.layer.cornerRadius = 8;
            key.layer.borderColor = [UIColor darkGrayColor].CGColor;
            
            key.layer.shadowOpacity = 0.75;
            key.layer.shadowRadius = 2;
            key.layer.shadowColor = [UIColor blackColor].CGColor;
            key.layer.shadowOffset = CGSizeMake(0, 2);
            
            key.frame = CGRectMake(i*(WIDTH+H_SPACE)+H_SPACE, row*(HEIGHT+V_SPACE)+2*V_SPACE, WIDTH, HEIGHT);
            [key setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin| UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin];
            [key setTitle:charString forState:UIControlStateNormal];
            [key addTarget:self.delegate action:@selector(screenKeyPressed:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:key];
        }
        row += 1;
    }
}

- (void)makeLeftKeyboard {
    NSArray *leftKB = @[@"qwert", @"asdfg", @"^zxcv"];
    [self makeKeyboard:leftKB];
}
- (void)makeRightKeyboard {
    NSArray *rightKB = @[@"yuiop",@"hjkl\n", @"bnm,.^"];
    [self makeKeyboard:rightKB];
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
