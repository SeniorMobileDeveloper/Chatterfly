//
//  DragView.h
//  CellsFriends
//
//  Created by black on 4/6/15.
//  Copyright (c) 2015 PJ55. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DragView : UIImageView
{

    CGPoint startLocation;
    BOOL isTouchBegan;
    BOOL isTouchMoved;
}
@property (nonatomic) NSInteger index;
@end
