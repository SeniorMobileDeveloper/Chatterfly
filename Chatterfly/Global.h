//
//  Global.h
//  Restarant
//
//  Created by PJ95 on 5/29/15.
//  Copyright (c) 2015 PJ95. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//#import "userInfo.h"
#import "INTULocationManager.h"
#import "INTULocationManager+Internal.h"
#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
#define IS_IPHONE_6 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )667 ) < DBL_EPSILON )
#define IS_IPHONE_6Plus ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )736 ) < DBL_EPSILON )

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define APP_NAME    @"Chatterfly"
#define LOGGED_IN   @"logged_in"



@interface Global : NSObject

@property (nonatomic) NSInteger badge;
@property (nonatomic,strong) NSString *username;
@property (nonatomic,strong) NSString *password;
@property (nonatomic,strong) NSString *firstname;
@property (nonatomic,strong) NSString *lastname;
@property (nonatomic,strong) NSString *email;
@property (nonatomic,strong) NSString *about_me;
@property (nonatomic,strong) NSString *gender;
@property (nonatomic,strong) NSData *portfloio;
@property (nonatomic) NSInteger dragViewIndex;
@property (nonatomic) NSInteger selectedUserIndex;
@property (nonatomic) float distance;
@property (nonatomic) int mileRadius;
@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, assign) BOOL isLoggedIn;
@property (nonatomic, strong) NSString *cityName;

//@property (nonatomic,strong) userInfo *Me;
@property (nonatomic,strong) NSMutableArray *groups;
@property (nonatomic) NSInteger usersCnt;
@property (nonatomic,strong) NSMutableArray *usersImageData;

@property (nonatomic) NSInteger usersCntPerRoom;
@property (nonatomic) BOOL isLogined;

+ (Global *) sharedInstance;
+ (UIStoryboard*) appStoryboard;

@property (nonatomic) BOOL showPopupOfChatRooms;
@property (nonatomic) BOOL showPopupOfChatRoom;

@end



