//
//  PFDatabase.h
//  Restarant
//
//  Created by PJ95 on 5/29/15.
//  Copyright (c) 2015 PJ95. All rights reserved.
//

#ifndef Restarant_PFDatabase_h
#define Restarant_PFDatabase_h

#define		PF_USER_CLASS_NAME					@"_User"				//	Class name
#define		PF_USER_OBJECTID					@"objectId"				//	String
#define		PF_USER_USERNAME					@"myusername"				//	String
#define		PF_USER_PASSWORD					@"password"				//	String
#define		PF_USER_EMAIL						@"email"				//	String
#define		PF_USER_FULLNAME					@"fullname"				//	String
#define		PF_USER_FIRSTNAME					@"firstname"			//	String
#define		PF_USER_LASTNAME					@"lastname"				//	String
#define		PF_USER_FACEBOOKID					@"facebookId"			//	String
#define     PF_USER_ONLINE_STATUS               @"online_status"
#define		PF_USER_PICTURE						@"picture"				//	URL
#define		PF_USER_THUMBNAIL					@"thumbnail"			//	File
#define     PF_USER_ABOUT_ME                    @"about_me"
#define     PF_USER_ABOUT_LIFE                  @"about_life"
#define     PF_USER_ABOUT_YOU                   @"about_you"
#define     PF_USER_CRONES                      @"crones"
#define     PF_USER_BIRTHDAY                    @"birthday"
#define     PF_USER_GENDER                      @"gender"
#define     PF_USER_AGE                         @"age"
#define     PF_USER_ZIPCODE                     @"zipcode"
#define     PF_USER_L_GENDER                    @"l_gender"
#define     PF_USER_L_DISTANCE                  @"l_distance"
#define     PF_USER_L_MINAGE                    @"min_age"
#define     PF_USER_L_MAXAGE                    @"max_age"
#define     PF_USER_ETHNICITY                   @"ethnicity"
#define     PF_USER_BELIEF                      @"belief"
#define     PF_USER_GEOLOCATION                 @"geolocation"
#define     PF_USER_MY_BELIEF                   @"mybelief"
#define     PF_USER_MY_ETHNICITY                @"myethnicity"
#define     PF_USER_QUESTIONNAIRE               @"questionnaire"
#define     PF_USER_QUESTIONNAIRE_MY_ANSWER     @"questionnaire_my_answer"
#define     PF_USER_QUESTIONNAIRE_YOUR_ANSWER   @"questionnaire_your_answer"
#define     PF_USER_BANS                        @"bans"
#define     PF_USER_FRIENDS                     @"friends"
#define     PF_USER_BLOCKS                      @"blocks"
#define     PF_USER_GROUP_ID                    @"group_id"
#define     PF_USER_LOGIN_STATUS                @"login_status"

// Questions - User Field
#define     PF_USER_Q_                          @"question_"

#define     PF_QUESTION_CLASS_NAME              @"Question"
#define     PF_QUESTION_POSITIVE                @"positive"
#define     PF_QUESTION_NEGATIVE                @"negative"

#define     PF_PHOTO_GALLERY_CLASS_NAME         @"PhotoGallery"
#define     PF_PHOTO_USER                       @"user"
#define     PF_PHOTO_PICTURE                    @"picture"
#define     PF_PHOTO_THUMB                      @"thumb"
#define     PF_PHOTO_EDITED_PICTURE             @"editedPicture"

#define     PF_ETHIC_CLASS                      @"Ethic"
#define     PF_ETHIC_CONTENT                    @"content"

#define     PF_BELIEF_CLASS                     @"Belief"
#define     PF_BELIEF_CONTENT                   @"content"

#define     PF_QUESTIONNAIRE_CLASS_NAME         @"Questionnaire"
#define     PF_QUESTIONNAIRE_CONTENT            @"content"
#define     PF_QUESTIONNAIRE_ANSWERS            @"answers"
#define     PF_QUESTIONNAIRE_SCORES             @"scores"


