//
//  SearchVC.h
//  Chatterfly
//
//  Created by Frank on 7/10/15.
//  Copyright (c) 2015 PJ95. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Public.h"

@interface SearchVC : UIViewController<UITableViewDataSource,UITableViewDelegate,SWTableViewCellDelegate,UISearchBarDelegate>


@property (retain, nonatomic) NSArray *searchResults;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end
