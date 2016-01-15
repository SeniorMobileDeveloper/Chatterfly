//
//  AppDelegate.h
//  Chatterfly
//
//  Created by PJ95 on 6/5/15.
//  Copyright (c) 2015 PJ95. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Public.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
+(AppDelegate *) delegate;
- (void) logout;

@property (assign, nonatomic) INTULocationAccuracy desiredAccuracy;
@property (assign, nonatomic) NSTimeInterval timeout;

@property (assign, nonatomic) INTULocationRequestID locationRequestID;

@end

