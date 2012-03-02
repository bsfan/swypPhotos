//
//  KBButton.m
//  MultiBoard
//
//  Created by Ethan Sherbondy on 3/2/12.
//  Copyright (c) 2012 MIT. All rights reserved.
//

#import "KBButton.h"
#import "UIImage+Colors.h"
#import <QuartzCore/QuartzCore.h>

@implementation KBButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundImage:[UIImage imageWithUIColor:[[UIColor grayColor] colorWithAlphaComponent:0.25]] 
                        forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageWithUIColor:[[UIColor grayColor] colorWithAlphaComponent:0.5]] 
                        forState:UIControlStateHighlighted];
        self.layer.cornerRadius = 8;
        self.layer.borderColor = [UIColor darkGrayColor].CGColor;
        
        self.layer.shadowOpacity = 0.75;
        self.layer.shadowRadius = 2;
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0, 2);
        [self setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin| UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin];
    }
    return self;
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
