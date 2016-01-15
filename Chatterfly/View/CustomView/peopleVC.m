//
//  peopleVC.m
//  Chatterfly
//
//  Created by dragon on 6/29/15.
//  Copyright (c) 2015 PJ95. All rights reserved.
//

#import "peopleVC.h"

@implementation peopleVC

//PFUser *user1 = [PFUser currentUser];
//NSString *groupId = StartPrivateChat([[[Global sharedInstance].groups objectAtIndex:[Global sharedInstance].dragViewIndex] objectAtIndex:[Global sharedInstance].selectedUserIndex], user1);
//[self actionChat:groupId];

- (void) viewWillAppear:(BOOL)animated{
    //self.navigationController.navigationBarHidden = YES;
}

- (void)actionChat:(NSString *)groupId
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    ChatView *chatView = [[ChatView alloc] initWith:groupId];
    chatView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chatView animated:YES];
}

- (void) searchFromServer:(NSString *)username{

}

#pragma mark -
#pragma mark - UISearchBarDelegate

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    searchBar.showsCancelButton = NO;
    searchBar.text = @"";
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = YES;
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSLog(@"%@", searchText);
}

@end
