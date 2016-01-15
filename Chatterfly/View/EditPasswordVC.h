//
//  EditPasswordVC.h
//  Chatterfly
//
//  Created by PJ95 on 6/10/15.
//  Copyright (c) 2015 PJ95. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Public.h"
@interface EditPasswordVC : UIViewController
- (IBAction)onBack:(id)sender;
- (IBAction)onUpdatePassword:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *tfOldPassword;
@property (weak, nonatomic) IBOutlet UITextField *tfNewPassword;
@property (weak, nonatomic) IBOutlet UITextField *tfConfirmPassword;

@end
