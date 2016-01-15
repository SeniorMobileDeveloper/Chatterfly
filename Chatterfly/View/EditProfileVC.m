//
//  EditProfileVC.m
//  Chatterfly
//
//  Created by PJ95 on 6/10/15.
//  Copyright (c) 2015 PJ95. All rights reserved.
//

#import "EditProfileVC.h"

@implementation EditProfileVC

- (void) viewDidLoad{
    UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeAction:)];
    leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    
    UISwipeGestureRecognizer *rightSwipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeAction:)];
    rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:rightSwipe];
    [self.view addGestureRecognizer:leftSwipe];
    
    self.tfFirstName.text = [Global sharedInstance].firstname;
    self.tfLastName.text = [Global sharedInstance].lastname;
    self.tfUsername.text = [Global sharedInstance].username;
    self.tfEmailAdr.text = [Global sharedInstance].email;
    chosenImage = [UIImage imageWithData:[Global sharedInstance].portfloio];
    [self.btnPortfolio setBackgroundImage:[UIImage imageWithData:[Global sharedInstance].portfloio] forState:UIControlStateNormal];
    
    self.btnPortfolio.layer.cornerRadius = self.btnPortfolio.frame.size.width / 2;
    self.btnPortfolio.layer.borderWidth = 3.0f;
    self.btnPortfolio.layer.borderColor = [UIColor whiteColor].CGColor;
    self.btnPortfolio.clipsToBounds = YES;
}

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

- (BOOL) prefersStatusBarHidden{
    return YES;
}

- (void) viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
}

- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) exceptionProcess:(NSString *)msg{
    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:APP_NAME message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertview show];
}

- (IBAction)onUpdateProfile:(id)sender {
    if ([self.tfFirstName.text isEqualToString:@""] == true){
        [self exceptionProcess:@"First Name is not inputted"];
        return;
    }
    
    if ([self.tfLastName.text isEqualToString:@""] == true){
        [self exceptionProcess:@"Last Name is not inputted"];
        return;
    }
    
    if ([self.tfEmailAdr.text isEqualToString:@""] == true){
        [self exceptionProcess:@"Email Address is not inputted"];
        return;
    }else if([self validateEmail:self.tfEmailAdr.text] == false){
        [self exceptionProcess:@"Email address is not valid"];
    }
    
    if ([self.tfUsername.text isEqualToString:@""] == true){
        [self exceptionProcess:@"Username is not inputted"];
        return;
    }
    
    // signup using Parse
    PFUser *user = [PFUser currentUser];
    user.username = self.tfUsername.text;
    user.email = self.tfEmailAdr.text;
    user[PF_USER_USERNAME] = self.tfUsername.text;
    user[PF_USER_FIRSTNAME] = self.tfFirstName.text;
    user[PF_USER_LASTNAME] = self.tfLastName.text;
    user[PF_USER_EMAIL] = self.tfEmailAdr.text;
    user[PF_USER_FULLNAME] = [NSString stringWithFormat:@"%@ %@",self.tfFirstName.text,self.tfLastName.text];
//    [PFUser logOut];
    NSData *imgData = UIImageJPEGRepresentation(chosenImage, 0.5);
    PFFile *PortfolioFile = [PFFile fileWithName:@"Portfolio" data:imgData];
    user[PF_USER_PICTURE] = PortfolioFile;
    user[PF_USER_THUMBNAIL] = PortfolioFile;
    
    [[KIProgressViewManager manager] showProgressOnView:self.view];
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [[KIProgressViewManager manager] hideProgressView];
        if (succeeded) {
            
            NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
            [defs setValue:@"1" forKey:LOGGED_IN];
            [defs setValue:user[PF_USER_USERNAME] forKey:PF_USER_USERNAME];
            [defs setValue:user[PF_USER_EMAIL] forKey:PF_USER_EMAIL];
            [defs setValue:user[PF_USER_FIRSTNAME] forKey:PF_USER_FIRSTNAME];
            [defs setValue:user[PF_USER_LASTNAME] forKey:PF_USER_LASTNAME];
            [defs setValue:imgData forKey:PF_USER_PICTURE];
            
            [Global sharedInstance].username = user[PF_USER_USERNAME];
            [Global sharedInstance].email = user[PF_USER_EMAIL];
            [Global sharedInstance].firstname = user[PF_USER_FIRSTNAME];
            [Global sharedInstance].lastname = user[PF_USER_LASTNAME];
            [Global sharedInstance].portfloio = imgData;
            [defs synchronize];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self exceptionProcess:@"Update Failure"];
        }
    }];

}

- (IBAction)onUpdatePortfolio:(id)sender {
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

#pragma mark - Image Picker Controller delegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    chosenImage = info[UIImagePickerControllerEditedImage];

    [self.btnPortfolio setBackgroundImage:chosenImage forState:UIControlStateNormal];
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

-(void)Dropdown: (id)sender:(NSMutableArray *) Array: (float) height{
    if(dropDown == nil) {
        CGFloat f = height;
        dropDown = [[NIDropDown alloc]showDropDown:sender :&f :Array :nil :@"up"];
        dropDown.delegate = self;
    }
    else {
        [dropDown hideDropDown:sender];
        [self rel];
    }
}

- (void) niDropDownDelegateMethod: (NIDropDown *) sender {
    [Global sharedInstance].distance = [sender.text floatValue];
    [self rel];
}

-(void)rel{
    //    [dropDown release];
    dropDown = nil;
}

- (IBAction)onChangeDistance:(id)sender {
    NSMutableArray * arr = [[NSMutableArray alloc] init];
    arr = [NSMutableArray arrayWithObjects:@"0.5",@"1",@"1.5",@"2",@"2.5",@"3",@"3.5",@"4",@"4.5",@"5", nil];
    [self Dropdown:sender:arr:180];
}


@end
