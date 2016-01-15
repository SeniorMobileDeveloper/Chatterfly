//
//  detailUserVC.m
//  Chatterfly
//
//  Created by PJ95 on 6/19/15.
//  Copyright (c) 2015 PJ95. All rights reserved.
//

#import "detailUserVC.h"
#import <UIKit/UIKit.h>

@implementation detailUserVC

- (void) viewDidLoad{
    [_profileImg setImageWithURL:[_user[PF_USER_PICTURE] url] placeholderImage:[UIImage imageNamed:@"placeholder_gb.png"]];
    _profileImg.layer.cornerRadius =_profileImg.frame.size.width / 2;
    _profileImg.layer.masksToBounds = YES;

    _lblFullName.text = _user[PF_USER_FULLNAME];
    _tvBio.text = _user[PF_USER_ABOUT_ME];
    isFriend = [self isMyFriend:_user];
    if (isFriend){
        [_btnAddFriend setTitle:@"Remove Friend" forState:UIControlStateNormal];
    }else{
        [_btnAddFriend setTitle:@"Add Friend" forState:UIControlStateNormal];
    }
    
    isBlocked = [self isBlockedUser:_user];
    if (isBlocked) {
        [_btnBlockUser setTitle:@"Unblock User" forState:UIControlStateNormal];
    }else{
        [_btnBlockUser setTitle:@"Block User" forState:UIControlStateNormal];
    }
    
    _btnAddFriend.layer.borderColor = [UIColor grayColor].CGColor;
    _btnAddFriend.layer.borderWidth = 1.0;
    _btnBlockUser.layer.borderColor = [UIColor grayColor].CGColor;
    _btnBlockUser.layer.borderWidth = 1.0;
    _btnReportUser.layer.borderColor = [UIColor grayColor].CGColor;
    _btnReportUser.layer.borderWidth = 1.0;
    [self.photos removeAllObjects];
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    PFFile *profileImage = _user[PF_USER_PICTURE];
    [profileImage getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        MWPhoto *photo = [MWPhoto photoWithImage:[UIImage imageWithData:imageData]];
        [photos addObject:photo];
    }];
    self.photos = photos;
    
    self.swipeGesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(gestureFired:)];
    [self.view addGestureRecognizer:self.swipeGesture];
    
}

-(void)gestureFired:(UISwipeGestureRecognizer *)gesture
{
    if (gesture.direction == UISwipeGestureRecognizerDirectionRight)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (void) viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
    UIView * navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    [navView setBackgroundColor:[UIColor colorWithRed:248.0/255.0f green:248.0/255.0f blue:248.0/255.0f alpha:1]];
    
    UIImageView * imagView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 1)];
    [imagView setBackgroundColor:[UIColor colorWithRed:186.0/255.0f green:186.0/255.0f blue:186.0/255.0f alpha:1]];
    [navView addSubview:imagView];
    
    UIButton * backBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 25, 20, 20)];
    [backBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(returnBack) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"bg_back copy"] forState:UIControlStateNormal];
    
    [navView addSubview:backBtn];
    
    [self.view addSubview:navView];
}

- (void)returnBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL) isMyFriend:(PFUser *)user{
    NSArray *friendsArray = [PFUser currentUser][PF_USER_FRIENDS];
    NSPredicate* p = [NSPredicate predicateWithFormat:@"SELF contains[cd] %@", _user.objectId];
    NSArray *friendList = [friendsArray filteredArrayUsingPredicate:p];
    if ([friendList count] > 0){
        return YES;
    }
    return NO;
}

- (BOOL) isBlockedUser:(PFUser *)user{
    NSArray *blockedArray = [PFUser currentUser][PF_USER_BLOCKS];
    NSPredicate* p = [NSPredicate predicateWithFormat:@"SELF contains[cd] %@", _user.objectId];
    NSArray *blockedList = [blockedArray filteredArrayUsingPredicate:p];
    if ([blockedList count] > 0){
        return YES;
    }
    return NO;
}

