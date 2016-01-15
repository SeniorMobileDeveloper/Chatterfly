//
//  avartarVC.m
//  Chatterfly
//
//  Created by PJ95 on 6/10/15.
//  Copyright (c) 2015 PJ95. All rights reserved.
//

#import "avartarVC.h"
#import "ViewController.h"

@implementation avartarVC
# pragma mark - View

- (void) viewDidLoad{
    
    [self initVariable];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onTouchBegin) name:@"touchBegin" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onTouchEnd) name:@"touchEnd" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onTouchMove) name:@"touchMove" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onTouchTap) name:@"touchTap" object:nil];
    UIPinchGestureRecognizer *twoFingerPinch = [[UIPinchGestureRecognizer alloc]
                                                initWithTarget:self
                                                action:@selector(twoFingerPinch:)];
    
    [self.mainView addGestureRecognizer:twoFingerPinch];
    
    tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    
//    [self.mainView addGestureRecognizer:gesture];
    
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.mainView];
    self.collisionBehavior = [[UICollisionBehavior alloc] initWithItems:nil];
    self.collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    self.collisionBehavior.collisionMode = UICollisionBehaviorModeEverything;
    self.collisionBehavior.collisionDelegate = self;
    
    self.itembehavior = [[UIDynamicItemBehavior alloc] initWithItems:nil];
    self.itembehavior.elasticity = 1.0;
    self.itembehavior.friction = 0.5;
    self.itembehavior.resistance = 0.5;
    self.itembehavior.allowsRotation = NO;
    
    [self.animator addBehavior:self.collisionBehavior];
    [self.animator addBehavior:self.itembehavior];
    
    self.mainViewHeight = self.mainView.frame.size.height;
    self.mainViewWidth = self.mainView.frame.size.width;
    self.mainViewOrgX = self.mainView.frame.origin.x;
    self.mainviewOrgY = self.mainView.frame.origin.y;
    
    // Do any additional setup after loading the view.
    previousScale = 1.0f;
    
    [self displayUsers];
    
    self.messageField.delegate = self;
    self.recommendationView.hidden = YES;
    self.detailView.hidden = YES;
    
    if ([Global sharedInstance].showPopupOfChatRoom == true){
        [Global sharedInstance].showPopupOfChatRoom = false;
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:APP_NAME message:@"To chat with someone, tap their dot." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

- (void) hideKeyboard{
    [self.view endEditing:NO];
}

- (void) viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    PFUser *user = [PFUser currentUser];
    user[PF_USER_GROUP_ID] = [NSString stringWithFormat:@"%ld",(long)[Global sharedInstance].dragViewIndex];
    [user saveInBackground];
}
- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onMenu:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Menu" message:@"" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"My Profile",@"Feedback",@"Find Users", @"Chatterfly Radius", @"Sign Out",@"Cancel", nil];
    
    [alertView showWithCompletion:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == 0){
            //My Profile
            EditProfileVC *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"EditProfileVC"];
            [self.navigationController pushViewController:vc animated:YES];
        }else if (buttonIndex == 1){
            reportVC *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"reportVC"];
            vc.title = @"FEEDBACK";
            vc.user = [PFUser currentUser];
            [self.navigationController pushViewController:vc animated:YES];
        }else if(buttonIndex == 2){
            
            SearchVC *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"searchUser"];
            [self.navigationController pushViewController:vc animated:YES];
            
        }else if(buttonIndex == 3){
            
            SearchLocationVC *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"searchLocation"];
            [self.navigationController pushViewController:vc animated:YES];
            
            
        }else if (buttonIndex == 4){
            //Sign out
            UIAlertView *signoutAlert = [[UIAlertView alloc] initWithTitle:APP_NAME message:@"Do you want to sign out?" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
            [signoutAlert showWithCompletion:^(UIAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex == 0){
                    
                    PFUser *user = [PFUser currentUser];
                    user[PF_USER_ONLINE_STATUS] = @"Offline";
                    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if (succeeded){
                            [PFUser logOut];
                            NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
                            [defs setValue:@"0" forKey:LOGGED_IN];
                            [defs synchronize];
                            
                        }
                    }];
                    
                    NSArray *viewControllers = [[self navigationController] viewControllers];
                    for( int i=0;i<[viewControllers count];i++){
                        id obj=[viewControllers objectAtIndex:i];
                        if([obj isKindOfClass:[ViewController class]]){
                            [[self navigationController] popToViewController:obj animated:YES];
                            break;
                        }
                    }
                    [[AppDelegate delegate].window makeKeyAndVisible];
                    
                }else{
                    
                }
            }];
        }
    }];
}
- (void) viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark - each Users and Position

