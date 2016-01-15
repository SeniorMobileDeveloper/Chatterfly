//
//  NATouchThroughView.h
//  TouchThroughViewDemo
//
//  Created by Nathan Rowe on 10/19/13.
//  Copyright (c) 2013 Natrosoft LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 @abstract  Simple container used to identify portions of your root view (NARootTouchThroughView) that should
 allow touches to get forwarded to views underneath your root view.  Simply add a UIView in Interface Builder
 and change its class type to NATouchThroughView.
 */
@interface NATouchThroughView : UIImageView

@end
