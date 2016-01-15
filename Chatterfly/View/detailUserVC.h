//
//  detailUserVC.h
//  Chatterfly
//
//  Created by PJ95 on 6/19/15.
//  Copyright (c) 2015 PJ95. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Public.h"
#import "MWPhotoBrowser.h"
@interface detailUserVC : UIViewController<MWPhotoBrowserDelegate, UIGestureRecognizerDelegate>
{
    BOOL isFriend;
    BOOL isBlocked;
}

@property (nonatomic,strong) PFUser *user;
@property (weak, nonatomic) IBOutlet UIImageView *profileImg;
@property (weak, nonatomic) IBOutlet UILabel *lblFullName;
@property (weak, nonatomic) IBOutlet UITextView *tvBio;

@property (weak, nonatomic) IBOutlet UIButton *btnAddFriend;
- (IBAction)onAddFriend:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btnBlockUser;
- (IBAction)onBlockUser:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btnReportUser;
- (IBAction)onReportUser:(id)sender;
- (IBAction)onImageDetail:(id)sender;

@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, retain) UISwipeGestureRecognizer *swipeGesture;

@end
