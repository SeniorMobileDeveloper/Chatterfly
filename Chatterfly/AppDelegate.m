//
//  AppDelegate.m
//  Chatterfly
//
//  Created by PJ95 on 6/5/15.
//  Copyright (c) 2015 PJ95. All rights reserved.
//

#import "AppDelegate.h"

NSString *const BFTaskMultipleExceptionsException = @"BFMultipleExceptionsException";

@interface AppDelegate ()

@end

@implementation AppDelegate

+ (AppDelegate *) delegate{
    return [UIApplication sharedApplication].delegate;
}

- (void) logout{
    
    PFUser *user = [PFUser currentUser];
    user[PF_USER_ONLINE_STATUS] = @"Offline";
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded){
            [PFUser logOut];
            NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
            [defs setValue:@"0" forKey:LOGGED_IN];
            [defs synchronize];
            for (UIView *view in self.window.subviews){
                [view removeFromSuperview];
            }
            
        }
    }];
    
    UIViewController *vc=[[Global appStoryboard] instantiateViewControllerWithIdentifier:@"nav"];
    self.window.rootViewController = vc;
    [self.window makeKeyAndVisible];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
    
    if ([[defs objectForKey:USER_FIRST_INSTALL] integerValue] == 0){
        [Global sharedInstance].showPopupOfChatRooms = true;
        [Global sharedInstance].showPopupOfChatRoom = true;
        [defs setValue:@"1" forKey:USER_FIRST_INSTALL];
        [defs synchronize];
    }else{
        [Global sharedInstance].showPopupOfChatRooms = false;
        [Global sharedInstance].showPopupOfChatRoom = false;
    }
    
    
    [Parse setApplicationId:@"LNn1N5CKVZnxIgE16J9lQfscmPRLuR2Fd87rSyRo"
                  clientKey:@"D1f8TN3Tsc8IAADqYWdWUFtuHtTKjRjVbpGbPY9c"];

    
    [PFFacebookUtils initializeFacebook];
    
    application.applicationIconBadgeNumber = 0;
    
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
        UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
        [application registerForRemoteNotifications];
    }
    
    [[KIProgressViewManager manager] setPosition:KIProgressViewPositionTop];
    // Set the color
    
    [[KIProgressViewManager manager] setColor:COLOR_Border];
    
    // Set the gradient
    [[KIProgressViewManager manager] setGradientStartColor:[UIColor blackColor]];
    [[KIProgressViewManager manager] setGradientEndColor:[UIColor whiteColor]];
    
    // Currently not supported
    [[KIProgressViewManager manager] setStyle:KIProgressViewStyleRepeated];
    [self trackingLocation];
    
    if (([[defs objectForKey:LOGGED_IN] integerValue] == 1) && ([PFUser currentUser])){
        [Global sharedInstance].isLoggedIn = true;
        [Global sharedInstance].username = [defs objectForKey:PF_USER_USERNAME];
        [Global sharedInstance].password = [defs objectForKey:PF_USER_PASSWORD];
        [Global sharedInstance].email = [defs objectForKey:PF_USER_EMAIL];
        [Global sharedInstance].firstname = [defs objectForKey:PF_USER_FIRSTNAME];
        [Global sharedInstance].lastname = [defs objectForKey:PF_USER_LASTNAME];
        [Global sharedInstance].about_me = [defs objectForKey:PF_USER_ABOUT_ME];
        [Global sharedInstance].portfloio = [defs objectForKey:PF_USER_PICTURE];
        //    self.navigationController=[[UINavigationController alloc] initWithRootViewController:login];
    }
    return YES;

}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                        withSession:[PFFacebookUtils session]];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    NSLog(@"didFailToRegisterForRemoteNotificationsWithError %@", error);
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    
    ///////////// Push Notification Prepare Part ////////////////////
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    
    if (currentInstallation.badge != 0) {
        currentInstallation.badge = 0;// Badge format part
        [currentInstallation saveInBackground];
    }
    [self createUsers];// fake user creation call part
//    [self trackingLocation];// track current user's location
    [FBAppCall handleDidBecomeActiveWithSession:[PFFacebookUtils session]];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    application.applicationIconBadgeNumber = 0;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    NSLog(@"Badge : %@",userInfo);
    [UIApplication sharedApplication].applicationIconBadgeNumber = [UIApplication sharedApplication].applicationIconBadgeNumber + 1;
    [Global sharedInstance].badge++;
//    [self performSelector:@selector(refreshMessagesView) withObject:nil afterDelay:4.0];
    //---------------------------------------------------------------------------------------------------------------------------------------------
    //[PFPush handlePush:userInfo];
}


#pragma mark -
#pragma mark Location Manager Tracking

- (void)trackingLocation {
    self.desiredAccuracy = INTULocationAccuracyCity;
    self.timeout = 30.0;
    self.locationRequestID = NSNotFound;
    [self startSingleLocationRequest];
}

-(int) generateRandomNumberWithlowerBound:(int)lowerBound
                               upperBound:(int)upperBound
{
    int rndValue = lowerBound + arc4random() % (upperBound - lowerBound);
    return rndValue;
}

- (void)startSingleLocationRequest
{
    __weak __typeof(self) weakSelf = self;
    INTULocationManager *locMgr = [INTULocationManager sharedInstance];
    self.locationRequestID = [locMgr requestLocationWithDesiredAccuracy:self.desiredAccuracy
                                                                timeout:self.timeout
                                                   delayUntilAuthorized:YES
                                                                  block:
                              ^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, INTULocationStatus status) {
                                  __typeof(weakSelf) strongSelf = weakSelf;
                                  
                                  if (status == INTULocationStatusSuccess) {
                                      // achievedAccuracy is at least the desired accuracy (potentially better)
                                      [Global sharedInstance].location = currentLocation;
                                      NSLog(@"%@",currentLocation);
                                      
                                      [self getReverseGeocode];
                                  }
                                  else if (status == INTULocationStatusTimedOut) {
                                      
                                  }
                                  else {
                                  }
                                  
                                  strongSelf.locationRequestID = NSNotFound;
                              }];
}

