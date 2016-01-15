//
//  forgotPasswordVC.m
//  Chatterfly
//
//  Created by PJ95 on 6/8/15.
//  Copyright (c) 2015 PJ95. All rights reserved.
//

#import "forgotPasswordVC.h"

@implementation forgotPasswordVC

- (void) viewDidLoad{
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

- (void) viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
}

- (IBAction)onBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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

- (IBAction)onRetrivePassword:(id)sender {
    [[KIProgressViewManager manager] showProgressOnView:self.view];
    [PFUser requestPasswordResetForEmailInBackground:_tfEmail.text block:^(BOOL succeeded, NSError *error) {
        [[KIProgressViewManager manager] hideProgressView];
        if (succeeded){
            UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:APP_NAME message:@"Please check out your mailbox" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertview show];
        }
    }];
}

@end
