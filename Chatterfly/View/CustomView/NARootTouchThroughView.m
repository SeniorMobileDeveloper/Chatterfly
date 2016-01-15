//
//  NARootTouchThroughView.m
//  TouchThroughViewDemo
//
//  Created by Nathan Rowe on 10/19/13.
//  Copyright (c) 2013 Natrosoft LLC. All rights reserved.
//

#import "NARootTouchThroughView.h"
#import "NATouchThroughView.h"

@implementation NARootTouchThroughView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (BOOL) pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    BOOL result = [super pointInside:point withEvent:event];
    return result;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *result = [super hitTest:point withEvent:event];
    if ([result isKindOfClass:[NATouchThroughView class]]) {
        result = nil;
    }
    
    return result;
}

@end
