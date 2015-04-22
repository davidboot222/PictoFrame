//
//  ShareViewController.m
//  PictoFrame
//
//  Created by Thomas on 9/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ShareViewController.h"
#import "PhotoViewController.h"
#import "FBConnect.h"

@implementation ShareViewController
@synthesize delegate, image;

static NSString* kAppId = @"196815323668389";//@"178002585570135";
//static NSString* kApiKey = @"0b5e5f54d1e83a259fd10a38ef17122d";
//static NSString* kApiSecret = @"9c58db3e2e1aa6de94ff489c05d26564";

#define ACCESS_TOKEN_KEY @"fb_access_token"
#define EXPIRATION_DATE_KEY @"fb_expiration_date"
#define REQUEST_NAME			0
#define REQUEST_ALBUM			1
#define REQUEST_ALBUM_ADD		2
#define REQUEST_UPLOAD			3

@synthesize request_type = _request_type, facebook = _facebook;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        // Custom initialization
        self.navigationItem.title = @"Share";
        
        self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" 
             style:UIBarButtonItemStyleDone target:self action:@selector(procBack)] autorelease];

		_permissions =  [[NSArray arrayWithObjects:
						  @"read_stream", 
						  @"offline_access", 
						  @"publish_stream", 
						  @"read_requests", 
						  @"user_photo_video_tags", 
						  @"friends_photo_video_tags", 
						  @"user_photos", 
						  @"friends_photos", 
						  @"user_videos", 
						  @"friends_videos", 
						  @"read_insights", 
						  @"user_checkins", 
						  @"create_event", 
						  @"publish_checkins", 
						  nil] retain];
    }
    return self;
}

- (void)dealloc
{
	[_facebook release];
	[_permissions release];

    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

    _facebook = [[Facebook alloc] init];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _facebook.accessToken = [defaults objectForKey:ACCESS_TOKEN_KEY];
    _facebook.expirationDate = [defaults objectForKey:EXPIRATION_DATE_KEY];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"Actions";
    } else if (section == 1) {
        return @"Services";
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"Email";
        } else if (indexPath.row == 1) {
            cell.textLabel.text = @"Save to Photo Album";
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"Facebook";
        } else if (indexPath.row == 1) {
            cell.textLabel.text = @"Twitter";
        }
    }
    // Configure the cell...
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [self sendMail:UIImagePNGRepresentation(self.image)];
        } else if (indexPath.row == 1) {
            UIImageWriteToSavedPhotosAlbum(self.image, nil, nil, nil);
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            if ([_facebook isSessionValid]) {
                _request_type = REQUEST_NAME;
                [_facebook requestWithGraphPath:@"me" andDelegate:self];
            } else {
                [_facebook authorize:kAppId permissions:_permissions delegate:self];
            }
        } else if (indexPath.row == 1) {
			alertMain = [[UIAlertView alloc] initWithTitle:@"Twitter Account Details" 
												   message:@"\n\n\n" // IMPORTANT
												  delegate:self 
										 cancelButtonTitle:@"Cancel" 
										 otherButtonTitles:@"Enter", nil];
			
			textField = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 50.0, 260.0, 25.0)]; 
			[textField setBackgroundColor:[UIColor whiteColor]];
			[textField setPlaceholder:@"username"];
			
			[alertMain addSubview:textField];
			
			textField2 = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 85.0, 260.0, 25.0)]; 
			[textField2 setBackgroundColor:[UIColor whiteColor]];
			[textField2 setPlaceholder:@"password"];
			[textField2 setSecureTextEntry:YES];
			
			
			[alertMain addSubview:textField2];
			
			// set place
			[alertMain setTransform:CGAffineTransformMakeTranslation(0.30, 5)]; //////
			[alertMain show];
			[alertMain release];
			
			// set cursor and show keyboard
			[textField becomeFirstResponder];
        }
    }
	[tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
}

- (void) procBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) sendMail:(NSData*)img
{
    MFMailComposeViewController *pickerMail = [[MFMailComposeViewController alloc] init];
    pickerMail.mailComposeDelegate = self;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd MMM yyyy"];
    
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setDateFormat:@"HH:mm:ss"];
    
    NSDate *now = [[NSDate alloc] init];
    
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dateFormatter setLocale:usLocale];
    
    NSString* str_date = [dateFormatter stringFromDate:now];
    NSString* str_time = [timeFormatter stringFromDate:now];
    
    [dateFormatter release];
    [timeFormatter release];
    [now release];
    [usLocale release];
    
    NSString* strDate = [NSString stringWithFormat:@"Picto Frame:%@ %@", str_date, str_time];
    
    [pickerMail setSubject:strDate];
    
    // Attach an image to the email
    [pickerMail addAttachmentData:img mimeType:@"image/png" fileName:@"attach"];
    
    // Fill out the email body text
    NSString *emailBody = @"Made with Picto Frame App!";
    [pickerMail setMessageBody:emailBody isHTML:NO];
    
    [self presentModalViewController:pickerMail animated:YES];
    [pickerMail release];
}

