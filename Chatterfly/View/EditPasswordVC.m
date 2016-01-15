//
//  EditPasswordVC.m
//  Chatterfly
//
//  Created by PJ95 on 6/10/15.
//  Copyright (c) 2015 PJ95. All rights reserved.
//

#import "EditPasswordVC.h"

@implementation EditPasswordVC

- (void) viewDidLoad{
    UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeAction:)];
    leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    
    UISwipeGestureRecognizer *rightSwipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeAction:)];
    rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:rightSwipe];
    [self.view addGestureRecognizer:leftSwipe];
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

- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
}

- (IBAction)onUpdatePassword:(id)sender {
    NSLog(@"%@",[PFUser currentUser]);
    if ([_tfOldPassword.text isEqualToString:[Global sharedInstance].password] == true){
        if ([self.tfNewPassword.text isEqualToString:@""] == true){
            [self exceptionProcess:@"Password is not inputted"];
            return;
        }
        
        if ([self.tfConfirmPassword.text isEqualToString:@""] == true){
            [self exceptionProcess:@"Confirm Password is not inputted"];
            return;
        }
        
        if ([self.tfNewPassword.text isEqualToString:self.tfConfirmPassword.text] == false){
            [self exceptionProcess:@"Password is not matched"];
            return;
        }
        [PFUser currentUser].password = self.tfNewPassword.text;
        [[KIProgressViewManager manager] showProgressOnView:self.view];
        [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [[KIProgressViewManager manager] hideProgressView];
            if (succeeded){
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }else{
        [self exceptionProcess:@"Old Password wrong!"];
    }
}

- (void) exceptionProcess:(NSString *)msg{
    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:APP_NAME message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertview show];
}
@end
