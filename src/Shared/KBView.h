//
//  KBView.h
//  swyp
//
//  Created by Ethan Sherbondy on 2/18/12.
//  Copyright (c) 2012 MIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KBButton.h"

@protocol KBViewDelegate <NSObject>

- (void)screenKeyPressed:(id)sender;

@end

@interface KBView : UIView {
    BOOL _isRightKB;
    BOOL _isShowingSymbols;
    KBButton *_symbolButton;
}

- (void)makeLeftKeyboard;
- (void)makeRightKeyboard;

@property (nonatomic, assign) id<KBViewDelegate>delegate;

@end
