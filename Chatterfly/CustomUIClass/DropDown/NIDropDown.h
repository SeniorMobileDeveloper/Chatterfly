//
//  NIDropDown.h
//  HumTum
//
//  Created by maemae on 2/22/15.
//  Copyright (c) 2015 maemae. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NIDropDown;
@protocol NIDropDownDelegate
- (void) niDropDownDelegateMethod: (NIDropDown *) sender;
@end

@interface NIDropDown : UIView <UITableViewDelegate, UITableViewDataSource>
{
    NSString *animationDirection;
    UIImageView *imgView;
}
@property (nonatomic, retain) id <NIDropDownDelegate> delegate;
@property (nonatomic, retain) NSString *animationDirection;
@property (nonatomic, retain) NSString *text;

-(void)hideDropDown:(UIButton *)b;
- (id)showDropDown:(UIButton *)b:(CGFloat *)height:(NSArray *)arr:(NSArray *)imgArr:(NSString *)direction;
@end
