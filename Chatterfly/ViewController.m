//
//  ViewController.m
//  Restarant
//
//  Created by PJ95 on 5/28/15.
//  Copyright (c) 2015 PJ95. All rights reserved.
//

#import "ViewController.h"
#import "Public.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.btnLogin.layer.cornerRadius = 8;
    
    _btnSignup.layer.cornerRadius = 8;
    
    _btnSignup.layer.masksToBounds = YES;
    
    _btnLogin.layer.masksToBounds = YES;
    
    _btnFB.layer.cornerRadius = 8;
    
    _btnFB.layer.masksToBounds = YES;
    
    _tfUsername.autocorrectionType = UITextAutocorrectionTypeNo;
    
}

- (BOOL) prefersStatusBarHidden{
    return YES;
}

- (void) viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
    
//    if ([Global sharedInstance].isLoggedIn == true){
//        [self performSegueWithIdentifier:@"goChatRoom" sender:self];
//        return;
//    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}


- (IBAction)onLogin:(id)sender {
    if ([self.tfUsername.text isEqualToString:@""] == true){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:APP_NAME message:@"Username not entered!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    if ([self.tfPw.text isEqualToString:@""] == true){
        UIAlertView *alertView1 = [[UIAlertView alloc] initWithTitle:APP_NAME message:@"Password not entered!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView1 show];
        return;
    }
    [[KIProgressViewManager manager] showProgressOnView:self.view];
    [PFUser logInWithUsernameInBackground:[self.tfUsername.text lowercaseString] password:self.tfPw.text block:^(PFUser *user, NSError *error) {
        [[KIProgressViewManager manager] hideProgressView];
        if (user){
            NSLog(@"User : %@",user);
            user[PF_USER_ONLINE_STATUS] = @"Online";
            [user saveInBackground];
            NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
            [defs setValue:@"1" forKey:LOGGED_IN];
            [defs synchronize];
            
        
            ParsePushUserAssign();
            
            [Global sharedInstance].username = user[PF_USER_USERNAME];
            [Global sharedInstance].gender = user[PF_USER_GENDER];
            [Global sharedInstance].password = _tfPw.text;
            [Global sharedInstance].email = user[PF_USER_EMAIL];
            [Global sharedInstance].firstname = user[PF_USER_FIRSTNAME];
            [Global sharedInstance].lastname = user[PF_USER_LASTNAME];
            [Global sharedInstance].about_me = user[PF_USER_ABOUT_ME];
            [self performSegueWithIdentifier:@"goChatRoom" sender:self];
            PFFile *imgFile = user[PF_USER_PICTURE];
            [imgFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                [Global sharedInstance].portfloio = data;
                NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
                [defs setValue:@"1" forKey:LOGGED_IN];
                [defs setValue:user[PF_USER_USERNAME] forKey:PF_USER_USERNAME];
                [defs setValue:_tfPw.text forKey:PF_USER_PASSWORD];
                [defs setValue:user[PF_USER_EMAIL] forKey:PF_USER_EMAIL];
                [defs setValue:user[PF_USER_FIRSTNAME] forKey:PF_USER_FIRSTNAME];
                [defs setValue:user[PF_USER_LASTNAME] forKey:PF_USER_LASTNAME];
                [defs setValue:user[PF_USER_ABOUT_ME] forKey:PF_USER_ABOUT_ME];
                [defs setValue:user[PF_USER_GENDER] forKey:PF_USER_GENDER];
                [defs setValue:[Global sharedInstance].portfloio forKey:PF_USER_PICTURE];
                [defs synchronize];
            }];
//            NSDictionary *dict = [[NSMutableDictionary alloc] init];
//            [dict setValue:@"MailGun First Test" forKey:PF_MAIL_TITLE];
//            [dict setValue:@"ksjgksdjgklsjdlkgj" forKey:PF_MAIL_MESSAGE];
//            [dict setValue:@"f@f.com" forKey:PF_MAIL_FROM_USER];
//            [dict setValue:@"feedback" forKey:PF_MAIL_TYPE];
//            [PFCloud callFunctionInBackground:@"sendEmail"
//                               withParameters:dict
//                                        block:^(NSString *result, NSError *error) {
//                                            if (!error) {
//                                                NSLog(@"%@",result);
//                                            }
//                                        }];
            
        }
        else{
            UIAlertView *alertView1 = [[UIAlertView alloc] initWithTitle:APP_NAME message:@"Login Failure!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView1 show];
        }
    }];
}

- (IBAction)onSignup:(id)sender {
    
}

- (IBAction)onLoginFacebook:(id)sender {
    //Login PFUser using Facebook
    [[KIProgressViewManager manager] showProgressOnView:self.view];
    [PFFacebookUtils logInWithPermissions:@[@"public_profile", @"email"] block:^(PFUser *user, NSError *error)
     {
         if (user != nil)
         {
             NSLog(@"%@",user);
             if (user[PF_USER_FACEBOOKID] == nil)
             {
                 [self requestFacebook:user];
             }
             //             //else [self userLoggedIn:user];
             else{
                 // user login
                 user[PF_USER_ONLINE_STATUS] = @"Online";
                 [user saveInBackground];
                 ParsePushUserAssign();
                 [[KIProgressViewManager manager] hideProgressView];
                 NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
                 [Global sharedInstance].username = [defs objectForKey:PF_USER_USERNAME];
                 [Global sharedInstance].password = [defs objectForKey:PF_USER_PASSWORD];
                 [Global sharedInstance].email = [defs objectForKey:PF_USER_EMAIL];
                 [Global sharedInstance].firstname = [defs objectForKey:PF_USER_FIRSTNAME];
                 [Global sharedInstance].lastname = [defs objectForKey:PF_USER_LASTNAME];
                 [Global sharedInstance].about_me = [defs objectForKey:PF_USER_ABOUT_ME];
                 [Global sharedInstance].portfloio = [defs objectForKey:PF_USER_PICTURE];
                 [Global sharedInstance].gender = [defs objectForKey:PF_USER_PICTURE];
                 [defs setObject:@"1" forKey:LOGGED_IN];
                 [self performSegueWithIdentifier:@"goChatRoom" sender:self];
             }
         }
         else{
             NSLog(@"ERROR : %@",error);
             [[KIProgressViewManager manager] hideProgressView];
         }
     }];
}

- (void)requestFacebook:(PFUser *)user
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    FBRequest *request = [FBRequest requestForMe];
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error)
     {
         if (error == nil)
         {
             NSDictionary *userData = (NSDictionary *)result;
             NSLog(@"%@",userData);
//             [self processFacebook:user UserData:userData];
         }
         else
         {
             [PFUser logOut];
             [[KIProgressViewManager manager] hideProgressView];
         }
     }];
}

