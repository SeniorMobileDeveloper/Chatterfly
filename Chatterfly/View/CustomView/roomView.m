//
//  roomView.m
//  Chatterfly
//
//  Created by PJ95 on 6/10/15.
//  Copyright (c) 2015 PJ95. All rights reserved.
//

#import "roomView.h"

@implementation roomView

- (void) touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    // Retrieve the touch point
    
    
    NSLog(@"GSC  %ld",(long)self.index);
    // SGR Added Start
    [Global sharedInstance].dragViewIndex = self.index;
    
    isTouchBegan = true;
    
    UIScrollView *scrView = (UIScrollView*) self.superview;
    scrView.scrollEnabled = NO;
    
    CGPoint pt = [[touches anyObject] locationInView:self];
    startLocation = pt;
    [[self superview] bringSubviewToFront:self];
}

-(UIView*)viewIntersectsWithAnotherView:(UIView*)selectedView{
    NSArray *subViewsInView=[self.superview subviews];// I assume self is a subclass
    // of UIViewController but the view can be
    //any UIView that'd act as a container
    //for all other views.
    for(UIView *theView in subViewsInView){
        if (![selectedView isEqual:theView])
            if(CGRectIntersectsRect(selectedView.frame, theView.frame))
                return theView;
    }
    return NULL;
}

- (void) touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event
{
    // Move relative to the original touch point
    
    isTouchMoved = true;
    
    //return;
    CGPoint pt = [[touches anyObject] locationInView:self];
    CGRect frame = [self frame];
    NSLog(@"Point:(%f,%f,%f,%f)",frame.origin.x,frame.origin.y, frame.size.width, frame.size.height);
    
    frame.origin.x += pt.x - startLocation.x;
    frame.origin.y += pt.y - startLocation.y;
    
    if([self viewIntersectsWithAnotherView: self] != NULL)
    {
        
    }
    
    
    //    frame.size.width = 40.0f;
    //    frame.size.height = 40.0f;
    
    if (frame.origin.x < 0) {
        frame.origin.x = 0;
    }
    if (frame.origin.x > (self.superview.frame.size.width - self.frame.size.width)) {
        frame.origin.x = self.superview.frame.size.width - self.frame.size.width;
    }
    
    if (frame.origin.y < 0) {
        frame.origin.y = 0;
    }
    if (frame.origin.y > (self.superview.frame.size.height - self.frame.size.height)) {
        frame.origin.y = self.superview.frame.size.height - self.frame.size.height;
    }
    
    [self setFrame:frame];
    NSLog(@"Point:(%f,%f,%f,%f)",frame.origin.x,frame.origin.y, frame.size.width, frame.size.height);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"touchMove" object:nil];
    
    //    frame.size.width = 40.0f;
    //    frame.size.height = 40.0f;
    [self setFrame:frame];
    
    
    [self resetAnimations];
    
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [Global sharedInstance].dragViewIndex = self.index;
    
    UIScrollView *scrView = (UIScrollView*) self.superview;
    scrView.scrollEnabled = YES;
    
    if ((isTouchBegan) && (!isTouchMoved)){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"touchTapChatRoom" object:nil];
    }else{
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"touchEnd" object:nil];
    }
    
    isTouchMoved = false;
    isTouchBegan = false;
    
    
    CGRect frame = [self frame];
    //    frame.size.width = 40.0f;
    //    frame.size.height = 40.0f;
    [self setFrame:frame];
    
    [self resetAnimations];
}

- (void) resetAnimations
{
//    [self.animator removeAllBehaviors];
//    [self.animator addBehavior:self.collisionBehavior];
//    [self.animator addBehavior:self.itembehavior];
    
    [self.chatRoomsDelegate resetAnimations111];
    
}


- (id)initWithFrameAndConstant:(CGRect)frame index:(NSInteger)index{
    self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height)];
    if (self) {
        self.index = index;
        [self sharedSetup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height)];
    if (self) {
        [self sharedSetup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self sharedSetup];
    }
    return self;
}

- (void) sharedSetup{
    originalSize = CGSizeMake(40, 40);
    self.layer.cornerRadius = self.frame.size.width / 2;

    self.clipsToBounds = YES;
    
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.superview];
    self.collisionBehavior = [[UICollisionBehavior alloc] initWithItems:nil];
    self.collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    self.collisionBehavior.collisionMode = UICollisionBehaviorModeEverything;
    self.collisionBehavior.collisionDelegate = self;
    
    self.itembehavior = [[UIDynamicItemBehavior alloc] initWithItems:nil];
    self.itembehavior.elasticity = 1.0;
    self.itembehavior.friction = 0.5;
    self.itembehavior.resistance = 0.5;
    self.itembehavior.allowsRotation = NO;
    
    [self.animator addBehavior:self.collisionBehavior];
    [self.animator addBehavior:self.itembehavior];
    