-(CGPoint)calculateCellPositionOnCellModeMap:(CGFloat)latitude longitude:(CGFloat)longitude{
    
    CGPoint tempPoint;
    tempPoint.x = 0.0;
    tempPoint.y = 0.0;
    
    int xRandom = arc4random() % 50;
    int yRandom = arc4random() % 50;
    
    //--------------- Convert coordinate from  latitude and longitude ---------------------//
    tempPoint.x = self.mainViewOrgX + self.mainViewWidth/(CGFloat)360 * longitude + self.mainViewWidth / (CGFloat)2 - xRandom;
    if(tempPoint.x < self.mainViewOrgX)
        tempPoint.x = 0;
    if(tempPoint.x > self.mainViewWidth)
        tempPoint.x = self.mainViewWidth - 40;
    
    
    tempPoint.y = self.mainviewOrgY - self.mainViewHeight / (CGFloat)180 * latitude + self.mainViewHeight /(CGFloat)2 - yRandom;
    
    if (tempPoint.y < self.mainviewOrgY)
        tempPoint.y = self.mainviewOrgY;
    if(tempPoint.y > self.mainViewHeight)
        tempPoint.y = self.mainViewHeight - 40;
    
    return tempPoint;
}

- (void) displayUsers{
//    NSLog(@"sdfsdfsdfg : %ld",(unsigned long)[[Global sharedInstance].users count]);
//    [[Global sharedInstance].usersImageData removeAllObjects];
    for(int i = 0 ; i < [[[Global sharedInstance].groups objectAtIndex:[Global sharedInstance].dragViewIndex] count] ; i++){
        
        PFObject *objectUser = [[[Global sharedInstance].groups objectAtIndex:[Global sharedInstance].dragViewIndex] objectAtIndex:i];
        PFUser *currentUser = [PFUser currentUser];
        
        NSString *userName = objectUser[PF_USER_USERNAME];
        NSString *currentName = currentUser[PF_USER_USERNAME];
        
        if(![userName isEqual:currentName])
        {
            DragView * imageView = [[DragView alloc] init];
            imageView.index = i;
            
            [imageView setUserInteractionEnabled:YES];
            
            NSLog(@"%@",[objectUser[PF_USER_PICTURE] url]);
            [imageView setImageWithURL:[objectUser[PF_USER_PICTURE] url] placeholderImage:[UIImage imageNamed:@"placeholder_gb.png"]];
            //        UIImage *userImage = imageView.image;
            //   imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpeg",i +1]];
            //        int ii = i % 13 + 1;
            //        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpeg",ii]];
            imageView.layer.cornerRadius =40 /2;
            imageView.layer.masksToBounds = YES;
            imageView.layer.borderWidth = 0;
            imageView.layer.borderColor = [UIColor redColor].CGColor;
            //        [imageView.badgeView setBadgeValue:1];
            //        [imageView.badgeView setType:MGBadgeTypeCircle];
            //        [imageView.badgeView setOutlineWidth:0.0];
            //        [imageView.badgeView setPosition:MGBadgePositionBottomRight];
            //        [imageView.badgeView setBadgeColor:[UIColor blueColor]];
            //NSLog(@"prointGeo == %@",pointGeo);
            CGPoint tempPoint;
            float x = arc4random() % 50;
            float y = arc4random() % 50;
            tempPoint = [self calculateCellPositionOnCellModeMap:x longitude: y];
            CGRect frame;
            frame.size.width = 40;
            frame.size.height = 40;
            frame.origin = tempPoint;
            imageView.frame = frame;
            
            // NSLog(@"%f",imageView.frame.origin.x);
            // NSLog(@"%f",imageView.frame.origin.y);
            
            [self.mainView addSubview:imageView];
            [self.mainView bringSubviewToFront:imageView];
            
            [self.collisionBehavior addItem:imageView];
            [self.itembehavior addItem:imageView];
            //
            [self.tempImgViewArray addObject:imageView];
        }
        
        if([self.tempImgViewArray count] == 0)
            self.msgInPutView.hidden = YES;
    }
    
    [[KIProgressViewManager manager] hideProgressView];
}