//- (void)processFacebook:(PFUser *)user UserData:(NSDictionary *)userData
////-------------------------------------------------------------------------------------------------------------------------------------------------
//{
//    NSString *link = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large", userData[@"id"]];
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:link]];
//    //---------------------------------------------------------------------------------------------------------------------------------------------
//    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//    operation.responseSerializer = [AFImageResponseSerializer serializer];
//    //---------------------------------------------------------------------------------------------------------------------------------------------
//    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
//     {
//         UIImage *image = (UIImage *)responseObject;
//         //-----------------------------------------------------------------------------------------------------------------------------------------
//         //         if (image.size.width > 140) image = ResizeImage(image, 140, 140);
//         //-----------------------------------------------------------------------------------------------------------------------------------------
//         PFFile *filePicture = [PFFile fileWithName:@"picture.jpg" data:UIImageJPEGRepresentation(image, 0.6)];
//         [filePicture saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
//          {
//              if (error != nil) [[KIProgressViewManager manager] hideProgressView];
//          }];
//         //-----------------------------------------------------------------------------------------------------------------------------------------
//         // if (image.size.width > 30) image = ResizeImage(image, 30, 30);
//         //-----------------------------------------------------------------------------------------------------------------------------------------
//         PFFile *fileThumbnail = [PFFile fileWithName:@"thumbnail.jpg" data:UIImageJPEGRepresentation(image, 0.6)];
//         [fileThumbnail saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
//          {
//              if (error != nil) [[KIProgressViewManager manager] hideProgressView];
//          }];
//         //self.pic.image = image;
//         //-----------------------------------------------------------------------------------------------------------------------------------------
//         user[PF_USER_EMAIL] = userData[@"email"];
//         user[PF_USER_FULLNAME] = userData[@"name"];
//         user[PF_USER_FULLNAME_LOWER] = [userData[@"name"] lowercaseString];
//         user[PF_USER_FACEBOOKID] = userData[@"id"];
//         user[PF_USER_PICTURE] = filePicture;
//         user[PF_USER_FIRSTNAME] = userData[@"first_name"];
//         user[PF_USER_LASTNAME] = userData[@"last_name"];
//         user[PF_USER_FACEBOOKID] = userData[@"id"];
//         user[PF_USER_GENDER] = userData[PF_USER_GENDER];
//         
//         //         user[PF_USER_THUMBNAIL] = fileThumbnail;
//         
//         [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
//          {
//              if (error == nil)
//              {
//                  ParsePushUserAssign();
//                  [Global sharedInstance].username = user[PF_USER_USERNAME];
//                  [Global sharedInstance].password = user[PF_USER_PASSWORD];
//                  [Global sharedInstance].email = user[PF_USER_EMAIL];
//                  [Global sharedInstance].firstname = user[PF_USER_FIRSTNAME];
//                  [Global sharedInstance].lastname = user[PF_USER_LASTNAME];
//                  [Global sharedInstance].about_me = user[PF_USER_ABOUT_ME];
//                  [Global sharedInstance].portfloio = UIImageJPEGRepresentation(image, 0.6);
//                  NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
//                  [defs setValue:@"1" forKey:LOGGED_IN];
//                  [defs setValue:user[PF_USER_USERNAME] forKey:PF_USER_USERNAME];
//                  [defs setValue:user[PF_USER_EMAIL] forKey:PF_USER_EMAIL];
//                  [defs setValue:user[PF_USER_FIRSTNAME] forKey:PF_USER_FIRSTNAME];
//                  [defs setValue:user[PF_USER_LASTNAME] forKey:PF_USER_LASTNAME];
//                  [defs setValue:user[PF_USER_ABOUT_ME] forKey:PF_USER_ABOUT_ME];
//                  [defs setValue:[Global sharedInstance].portfloio forKey:PF_USER_PICTURE];
//                  [defs synchronize];
//                  [[KIProgressViewManager manager] hideProgressView];
//                  user[PF_USER_ONLINE_STATUS] = @"Online";
//                  [user saveInBackground];
//                  [self performSegueWithIdentifier:@"goChatRoom" sender:self];
//              }
//              else
//              {
//                  [PFUser logOut];
//                  [[KIProgressViewManager manager] hideProgressView];
//              }
//          }];
//         [[NSNotificationCenter defaultCenter] postNotificationName:@"onGoNext" object:self];
//     }
//                                     failure:^(AFHTTPRequestOperation *operation, NSError *error)
//     {
//         [PFUser logOut];
//         [[KIProgressViewManager manager] hideProgressView];
//     }];
//    //---------------------------------------------------------------------------------------------------------------------------------------------
//    [[NSOperationQueue mainQueue] addOperation:operation];
//}

@end
