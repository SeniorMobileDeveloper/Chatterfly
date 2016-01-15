//
//  avartarVC.h
//  Chatterfly
//
//  Created by PJ95 on 6/10/15.
//  Copyright (c) 2015 PJ95. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Public.h"
@interface avartarVC : UIViewController<UIGestureRecognizerDelegate,UIBarPositioningDelegate,UICollisionBehaviorDelegate,UIDynamicAnimatorDelegate,UIAlertViewDelegate,UITextFieldDelegate>{
    CGRect tempFrame;
    NSInteger tapNo;
    float previousScale;
    UITapGestureRecognizer *tapGesture;
}

@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) UICollisionBehavior *collisionBehavior;
@property (nonatomic, strong) UIDynamicItemBehavior *itembehavior;
@property (strong, nonatomic) NSMutableArray        *tempImgViewArray;

@property  int cellMessageWidth;
@property  int cellMessageHeight;
@property CGFloat mainViewWidth;
@property CGFloat mainViewHeight;
@property CGFloat mainViewOrgX;
@property CGFloat mainviewOrgY;

- (IBAction)onBack:(id)sender;
- (IBAction)onMenu:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *mainView;

@property (weak, nonatomic) IBOutlet UIView *msgInPutView;
@property (weak, nonatomic) IBOutlet UITextField *messageField;
- (IBAction)sendMessageNow:(id)sender;


@property (weak, nonatomic) IBOutlet UIView *recommendationView;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblMessage;
- (IBAction)onAddComment:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *myImage;
- (IBAction)onClickMyImage:(id)sender;
- (IBAction)onCloseRecomm:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *detailView;
@property (weak, nonatomic) IBOutlet UIButton *btnImage;
- (IBAction)onCloseDetailView:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *tvAboutMe;
- (IBAction)onAddFriend:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnAddFriend;

- (IBAction)onBlockUser:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnBlockUser;

- (IBAction)onReportUser:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnRegisterUser;

@property (weak, nonatomic) IBOutlet UILabel *lblName2;

@end
