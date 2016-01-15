//
//  Public.h
//  Restarant
//
//  Created by PJ95 on 5/29/15.
//  Copyright (c) 2015 PJ95. All rights reserved.
//

#ifndef Restarant_Public_h
#define Restarant_Public_h
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <Parse/Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import <SpriteKit/SpriteKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MessageUI/MessageUI.h>
#import <FacebookSDK/FacebookSDK.h>



#import "KIProgressViewManager.h"

#import "PFDatabase.h"

#import "APAvatarImageView.h"
#import "UIViewAdditions.h"
#import "UINavigationBar+Addition.h"
#import "NSDate+Escort.h"
#import "RESideMenu.h"
#import "UIView+Blur.h"
#import "UIView+RNActivityView.h"
#import "UINavigationController+Retro.h"
#import "KRLCollectionViewGridLayout.h"
#import "BorderButton.h"
#import "KIProgressView.h"
#import "KIProgressViewManager.h"
#import "UILabel+dynamicSizeMe.h"
#import "INTULocationManager.h"
#import "INTULocationManager+Internal.h"
#import "DataManager.h"
#import "UIAlertView+NSCookbook.h"
#import "NIDropDown.h"
#import "UIView+MGBadgeView.h"
#import "Global.h"
#import "pushnotification.h"
#import "MessagesView.h"
#import "ChatView.h"
#import "utilities.h"
#import "messages.h"
#import "MBFaker.h"
#import "roomView.h"
#import "camera.h"
#import "images.h"
#import "converters.h"
#import "SWTableViewCell.h"
#import "VPImageCropperViewController.h"
#import "MWPhotoBrowser.h"
#import "MWCommon.h"
#import "Mailgun.h"
#import "likeVC.h"
#import "peopleVC.h"
#import "RMPScrollingMenuBarController.h"
#import "RMPScrollingMenuBar.h"
#import "RMPScrollingMenuBarControllerAnimator.h"
#import "RMPScrollingMenuBarControllerTransition.h"
#import "RMPScrollingMenuBarItem.h"
#import "favoriteVC.h"
#import "SearchVC.h"
#import "SearchLocationVC.h"

//#import "AFNetworkReachabilityManager.h"

#import "AppDelegate.h"
#import "EditProfileVC.h"
#import "reportVC.h"
#import "detailUserVC.h"
#import "DragView.h"
//#import "userInfo.h"
#import "JPSThumbnailAnnotation.h"

#define COLOR_MENU [UIColor colorWithRed:35.0/255.0 green:37.0/255.0 blue:44.0/255.0 alpha:1.0]
#define COLOR_TINT [UIColor whiteColor]
#define COLOR_BACKGROUND [UIColor colorWithRed:31.0/255.0 green:51.0/255.0 blue:121.0/255.0 alpha:1.0]
#define COLOR_Border [UIColor colorWithRed:255.0/255.0 green:1.0/255.0 blue:1.0/255.0 alpha:1.0]
#define COLOR_SECOND [UIColor colorWithRed:31.0/255.0 green:51.0/255.0 blue:121.0/255.0 alpha:1.0]

#define Notification_Timer_Refresh @"Notification_Timer_Refresh"
#define Notification_InitialSetting_Refresh @"Notification_InitialSetting_Refresh"

#define kRemindMeNotificationDataKey @"kRemindMeNotificationDataKey"

//#define [GlobalPool sharedInstance].kMatchLimit      80
//
//#define [GlobalPool sharedInstance].kUnlockLimit              20
//#define kPurchaseMoreMatch          50

#define HEXCOLOR(c) [UIColor colorWithRed:((c>>24)&0xFF)/255.0 green:((c>>16)&0xFF)/255.0 blue:((c>>8)&0xFF)/255.0 alpha:((c)&0xFF)/255.0]
#define		MESSAGE_INVITE						@"Check out Project6. You can download here: http://itunesconnect.apple.com"

#define pubWidth [UIScreen mainScreen].bounds.size.width


#endif
