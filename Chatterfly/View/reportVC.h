//
//  reportVC.h
//  Chatterfly
//
//  Created by PJ95 on 6/16/15.
//  Copyright (c) 2015 PJ95. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Public.h"
@interface reportVC : UIViewController<UITextViewDelegate>
@property (nonatomic,strong) PFUser *user;
- (IBAction)onCancel:(id)sender;
- (IBAction)onSave:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *tvFeedback;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblContents;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle1;


@end