- (void) initVariable{
    self.tempImgViewArray = [[NSMutableArray alloc] init];
}

- (void) onTouchTap{
    NSLog(@"onTouchTap Start");
    PFUser *user1 = [PFUser currentUser];
    PFUser *user2 = [[[Global sharedInstance].groups objectAtIndex:[Global sharedInstance].dragViewIndex] objectAtIndex:[Global sharedInstance].selectedUserIndex];
    
    NSString *groupId = StartPrivateChat(user2, user1);
    [self actionChat:groupId user : user2];
//    [self showRecommendation:[Global sharedInstance].selectedUserIndex];
    
//    [self.mainView setUserInteractionEnabled:NO];
//    [self.view bringSubviewToFront:self.recommendationView];

}
- (void)twoFingerPinch:(UIPinchGestureRecognizer *)recognizer
{
    NSLog(@"twoFingerPinch Start");
    [self.animator removeAllBehaviors];
    NSLog(@"Pinch scale: %f", recognizer.scale);
    CGFloat maxScale;
    CGFloat minScale;
    maxScale = 2.0;
    minScale = 0.8;
    CGFloat rate = recognizer.scale;
    CGRect frame;
    if ([recognizer state] == UIGestureRecognizerStateBegan) {
        previousScale = recognizer.scale;
    }
    
    for(int i =  0 ; i < self.tempImgViewArray.count; i++)
    {
        UIImageView *imgView = [self.tempImgViewArray objectAtIndex:i];
        frame = imgView.frame;
        frame.size.height = tempFrame.size.height * rate;
        frame.size.width = tempFrame.size.width * rate;
        if (frame.size.height > 40 * maxScale){
            frame.size.height = 40 * maxScale;
            frame.size.width = 40 * maxScale;
        }
        
        if(frame.size.height < 40 * minScale){
            
            frame.size.height = 40 * minScale;
            frame.size.width = 40 * minScale ;
        }
        
        // calculate again base on scale
        float scaleCordinate = recognizer.scale / previousScale;
        float w = self.mainView.frame.size.width/2;
        float h = self.mainView.frame.size.height/2;
        CGFloat x = frame.origin.x * scaleCordinate - w * scaleCordinate + w;
        CGFloat y = frame.origin.y * scaleCordinate - h * scaleCordinate + h;
        
        NSLog(@"scale: %f, prefious %f, X before: %f X after: %f", recognizer.scale, previousScale, frame.origin.x, x);
        
        frame.origin.x = x;
        frame.origin.y = y;
        // validate x,y
        if(x < 0) {
            frame.origin.x = 0;
        }
        if(x > (self.mainView.frame.size.width - frame.size.width)) {
            frame.origin.x = self.mainView.frame.size.width - frame.size.width;
        }
        if( y < 0) {
            frame.origin.y = 0;
        }
        
        if(y >(self.mainView.frame.size.height - frame.size.height)) {
            frame.origin.y = self.mainView.frame.size.height - frame.size.height;
        }
        
        imgView.layer.cornerRadius = frame.size.height / 2;
        imgView.frame = frame;
    }
    NSLog(@"------------");
    tempFrame = frame;
    [self.mainView setUserInteractionEnabled:YES];
    if ([recognizer state] == UIGestureRecognizerStateEnded || [recognizer state] == UIGestureRecognizerStateCancelled) {
        [self resetAnimations];
    }
    previousScale = recognizer.scale;
    
}
-(void) onTouchMove {
    NSLog(@"onTouchMove Start");
    NSInteger index = (long)[Global sharedInstance].selectedUserIndex;
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView = [self.tempImgViewArray objectAtIndex:index];
    CGRect frame;
    frame = imgView.frame;
    CGFloat x = frame.origin.x;
    CGFloat y =  frame.origin.y;
    
    if(x < 0)
    {
        frame.origin.x = 0;
    }
    if(x > (self.mainView.frame.size.width - frame.size.width))
    {
        frame.origin.x = self.mainView.frame.size.width - frame.size.width;
    }
    if( y < 0)
    {
        frame.origin.y = 0;
    }
    if(y >(self.mainView.frame.size.height - frame.size.height))
    {
        frame.origin.y = self.mainView.frame.size.height - frame.size.height;
    }
    
    [imgView setFrame:frame];
    [self resetAnimations];
}
-(void) onTouchBegin{
    NSLog(@"onTouchBegin Start");
    //    [self.mainView setUserInteractionEnabled:NO];
}

