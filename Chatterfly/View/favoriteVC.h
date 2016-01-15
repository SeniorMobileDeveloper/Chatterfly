//
//  favoriteVC.h
//  Chatterfly
//
//  Created by PJ95 on 6/8/15.
//  Copyright (c) 2015 PJ95. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Public.h"
@interface favoriteVC : UIViewController<UITableViewDataSource,UITableViewDelegate,SWTableViewCellDelegate,UISearchBarDelegate>{
    
}

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (retain, nonatomic) IBOutlet UIRefreshControl *refreshControl;
- (IBAction)onBack:(id)sender;

@property (retain, nonatomic) NSMutableArray *favoriteUser;
@property (retain, nonatomic) NSMutableArray            *tempFriends;
@property (retain, nonatomic) NSMutableArray            *searchResults;
@property (retain, nonatomic) NSMutableDictionary       *sectionDict;
@property (retain, nonatomic) NSMutableArray            *charArray;        //'A','B'...'z'
@property (retain, nonatomic) NSMutableArray            *sectionArray;

@property (retain, nonatomic) NSArray                 *swipeArrary;
@property (retain, nonatomic) NSDictionary            *swipeDictionary;
@end
