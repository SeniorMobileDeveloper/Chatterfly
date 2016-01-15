//
//  DragView.m
//  CellsFriends
//
//  Created by black on 4/6/15.
//  Copyright (c) 2015 PJ55. All rights reserved.
//

#import "DragView.h"
#import "Global.h"
@implementation DragView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */



- (void) touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    // Retrieve the touch point
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"touchBegin" object:nil];
    
    
    // SGR Added Start
    [Global sharedInstance].selectedUserIndex = self.index;
 
    
    
    isTouchBegan = true;
    CGPoint pt = [[touches anyObject] locationInView:self];
    startLocation = pt;
    [[self superview] bringSubviewToFront:self];
}

- (void) touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event
{
    // Move relative to the original touch point
    
    isTouchMoved = true;
    
    CGPoint pt = [[touches anyObject] locationInView:self];
    CGRect frame = [self frame];
    NSLog(@"Point:(%f,%f,%f,%f)",frame.origin.x,frame.origin.y, frame.size.width, frame.size.height);
    frame.origin.x += pt.x - startLocation.x;
    frame.origin.y += pt.y - startLocation.y;
    //    frame.size.width = 40.0f;
    //    frame.size.height = 40.0f;
    
    if (frame.origin.x < 0) {
        frame.origin.x = 0;
    }
    if (frame.origin.x > (self.superview.frame.size.width - self.frame.size.width)) {
        frame.origin.x = (self.superview.frame.size.width - self.frame.size.width);
    }
    
    if (frame.origin.y < 0) {
        frame.origin.y = 0;
    }
    if (frame.origin.y > (self.superview.frame.size.height - self.frame.size.height)) {
        frame.origin.y = (self.superview.frame.size.height - self.frame.size.height);
    }
    
    [self setFrame:frame];
    NSLog(@"Point:(%f,%f,%f,%f)",frame.origin.x,frame.origin.y, frame.size.width, frame.size.height);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"touchMove" object:nil];
    
    //    frame.size.width = 40.0f;
    //    frame.size.height = 40.0f;
    [self setFrame:frame];
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [Global sharedInstance].selectedUserIndex = self.index;
    if ((isTouchBegan) && (!isTouchMoved)){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"touchTap" object:nil];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"touchEnd" object:nil];
    }
    
    isTouchMoved = false;
    isTouchBegan = false;
    
    
    CGRect frame = [self frame];
    //    frame.size.width = 40.0f;
    //    frame.size.height = 40.0f;
    [self setFrame:frame];
}


@end
