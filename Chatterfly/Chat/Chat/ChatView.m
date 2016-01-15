//
// Copyright (c) 2015 Related Code - http://relatedcode.com
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <MediaPlayer/MediaPlayer.h>

#import <Parse/Parse.h>
#import "ProgressHUD.h"

#import "Public.h"
#import "camera.h"
#import "messages.h"
#import "pushnotification.h"

#import "ChatView.h"
#import <MessageUI/MFMailComposeViewController.h>
#import <MessageUI/MFMessageComposeViewController.h>

//#import "RootFriendProfileViewController.h"

#import "MWPhoto.h"
#import "MWPhotoBrowser.h"
#import "IQFeedbackView.h"

//-------------------------------------------------------------------------------------------------------------------------------------------------
@interface ChatView()< MFMailComposeViewControllerDelegate,MWPhotoBrowserDelegate>
{
	NSTimer *timer;
	BOOL isLoading;
	BOOL initialized;

	NSString *groupId;

	NSMutableArray *users;
	NSMutableArray *messages;
	NSMutableDictionary *avatars;

	JSQMessagesBubbleImage *bubbleImageOutgoing;
	JSQMessagesBubbleImage *bubbleImageIncoming;
	JSQMessagesAvatarImage *avatarImageBlank;
    
    PFUser *oppUser;
    UIView *popupView;
}

@property (nonatomic, strong) NSMutableArray *photos;

@end
//-------------------------------------------------------------------------------------------------------------------------------------------------

@implementation ChatView
@synthesize oppUser;
//-------------------------------------------------------------------------------------------------------------------------------------------------
- (id)initWith:(NSString *)groupId_
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	self = [super init];
	groupId = groupId_;
	return self;
}

- (void) showUserDetail{
    if (!oppUser) return;
    detailUserVC *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"detailUserVC"];
    vc.user = oppUser;
    [self.navigationController pushViewController:vc animated:YES];
}
//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidLoad

//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[super viewDidLoad];
    [[KIProgressViewManager manager] showProgressOnView:self.view];

    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Details" style:UIBarButtonItemStylePlain target:self action:@selector(showUserDetail)];
    self.navigationItem.rightBarButtonItem = anotherButton;
    
    
