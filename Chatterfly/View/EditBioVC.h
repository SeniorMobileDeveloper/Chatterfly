//
//  EditBioVC.h
//  Chatterfly
//
//  Created by PJ95 on 6/10/15.
//  Copyright (c) 2015 PJ95. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Public.h"
@interface EditBioVC : UIViewController
- (IBAction)onBack:(id)sender;
- (IBAction)onUpdateBio:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *tvAboutMe;

@end
