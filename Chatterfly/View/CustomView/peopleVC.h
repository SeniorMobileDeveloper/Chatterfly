//
//  peopleVC.h
//  Chatterfly
//
//  Created by dragon on 6/29/15.
//  Copyright (c) 2015 PJ95. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Public.h"

@interface peopleVC : UIViewController<UITableViewDataSource,UITableViewDelegate,SWTableViewCellDelegate,UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end
