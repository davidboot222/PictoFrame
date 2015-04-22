//
//  ShareViewController.h
//  PictoFrame
//
//  Created by Thomas on 9/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "FBConnect.h"
#import "FBLoginButton.h"
#import "FBVideoUpload.h"
#import "TwitpicEngine.h" // API used for Twitter

@class PhotoViewController;

@interface ShareViewController : UITableViewController<FBRequestDelegate, FBDialogDelegate, FBSessionDelegate, MFMailComposeViewControllerDelegate, TwitpicEngineDelegate> {
    PhotoViewController* delegate;
    UIImage*             image;
	UIPopoverController *curPopover;

    NSString*		m_strTwitterUser;
    NSString*		m_strTwitterPassword;
    UIAlertView*    alertMain;
    UITextField*    textField;
    UITextField*    textField2;
	UIActivityIndicatorView *ActivityIndicator;

	Facebook*				_facebook;
	NSArray*				_permissions;
}

@property(nonatomic, retain) PhotoViewController* delegate;
@property(nonatomic, retain) UIImage* image;
@property(readonly) int request_type;
@property(readonly) Facebook *facebook;

- (void) sendMail:(NSData*)img;
- (void) AddAlertWindow;
- (void) actionTwitter;
- (void)alertSimpleAction:(NSString*) strMessage;

@end
