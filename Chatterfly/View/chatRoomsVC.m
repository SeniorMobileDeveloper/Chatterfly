//
//  chatRoomsVC.m
//  Chatterfly
//
//  Created by PJ95 on 6/10/15.
//  Copyright (c) 2015 PJ95. All rights reserved.
//

#import "chatRoomsVC.h"
#import "ViewController.h"
@implementation chatRoomsVC

- (void) viewWillAppear:(BOOL)animated{
    [self loadBadge];
    self.navigationController.navigationBarHidden = NO;
}

- (void) viewDidAppear:(BOOL)animated{
    timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(loadBadge) userInfo:nil repeats:YES];
}

- (void) loadBadge{
    [_btnMessage.badgeView setBadgeValue:[Global sharedInstance].badge];
}

- (void) viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    [timer invalidate];
}

- (void) viewDidLoad{
    NSLog(@"ViewDidLoad");
    [_btnMessage.badgeView setOutlineWidth:0.0];
    [_btnMessage.badgeView setPosition:MGBadgePositionTopRight];
    [_btnMessage.badgeView setBadgeColor:[UIColor redColor]];
    [self.navigationItem setHidesBackButton:YES animated:NO];
    
    CGSize size = _scrView.contentSize;
    size.width = 900;
    size.height = 900;
    _scrView.contentSize = size;
    
    
//    [PFUser currentUser][PF_USER_FRIENDS] = @[@"Ij7QtkqxTl",@"u05PXubNGB",@"C12HkgxR8T",@"H9GNcjePky"];
//    [[PFUser currentUser] saveInBackground];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onGoAvartarVC) name:@"touchTapChatRoom" object:nil];
    
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.scrView];
    self.collisionBehavior = [[UICollisionBehavior alloc] initWithItems:nil];
    self.collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    self.collisionBehavior.collisionMode = UICollisionBehaviorModeEverything;
    self.collisionBehavior.collisionDelegate = self;
    
    self.itembehavior = [[UIDynamicItemBehavior alloc] initWithItems:nil];
    self.itembehavior.elasticity = 0.6;
    self.itembehavior.friction = 0.5;
    self.itembehavior.resistance = 0.5;
    self.itembehavior.allowsRotation = NO;

    [self.animator addBehavior:self.collisionBehavior];
    [self.animator addBehavior:self.itembehavior];
    [self getAllUsers];
    
    if ([Global sharedInstance].showPopupOfChatRooms == true){
        [Global sharedInstance].showPopupOfChatRooms = false;
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:APP_NAME message:@"To enter a room, tap any dot." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

- (void) resetAnimations
{
    [self.animator removeAllBehaviors];
    [self.animator addBehavior:self.collisionBehavior];
    [self.animator addBehavior:self.itembehavior];
}


//- (void) viewWillAppear:(BOOL)animated{
//    self.navigationController.navigationBarHidden = YES;
//}
//
//- (void) viewWillDisappear:(BOOL)animated{
//    self.navigationController.navigationBarHidden = NO;
//}


//////////// Parse Access Part ////////////////////
- (void) getAllUsers{
    [[KIProgressViewManager manager] showProgressOnView:self.view];
    
    PFUser *currentUser = [PFUser currentUser];//Get User Location
    PFGeoPoint *myPoint = currentUser[PF_USER_GEOLOCATION];
    CLLocation *myLocation = [[CLLocation alloc] initWithLatitude:myPoint.latitude longitude:myPoint.longitude];
    
    
    PFQuery *query = [PFQuery queryWithClassName:PF_USER_CLASS_NAME];
    [query orderByAscending:PF_USER_GROUP_ID];
    //[query whereKey:PF_USER_OBJECTID notEqualTo:[PFUser currentUser].objectId];
    [query whereKey:PF_USER_ONLINE_STATUS equalTo:@"Online"];
    NSArray *friendsInfo = [query findObjects];
    NSMutableArray *searchResults = [[NSMutableArray alloc] init];
    
    for(PFUser *obj in friendsInfo){
        
        PFGeoPoint *point = obj[PF_USER_GEOLOCATION];
        CLLocation *location = [[CLLocation alloc] initWithLatitude:point.latitude longitude:point.longitude];
        float dis = [self getDistanceFrom:myLocation to:location];
        if (dis < [Global sharedInstance].mileRadius * 1609){
            [searchResults addObject:obj];
        }
    }
    [self sortUsers:searchResults];
    totalCnt = [searchResults count];
}

-(float)getDistanceFrom:(CLLocation*)loc1 to:(CLLocation*)loc2
{
    return [loc1 distanceFromLocation:loc2];
}


////////////// Sorting by Group Part & Detection Block Status //////////////////////////
- (void) sortUsers:(NSArray *)users{
    if (![Global sharedInstance].groups){
        [Global sharedInstance].groups = [NSMutableArray array];
    }else{
        [[Global sharedInstance].groups removeAllObjects];
    }
    NSInteger tGroupID = -1;
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [Global sharedInstance].usersCnt = 0;
    for (int i = 0;i < [users count];i++){
        PFUser *user = [users objectAtIndex:i];
        if (![self isBlockedUser:user]){
            [Global sharedInstance].usersCnt++;
            NSInteger groupID = [user[PF_USER_GROUP_ID] integerValue];
            if (tGroupID != groupID){
                if (groupID > 0){
                    NSMutableArray *array1 = [NSMutableArray arrayWithArray:array];
                    [[Global sharedInstance].groups addObject:array1];
                    [array removeAllObjects];
                }
                tGroupID = groupID;
            }
            [array addObject:user];
        }
    }
    if ([array count] > 0)
        [[Global sharedInstance].groups addObject:array];
    if ([[Global sharedInstance].groups count] > 0){
        [self createChatRooms];
    }
    [[KIProgressViewManager manager] hideProgressView];
}

- (void) createChatRooms{
    
    for (UIView *view in self.scrView.subviews){
        [view removeFromSuperview];
    }
    
    for (int i = 0;i < [[Global sharedInstance].groups count];i++){
        roomView *room = [[roomView alloc] initWithFrameAndConstant:CGRectMake(self.scrView.bounds.size.width / 2 , self.scrView.bounds.size.height / 2 , 100, 100) index:i];
        
        ////lgilgilgi
        room.chatRoomsDelegate = self;
        
        [self.scrView addSubview:room];
        [self.collisionBehavior addItem:room];
        [self.itembehavior addItem:room];
//        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.scrView.bounds.size.width / 2, self.scrView.bounds.size.height / 2, 100, 100)];
//        NSInteger maleCnt = 0;
//        NSInteger femaleCnt = 0;
//        NSInteger totalCnt = [array count];
//        for (int j = 0;j < totalCnt;j++){
//            PFUser *user = [array objectAtIndex:j];
//            if ([user[PF_USER_GENDER] isEqualToString:@"male"] == true){
//                maleCnt++;
//            }else{
//                femaleCnt++;
//            }
//        }
//        if (maleCnt > femaleCnt){
//            imageView.backgroundColor = [UIColor colorWithRed:1.000f green:0.655f blue:0.918f alpha:1.00f];
//        }else{
//            imageView.backgroundColor = [UIColor colorWithRed:0.000f green:0.0f blue:0.918f alpha:1.00f];
//        }
//        imageView.layer.cornerRadius = imageView.frame.size.width / 2;
//        imageView.clipsToBounds = true;
//        [self.scrView addSubview:imageView];
//        [self.collisionBehavior addItem:imageView];
//        [self.itembehavior addItem:imageView];
    }
    if (((totalCnt % 50) == 0) && (totalCnt >= ([[Global sharedInstance].groups count] * 50))){
        roomView *room = [[roomView alloc] initWithFrameAndConstant:CGRectMake(self.scrView.bounds.size.width / 2, self.scrView.bounds.size.height / 2, 100, 100) index:[[Global sharedInstance].groups count]];
        [self.scrView addSubview:room];
        [self.collisionBehavior addItem:room];
        [self.itembehavior addItem:room];
    }
}


//////////// Detection Block Status ///////////////
- (BOOL) isBlockedUser:(PFUser *)user{
    NSArray *blockedArray = [PFUser currentUser][PF_USER_BLOCKS]; // Block Field Value Getting Part
    NSPredicate* p = [NSPredicate predicateWithFormat:@"SELF contains[cd] %@", user.objectId];// Detection Block Status.
    NSArray *blockedList = [blockedArray filteredArrayUsingPredicate:p];
    if ([blockedList count] > 0){
        return YES;
    }
    return NO;
}

- (void) onGoAvartarVC{
    if ([[[Global sharedInstance].groups objectAtIndex:[Global sharedInstance].dragViewIndex] count] >= 50){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:APP_NAME message:@"This Room is Full,Please select other room." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
        [alertView show];
    }else{
        [self performSegueWithIdentifier:@"onGoAvartar" sender:self];
    }
}

- (IBAction)onGoFavorite:(id)sender {
    favoriteVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"favorite"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)onGoMessage:(id)sender {
    MessagesView *messagesView = [[MessagesView alloc] init];
    [self.navigationController pushViewController:messagesView animated:YES];
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
            
            NSMutableArray *allViewControllers = [NSMutableArray arrayWithArray: self.navigationController.viewControllers];
            for (int i = 0; i < [allViewControllers count]; i++) {
                UIViewController *vc = [allViewControllers objectAtIndex:i];
                if ([vc isKindOfClass:[chatRoomsVC class]]) {
                    [allViewControllers removeObjectAtIndex:i];
                    
                }
            }
            self.navigationController.viewControllers = allViewControllers;
            
        }
        else if (buttonIndex == 4){
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

#pragma mark - RMPScrollingMenuBarController

- (RMPScrollingMenuBarItem*)menuBarController:(RMPScrollingMenuBarController *)menuBarController
                           menuBarItemAtIndex:(NSInteger)index
{
    RMPScrollingMenuBarItem* item = [[RMPScrollingMenuBarItem alloc] init];
    item.title = [NSString stringWithFormat:@"Title %02ld", (long)(index+1)];
    
    return item;
}

- (void)menuBarController:(RMPScrollingMenuBarController *)menuBarController
 willSelectViewController:(UIViewController *)viewController
{
    NSLog(@"will select %@", viewController);
}

- (void)menuBarController:(RMPScrollingMenuBarController *)menuBarController
  didSelectViewController:(UIViewController *)viewController
{
    NSLog(@"did select %@", viewController);
}

- (void)menuBarController:(RMPScrollingMenuBarController *)menuBarController
  didCancelViewController:(UIViewController *)viewController
{
    NSLog(@"did cancel %@", viewController);
}

- (void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item withBoundaryIdentifier:(id<NSCopying>)identifier atPoint:(CGPoint)p {
    
    NSLog(@" point (%f %f)------", p.x, p.y);
    
}

/////lgilgilgi
#pragma mark chatRoomsVCDelegate
-(void) resetAnimations111
{
    [self resetAnimations];
}


@end
