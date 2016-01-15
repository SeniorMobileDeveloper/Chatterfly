//
//  createAccountVC.h
//  Chatterfly
//
//  Created by PJ95 on 6/7/15.
//  Copyright (c) 2015 PJ95. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Public.h"
#import "PFDatabase.h"
@interface createAccountVC : UIViewController<UIActionSheetDelegate,UIPopoverControllerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,UITextViewDelegate>{
    UIImage *chosenImage;
    NSString *gender;
}

@property (weak, nonatomic) IBOutlet UIButton *btnCreate;
@property (weak, nonatomic) IBOutlet UISwitch *genderSwitch;

- (IBAction)onChangeGender:(UISwitch *)sender;
- (IBAction)onCreate:(id)sender;
- (IBAction)onBack:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnAvatar;
- (IBAction)onChangeAvatar:(id)sender;

@property (weak, nonatomic) IBOutlet UITextView  *tvAboutMe;
@property (weak, nonatomic) IBOutlet UITextField *tfFirstName;
@property (weak, nonatomic) IBOutlet UITextField *tfLastName;
@property (weak, nonatomic) IBOutlet UITextField *tfEmailAdr;
@property (weak, nonatomic) IBOutlet UITextField *tfUsername;
@property (weak, nonatomic) IBOutlet UITextField *tfPassword;
@property (weak, nonatomic) IBOutlet UITextField *tfConfirmPassword;

@end
