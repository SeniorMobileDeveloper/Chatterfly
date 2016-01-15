//
//  ViewController.h
//  Chatterfly
//
//  Created by PJ95 on 6/5/15.
//  Copyright (c) 2015 PJ95. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
@property (weak, nonatomic) IBOutlet UIButton *btnSignup;
@property (weak, nonatomic) IBOutlet UIButton *btnFB;
- (IBAction)onLogin:(id)sender;
- (IBAction)onSignup:(id)sender;
- (IBAction)onLoginFacebook:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *tfUsername;
@property (weak, nonatomic) IBOutlet UITextField *tfPw;
@end

