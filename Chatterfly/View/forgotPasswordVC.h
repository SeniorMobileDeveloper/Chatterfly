//
//  forgotPasswordVC.h
//  Chatterfly
//
//  Created by PJ95 on 6/8/15.
//  Copyright (c) 2015 PJ95. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Public.h"
@interface forgotPasswordVC : UIViewController
- (IBAction)onBack:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *tfEmail;
- (IBAction)onRetrivePassword:(id)sender;

@end