-(void) onTouchEnd{
    NSLog(@"onTouchEnd Start");
    //    [self.mainView setUserInteractionEnabled:YES];
    [self resetAnimations];
    
}

- (void) resetAnimations
{
    [self.animator removeAllBehaviors];
    [self.animator addBehavior:self.collisionBehavior];
    [self.animator addBehavior:self.itembehavior];
}

#pragma mark - Message
- (IBAction)sendMessageNow:(id)sender {
    
    if ([self.messageField.text isEqualToString:@""] == true){
        return;
    }
    
//    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"hh:mm a"];
    

    PFUser *user1 = [PFUser currentUser];
    for (int i = 0;i <[[[Global sharedInstance].groups objectAtIndex:[Global sharedInstance].dragViewIndex] count];i++){
        NSString *groupId = StartPrivateChat([[[Global sharedInstance].groups objectAtIndex:[Global sharedInstance].dragViewIndex] objectAtIndex:i], user1);
        PFObject *object = [PFObject objectWithClassName:PF_CHAT_CLASS_NAME];
        object[PF_CHAT_USER] = [PFUser currentUser];
        object[PF_CHAT_GROUPID] = groupId;
        object[PF_CHAT_TEXT] = self.messageField.text;

        [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
         {
             if (error == nil)
             {

             }
         }];
        //---------------------------------------------------------------------------------------------------------------------------------------------
        SendPushNotification(groupId, self.messageField.text);
        UpdateMessageCounter(groupId, self.messageField.text);
    }
    if ([self.messageField.text length]>0) {
        self.messageField.text = @"";
        [self.view endEditing:YES];
    }
}

/////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////******* KEYBOARD UPDOWN EVENT                      **************/////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - TextFieldDelegate

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.mainView addGestureRecognizer:tapGesture];
    CGRect msgframes=self.msgInPutView.frame;
    //CGRect btnframes=self.sendChatBtn.frame;
    msgframes.origin.y=self.view.frame.size.height-260;
    [UIView animateWithDuration:0.25 animations:^{
        self.msgInPutView.frame=msgframes;
    }];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{ CGRect msgframes=self.msgInPutView.frame;
    //CGRect btnframes=self.sendChatBtn.frame;
    [self.mainView removeGestureRecognizer:tapGesture];
    msgframes.origin.y=self.view.frame.size.height-50;
    [UIView animateWithDuration:0.25 animations:^{
        self.msgInPutView.frame = msgframes;
    }];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    self.messageField.text = @"";
    [self.view endEditing:YES];
    return YES;
}

#pragma mark - subViews


- (void) showRecommendation:(NSInteger) index{
    self.recommendationView.hidden = NO;
    [self.view bringSubviewToFront:self.recommendationView];
    NSLog(@"%ld",[Global sharedInstance].dragViewIndex);
    PFUser *obj = [[[Global sharedInstance].groups objectAtIndex:[Global sharedInstance].dragViewIndex] objectAtIndex:index];
    
    UIImageView *image = (UIImageView *)[self.tempImgViewArray objectAtIndex:index];
    [self.myImage setBackgroundImage:image.image forState:UIControlStateNormal];
    self.myImage.layer.cornerRadius = self.myImage.frame.size.height /2;
    self.myImage.layer.masksToBounds = YES;
    self.myImage.layer.borderWidth = 2;
    self.lblName.text = [obj objectForKey:PF_USER_FULLNAME];
    PFQuery *query = [PFQuery queryWithClassName:PF_MESSAGES_CLASS_NAME];
    [query whereKey:PF_MESSAGES_USER equalTo:obj];
    [query whereKey:PF_MESSAGES_USER notEqualTo:[PFUser currentUser]];
    [query whereKey:PF_MESSAGES_GROUPID containsString:[PFUser currentUser].objectId];
//    [query includeKey:PF_MESSAGES_LASTUSER];
//    [query includeKey:PF_MESSAGES_USER];
    [query orderByDescending:PF_MESSAGES_UPDATEDACTION];
    self.lblMessage.text = @"";
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
         if (error == nil)
         {
             NSLog(@"%@",object);
             self.lblMessage.text = object[PF_MESSAGES_LASTMESSAGE];
         }
     }];
}

