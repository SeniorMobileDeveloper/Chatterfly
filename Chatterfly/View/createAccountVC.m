//
//  createAccountVC.m
//  Chatterfly
//
//  Created by PJ95 on 6/7/15.
//  Copyright (c) 2015 PJ95. All rights reserved.
//

#import "createAccountVC.h"

@implementation createAccountVC

#pragma  mark - View

- (void) viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
}

- (void) viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
}

- (void) viewDidLoad{
    
    
    ////// Swipe Right or Left of Signup Screen ///////////
    UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeAction:)];
    leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    
    UISwipeGestureRecognizer *rightSwipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeAction:)];
    rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:rightSwipe];
    [self.view addGestureRecognizer:leftSwipe];
    
    self.btnAvatar.layer.cornerRadius = self.btnAvatar.frame.size.width / 2;
    self.btnAvatar.layer.borderWidth = 3.0f;
    self.btnAvatar.layer.borderColor = [UIColor whiteColor].CGColor;
    self.btnAvatar.clipsToBounds = YES;
    self.btnAvatar.layer.borderColor = [UIColor colorWithRed:0.000f green:0.420f blue:1.000f alpha:1.00f].CGColor;
    _btnAvatar.layer.borderWidth = 2;
    
    self.tvAboutMe.delegate = self;
    self.tvAboutMe.layer.borderColor = [UIColor grayColor].CGColor;
    self.tvAboutMe.layer.borderWidth = 2;
    self.tvAboutMe.textColor = [UIColor grayColor];
    gender = @"male";
    [self.btnAvatar setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_default.png",gender]] forState:UIControlStateNormal];
    self.genderSwitch.on = false;
    
    _tfFirstName.autocorrectionType = UITextAutocorrectionTypeNo;
    _tfLastName.autocorrectionType = UITextAutocorrectionTypeNo;
    _tfEmailAdr.autocorrectionType = UITextAutocorrectionTypeNo;
    _tfUsername.autocorrectionType = UITextAutocorrectionTypeNo;
    _tvAboutMe.autocorrectionType = UITextAutocorrectionTypeNo;
    
}

- (void) textViewDidChange:(UITextView *)textView{
    NSString *string = self.tvAboutMe.text;
    if ([string length] > 140){
        self.tvAboutMe.text = [string substringWithRange:NSMakeRange(0, 140)];
        [self exceptionProcess:@"You can't input more than 140 letters"];
    }
}


