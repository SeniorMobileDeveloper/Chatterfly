//
//  SearchVC.m
//  Chatterfly
//
//  Created by Frank on 7/10/15.
//  Copyright (c) 2015 PJ95. All rights reserved.
//

#import "SearchVC.h"
#import <UIKit/UIKit.h>
#import "SearchCell.h"

@interface SearchVC ()

@end

@implementation SearchVC

- (void)viewDidLoad {
    [super viewDidLoad]; 

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton= YES;
    NSLog(@"Search Begin");
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    searchBar.showsCancelButton = NO;
    searchBar.text = @"";

}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    searchBar.showsCancelButton = NO;
    
    [self searchArray:searchBar.text];
    
}

-(void) searchArray:(NSString*) strText
{
    PFQuery *query = [PFUser query];
    [query whereKey:PF_USER_USERNAME containsString:[strText lowercaseString]];
    [query whereKey:PF_USER_USERNAME notEqualTo:[PFUser currentUser][PF_USER_USERNAME]];
    
    _searchResults = [query findObjects];
    
    if([_searchResults count] == 0)
    {
        UIAlertView *alertView1 = [[UIAlertView alloc] initWithTitle:APP_NAME message:@"No Search Result!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView1 show];
    }else
    {
        [self.myTableView reloadData];
    }
    
}

#pragma mark - UITableViewDelegate

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [_searchResults count];
    
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
     SearchCell *cell = (SearchCell *)[tableView dequeueReusableCellWithIdentifier:@"SearchCell"];
    
    PFObject *objectUser = [_searchResults objectAtIndex:indexPath.row];
    [cell.image setImageWithURL:[objectUser[PF_USER_PICTURE] url] placeholderImage:[UIImage imageNamed:@"placeholder_gb.png"]];
    cell.image.layer.cornerRadius = [cell.image bounds].size.width / 2;
    cell.image.layer.masksToBounds = YES;
    cell.image.layer.borderWidth = 2;
    cell.image.layer.borderColor = [UIColor redColor].CGColor;
    
    cell.lblFullName.text = objectUser[PF_USER_USERNAME];
    
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PFUser *otherUser = [_searchResults objectAtIndex:indexPath.row];
    PFUser *currentUser = [PFUser currentUser];

    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:APP_NAME message:@"Do you want to chat this user?"  delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:@"Cancel", nil];
    
    [alertView showWithCompletion:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == 0){
            
            NSString *groupId = StartPrivateChat(otherUser, currentUser);
            [self actionChat:groupId user : otherUser];

        }
    }];
}

- (void)actionChat:(NSString *)groupId user:(PFUser*) user
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    
    ChatView *chatView = [[ChatView alloc] initWith:groupId];
    chatView.oppUser = user;
    chatView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chatView animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