///////////////// Fake User Creation Part ////////////////////

- (void) createUsers{
    [PFUser logOut]; // essentially require.
    for(int i = 0; i < 5; i++) {
    

        // User Table
//        PFUser *user = [PFUser new];
//        user.username = [MBFakerInternet userName];
////        user[PF_USER_USERNAME] = [MBFakerInternet userName];
//        user.password = [MBFakerInternet freeEmail];
//        user[PF_USER_EMAIL] = [MBFakerInternet freeEmail];
////        user[@"userid"] = [MBFakerName name];
////        user[PF_USER_FIRSTNAME] = [MBFakerName name];
////        user[PF_USER_LASTNAME] = [MBFakerName name];
////        user[PF_USER_GENDER] = @"male";
////        user[PF_USER_ABOUT_ME] = [MBFakerLorem sentences:[self generateRandomNumberWithlowerBound:2 upperBound:5]];
////        user[PF_USER_GEOLOCATION] = [PFGeoPoint geoPointWithLatitude:42.91873020 longitude:129.52190170];
////        //                                          user[PF_USER_PICTURE] = [NSString stringWithFormat:@"http://robohash.org/%@.png?size=100x100",user[PF_USER_USERNAME]];
////        int ii = i % 13 + 1;
////        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpeg",ii]];
////        NSData *imgData = UIImageJPEGRepresentation(image, 0.5f);
////        PFFile *PortfolioFile = [PFFile fileWithName:@"Portfolio" data:imgData];
////        user[PF_USER_PICTURE] = PortfolioFile;
////        user[PF_USER_GROUP_ID] = [NSString stringWithFormat:@"%ld",(long)(arc4random() % 3)];
//        [user signUpInBackground];
        
        
        // Property Table
        PFObject *object = [PFObject objectWithClassName:@"Properties"];
        object[@"name"] = [MBFakerInternet userName];
        object[@"userid"] = [MBFakerInternet userName];
        object[@"email"] = [MBFakerInternet freeEmail];
        object[@"phone"] = [MBFakerPhoneNumber phoneNumber];
        object[@"street"] = [MBFakerAddress streetName];
        object[@"city"] = [MBFakerAddress city];
        object[@"state"] = [MBFakerAddress state];
        object[@"zipcode"] = [MBFakerAddress zipCode];
        int ii = i % 13 + 1;
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpeg",ii]];
        NSData *imgData = UIImageJPEGRepresentation(image, 0.5f);
        PFFile *PortfolioFile = [PFFile fileWithName:@"Portfolio" data:imgData];
        object[@"photo"] = PortfolioFile;
        
        int iii = (i + 4) % 13 + 1;
        UIImage *image1 = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpeg",iii]];
        NSData *imgData1 = UIImageJPEGRepresentation(image1, 0.5f);
        PFFile *PortfolioFile1 = [PFFile fileWithName:@"Portfolio" data:imgData1];
        object[@"photourl"] = PortfolioFile1;
        
        object[@"lng"] = [MBFakerAddress longitude];
        object[@"lat"] = [MBFakerAddress latitude];
        object[@"description"] = @"Test Data";
        object[@"type"] = [MBFakerInternet userName];
        
        
        object[@"space"] = [NSString stringWithFormat:@"%ld",(long)arc4random() % 100];
        object[@"rate"] = [NSString stringWithFormat:@"%ld.%ld",(long)arc4random() % 5,(long)arc4random() % 10];
        [object saveInBackground];
    }
}

- (void) getReverseGeocode
{
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    if([Global sharedInstance].location != nil)
    {
        CLLocationCoordinate2D myCoOrdinate;
        myCoOrdinate = [Global sharedInstance].location.coordinate;
        
        CLLocation *location = [[CLLocation alloc] initWithLatitude:myCoOrdinate.latitude longitude:myCoOrdinate.longitude];
        [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error)
         {
             if (error)
             {
                 NSLog(@"failed with error: %@", error);
                 [Global sharedInstance].cityName = @"City Not founded";
                 return;
             }
             if(placemarks.count > 0)
             {
                 NSString *MyAddress = @"";
                 NSString *city = @"";
                 CLPlacemark *placemark = [placemarks firstObject];
                 
                 if([placemark.addressDictionary objectForKey:@"FormattedAddressLines"] != NULL)
                     MyAddress = [[placemark.addressDictionary objectForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
                 else
                     MyAddress = @"Address Not founded";
                 
                 if([placemark.addressDictionary objectForKey:@"SubAdministrativeArea"] != NULL)
                     city = [placemark.addressDictionary objectForKey:@"SubAdministrativeArea"];
                 else if([placemark.addressDictionary objectForKey:@"City"] != NULL)
                     city = [placemark.addressDictionary objectForKey:@"City"];
                 else if([placemark.addressDictionary objectForKey:@"Country"] != NULL)
                     city = [placemark.addressDictionary objectForKey:@"Country"];
                 else
                     city = @"City Not founded";
                 [Global sharedInstance].cityName =  [NSString stringWithFormat:@"%@,%@",city,placemark.administrativeArea];
                 return;
             }
         }];
    } else {
        [Global sharedInstance].cityName = @"City Not founded";
    }
}
@end