- (IBAction)onAddFriend:(id)sender {

    if (![self isMyFriend:_user]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:APP_NAME message:@"Do you want to add this user?"  delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:@"Cancel", nil];
        [alertView showWithCompletion:^(UIAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex == 0){
                NSMutableArray *friendsArray =[NSMutableArray arrayWithArray:[PFUser currentUser][PF_USER_FRIENDS]];
                [friendsArray addObject:_user.objectId];
                [PFUser currentUser][PF_USER_FRIENDS] = [NSArray arrayWithArray:friendsArray];
                [[PFUser currentUser] saveInBackground];
                [_btnAddFriend setTitle:@"Remove Friend" forState:UIControlStateNormal];
            }
        }];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:APP_NAME message:@"Do you want to remove this friend?"  delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:@"Cancel", nil];
        [alertView showWithCompletion:^(UIAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex == 0){
                NSMutableArray *friendsArray =[NSMutableArray arrayWithArray:[PFUser currentUser][PF_USER_FRIENDS]];
                [friendsArray removeObject:_user.objectId];
                [PFUser currentUser][PF_USER_FRIENDS] = [NSArray arrayWithArray:friendsArray];
                [[PFUser currentUser] saveInBackground];
                [_btnAddFriend setTitle:@"Add Friend" forState:UIControlStateNormal];
            }
        }];
    }
}

- (IBAction)onBlockUser:(id)sender {
    
    if (![self isBlockedUser:_user]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:APP_NAME message:@"Do you want to block this user?"  delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:@"Cancel", nil];
        [alertView showWithCompletion:^(UIAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex == 0){
                NSMutableArray *blockedArray =[NSMutableArray arrayWithArray:[PFUser currentUser][PF_USER_BLOCKS]];
                [blockedArray addObject:_user.objectId];
                [PFUser currentUser][PF_USER_BLOCKS] = [NSArray arrayWithArray:blockedArray];
                [[PFUser currentUser] saveInBackground];
                [_btnBlockUser setTitle:@"Unblock User" forState:UIControlStateNormal];
            }
        }];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:APP_NAME message:@"Do you want to unblock this user?"  delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:@"Cancel", nil];
        [alertView showWithCompletion:^(UIAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex == 0){
                NSMutableArray *blockedArray =[NSMutableArray arrayWithArray:[PFUser currentUser][PF_USER_BLOCKS]];
                [blockedArray removeObject:_user.objectId];
                [PFUser currentUser][PF_USER_BLOCKS] = [NSArray arrayWithArray:blockedArray];
                [[PFUser currentUser] saveInBackground];
                [_btnBlockUser setTitle:@"Block User" forState:UIControlStateNormal];
            }
        }];
    }
}

- (IBAction)onReportUser:(id)sender {
    reportVC *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"reportVC"];
    vc.user = _user;
    vc.title = @"Report";
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)onImageDetail:(id)sender {
    
    BOOL displayActionButton = NO;
    BOOL displaySelectionButtons = NO;
    BOOL displayNavArrows = YES;
    BOOL enableGrid = NO;
    BOOL startOnGrid = NO;
    
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = displayActionButton;
    browser.displayNavArrows = displayNavArrows;
    browser.displaySelectionButtons = displaySelectionButtons;
    browser.alwaysShowControls = displaySelectionButtons;
    browser.zoomPhotosToFill = YES;
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
    browser.wantsFullScreenLayout = YES;
#endif
    browser.enableGrid = enableGrid;
    browser.startOnGrid = startOnGrid;
    browser.enableSwipeToDismiss = YES;
    browser.enableSwipeNextPrev = YES;
    browser.enableDeleteBtn = NO;
    [browser setCurrentPhotoIndex:0];
    
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:browser];
    nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:nc animated:YES completion:nil];
    
    
    double delayInSeconds = 3;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
    });

}
#pragma mark - MWPhotoBrowserDelegate

- (void)photoBrowserDidFinishModalPresentation:(MWPhotoBrowser *)photoBrowser {
    // If we subscribe to this method we must dismiss the view controller ourselves
    NSLog(@"Did finish modal presentation");
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _photos.count)
        return [_photos objectAtIndex:index];
    return nil;
}

@end
