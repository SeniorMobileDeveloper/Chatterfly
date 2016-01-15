//
//  chatRoomsVC.h
//  Chatterfly
//
//  Created by PJ95 on 6/10/15.
//  Copyright (c) 2015 PJ95. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Public.h"


@interface chatRoomsVC : UIViewController<UICollisionBehaviorDelegate,UIDynamicAnimatorDelegate, RMPScrollingMenuBarControllerDelegate, chatRoomsVCDelegate>{
    NSInteger totalCnt;
    NSTimer *timer;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrView;
- (IBAction)onGoFavorite:(id)sender;

@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) UICollisionBehavior *collisionBehavior;
@property (nonatomic, strong) UIDynamicItemBehavior *itembehavior;
@property (strong, nonatomic) NSMutableArray        *tempImgViewArray;
@property (weak, nonatomic) IBOutlet UIButton *btnMessage;

- (IBAction)onGoMessage:(id)sender;
- (IBAction)onMenu:(id)sender;

- (void) resetAnimations;
@end