- (void) onClickMyImage:(id)sender{
    PFUser *user = [[[Global sharedInstance].groups objectAtIndex:[Global sharedInstance].dragViewIndex] objectAtIndex:[Global sharedInstance].selectedUserIndex];
    if ([self isMyFriend:user]){
        _btnAddFriend.enabled = NO;
    }else{
        _btnAddFriend.enabled = YES;
    }
    if ([self isBlockedUser:user]) {
        _btnBlockUser.enabled = NO;
    }else{
        _btnBlockUser.enabled = YES;
    }
    _detailView.hidden = NO;
    UIImageView *image = (UIImageView *)[self.tempImgViewArray objectAtIndex:[Global sharedInstance].selectedUserIndex];
    [self.btnImage setBackgroundImage:image.image forState:UIControlStateNormal];
    self.btnImage.layer.cornerRadius = self.btnImage.frame.size.height /2;
    self.btnImage.layer.masksToBounds = YES;
    self.btnImage.layer.borderWidth = 2;
    self.lblName2.text = [user objectForKey:PF_USER_FULLNAME];
    self.tvAboutMe.text = [user objectForKey:PF_USER_ABOUT_ME];
    [self.view bringSubviewToFront:_detailView];
}

- (IBAction)onCloseRecomm:(id)sender {
    self.recommendationView.hidden = YES;
    [self.mainView setUserInteractionEnabled:YES];
}

- (IBAction)onAddComment:(id)sender {
    PFUser *user1 = [PFUser currentUser];
    PFUser *user2 = [[[Global sharedInstance].groups objectAtIndex:[Global sharedInstance].dragViewIndex] objectAtIndex:[Global sharedInstance].selectedUserIndex];
    NSString *groupId = StartPrivateChat(user2, user1);
    [self actionChat:groupId user : user2];
}

- (void)actionChat:(NSString *)groupId user:(PFUser*) user
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    
    ChatView *chatView = [[ChatView alloc] initWith:groupId];
    chatView.oppUser = user;
    chatView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chatView animated:YES];
}

- (IBAction)onCloseDetailView:(id)sender {
    _detailView.hidden = YES;
}

- (BOOL) isMyFriend:(PFUser *)user{
    NSArray *friendsArray = [PFUser currentUser][PF_USER_FRIENDS];
    NSPredicate* p = [NSPredicate predicateWithFormat:@"SELF contains[cd] %@", user.objectId];
    NSArray *friendList = [friendsArray filteredArrayUsingPredicate:p];
    if ([friendList count] > 0){
        return YES;
    }
    return NO;
}

- (IBAction)onAddFriend:(id)sender {
    PFUser *user = [[[Global sharedInstance].groups objectAtIndex:[Global sharedInstance].dragViewIndex] objectAtIndex:[Global sharedInstance].selectedUserIndex];
    NSMutableArray *friendsArray =[NSMutableArray arrayWithArray:[PFUser currentUser][PF_USER_FRIENDS]];
    [friendsArray addObject:user.objectId];
    [PFUser currentUser][PF_USER_FRIENDS] = [NSArray arrayWithArray:friendsArray];
    [[PFUser currentUser] saveInBackground];
    _btnAddFriend.enabled = NO;
}

- (IBAction)onBlockUser:(id)sender {
    
}

- (BOOL) isBlockedUser:(PFUser *)user{
    NSArray *blockedArray = [PFUser currentUser][PF_USER_BLOCKS];
    NSPredicate* p = [NSPredicate predicateWithFormat:@"SELF contains[cd] %@", user.objectId];
    NSArray *blockedList = [blockedArray filteredArrayUsingPredicate:p];
    if ([blockedList count] > 0){
        return YES;
    }
    return NO;
}

- (IBAction)onReportUser:(id)sender {
    reportVC *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"reportVC"];
    vc.title = @"Report";
    [self.navigationController pushViewController:vc animated:YES];
}

@end