//    UIBarButtonItem *item_down = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"downArrow.png"] style:UIBarButtonItemStylePlain target:self action:@selector(itemBanClicked:)];
//    self.navigationItem.rightBarButtonItem = item_down;
    
    popupView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, pubWidth, 80)];
    UIButton *btnBan = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, pubWidth, 40)];
    [btnBan setTitle:@" Ban User from contacting you" forState:UIControlStateNormal];
    [btnBan setImage:[[UIImage imageNamed:@"banIcon.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]forState:UIControlStateNormal];
    [btnBan setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [btnBan setTintColor:[UIColor whiteColor]];
    [btnBan.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
    [btnBan setBackgroundColor:COLOR_MENU];
    [btnBan setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnBan addTarget:self action:@selector(btnBanClicked:) forControlEvents:UIControlEventTouchUpInside];
    [popupView addSubview:btnBan];
    
    UIButton *btnFlag = [[UIButton alloc] initWithFrame:CGRectMake(0, 40, pubWidth, 40)];
    [btnFlag setTitle:@" Flag user for inappropriate content" forState:UIControlStateNormal];
    [btnFlag setBackgroundColor:COLOR_MENU];
    [btnFlag.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
    [btnFlag setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnFlag setTintColor:[UIColor whiteColor]];
    [btnFlag setImage:[[UIImage imageNamed:@"flagIcon.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [btnFlag setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [btnFlag addTarget:self action:@selector(btnFlagClicked:) forControlEvents:UIControlEventTouchUpInside];
    [popupView addSubview:btnFlag];
    
    UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 0, pubWidth-60, 1)];
    lineImageView.backgroundColor = [UIColor darkGrayColor];
    lineImageView.centerY = 40;
    [popupView addSubview:lineImageView];
    
    popupView.bottom = 0;

    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"flagIcon.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] style:UIBarButtonItemStylePlain target:self action:@selector(flagBtnClicked)];

	//---------------------------------------------------------------------------------------------------------------------------------------------
	users = [[NSMutableArray alloc] init];
	messages = [[NSMutableArray alloc] init];
	avatars = [[NSMutableDictionary alloc] init];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	PFUser *user = [PFUser currentUser];
	self.senderId = user.objectId;
	self.senderDisplayName = user[PF_USER_USERNAME];
    
    self.title = oppUser[PF_USER_USERNAME];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] init];
	bubbleImageOutgoing = [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleLightGrayColor]];
	bubbleImageIncoming = [bubbleFactory incomingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleGreenColor]];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	avatarImageBlank = [JSQMessagesAvatarImageFactory avatarImageWithImage:[UIImage imageNamed:@"chat_blank"] diameter:30.0];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	isLoading = NO;
	initialized = NO;
    //self.title = @"Chat";
	[self loadMessages];
}

- (void)showPopup {
    [self.view addSubview:popupView];
    [UIView animateWithDuration:0.3 animations:^{
        popupView.transform= CGAffineTransformMakeTranslation(0, 80);
    }];
}
- (void)hidePopup {
    [self.view addSubview:popupView];
    [UIView animateWithDuration:0.3 animations:^{
        popupView.transform= CGAffineTransformIdentity;
    }];
}
- (void)itemBanClicked:(id) sender {

    if(popupView.bottom > 0) {
        [self hidePopup];
    } else {
        [self showPopup];
    }
    
}
- (void)btnBanClicked:(id) sender {
    
    [self hidePopup];
    NSArray *banArray = [PFUser currentUser][PF_USER_BANS];
    if(!banArray)
        banArray = [NSArray array];
    NSMutableArray *newBanArray = [NSMutableArray arrayWithArray:banArray];
    [newBanArray addObject:self.oppUser.objectId];
    [PFUser currentUser][PF_USER_BANS] = newBanArray;
    [[PFUser currentUser] saveInBackground];
    
}
- (void)btnFlagClicked:(id) sender {
    [self hidePopup];
    
    IQFeedbackView *feedback = [[IQFeedbackView alloc] initWithTitle:@"Report" message:nil image:nil cancelButtonTitle:@"Cancel" doneButtonTitle:@"Send"];
    [feedback setCanAddImage:NO];
    [feedback setCanEditText:YES];
    
    [feedback showInViewController:self completionHandler:^(BOOL isCancel, NSString *message, UIImage *image) {
        [feedback dismiss];
        if(!isCancel && ![message isEqualToString:@""]) {
            
            PFObject *object = [PFObject objectWithClassName:PF_FLAG_CLASS];
            object[PF_FLAG_REASON] = message;
            if([PFUser currentUser][PF_USER_EMAIL])
                object[PF_FLAG_USER] = [PFUser currentUser][PF_USER_EMAIL];
            if(self.oppUser[PF_USER_EMAIL])
                object[PF_FLAG_REPORTER] = self.oppUser[PF_USER_EMAIL];
            object[PF_FLAG_TIME] = [NSDate date];
            [object saveInBackground];
            
        }
    }];
    
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)viewWillAppear:(BOOL)animated
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    self.navigationController.navigationBarHidden = NO;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidAppear:(BOOL)animated
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[super viewDidAppear:animated];
	self.collectionView.collectionViewLayout.springinessEnabled = YES;
	timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(loadMessages) userInfo:nil repeats:YES];
}


//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)viewWillDisappear:(BOOL)animated
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[super viewWillDisappear:animated];
	ClearMessageCounter(groupId);
	[timer invalidate];
}

