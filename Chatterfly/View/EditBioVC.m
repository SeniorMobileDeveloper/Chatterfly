//
//  EditBioVC.m
//  Chatterfly
//
//  Created by PJ95 on 6/10/15.
//  Copyright (c) 2015 PJ95. All rights reserved.
//

#import "EditBioVC.h"

@implementation EditBioVC

- (void) viewDidLoad{
    self.title = @"Edit Bio";
    self.tvAboutMe.text = [Global sharedInstance].about_me;
    UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeAction:)];
    leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    
    UISwipeGestureRecognizer *rightSwipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeAction:)];
    rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:rightSwipe];
    [self.view addGestureRecognizer:leftSwipe];
}

- (void) viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
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

- (void) exceptionProcess:(NSString *)msg{
    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:APP_NAME message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertview show];
}

- (IBAction)onUpdateBio:(id)sender {
    PFUser *user = [PFUser currentUser];
    user[PF_USER_ABOUT_ME] = self.tvAboutMe.text;
    [[KIProgressViewManager manager] showProgressOnView:self.view];
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [[KIProgressViewManager manager] hideProgressView];
        if (succeeded){
            [self exceptionProcess:@"Update Success!"];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

@end
