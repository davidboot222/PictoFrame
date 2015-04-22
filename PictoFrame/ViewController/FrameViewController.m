//
//  FrameViewController.m
//  PictoFrame
//
//  Created by KRS on 9/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FrameViewController.h"
#import "PhotoViewController.h"

@implementation FrameViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
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
    // Do any additional setup after loading the view from its nib.
    [segment addTarget:self action:@selector(updateFrameType:) forControlEvents:UIControlEventValueChanged];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) updateFrameType:(UISegmentedControl*)seg
{
    [self setFrameType:seg.selectedSegmentIndex];
}

- (IBAction) onBtnFrame1:(id)sender
{
    [self selectFrame:1 SUB:1];
}

- (IBAction) onBtnFrame2:(id)sender
{
    [self selectFrame:2 SUB:1];
}

- (IBAction) onBtnFrame3:(id)sender
{
    [self selectFrame:2 SUB:2];
}

- (IBAction) onBtnFrame4:(id)sender
{
    [self selectFrame:3 SUB:1];
}

- (IBAction) onBtnFrame5:(id)sender
{
    [self selectFrame:3 SUB:2];
}

- (IBAction) onBtnFrame6:(id)sender
{
    [self selectFrame:3 SUB:3];
}

- (IBAction) onBtnFrame7:(id)sender
{
    [self selectFrame:3 SUB:4];
}

- (IBAction) onBtnFrame8:(id)sender
{
    [self selectFrame:3 SUB:5];
}

- (IBAction) onBtnFrame9:(id)sender
{
    [self selectFrame:3 SUB:6];
}

- (IBAction) onBtnFrame10:(id)sender
{
    [self selectFrame:4 SUB:1];
}

- (IBAction) onBtnFrame11:(id)sender
{
    [self selectFrame:4 SUB:2];
}

- (IBAction) onBtnFrame12:(id)sender
{
    [self selectFrame:4 SUB:3];
}

- (IBAction) onBtnFrame13:(id)sender
{
    [self selectFrame:4 SUB:4];
}

- (IBAction) onBtnFrame14:(id)sender
{
    [self selectFrame:4 SUB:5];
}

- (IBAction) onBtnFrame15:(id)sender
{
    [self selectFrame:4 SUB:6];
}

- (IBAction) onBtnFrame16:(id)sender
{
    [self selectFrame:4 SUB:7];
}

- (void) setFrameType:(int)mode
{
    nMode = mode;
    int newWidth = 0;
    int newHeight = 0;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        switch (mode) {
            case 0://1:1
                newWidth = 120; newHeight = 120;
                break;
            case 1://4:3
                newWidth = 120; newHeight = 90;
                break;
            case 2://3:4
                newWidth = 90; newHeight = 120;
                break;
            case 3://3:2
                newWidth = 120; newHeight = 80;
                break;
            default:
                break;
        }
    }
    else 
    {
        switch (mode) {
            case 0://1:1
                newWidth = 60; newHeight = 60;
                break;
            case 1://4:3
                newWidth = 60; newHeight = 45;
                break;
            case 2://3:4
                newWidth = 45; newHeight = 60;
                break;
            case 3://3:2
                newWidth = 60; newHeight = 40;
                break;
            default:
                break;
        }
    }
    
    btnFrame1.frame =  CGRectMake(btnFrame1.center.x-newWidth/2,  btnFrame1.center.y-newHeight/2,  newWidth, newHeight);
    btnFrame2.frame =  CGRectMake(btnFrame2.center.x-newWidth/2,  btnFrame2.center.y-newHeight/2,  newWidth, newHeight);
    btnFrame3.frame =  CGRectMake(btnFrame3.center.x-newWidth/2,  btnFrame3.center.y-newHeight/2,  newWidth, newHeight);
    btnFrame4.frame =  CGRectMake(btnFrame4.center.x-newWidth/2,  btnFrame4.center.y-newHeight/2,  newWidth, newHeight);
    btnFrame5.frame =  CGRectMake(btnFrame5.center.x-newWidth/2,  btnFrame5.center.y-newHeight/2,  newWidth, newHeight);
    btnFrame6.frame =  CGRectMake(btnFrame6.center.x-newWidth/2,  btnFrame6.center.y-newHeight/2,  newWidth, newHeight);
    btnFrame7.frame =  CGRectMake(btnFrame7.center.x-newWidth/2,  btnFrame7.center.y-newHeight/2,  newWidth, newHeight);
    btnFrame8.frame =  CGRectMake(btnFrame8.center.x-newWidth/2,  btnFrame8.center.y-newHeight/2,  newWidth, newHeight);
    btnFrame9.frame =  CGRectMake(btnFrame9.center.x-newWidth/2,  btnFrame9.center.y-newHeight/2,  newWidth, newHeight);
    btnFrame10.frame = CGRectMake(btnFrame10.center.x-newWidth/2, btnFrame10.center.y-newHeight/2, newWidth, newHeight);
    btnFrame11.frame = CGRectMake(btnFrame11.center.x-newWidth/2, btnFrame11.center.y-newHeight/2, newWidth, newHeight);
    btnFrame12.frame = CGRectMake(btnFrame12.center.x-newWidth/2, btnFrame12.center.y-newHeight/2, newWidth, newHeight);
    btnFrame13.frame = CGRectMake(btnFrame13.center.x-newWidth/2, btnFrame13.center.y-newHeight/2, newWidth, newHeight);
    btnFrame14.frame = CGRectMake(btnFrame14.center.x-newWidth/2, btnFrame14.center.y-newHeight/2, newWidth, newHeight);
    btnFrame15.frame = CGRectMake(btnFrame15.center.x-newWidth/2, btnFrame15.center.y-newHeight/2, newWidth, newHeight);
    btnFrame16.frame = CGRectMake(btnFrame16.center.x-newWidth/2, btnFrame16.center.y-newHeight/2, newWidth, newHeight);
}

- (void) selectFrame:(int)style SUB:(int)sub
{
    PhotoViewController* controller = [[PhotoViewController alloc] init];
    [controller setNStyle:style];
    [controller setNSubStyle:sub];
    [controller setNMode:nMode];
    [controller setDelegate:self];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

@end
