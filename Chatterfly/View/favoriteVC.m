//
//  favoriteVC.m
//  Chatterfly
//
//  Created by PJ95 on 6/8/15.
//  Copyright (c) 2015 PJ95. All rights reserved.
//

#import "favoriteVC.h"
#import "FavoriteCell.h"
#import <UIKit/UIKit.h>

@implementation favoriteVC

- (void) viewDidLoad{
    
    [super viewDidLoad];
    [[KIProgressViewManager manager] showProgressOnView:self.view];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    
    _favoriteUser = [[NSMutableArray alloc] init];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor lightGrayColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self action:@selector(getFavoriteUsers) forControlEvents:UIControlEventValueChanged];
    [self.myTableView addSubview:self.refreshControl];
    [self getFavoriteUsers];
}

- (void) viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
}

- (void) getFavoriteUsers{
    NSArray *array = [PFUser currentUser][PF_USER_FRIENDS];
    [_favoriteUser removeAllObjects];
    for (int i = 0;i < [array count];i++){
        PFQuery *query = [PFUser query];
        [query whereKey:PF_USER_OBJECTID equalTo:array[i]];
        [_favoriteUser addObject:[query getFirstObject]];
    }
    _tempFriends = _favoriteUser;
    [[KIProgressViewManager manager] hideProgressView];
    [self seperateContacts];
    [self.myTableView reloadData];
    if (self.refreshControl)
        [self.refreshControl endRefreshing];
}

#pragma mark - Delete freind from favorite list

- (void) removeFriendFromFavorite:(PFUser *)friend{

    NSLog(@"%@",_favoriteUser);
    NSMutableArray *friendsArray =[NSMutableArray arrayWithArray:[PFUser currentUser][PF_USER_FRIENDS]];
    [friendsArray removeObject:friend.objectId];
    [_favoriteUser removeAllObjects];
    for (int i = 0;i < [friendsArray count];i++){
        PFQuery *query = [PFUser query];
        [query whereKey:PF_USER_OBJECTID equalTo:friendsArray[i]];
        [_favoriteUser addObject:[query getFirstObject]];
    }
    _tempFriends = _favoriteUser;
    [self seperateContacts];
    [self.myTableView reloadData];
    [PFUser currentUser][PF_USER_FRIENDS] = [NSArray arrayWithArray:friendsArray];
    [[PFUser currentUser] saveInBackground];
}

- (void) seperateContacts
{
    
    _charArray = [NSMutableArray new];
    for(char c ='A' ; c <= 'Z' ;  c++)
    {
        [_charArray addObject:[NSString stringWithFormat:@"%c",c]];
    }
    _sectionDict = [[NSMutableDictionary alloc] init];
    
    for(PFUser *friend in _tempFriends)
    {

        NSString *name = friend[PF_USER_USERNAME];

        
        NSString *key = [[name substringToIndex:1] uppercaseString];
        
        NSMutableArray *tempArray = [_sectionDict objectForKey:key];
        
        if(!tempArray)
        {
            tempArray = [[NSMutableArray alloc] initWithObjects:friend, nil];
            [_sectionDict setValue:tempArray forKey:key];
        }
        else
        {
            [tempArray addObject:friend];
            [_sectionDict setValue:tempArray forKey:key];
        }
    }
    _sectionArray = (NSMutableArray*)[[_sectionDict allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    NSLog(@"%@",_sectionArray);
    [self.myTableView reloadData];
}

//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
//{
//    //  return animalSectionTitles;
//    return sectionArray;
//}

#pragma mark -
#pragma mark - UISearchBarDelegate


- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    searchBar.showsCancelButton = NO;
    searchBar.text = @"";
    
    _tempFriends = [NSMutableArray arrayWithArray:_favoriteUser];
    
    [self seperateContacts];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    searchBar.showsCancelButton = NO;
    
    [self searchArray:searchBar.text];
    
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = YES;
    NSLog(@"Search Begin");
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSLog(@"%@", searchText);
    [self searchArray:searchText];
}


- (void) searchArray:(NSString*)strText
{
    _tempFriends = [NSMutableArray arrayWithArray:_favoriteUser];
    
    NSMutableArray *tempArr = [[NSMutableArray alloc] init];
    
    for(PFUser *friend in _tempFriends)
    {
        
        NSString *name = [friend[PF_USER_USERNAME] uppercaseString];
        
        
        if([name containsString:[strText uppercaseString]])
        {
            [tempArr addObject:friend];
        }
    }
    
    _tempFriends = [NSMutableArray arrayWithArray:tempArr];
    
    [self seperateContacts];
}


- (IBAction)onBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(UIView *)headerContentView:(NSInteger)section
{
    UIFont *labelTextFont = [UIFont systemFontOfSize:15.0];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.myTableView.frame.size.width, 25)];
    
    UILabel *keyLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 2, self.myTableView.frame.size.width - 30, 20)];
    [keyLabel setFont:labelTextFont];
    [keyLabel setTextAlignment:NSTextAlignmentLeft];
    [keyLabel setTextColor:[UIColor blackColor]];
    
    [keyLabel setText:[_sectionArray objectAtIndex:section]];
    [view addSubview:keyLabel];
    [view setBackgroundColor:[UIColor grayColor]];
    
    
    return view;
}

- (UIView *)headerView:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    UIView* headerContentView = [self headerContentView:section];
    [headerView addSubview:headerContentView];
    
    return headerView;
}

#pragma mark - tableViewcell swipe Left Right

- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    //    [rightUtilityButtons sw_addUtilityButtonWithColor:
    //     [UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0]
    //                                                title:@"More"];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                title:@"Delete"];
    
    return rightUtilityButtons;
}

- (NSArray *)leftButtons
{
    NSMutableArray *leftUtilityButtons = [NSMutableArray new];
    
    [leftUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:0.07 green:0.75f blue:0.16f alpha:1.0]
                                                icon:[UIImage imageNamed:@"check.png"]];
    [leftUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:1.0f blue:0.35f alpha:1.0]
                                                icon:[UIImage imageNamed:@"clock.png"]];
    [leftUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.231f blue:0.188f alpha:1.0]
                                                icon:[UIImage imageNamed:@"cross.png"]];
    [leftUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:0.55f green:0.27f blue:0.07f alpha:1.0]
                                                icon:[UIImage imageNamed:@"list.png"]];
    return  nil;
    //return leftUtilityButtons;
}


#pragma mark - SWTableViewDelegate

- (void)swipeableTableViewCell:(SWTableViewCell *)cell scrollingToState:(SWCellState)state
{
    switch (state) {
        case 0:
            NSLog(@"utility buttons closed");
            break;
        case 1:
            NSLog(@"left utility buttons open");
            break;
        case 2:
//            cell.accessoryType = UITableViewCellAccessoryNone;
            NSLog(@"right utility buttons open");
//            [self.myTableView setAccessibilityElementsHidden:YES];
            break;
        default:
            break;
    }
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index
{
    switch (index) {
        case 0:
            NSLog(@"left button 0 was pressed");
            break;
        case 1:
            NSLog(@"left button 1 was pressed");
            break;
        case 2:
            NSLog(@"left button 2 was pressed");
            break;
        case 3:
            NSLog(@"left btton 3 was pressed");
        default:
            break;
    }
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    switch (index) {
        case 1:
        {
            //            NSLog(@"More button was pressed");
            //            UIAlertView *alertTest = [[UIAlertView alloc] initWithTitle:@"Hello" message:@"More more more" delegate:nil cancelButtonTitle:@"cancel" otherButtonTitles: nil];
            //            [alertTest show];
            //
            //            [cell hideUtilityButtonsAnimated:YES];
            break;
        }
        case 0:
        {
            // Select button was pressed
            NSIndexPath *cellIndexPath = [self.myTableView indexPathForCell:cell];
            NSString *sectionTitle = [_sectionArray objectAtIndex:cellIndexPath.section];
            
            _swipeArrary = [_sectionDict objectForKey:sectionTitle];;
            NSLog(@"Row : %ld",(long)cellIndexPath.row);
//            [self.myTableView deleteRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
            PFUser *friend = [_swipeArrary objectAtIndex:cellIndexPath.row];
            [self removeFriendFromFavorite:friend];
            break;
        }
        default:
            break;
    }
}

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell
{
    // allow just one cell's utility button to be open at once
    return YES;
}

- (BOOL)swipeableTableViewCell:(SWTableViewCell *)cell canSwipeToState:(SWCellState)state
{
    switch (state) {
        case 1:
            // set to NO to disable all left utility buttons appearing
            return YES;
            break;
        case 2:
            // set to NO to disable all right utility buttons appearing
            return YES;
            break;
        default:
            break;
    }
    
    return YES;
}

#pragma mark - UITableViewDelegate

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSString *sectionTitle = [_sectionArray objectAtIndex:section];
    
    NSArray *array = [_sectionDict objectForKey:sectionTitle];
    
    return [array count];
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [self headerView:section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [_sectionArray count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FavoriteCell *cell = (FavoriteCell *)[tableView dequeueReusableCellWithIdentifier:@"FavoriteCell"];
    
    NSLog(@"%f", cell.contentView.size.width);
    [cell setRightUtilityButtons:[self rightButtons] WithButtonWidth:100.0f];
    
    cell.delegate = self;
    NSString *sectionTitle = [_sectionArray objectAtIndex:indexPath.section];
    
    NSArray *array = [_sectionDict objectForKey:sectionTitle];
    NSLog(@"%ld",(long)[array count]);
    _swipeArrary = [_sectionDict objectForKey:sectionTitle];
    
    PFObject *objectUser = [array objectAtIndex:indexPath.row];
    [cell.image setImageWithURL:[objectUser[PF_USER_PICTURE] url] placeholderImage:[UIImage imageNamed:@"placeholder_gb.png"]];
    cell.image.layer.cornerRadius = [cell.image bounds].size.width / 2;
    cell.image.layer.masksToBounds = YES;
    cell.image.layer.borderWidth = 2;
    cell.image.layer.borderColor = [UIColor redColor].CGColor;
    cell.img.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    cell.btnInfo.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    
    cell.lblFullName.text = objectUser[PF_USER_USERNAME];
//    cell.lblLastMessage.text = obj
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PFUser *user1 = [PFUser currentUser];
    NSString *sectionTitle = [_sectionArray objectAtIndex:indexPath.section];
    
    NSArray *array = [_sectionDict objectForKey:sectionTitle];
    PFUser *objectUser = [array objectAtIndex:indexPath.row];
    
    NSString *groupId = StartPrivateChat(objectUser, user1);
    [self actionChat:groupId];
}

- (void)actionChat:(NSString *)groupId
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    ChatView *chatView = [[ChatView alloc] initWith:groupId];
    chatView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chatView animated:YES];
}


@end