////////// SwipeGesture Action Method /////////////////
- (void)swipeAction: (UISwipeGestureRecognizer *)sender{
    NSLog(@"Swipe action called");
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
        //Do Something
        NSLog(@"Left");
    }
    else if (sender.direction == UISwipeGestureRecognizerDirectionRight){
        NSLog(@"Right");
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)onChangeGender:(UISwitch *)sender {
    if (self.genderSwitch.on == true){
        gender = @"female";
    }else{
        gender = @"male";
    }
    if (!chosenImage){
        [self.btnAvatar setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_default.png",gender]] forState:UIControlStateNormal];
    }
}

- (IBAction)onCreate:(id)sender {
    
    if ([self.tfFirstName.text isEqualToString:@""] == true){
        [self exceptionProcess:@"First Name is not inputted"];
        return;
    }else if ([self validateUsername:_tfFirstName.text] == NO){
        return;
    }
    
    if ([self.tfLastName.text isEqualToString:@""] == true){
        [self exceptionProcess:@"Last Name is not inputted"];
        return;
    }else if ([self validateUsername:_tfLastName.text] == NO){
        return;
    }
    
    if ([self.tfEmailAdr.text isEqualToString:@""] == true){
        [self exceptionProcess:@"Email Address is not inputted"];
        return;
    }else if([self validateEmail:self.tfEmailAdr.text] == false){
        [self exceptionProcess:@"incorrect email"];
    }
    
    if ([self.tfUsername.text isEqualToString:@""] == true){
        [self exceptionProcess:@"Username is not inputted"];
        return;
    }else if ([self validateUsername:_tfUsername.text] == NO){
        return;
    }else if ([self.tfUsername.text length] > 30){
        [self exceptionProcess:@"Username length can not be larger than 30."];
        return;
    }
    
    if ([self.tfPassword.text isEqualToString:@""] == true){
        [self exceptionProcess:@"Password is not inputted"];
        return;
    }else if ([self.tfPassword.text length] < 6){
        [self exceptionProcess:@"Password must be a minimum of six characters."];
        return;
    }
    
    if ([self.tfConfirmPassword.text isEqualToString:@""] == true){
        [self exceptionProcess:@"Confirm Password is not inputted"];
        return;
    }else if ([self.tfConfirmPassword.text length] < 6){
        [self exceptionProcess:@"Password must be a minimum of six characters."];
        return;
    }
    
    if ([self.tfPassword.text isEqualToString:self.tfConfirmPassword.text] == false){
        [self exceptionProcess:@"Password is not matched"];
        return;
    }
    
    if ([self.tvAboutMe.text isEqualToString:@""] == true){
        [self exceptionProcess:@"About Me is not inputted"];
        return;
    }
    
    // signup using Parse
    PFUser *user = [PFUser user];
    user.username = [self.tfUsername.text lowercaseString];
    user.password = self.tfPassword.text;
    user.email = self.tfEmailAdr.text;
    user[PF_USER_USERNAME] = [self.tfUsername.text lowercaseString];
    user[PF_USER_FIRSTNAME] = self.tfFirstName.text;
    user[PF_USER_LASTNAME] = self.tfLastName.text;
    user[PF_USER_FULLNAME] = [NSString stringWithFormat:@"%@ %@",self.tfFirstName.text,self.tfLastName.text];
    user[PF_USER_ABOUT_ME] = self.tvAboutMe.text;
    user[PF_USER_GENDER] = gender;
    UIImage *tempImage;
    if (!chosenImage){
        tempImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_default.png",gender]];
    }else{
        tempImage = chosenImage;
    }
    [PFUser logOut];
    NSData *imgData = UIImageJPEGRepresentation(tempImage, 0.6);
    if (tempImage.size.width > 140) tempImage = ResizeImage(tempImage, 140, 140);
    PFFile *filePicture = [PFFile fileWithName:@"picture.jpg" data:imgData];
    [filePicture saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
     {
         
     }];
    //---------------------------------------------------------------------------------------------------------------------------------------------
    //---------------------------------------------------------------------------------------------------------------------------------------------
    
    //---------------------------------------------------------------------------------------------------------------------------------------------
    if (tempImage.size.width > 30) tempImage = ResizeImage(tempImage, 30, 30);
    //---------------------------------------------------------------------------------------------------------------------------------------------
    PFFile *fileThumbnail = [PFFile fileWithName:@"thumbnail.jpg" data:UIImageJPEGRepresentation(tempImage, 0.6)];
    [fileThumbnail saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
     {
         
     }];

//    NSData *imgData = UIImageJPEGRepresentation(tempImage, 0.5);
//    PFFile *PortfolioFile = [PFFile fileWithName:@"Portfolio" data:imgData];
    user[PF_USER_PICTURE] = filePicture;
    user[PF_USER_THUMBNAIL] = fileThumbnail;
    [user setObject:[PFGeoPoint geoPointWithLocation:[Global sharedInstance].location] forKey:PF_USER_GEOLOCATION];
    [[PFUser currentUser] saveInBackground];
    [[KIProgressViewManager manager] showProgressOnView:self.view];
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [[KIProgressViewManager manager] hideProgressView];
        if (succeeded) {

            NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
            [defs setValue:@"1" forKey:LOGGED_IN];
            [defs setValue:gender forKey:PF_USER_GENDER];
            [defs setValue:user[PF_USER_USERNAME] forKey:PF_USER_USERNAME];
            [defs setValue:user[PF_USER_PASSWORD] forKey:PF_USER_PASSWORD];
            [defs setValue:user[PF_USER_EMAIL] forKey:PF_USER_EMAIL];
            [defs setValue:user[PF_USER_FIRSTNAME] forKey:PF_USER_FIRSTNAME];
            [defs setValue:user[PF_USER_LASTNAME] forKey:PF_USER_LASTNAME];
            [defs setValue:user[PF_USER_ABOUT_ME] forKey:PF_USER_ABOUT_ME];
            [defs setValue:imgData forKey:PF_USER_PICTURE];
            
            [Global sharedInstance].username = user[PF_USER_USERNAME];
            [Global sharedInstance].password = user[PF_USER_PASSWORD];
            [Global sharedInstance].email = user[PF_USER_EMAIL];
            [Global sharedInstance].firstname = user[PF_USER_FIRSTNAME];
            [Global sharedInstance].lastname = user[PF_USER_LASTNAME];
            [Global sharedInstance].about_me = user[PF_USER_ABOUT_ME];
            [Global sharedInstance].portfloio = imgData;
            [Global sharedInstance].gender = gender;
            [defs synchronize];
            [self performSegueWithIdentifier:@"goChatRoom" sender:self];
        }else{
            [self exceptionProcess:@"Username already in use"];
            NSLog(@"%@",error);
        }
    }];
}


