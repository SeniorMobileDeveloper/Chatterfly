//
//  EditProfileVC.h
//  Chatterfly
//
//  Created by PJ95 on 6/10/15.
//  Copyright (c) 2015 PJ95. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Public.h"
@interface EditProfileVC : UIViewController<UIActionSheetDelegate,UIPopoverControllerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,UITextViewDelegate,NIDropDownDelegate,VPImageCropperDelegate>{
    UIImage *chosenImage;
    NIDropDown *dropDown;
}
- (IBAction)onBack:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnPortfolio;
- (IBAction)onUpdatePortfolio:(id)sender;
//@property (weak, nonatomic) IBOutlet UITextView *tvAboutMe;
@property (weak, nonatomic) IBOutlet UITextField *tfFirstName;
@property (weak, nonatomic) IBOutlet UITextField *tfLastName;
@property (weak, nonatomic) IBOutlet UITextField *tfEmailAdr;
@property (weak, nonatomic) IBOutlet UITextField *tfUsername;
@property (weak, nonatomic) IBOutlet UIButton *btnDistance;
- (IBAction)onChangeDistance:(id)sender;

- (IBAction)onUpdateProfile:(id)sender;

@end
