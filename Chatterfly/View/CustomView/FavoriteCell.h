//
//  FavoriteCell.h
//  Chatterfly
//
//  Created by PJ95 on 6/10/15.
//  Copyright (c) 2015 PJ95. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"
@interface FavoriteCell : SWTableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UIButton *btnInfo;
@property (weak, nonatomic) IBOutlet UILabel *lblFullName;
@property (weak, nonatomic) IBOutlet UILabel *lblLastMessage;
@property (weak, nonatomic) IBOutlet UIImageView *img;

@end