- (IBAction)onBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onChangeAvatar:(id)sender {
    UIActionSheet *sharingSheet = [[UIActionSheet alloc] initWithTitle:@"Profile Photo"
                                                              delegate:self
                                                     cancelButtonTitle:@"Cancel"
                                                destructiveButtonTitle:nil
                                                     otherButtonTitles:@"Take a Photo",
                                   @"Choose From Library", nil];
    [sharingSheet showInView:self.view];
}

#pragma mark - UIActionSheetDelegate Methods

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        UIDevice *currentDevice = [UIDevice currentDevice];
        
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:picker animated:YES completion:NULL];
        while ([currentDevice isGeneratingDeviceOrientationNotifications])
            [currentDevice endGeneratingDeviceOrientationNotifications];
    }
    else if (buttonIndex == 1)
    {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }
}

#pragma mark - Image Picker Controller delegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
//    chosenImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    [self.btnAvatar setBackgroundImage:chosenImage forState:UIControlStateNormal];
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (BOOL) validateUsername:(NSString *)str{
    
    NSRange whiteSpaceRange = [str rangeOfCharacterFromSet:[NSCharacterSet whitespaceCharacterSet]];
    NSCharacterSet * set = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ0123456789_"] invertedSet];
    
    if ((whiteSpaceRange.location != NSNotFound) ||([str rangeOfCharacterFromSet:set].location != NSNotFound))
    {
        NSLog(@"Found Whitespace");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Username must contain only letters, numbers, periods or underscores." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        return NO;
    }
    return YES;
}

#pragma mark: E-mail Validation

-(BOOL)validateEmail:(NSString*)email
{
    if( (0 != [email rangeOfString:@"@"].length) &&  (0 != [email rangeOfString:@"."].length) )
    {
        NSMutableCharacterSet *invalidCharSet = [[[NSCharacterSet alphanumericCharacterSet] invertedSet]mutableCopy];
        [invalidCharSet removeCharactersInString:@"_-"];
        
        NSRange range1 = [email rangeOfString:@"@" options:NSCaseInsensitiveSearch];
        
        // If username part contains any character other than "."  "_" "-"
        NSString *usernamePart = [email substringToIndex:range1.location];
        NSArray *stringsArray1 = [usernamePart componentsSeparatedByString:@"."];
        for (NSString *string in stringsArray1)
        {
            NSRange rangeOfInavlidChars=[string rangeOfCharacterFromSet: invalidCharSet];
            if(rangeOfInavlidChars.length !=0 || [string isEqualToString:@""])
                return NO;
        }
        
        NSString *domainPart = [email substringFromIndex:range1.location+1];
        NSArray *stringsArray2 = [domainPart componentsSeparatedByString:@"."];
        
        for (NSString *string in stringsArray2)
        {
            NSRange rangeOfInavlidChars=[string rangeOfCharacterFromSet:invalidCharSet];
            if(rangeOfInavlidChars.length !=0 || [string isEqualToString:@""])
                return NO;
        }
        return YES;
    }
    else
        return NO;
}

- (void) exceptionProcess:(NSString *)msg{
    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:APP_NAME message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertview show];
}

@end