#pragma mark - Backend methods

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)loadMessages
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	if (isLoading == NO)
	{
		isLoading = YES;
		JSQMessage *message_last = [messages lastObject];

		PFQuery *query = [PFQuery queryWithClassName:PF_CHAT_CLASS_NAME];
		[query whereKey:PF_CHAT_GROUPID equalTo:groupId];
		if (message_last != nil) [query whereKey:PF_CHAT_CREATEDAT greaterThan:message_last.date];
		[query includeKey:PF_CHAT_USER];
		[query orderByDescending:PF_CHAT_CREATEDAT];
		[query setLimit:50];
		[query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
		{
			if (error == nil)
			{
				BOOL incoming = NO;
				self.automaticallyScrollsToMostRecentMessage = NO;
				for (PFObject *object in [objects reverseObjectEnumerator])
				{
					JSQMessage *message = [self addMessage:object];
					if ([self incoming:message]) incoming = YES;
				}
				if ([objects count] != 0)
				{
					if (initialized && incoming)
						[JSQSystemSoundPlayer jsq_playMessageReceivedSound];
					[self finishReceivingMessage];
					[self scrollToBottomAnimated:NO];
				}
				self.automaticallyScrollsToMostRecentMessage = YES;
				initialized = YES;
                
                for(PFUser *user in users) {
                    if(![user.objectId isEqualToString:[PFUser currentUser].objectId]) {
                        self.title = user[PF_USER_USERNAME];
                        
                        oppUser = user;
                    }
                }
                [[KIProgressViewManager manager] hideProgressView];
			}

			else [ProgressHUD showError:@"Network error."];
			isLoading = NO;
		}];
	}
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (JSQMessage *)addMessage:(PFObject *)object
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	JSQMessage *message;
	//---------------------------------------------------------------------------------------------------------------------------------------------
	PFUser *user = object[PF_CHAT_USER];
	NSString *name = user[PF_USER_FULLNAME];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	PFFile *fileVideo = object[PF_CHAT_VIDEO];
	PFFile *filePicture = object[PF_CHAT_PICTURE];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	if ((filePicture == nil) && (fileVideo == nil))
	{
		message = [[JSQMessage alloc] initWithSenderId:user.objectId senderDisplayName:name date:object.createdAt text:object[PF_CHAT_TEXT]];
	}
	//---------------------------------------------------------------------------------------------------------------------------------------------
	if (fileVideo != nil)
	{
		JSQVideoMediaItem *mediaItem = [[JSQVideoMediaItem alloc] initWithFileURL:[NSURL URLWithString:fileVideo.url] isReadyToPlay:YES];
		mediaItem.appliesMediaViewMaskAsOutgoing = [user.objectId isEqualToString:self.senderId];
		message = [[JSQMessage alloc] initWithSenderId:user.objectId senderDisplayName:name date:object.createdAt media:mediaItem];
	}
	//---------------------------------------------------------------------------------------------------------------------------------------------
	if (filePicture != nil)
	{
		JSQPhotoMediaItem *mediaItem = [[JSQPhotoMediaItem alloc] initWithImage:nil];
		mediaItem.appliesMediaViewMaskAsOutgoing = [user.objectId isEqualToString:self.senderId];
		message = [[JSQMessage alloc] initWithSenderId:user.objectId senderDisplayName:name date:object.createdAt media:mediaItem];
		//-----------------------------------------------------------------------------------------------------------------------------------------
		[filePicture getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error)
		{
			if (error == nil)
			{
				mediaItem.image = [UIImage imageWithData:imageData];
				[self.collectionView reloadData];
			}
		}];
	}
	//---------------------------------------------------------------------------------------------------------------------------------------------
	[users addObject:user];
	[messages addObject:message];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	return message;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)sendMessage:(NSString *)text Video:(NSURL *)video Picture:(UIImage *)picture
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	PFFile *fileVideo = nil;
	PFFile *filePicture = nil;
	//---------------------------------------------------------------------------------------------------------------------------------------------
	if (video != nil)
	{
		text = @"[Video message]";
		fileVideo = [PFFile fileWithName:@"video.mp4" data:[[NSFileManager defaultManager] contentsAtPath:video.path]];
		[fileVideo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
		{
			if (error != nil) [ProgressHUD showError:@"Network error."];
		}];
	}
	//---------------------------------------------------------------------------------------------------------------------------------------------
	if (picture != nil)
	{
		text = @"[Picture message]";
		filePicture = [PFFile fileWithName:@"picture.jpg" data:UIImageJPEGRepresentation(picture, 0.6)];
		[filePicture saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
		{
			if (error != nil) [ProgressHUD showError:@"Picture save error."];
		}];
	}
	//---------------------------------------------------------------------------------------------------------------------------------------------
	PFObject *object = [PFObject objectWithClassName:PF_CHAT_CLASS_NAME];
	object[PF_CHAT_USER] = [PFUser currentUser];
	object[PF_CHAT_GROUPID] = groupId;
	object[PF_CHAT_TEXT] = text;
	if (fileVideo != nil) object[PF_CHAT_VIDEO] = fileVideo;
	if (filePicture != nil) object[PF_CHAT_PICTURE] = filePicture;
	[object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
	{
		if (error == nil)
		{
			[JSQSystemSoundPlayer jsq_playMessageSentSound];
			[self loadMessages];
		}
		else [ProgressHUD showError:@"Network error."];;
	}];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	SendPushNotification(groupId, text);
	UpdateMessageCounter(groupId, text);
	//---------------------------------------------------------------------------------------------------------------------------------------------
	[self finishSendingMessage];
}

