//
//  reportVC.m
//  Chatterfly
//
//  Created by PJ95 on 6/16/15.
//  Copyright (c) 2015 PJ95. All rights reserved.
//

#import "reportVC.h"
#import "Public.h"
@implementation reportVC

- (void) viewDidLoad{
    self.tvFeedback.delegate = self;
}

- (void) viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
    _lblTitle1.text = self.title;
    if ([self.title isEqualToString:@"Report"]){
        _lblTitle.text = @"Report";
        _lblContents.text = @"Why are you reporting this user?";
    }else{
        _lblTitle.text = @"GENERAL FEEDBACK";
        _lblContents.text = @"Briefly explain what you love, or what could improve.";
    }
}

- (IBAction)onCancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onSave:(id)sender {
    NSString *message;
    if ([self.title isEqualToString:@"Report"]){
        message = @"Do you want to report?";
    }else{
        message = @"Do you want to send feedback?";
    }
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:APP_NAME message:message  delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:@"Cancel", nil];
    [alertView showWithCompletion:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == 0){
            Mailgun *gun = [Mailgun clientWithDomain:@"sandbox1e3c0d9962d94cf9baef0b56104c98ac.mailgun.org" apiKey:@"key-08c74cada35a25d8d7d52825efb2b1c3"];
            //    Mailgun *gun = [Mailgun clientWithDomain:@"sandbox797786ea2238465fb5462e03314c0e3f.mailgun.org" apiKey:@"key-3b4534bfd039456869195a6332b21ad4"];
            NSString *mail = _user.email;
            MGMessage *message = [MGMessage messageFrom:mail to:@"v_shahoian@hotmail.com" subject:self.title body:_tvFeedback.text];
            [gun sendMessage:message success:^(NSString *messageId) {
                NSLog(@"Message %@ sent successfully!", messageId);
                [self.navigationController popViewControllerAnimated:YES];
            } failure:^(NSError *error) {
                NSLog(@"Error sending message. The error was : %@ !", [error userInfo]);
            }];
//            NSDictionary *dict = [[NSMutableDictionary alloc] init];
//            [dict setValue:[NSString stringWithFormat:@"%@ from Chatterfly",self.title] forKey:PF_MAIL_TITLE];
//            [dict setValue:_tvFeedback.text forKey:PF_MAIL_MESSAGE];
//            [dict setValue:_user.email forKey:PF_MAIL_FROM_USER];
//            [dict setValue:self.title forKey:PF_MAIL_TYPE];
//            [[KIProgressViewManager manager] showProgressOnView:self.view];
//            [PFCloud callFunctionInBackground:@"sendEmail"
//                               withParameters:dict
//                                        block:^(NSString *result, NSError *error) {
//                                            if (!error) {
//                                                NSLog(@"%@",result);
//                                                [self.navigationController popViewControllerAnimated:YES];
//                                            }
//                                        }];
        }
    }];
}

@end