#define     PF_FLAG_CLASS                       @"Flag"
#define     PF_FLAG_USER                        @"user"
#define     PF_FLAG_REPORTER                    @"reporter"
#define     PF_FLAG_TIME                        @"time"
#define     PF_FLAG_TYPE                        @"type"
#define     PF_FLAG_REASON                      @"reason"

#define     PF_PROFILEOVERVIEW_CLASS            @"ProfileOverview"
#define     PF_PROFILEOVERVIEW_TITLE            @"title"
#define     PF_PROFILEOVERVIEW_COLNAME          @"column_name"

#define     PF_KRONELIMIT_CLASS                 @"KroneLimit"
#define     PF_KRONELIMIT_VALUE                 @"value"
#define     PF_KRONELIMIT_KEY                   @"key"
#define     PF_KRONELIMIT_KEY_MATCH_LIMIT       @"MatchLimit"
#define     PF_KRONELIMIT_KEY_UNLOCK_LIMIT      @"UnlockLimit"
#define     PF_KRONELIMIT_KEY_MORE_LIMIT        @"MoreMatchLimit"

#define     PF_FREEKRONE_CLASS                  @"FreeKrones"
#define     PF_FREEKRONE_TYPE                   @"type"
#define     PF_FREEKRONE_CONTENT                @"content"
#define     PF_FREEKRONE_OWNER                  @"owner"

// Chat Fields
#define		PF_INSTALLATION_CLASS_NAME			@"_Installation"		//	Class name
#define		PF_INSTALLATION_OBJECTID			@"objectId"				//	String
#define		PF_INSTALLATION_USER				@"user"					//	Pointer to User Class
//-----------------------------------------------------------------------
#define		PF_USER_EMAILCOPY					@"emailCopy"			//	String
#define		PF_USER_FULLNAME_LOWER				@"fullname_lower"		//	String

//-----------------------------------------------------------------------
#define		PF_CHAT_CLASS_NAME					@"Chat"					//	Class name
#define		PF_CHAT_USER						@"user"					//	Pointer to User Class
#define		PF_CHAT_GROUPID						@"groupId"				//	String
#define		PF_CHAT_TEXT						@"text"					//	String
#define		PF_CHAT_PICTURE						@"picture"				//	File
#define		PF_CHAT_VIDEO						@"video"				//	File
#define		PF_CHAT_CREATEDAT					@"createdAt"			//	Date
//-----------------------------------------------------------------------
#define		PF_GROUPS_CLASS_NAME				@"Groups"				//	Class name
#define		PF_GROUPS_NAME						@"name"					//	String
//-----------------------------------------------------------------------
#define		PF_MESSAGES_CLASS_NAME				@"Messages"				//	Class name
#define		PF_MESSAGES_USER					@"user"					//	Pointer to User Class
#define		PF_MESSAGES_GROUPID					@"groupId"				//	String
#define		PF_MESSAGES_DESCRIPTION				@"description"			//	String
#define		PF_MESSAGES_LASTUSER				@"lastUser"				//	Pointer to User Class
#define		PF_MESSAGES_LASTMESSAGE				@"lastMessage"			//	String
#define		PF_MESSAGES_COUNTER					@"counter"				//	Number
#define		PF_MESSAGES_UPDATEDACTION			@"updatedAction"		//	Date
//-------------------------------------------------------------------------------------------------------------------------------------------------
#define		NOTIFICATION_APP_STARTED			@"NCAppStarted"
#define		NOTIFICATION_USER_LOGGED_IN			@"NCUserLoggedIn"
#define		NOTIFICATION_USER_LOGGED_OUT		@"NCUserLoggedOut"

// Cloud code

#define     PF_MAIL_TITLE                       @"mail_title"
#define     PF_MAIL_MESSAGE                     @"mail_message"
#define     PF_MAIL_FROM_USER                   @"mail_fromUser"
#define     PF_MAIL_TYPE                        @"mail_type"

#define     USER_FIRST_INSTALL                  @"user_first_install"

#endif