#pragma mark - JSQMessagesViewController method overrides

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)didPressSendButton:(UIButton *)button withMessageText:(NSString *)text senderId:(NSString *)senderId senderDisplayName:(NSString *)senderDisplayName date:(NSDate *)date
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    NSArray *banArray = oppUser[PF_USER_BANS];
    
    if(!banArray)
        banArray = [NSArray array];
    
    if([banArray containsObject:[PFUser currentUser].objectId]) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Project6 Notice" message:@"You are banned! Cannot find the user!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alertView show];
        
    } else {
        
        [self sendMessage:text Video:nil Picture:nil];
        
    }

}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)didPressAccessoryButton:(UIButton *)sender
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil
											   otherButtonTitles:@"Take photo or video", @"Choose existing photo", @"Choose existing video", nil];
	[action showInView:self.view];
}

#pragma mark - JSQMessages CollectionView DataSource

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	return messages[indexPath.item];
}
//-------------------------------------------------------------------------------------------------------------------------------------------------
- (id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView
			 messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	if ([self outgoing:messages[indexPath.item]])
	{
		return bubbleImageOutgoing;
	}
	else return bubbleImageIncoming;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView
					avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	PFUser *user = users[indexPath.item];
	if (avatars[user.objectId] == nil)
	{
		PFFile *file = user[PF_USER_THUMBNAIL];
		[file getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error)
		{
			if (error == nil)
			{
				avatars[user.objectId] = [JSQMessagesAvatarImageFactory avatarImageWithImage:[UIImage imageWithData:imageData] diameter:30.0];
				[self.collectionView reloadData];
			}
		}];
		return avatarImageBlank;
	}
	else return avatars[user.objectId];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	if (indexPath.item % 3 == 0)
	{
		JSQMessage *message = messages[indexPath.item];
		return [[JSQMessagesTimestampFormatter sharedFormatter] attributedTimestampForDate:message.date];
	}
	else return nil;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	JSQMessage *message = messages[indexPath.item];
	if ([self incoming:message])
	{
		if (indexPath.item > 0)
		{
			JSQMessage *previous = messages[indexPath.item-1];
			if ([previous.senderId isEqualToString:message.senderId])
			{
				return nil;
			}
		}
		return [[NSAttributedString alloc] initWithString:message.senderDisplayName];
	}
	else return nil;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	return nil;
}

#pragma mark - UICollectionView DataSource

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	return [messages count];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (UICollectionViewCell *)collectionView:(JSQMessagesCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];

	if ([self outgoing:messages[indexPath.item]])
	{
		cell.textView.textColor = [UIColor blackColor];
	}
	else
	{
		cell.textView.textColor = [UIColor whiteColor];
	}
	return cell;
}

#pragma mark - JSQMessages collection view flow layout delegate

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
				   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	if (indexPath.item % 3 == 0)
	{
		return kJSQMessagesCollectionViewCellLabelHeightDefault;
	}
	else return 0;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
				   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	JSQMessage *message = messages[indexPath.item];
	if ([self incoming:message])
	{
		if (indexPath.item > 0)
		{
			JSQMessage *previous = messages[indexPath.item-1];
			if ([previous.senderId isEqualToString:message.senderId])
			{
				return 0;
			}
		}
		return kJSQMessagesCollectionViewCellLabelHeightDefault;
	}
	else return 0;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
				   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	return 0;
}

