//
//  roomView.h
//  Chatterfly
//
//  Created by PJ95 on 6/10/15.
//  Copyright (c) 2015 PJ95. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Public.h"
#import "PFDatabase.h"

@protocol chatRoomsVCDelegate;

@interface roomView : UIView<UICollisionBehaviorDelegate,UIDynamicAnimatorDelegate>{
    
    BOOL isTouchBegan;
    BOOL isTouchMoved;
    CGSize originalSize;
    CGPoint startLocation;
    NSInteger direction;
}
- (id)initWithFrameAndConstant:(CGRect)frame index:(NSInteger)index;

//@property (nonatomic, assign) chatRoomsVC *m_chatRoom;

@property (nonatomic, assign) id<chatRoomsVCDelegate> chatRoomsDelegate;

@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) UICollisionBehavior *collisionBehavior;
@property (nonatomic, strong) UIDynamicItemBehavior *itembehavior;
@property (nonatomic,strong) NSMutableArray *usersArray;
@property (nonatomic) NSInteger index;

@end

////lgilgilgi
@protocol chatRoomsVCDelegate <NSObject>

@optional

-(void) resetAnimations111;

@end