//    [self displayUsers];
    NSMutableArray *array = [[Global sharedInstance].groups objectAtIndex:self.index];
    NSInteger maleCnt = 0;
    NSInteger femaleCnt = 0;
    NSInteger totalCnt = [array count];
    for (int j = 0;j < totalCnt;j++){
        PFUser *user = [array objectAtIndex:j];
        if ([user[PF_USER_GENDER] isEqualToString:@"male"] == true){
            maleCnt++;
        }else{
            femaleCnt++;
        }
    }
    if (maleCnt > femaleCnt){
        self.backgroundColor = [UIColor colorWithRed:0.000f green:0.0f blue:0.918f alpha:1.00f];
    }else{
        self.backgroundColor = [UIColor colorWithRed:1.000f green:0.655f blue:0.918f alpha:1.00f];
    }
}

- (void) displayUsers{
    
    NSMutableArray *array = [[Global sharedInstance].groups objectAtIndex:self.index];
    for(int i = 0 ; i < [array count] ; i++){
        UIImageView * imageView = [[UIImageView alloc] init];
        
        
        [imageView setUserInteractionEnabled:YES];
        PFObject *objectUser = [array objectAtIndex:i];
        [imageView setImageWithURL:[objectUser[PF_USER_PICTURE] url] placeholderImage:[UIImage imageNamed:@"placeholder_gb.png"]];
//        UIImage *userImage = imageView.image;
//        int ii = (i) % 13 + 1;
//           imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpeg",ii]];
        imageView.layer.cornerRadius = 20;
        imageView.clipsToBounds = YES;
        imageView.layer.masksToBounds = YES;
        imageView.layer.borderWidth = 2;
        imageView.layer.borderColor = [UIColor redColor].CGColor;
//        [imageView.badgeView setBadgeValue:1];
//        [imageView.badgeView setType:MGBadgeTypeCircle];
//        [imageView.badgeView setOutlineWidth:0.0];
//        [imageView.badgeView setPosition:MGBadgePositionBottomRight];
//        [imageView.badgeView setBadgeColor:[UIColor blueColor]];
        CGPoint tempPoint;
        tempPoint = [self calculateCellPositionOnCellModeMap];
        CGRect frame = CGRectMake(tempPoint.x, tempPoint.y, originalSize.width, originalSize.height);
        imageView.frame = frame;
        
        // NSLog(@"%f",imageView.frame.origin.x);
        // NSLog(@"%f",imageView.frame.origin.y);
        
        
        [self addSubview:imageView];
        [self bringSubviewToFront:imageView];
        
        [self.collisionBehavior addItem:imageView];
        [self.itembehavior addItem:imageView];
        //
        //[self.tempImgViewArray addObject:imageView];
        NSLog(@"%d",i);
        
    }
    [[KIProgressViewManager manager] hideProgressView];
}


-(CGPoint)calculateCellPositionOnCellModeMap{
    
    CGPoint tempPoint;
    int r = arc4random() % (int)self.frame.size.width / 2;
    NSLog(@"%ld",(long)self.frame.size.width);
    int r0 = originalSize.width / 2;
    int r1 = r - r0;
    if (r1 < 0) r1 = 0;
    NSInteger totalAlpha = 0;
    if (direction == 1) totalAlpha = 90;
    if (direction == 2) totalAlpha = 180;
    if (direction == 3) totalAlpha = 270;
    direction = (direction + 1) % 4;
    float alpha = arc4random() % 90 + totalAlpha;
    int x0 = self.frame.size.width / 2;
    int y0 = self.frame.size.height / 2;
    int x = x0 + r1 * cos(alpha / 360 * 6.28) - r0;
    int y = y0 + r1 * sin(alpha / 360 * 6.28) - r0;
    tempPoint.x = x;
    tempPoint.y = y;
    NSLog(@"%d: %d",x,y);
    return tempPoint;
}

#pragma mark UICollisionBehaviorDelegate

- (void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item withBoundaryIdentifier:(id<NSCopying>)identifier atPoint:(CGPoint)p {

    NSLog(@" point (%f %f)------", p.x, p.y);
    
}


@end