#pragma mark - Responding to collection view tap events

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)collectionView:(JSQMessagesCollectionView *)collectionView
				header:(JSQMessagesLoadEarlierHeaderView *)headerView didTapLoadEarlierMessagesButton:(UIButton *)sender
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	NSLog(@"didTapLoadEarlierMessagesButton");
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapAvatarImageView:(UIImageView *)avatarImageView
		   atIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	NSLog(@"didTapAvatarImageView");
    NSLog(@"%@",indexPath);
    JSQMessage *message = [messages objectAtIndex:indexPath.row];
    NSLog(@"%@",message);
    
    if(![message.senderId isEqualToString:[PFUser currentUser].objectId]) {
        PFQuery *query = [PFUser query];
        [query whereKey:PF_USER_OBJECTID equalTo:message.senderId];
        [[KIProgressViewManager manager] showProgressOnView:self.view];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            [[KIProgressViewManager manager] hideProgressView];
            if(!error) {
                if(objects.count > 0 ) {
//                    PFUser *user = [objects firstObject];
//                    RootFriendProfileViewController *rootFriendProfileViewCtrl = [[RootFriendProfileViewController alloc] init];
//                    rootFriendProfileViewCtrl.user = user;
//                    rootFriendProfileViewCtrl.type = 9;
//                    [self.navigationController pushViewController:rootFriendProfileViewCtrl animated:YES];
                    
                }
            }
        }];
    }
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapMessageBubbleAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	JSQMessage *message = messages[indexPath.item];
	if (message.isMediaMessage)
	{
		if ([message.media isKindOfClass:[JSQVideoMediaItem class]])
		{
			JSQVideoMediaItem *mediaItem = (JSQVideoMediaItem *)message.media;
			MPMoviePlayerViewController *moviePlayer = [[MPMoviePlayerViewController alloc] initWithContentURL:mediaItem.fileURL];
			[self presentMoviePlayerViewControllerAnimated:moviePlayer];
			[moviePlayer.moviePlayer play];
        } else if([message.media isKindOfClass:[JSQPhotoMediaItem class]]) {
            JSQPhotoMediaItem *mediaItem = (JSQPhotoMediaItem *)message.media;

            MWPhoto *photo;
            BOOL displayActionButton = YES;
            BOOL displaySelectionButtons = NO;
            BOOL displayNavArrows = NO;
            BOOL enableGrid = NO;
            BOOL startOnGrid = NO;
            
            
            NSMutableArray *photos = [[NSMutableArray alloc] init];
            photo = [MWPhoto photoWithImage:mediaItem.image];
            [photos addObject:photo];
            self.photos = photos;
            
            MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
            browser.displayActionButton = displayActionButton;
            browser.displayNavArrows = displayNavArrows;
            browser.displaySelectionButtons = displaySelectionButtons;
            browser.alwaysShowControls = displaySelectionButtons;
            browser.zoomPhotosToFill = YES;
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
            browser.wantsFullScreenLayout = YES;
#endif
            browser.enableGrid = enableGrid;
            browser.startOnGrid = startOnGrid;
            browser.enableSwipeToDismiss = YES;
            browser.enableDeleteBtn = NO;
            [browser setCurrentPhotoIndex:0];
            
            UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:browser];
            nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self presentViewController:nc animated:YES completion:nil];
            
            
            double delayInSeconds = 3;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                
            });

            
        }
	}
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapCellAtIndexPath:(NSIndexPath *)indexPath touchLocation:(CGPoint)touchLocation
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	NSLog(@"didTapCellAtIndexPath %@", NSStringFromCGPoint(touchLocation));
}

#pragma mark - UIActionSheetDelegate

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	if (buttonIndex != actionSheet.cancelButtonIndex)
	{
		if (buttonIndex == 0)	ShouldStartMultiCamera(self, YES);
		if (buttonIndex == 1)	ShouldStartPhotoLibrary(self, YES);
		if (buttonIndex == 2)	ShouldStartVideoLibrary(self, YES);
	}
}

#pragma mark - UIImagePickerControllerDelegate

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	NSURL *video = info[UIImagePickerControllerMediaURL];
	UIImage *picture = info[UIImagePickerControllerEditedImage];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	[self sendMessage:nil Video:video Picture:picture];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	[picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Helper methods

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (BOOL)incoming:(JSQMessage *)message
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	return ([message.senderId isEqualToString:self.senderId] == NO);
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (BOOL)outgoing:(JSQMessage *)message
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	return ([message.senderId isEqualToString:self.senderId] == YES);
}
- (void)flagBtnClicked {
    self.navigationItem.rightBarButtonItem.enabled = NO;
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
        mailViewController.mailComposeDelegate = self;
        NSArray *toRecipients = [NSArray arrayWithObjects:@"glenchiu@live.com",@"kenny4657@msn.com", nil];
        [mailViewController setToRecipients:toRecipients];
        [mailViewController setSubject:@"Report"];
        [mailViewController setMessageBody:@"Please note contents you want to report" isHTML:YES];
        [self.navigationController presentViewController:mailViewController animated:YES completion:nil];
        
    } else {
        NSLog(@"Not Able to Mail");
    }

}
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [controller dismissViewControllerAnimated:YES completion:nil];
    
    if (result == MFMailComposeResultCancelled) {
        //NSLog(@"Mail cancelled");
    } else if (result == MFMailComposeResultFailed) {
        //NSLog(@"Mail fialed");
    } else if (result == MFMailComposeResultSent) {
        //NSLog(@"Completely Sent");
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
    
}

#pragma mark - MWPhotoBrowserDelegate

- (void)photoBrowserDidFinishModalPresentation:(MWPhotoBrowser *)photoBrowser {
    // If we subscribe to this method we must dismiss the view controller ourselves
    NSLog(@"Did finish modal presentation");
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _photos.count)
        return [_photos objectAtIndex:index];
    return nil;
}
@end