#pragma mark MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{	
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark services
- (void) actionTwitter
{
	if(m_strTwitterUser == nil || m_strTwitterPassword == nil)
	{
		UIAlertView *alt = [[UIAlertView alloc]initWithTitle:@"Twitter Message" message:@"Please login first" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[alt show];
		[alt release];
		return;
	}
	
	TwitpicEngine *twitpicEngine = [[TwitpicEngine alloc] initWithDelegate:self];
	[self AddAlertWindow];
	[twitpicEngine uploadImageToTwitpic:image withMessage:NSLocalizedString(@"To my friends from the Picto Frame App!",@"") 
							   username:m_strTwitterUser password:m_strTwitterPassword];
	[twitpicEngine release];
    
}

-(void)AddAlertWindow
{
	alertMain = [[[UIAlertView alloc] initWithTitle:@"Uploading Photo\nPlease Wait..." message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil] autorelease];
	[alertMain show];
	
	ActivityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	
	// Adjust the indicator so it is up a few pixels from the bottom of the alert
	ActivityIndicator.center = CGPointMake(150, 85);
	[alertMain addSubview:ActivityIndicator];
	[ActivityIndicator startAnimating];
}

- (void)twitpicEngine:(TwitpicEngine *)engine didUploadImageWithResponse:(NSString *)response{
	[ActivityIndicator stopAnimating];
	[alertMain dismissWithClickedButtonIndex:0 animated:YES];
	
	if([response hasPrefix:@"http://"])
	{
		UIAlertView *baseAlert = [[UIAlertView alloc] initWithTitle:@"Photo Uploaded Successfully." message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
		[baseAlert show];
	}
	else if([[response uppercaseString] isEqualToString:@"ERROR"])
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error",@"Error") message:NSLocalizedString(@"Unable to upload Photo",@"Unable to upload Flyers") delegate:nil cancelButtonTitle:NSLocalizedString(@"Dismiss",@"Dismiss") otherButtonTitles: nil];
		[alert show];
		
	}
	else
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error",@"Error") message:response delegate:nil cancelButtonTitle:NSLocalizedString(@"Dismiss",@"Dismiss") otherButtonTitles: nil];
		[alert show];
		
	}
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	if ([alertView title] == @"Twitter Account Details")
	{
		if( buttonIndex == 1)
		{
			m_strTwitterUser = [[NSString alloc] initWithString:textField.text];
			m_strTwitterPassword = [[NSString alloc] initWithString:textField2.text];
            
            [self actionTwitter];
		}
	}
}

- (void) uploadItem
{
	[self AddAlertWindow];
	_request_type = REQUEST_UPLOAD;
	{
		NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
									   _facebook.accessToken,@"access_token",
									   image,@"source",
									   @"upload with PhotoUploader",@"message",
									   nil];
		[_facebook requestWithGraphPath:@"me/photos"
							  andParams:params
						  andHttpMethod:@"POST"
							andDelegate:self];
	}
}

- (void)fbDidLogin {
	_request_type = REQUEST_NAME;
	[_facebook requestWithGraphPath:@"me" andDelegate:self];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:_facebook.accessToken forKey:ACCESS_TOKEN_KEY];
    [defaults setObject:_facebook.expirationDate forKey:EXPIRATION_DATE_KEY];
    [defaults synchronize];
}

-(void)fbDidNotLogin:(BOOL)cancelled {
	NSLog(@"did not login");
}

- (void)fbDidLogout {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:nil forKey:ACCESS_TOKEN_KEY];
    [defaults setObject:nil forKey:EXPIRATION_DATE_KEY];
    [defaults synchronize];
}


- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response {
	NSLog(@"received response");
}

- (void)request:(FBRequest *)request didLoad:(id)result 
{
	if (_request_type == REQUEST_NAME) {
		if ([result isKindOfClass:[NSArray class]]) {
			result = [result objectAtIndex:0];
		}
		[self uploadItem];
	} else if (_request_type == REQUEST_UPLOAD) {
        [self alertSimpleAction:@"Upload successful."];
	}
};

- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
	[self alertSimpleAction:@"Upload fail."];
};

- (void)dialogDidComplete:(FBDialog *)dialog {
}

- (void)alertSimpleAction:(NSString*) strMessage
{
	[ActivityIndicator stopAnimating];
	[alertMain dismissWithClickedButtonIndex:0 animated:YES];

	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Photo Uploader" message:strMessage
												   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
	[alert show];	
	[alert release];
}

@end
