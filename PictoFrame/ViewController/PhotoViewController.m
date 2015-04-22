//
//  PhotoViewController.m
//  PictoFrame
//
//  Created by Thomas on 9/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PhotoViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "MyImageView.h"
#import "ShareViewController.h"

#define SCROLL1_VIEW_TAG	41
#define SCROLL2_VIEW_TAG	42
#define SCROLL3_VIEW_TAG	43
#define SCROLL4_VIEW_TAG	44

#define IMAGE1_VIEW_TAG     410
#define IMAGE2_VIEW_TAG     420
#define IMAGE3_VIEW_TAG     430
#define IMAGE4_VIEW_TAG     440

#define BACK_WIDTH          320
#define BACK_HEIGHT         320

#define BACK_WIDTH_IPAD     768
#define BACK_HEIGHT_IPAD    960

#define TAB_FRAME           0
#define TAB_CORNER          1
#define TAB_STYLE           2
#define TAB_ADJUST          3

#define TAB_REPLACE         901
#define TAB_ROTATE1         902
#define TAB_ROTATE2         903
#define TAB_FLIP            904
#define TAB_DONE            905

#define TAB_ADVANCED        0
#define TAB_IMAGEEDT        1

#define ROTATE_RIGHT        0
#define ROTATE_LEFT         1
#define ROTATE_FLIP         2

@implementation PhotoViewController

@synthesize     delegate;
@synthesize     nStyle, nSubStyle, nMode;
@synthesize     nCorner, nMargin, nFrameBack, nFrameColor, nFrameImage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        self = [super initWithNibName:@"PhotoViewController_iPad" bundle:nil];
    else
        self = [super initWithNibName:@"PhotoViewController" bundle:nil];
        
    if (self) {
        // Custom initialization
        self.navigationItem.title = @"Photo Frame";
        
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(actionClick)] autorelease];
        
        self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(composeClick)] autorelease];
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
    nCorner = 0;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        nMargin = 24;
    else
        nMargin = 10;
        
    nFrameBack = 0;
    nFrameColor = 0;
    nFrameImage = 0;
    nChangeWidth = 0;
    nChangeHeight = 0;
    nTabBarState = TAB_ADVANCED;
    fRotateImage1 = 0;
    fRotateImage2 = 0;
    fRotateImage3 = 0;
    fRotateImage4 = 0;
    
    bFlipImage1 = NO;
    bFlipImage2 = NO;
    bFlipImage3 = NO;
    bFlipImage4 = NO;
    
    int nOrgWidth = 300;
    int nOrgHeight = 300;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        if (nMode == 0) {
            nOrgWidth = 720;
            nOrgHeight = 720;
        } else if (nMode == 1) {
            nOrgWidth = 720;
            nOrgHeight = 540;
        } else if (nMode == 2) {
            nOrgWidth = 540;
            nOrgHeight = 720;
        } else if (nMode == 3) {
            nOrgWidth = 720;
            nOrgHeight = 480;
        }
    }
    else
    {
        if (nMode == 0) {
            nOrgWidth = 300;
            nOrgHeight = 300;
        } else if (nMode == 1) {
            nOrgWidth = 300;
            nOrgHeight = 225;
        } else if (nMode == 2) {
            nOrgWidth = 240;
            nOrgHeight = 320;
        } else if (nMode == 3) {
            nOrgWidth = 300;
            nOrgHeight = 200;
        }
    }

    int nBackMarginX = (BACK_WIDTH-nOrgWidth)/2;
    int nBackMarginY = (BACK_HEIGHT-nOrgHeight)/2;

    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        nBackMarginX = (BACK_WIDTH_IPAD-nOrgWidth)/2;
        nBackMarginY = (BACK_HEIGHT_IPAD-nOrgHeight)/2;
    }
    
    if (nBackMarginY < nMargin) {
        nBackMarginY = nMargin;
    }
    scrollBack = [[UIView alloc] initWithFrame:CGRectMake(nBackMarginX, nBackMarginY, nOrgWidth, nOrgHeight)];
    scrollBackImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, nOrgWidth, nOrgHeight)];
    [scrollBack addSubview:scrollBackImage];
    
    scrollBack.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:scrollBack];
    
    rcScroll1 = [self getScrollFrame1];
    rcScroll2 = [self getScrollFrame2];
    rcScroll3 = [self getScrollFrame3];
    rcScroll4 = [self getScrollFrame4];
    
    scrollView1 = [[UIScrollView alloc] initWithFrame:rcScroll1];
    scrollView2 = [[UIScrollView alloc] initWithFrame:rcScroll2];
    scrollView3 = [[UIScrollView alloc] initWithFrame:rcScroll3];
    scrollView4 = [[UIScrollView alloc] initWithFrame:rcScroll4];
    
    scrollView1.backgroundColor = [UIColor grayColor];
    scrollView2.backgroundColor = [UIColor grayColor];
    scrollView3.backgroundColor = [UIColor grayColor];
    scrollView4.backgroundColor = [UIColor grayColor];
    
    scrollView1.tag = SCROLL1_VIEW_TAG;
    scrollView2.tag = SCROLL2_VIEW_TAG;
    scrollView3.tag = SCROLL3_VIEW_TAG;
    scrollView4.tag = SCROLL4_VIEW_TAG;

    [scrollBack addSubview:scrollView1];
    [scrollBack addSubview:scrollView2];
    [scrollBack addSubview:scrollView3];
    [scrollBack addSubview:scrollView4];
	
    UIImage *img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"add.png" ofType:nil]];
    //scroll 1 initialize
	image1 = [[MyImageView alloc] initWithImage:img];
    [image1 setDelegate:self];
    [image1 setSelected:NO];
	image1.tag = IMAGE1_VIEW_TAG;
	image1.userInteractionEnabled = YES;
    image1.frame = CGRectMake(0, 0, scrollView1.frame.size.width, scrollView1.frame.size.height);
    
	[scrollView1 setScrollEnabled:YES];
    [scrollView1 setShowsHorizontalScrollIndicator:NO];
    [scrollView1 setShowsVerticalScrollIndicator:NO];
	[scrollView1 setContentSize:image1.frame.size];
	[scrollView1 setMaximumZoomScale: 2.0f];
	[scrollView1 setMinimumZoomScale: 1.0f];
	[scrollView1 setDelegate:self];
	[scrollView1 addSubview:image1];
    
    //scroll 2 initialize
	image2 = [[MyImageView alloc] initWithImage:img];
    [image2 setDelegate:self];
    [image2 setSelected:NO];
	image2.tag = IMAGE2_VIEW_TAG;
	image2.userInteractionEnabled = YES;
    image2.frame = CGRectMake(0, 0, scrollView2.frame.size.width, scrollView2.frame.size.height);
    
	[scrollView2 setScrollEnabled:YES];
    [scrollView2 setShowsHorizontalScrollIndicator:NO];
    [scrollView2 setShowsVerticalScrollIndicator:NO];
	[scrollView2 setContentSize:image2.frame.size];
	[scrollView2 setMaximumZoomScale: 2.0f];
	[scrollView2 setMinimumZoomScale: 1.0f];
	[scrollView2 setDelegate:self];
	[scrollView2 addSubview:image2];
    
    //scroll 3 initialize
	image3 = [[MyImageView alloc] initWithImage:img];
    [image3 setDelegate:self];
    [image3 setSelected:NO];
	image3.tag = IMAGE3_VIEW_TAG;
	image3.userInteractionEnabled = YES;
    image3.frame = CGRectMake(0, 0, scrollView3.frame.size.width, scrollView3.frame.size.height);
    
	[scrollView3 setScrollEnabled:YES];
    [scrollView3 setShowsHorizontalScrollIndicator:NO];
    [scrollView3 setShowsVerticalScrollIndicator:NO];
	[scrollView3 setContentSize:image3.frame.size];
	[scrollView3 setMaximumZoomScale: 2.0f];
	[scrollView3 setMinimumZoomScale: 1.0f];
	[scrollView3 setDelegate:self];
	[scrollView3 addSubview:image3];
    
    //scroll 4 initialize
	image4 = [[MyImageView alloc] initWithImage:img];
    [image4 setDelegate:self];
    [image4 setSelected:NO];
	image4.tag = IMAGE4_VIEW_TAG;
	image4.userInteractionEnabled = YES;
    image4.frame = CGRectMake(0, 0, scrollView4.frame.size.width, scrollView4.frame.size.height);
    
	[scrollView4 setScrollEnabled:YES];
    [scrollView4 setShowsHorizontalScrollIndicator:NO];
    [scrollView4 setShowsVerticalScrollIndicator:NO];
	[scrollView4 setContentSize:image4.frame.size];
	[scrollView4 setMaximumZoomScale: 2.0f];
	[scrollView4 setMinimumZoomScale: 1.0f];
	[scrollView4 setDelegate:self];
	[scrollView4 addSubview:image4];

    CGRect rcSliderCorner = CGRectMake(20, 350, 120, 10);
    CGRect rcSliderMargin = CGRectMake(180, 350, 120, 10);
    CGRect rcSliderAdjustRow = CGRectMake(20, 350, 120, 10);
    CGRect rcSliderAdjustCol = CGRectMake(180, 350, 120, 10);

    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        rcSliderCorner = CGRectMake(42, 860, 300, 10);
        rcSliderMargin = CGRectMake(426, 860, 300, 10);
        rcSliderAdjustRow = CGRectMake(42, 860, 300, 10);
        rcSliderAdjustCol = CGRectMake(426, 860, 300, 10);
    }

    sliderCorner = [[UISlider alloc] initWithFrame:rcSliderCorner];
    sliderMargin = [[UISlider alloc] initWithFrame:rcSliderMargin];
    sliderAdjustRow = [[UISlider alloc] initWithFrame:rcSliderAdjustRow];
    sliderAdjustCol = [[UISlider alloc] initWithFrame:rcSliderAdjustCol];
    
    [sliderCorner addTarget:self action:@selector(updateCorner:) forControlEvents:UIControlEventValueChanged];
    [sliderMargin addTarget:self action:@selector(updateMargin:) forControlEvents:UIControlEventValueChanged];
    [sliderAdjustRow addTarget:self action:@selector(updateAdjustRow:) forControlEvents:UIControlEventValueChanged];
    [sliderAdjustCol addTarget:self action:@selector(updateAdjustCol:) forControlEvents:UIControlEventValueChanged];
    
    [sliderCorner setMinimumValue:0.0f];
    [sliderCorner setMaximumValue:100.0f];
    [sliderCorner setValue:0.0f];
    
    [sliderMargin setMinimumValue:0.0f];
    [sliderMargin setMaximumValue:40.0f];
    [sliderMargin setValue:10.0f];
    
    [sliderAdjustRow setMinimumValue:0.0f];
    [sliderAdjustRow setMaximumValue:100.0f];
    [sliderAdjustRow setValue:0.0f];
    
    [sliderAdjustCol setMinimumValue:0.0f];
    [sliderAdjustCol setMaximumValue:100.0f];
    [sliderAdjustCol setValue:0.0f];
    
    [self.view addSubview:sliderCorner];
    [self.view addSubview:sliderMargin];
    [self.view addSubview:sliderAdjustRow];
    [self.view addSubview:sliderAdjustCol];
    
    tabBar.selectedItem = [tabBar.items objectAtIndex:1];
    
    [sliderCorner setHidden:NO];
    [sliderMargin setHidden:NO];
    [sliderAdjustRow setHidden:YES];
    [sliderAdjustCol setHidden:YES];
    
    [self setStyleView];
    [self setAdjustLimitWidth];
    [self setAdjustLimitHeight];
    
    [viewStyle setHidden:YES];
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

- (void) actionClick
{
    ShareViewController* controller = [[ShareViewController alloc] init];
    [controller setDelegate:self];
    UIImage* image = [self captureView:scrollBack];
    [controller setImage:image];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

- (void) composeClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITabBarDelegate

- (void)tabBar:(UITabBar *)tab didSelectItem:(UITabBarItem *)item
{
    switch (item.tag) {
        case TAB_FRAME:
            [self.navigationController popViewControllerAnimated:YES];
            break;
        case TAB_CORNER:
            [sliderCorner setHidden:NO];
            [sliderMargin setHidden:NO];
            [sliderAdjustRow setHidden:YES];
            [sliderAdjustCol setHidden:YES];
            [viewStyle setHidden:YES];
            break;
        case TAB_STYLE:
            [sliderCorner setHidden:YES];
            [sliderMargin setHidden:YES];
            [sliderAdjustRow setHidden:YES];
            [sliderAdjustCol setHidden:YES];
            [viewStyle setHidden:NO];
            break;
        case TAB_ADJUST:
            [sliderCorner setHidden:YES];
            [sliderMargin setHidden:YES];
            [sliderAdjustRow setHidden:NO];
            [sliderAdjustCol setHidden:NO];
            [viewStyle setHidden:YES];
            [self activeSliders];
            break;
        case TAB_REPLACE:
            [self pickImage:nCurrentImage];
            break;
        case TAB_ROTATE1:
            [self rotateImage:ROTATE_RIGHT];
            break;
        case TAB_ROTATE2:
            [self rotateImage:ROTATE_LEFT];
            break;
        case TAB_FLIP:
            [self rotateImage:ROTATE_FLIP];
            break;
        case TAB_DONE:
            [self showAdvancedTabBar];
            break;
        default:
            break;
    }
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
	return [self.view viewWithTag:scrollView.tag*10];
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale
{
}

#pragma mark - UISlider 

- (void) updateCorner: (UISlider *) slider
{
    scrollView1.layer.cornerRadius = slider.value;
    scrollView2.layer.cornerRadius = slider.value;
    scrollView3.layer.cornerRadius = slider.value;
    scrollView4.layer.cornerRadius = slider.value;
}

- (void) updateMargin: (UISlider *) slider
{
    int newMargin = (int)slider.value;
    nMargin = newMargin;
    
    rcScroll1 = [self getScrollFrame1];
    rcScroll2 = [self getScrollFrame2];
    rcScroll3 = [self getScrollFrame3];
    rcScroll4 = [self getScrollFrame4];
    
    scrollView1.frame = rcScroll1;
    scrollView2.frame = rcScroll2;
    scrollView3.frame = rcScroll3;
    scrollView4.frame = rcScroll4;
    
    [self resizeImageViewWithScrollView];
}

- (void) updateAdjustRow: (UISlider *) slider
{
    //width change
    int nVal = (int)slider.value;
    int nChange = nVal - nChangeWidth;
    nChangeWidth = nVal;
    
    if (nStyle == 2) {
        if (nSubStyle == 1) {
            rcScroll1.size.width += nChange;
            rcScroll2.size.width -= nChange;
            rcScroll2.origin.x += nChange;
        }
        scrollView1.frame = rcScroll1;
        scrollView2.frame = rcScroll2;
    } else if (nStyle == 3) {
        if (nSubStyle == 1) {
            rcScroll1.size.width += nChange;
            rcScroll2.size.width -= nChange;
            rcScroll2.origin.x += nChange;
            rcScroll3.size.width -= nChange;
            rcScroll3.origin.x += nChange;
        } else if (nSubStyle == 2) {
            rcScroll1.size.width += nChange;
            rcScroll3.size.width += nChange;
            rcScroll2.size.width -= nChange;
            rcScroll2.origin.x += nChange;
        } else if (nSubStyle == 3) {
            rcScroll2.size.width += nChange;
            rcScroll3.size.width -= nChange;
            rcScroll3.origin.x += nChange;
        } else if (nSubStyle == 4) {
            rcScroll1.size.width += nChange;
            rcScroll2.size.width -= nChange;
            rcScroll2.origin.x += nChange;
        } else if (nSubStyle == 5) {
            rcScroll1.size.width -= nChange;
            rcScroll2.size.width += nChange*2;
            rcScroll2.origin.x -= nChange;
            rcScroll3.size.width -= nChange;
            rcScroll3.origin.x += nChange;
        }
        scrollView1.frame = rcScroll1;
        scrollView2.frame = rcScroll2;
        scrollView3.frame = rcScroll3;
    } else if (nStyle == 4) {
        if (nSubStyle == 1) {
            rcScroll1.size.width += nChange;
            rcScroll3.size.width += nChange;
            rcScroll2.size.width -= nChange;
            rcScroll4.size.width -= nChange;
            rcScroll2.origin.x += nChange;
            rcScroll4.origin.x += nChange;
        } else if (nSubStyle == 2) {
            rcScroll2.size.width += nChange;
            rcScroll3.size.width += nChange;
            rcScroll1.size.width -= nChange;
            rcScroll4.size.width -= nChange;
            rcScroll2.origin.x -= nChange;
            rcScroll4.origin.x += nChange;
        } else if (nSubStyle == 4) {
            rcScroll1.size.width += nChange;
            rcScroll3.size.width -= nChange;
            rcScroll2.size.width -= nChange;
            rcScroll4.size.width -= nChange;
            rcScroll2.origin.x += nChange;
            rcScroll3.origin.x += nChange;
            rcScroll4.origin.x += nChange;
        } else if (nSubStyle == 5) {
            rcScroll1.size.width += nChange;
            rcScroll3.size.width += nChange;
            rcScroll4.size.width += nChange;
            rcScroll2.size.width -= nChange;
            rcScroll2.origin.x += nChange;
        } else if (nSubStyle == 6) {
            rcScroll3.size.width += nChange*2;
            rcScroll2.size.width -= nChange;
            rcScroll4.size.width -= nChange;
            rcScroll3.origin.x -= nChange;
            rcScroll4.origin.x += nChange;
        } else if (nSubStyle == 7) {
            rcScroll2.size.width += nChange*2;
            rcScroll1.size.width -= nChange;
            rcScroll3.size.width -= nChange;
            rcScroll2.origin.x -= nChange;
            rcScroll3.origin.x += nChange;
        }
        scrollView1.frame = rcScroll1;
        scrollView2.frame = rcScroll2;
        scrollView3.frame = rcScroll3;
        scrollView4.frame = rcScroll4;
    }
    
    [self resizeImageViewWithScrollView];
}

- (void) updateAdjustCol: (UISlider *) slider
{
    //height change
    int nVal = (int)slider.value;
    int nChange = nVal - nChangeHeight;
    nChangeHeight = nVal;

    if (nStyle == 2) {
        if (nSubStyle == 2) {
            rcScroll1.size.height += nChange;
            rcScroll2.size.height -= nChange;
            rcScroll2.origin.y += nChange;
        }
        scrollView1.frame = rcScroll1;
        scrollView2.frame = rcScroll2;
    } else if (nStyle == 3) {
        if (nSubStyle == 1) {
            rcScroll2.size.height += nChange;
            rcScroll3.size.height -= nChange;
            rcScroll3.origin.y += nChange;
        } else if (nSubStyle == 2) {
            rcScroll1.size.height += nChange;
            rcScroll3.size.height -= nChange;
            rcScroll3.origin.y += nChange;
        } else if (nSubStyle == 3) {
            rcScroll1.size.height += nChange;
            rcScroll2.size.height -= nChange;
            rcScroll3.size.height -= nChange;
            rcScroll2.origin.y += nChange;
            rcScroll3.origin.y += nChange;
        } else if (nSubStyle == 4) {
            rcScroll1.size.height += nChange;
            rcScroll2.size.height += nChange;
            rcScroll3.size.height -= nChange;
            rcScroll3.origin.y += nChange;
        } else if (nSubStyle == 6) {
            rcScroll2.size.height += nChange*2;
            rcScroll1.size.height -= nChange;
            rcScroll3.size.height -= nChange;
            rcScroll2.origin.y -= nChange;
            rcScroll3.origin.y += nChange;
        }
        scrollView1.frame = rcScroll1;
        scrollView2.frame = rcScroll2;
        scrollView3.frame = rcScroll3;
    } else if (nStyle == 4) {
        if (nSubStyle == 1) {
            rcScroll1.size.height += nChange;
            rcScroll2.size.height += nChange;
            rcScroll3.size.height -= nChange;
            rcScroll4.size.height -= nChange;
            rcScroll3.origin.y += nChange;
            rcScroll4.origin.y += nChange;
        } else if (nSubStyle == 3) {
            rcScroll2.size.height += nChange;
            rcScroll3.size.height += nChange;
            rcScroll1.size.height -= nChange;
            rcScroll4.size.height -= nChange;
            rcScroll2.origin.y -= nChange;
            rcScroll4.origin.y += nChange;
        } else if (nSubStyle == 4) {
            rcScroll3.size.height += nChange*2;
            rcScroll2.size.height -= nChange;
            rcScroll4.size.height -= nChange;
            rcScroll3.origin.y -= nChange;
            rcScroll4.origin.y += nChange;
        } else if (nSubStyle == 5) {
            rcScroll3.size.height += nChange*2;
            rcScroll1.size.height -= nChange;
            rcScroll4.size.height -= nChange;
            rcScroll3.origin.y -= nChange;
            rcScroll4.origin.y += nChange;
        } else if (nSubStyle == 6) {
            rcScroll1.size.height += nChange;
            rcScroll2.size.height -= nChange;
            rcScroll3.size.height -= nChange;
            rcScroll4.size.height -= nChange;
            rcScroll2.origin.y += nChange;
            rcScroll3.origin.y += nChange;
            rcScroll4.origin.y += nChange;
        } else if (nSubStyle == 7) {
            rcScroll1.size.height += nChange;
            rcScroll2.size.height += nChange;
            rcScroll3.size.height += nChange;
            rcScroll4.size.height -= nChange;
            rcScroll4.origin.y += nChange;
        }
        scrollView1.frame = rcScroll1;
        scrollView2.frame = rcScroll2;
        scrollView3.frame = rcScroll3;
        scrollView4.frame = rcScroll4;
    }
    
    [self resizeImageViewWithScrollView];
}

- (void) setStyleView
{
    [self.view addSubview:viewStyle];
    
    [sliderColorRed setMaximumTrackImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"slider.png" ofType:nil]] forState:UIControlStateNormal];
    [sliderColorGreen setMaximumTrackImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"slider.png" ofType:nil]] forState:UIControlStateNormal];
    [sliderColorBlur setMaximumTrackImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"slider.png" ofType:nil]] forState:UIControlStateNormal];

    [sliderColorRed setMinimumTrackImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"slider1.png" ofType:nil]] forState:UIControlStateNormal];
    [sliderColorGreen setMinimumTrackImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"slider2.png" ofType:nil]] forState:UIControlStateNormal];
    [sliderColorBlur setMinimumTrackImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"slider3.png" ofType:nil]] forState:UIControlStateNormal];

    [sliderColorRed setThumbImage: [UIImage imageNamed:@"whiteSlide.png"] forState:UIControlStateNormal];
    [sliderColorGreen setThumbImage: [UIImage imageNamed:@"whiteSlide.png"] forState:UIControlStateNormal];
    [sliderColorBlur setThumbImage: [UIImage imageNamed:@"whiteSlide.png"] forState:UIControlStateNormal];
    
    [sliderColorRed addTarget:self action:@selector(updateColorRed:) forControlEvents:UIControlEventValueChanged];
    [sliderColorGreen addTarget:self action:@selector(updateColorGreen:) forControlEvents:UIControlEventValueChanged];
    [sliderColorBlur addTarget:self action:@selector(updateColorBlur:) forControlEvents:UIControlEventValueChanged];
    
    [sliderColorRed setMinimumValue:0.0f]; [sliderColorRed setMaximumValue:1.0f]; [sliderColorRed setValue:1.0f];
    [sliderColorGreen setMinimumValue:0.0f]; [sliderColorGreen setMaximumValue:1.0f]; [sliderColorGreen setValue:1.0f];
    [sliderColorBlur setMinimumValue:0.0f]; [sliderColorBlur setMaximumValue:1.0f]; [sliderColorBlur setValue:1.0f];
    
    [sgmStyle setSelectedSegmentIndex:0];
	[sgmStyle addTarget:self action:@selector(updateSegValue:) forControlEvents:UIControlEventValueChanged];
    [btnBlack addTarget:self action:@selector(updateColorBlack:) forControlEvents:UIControlEventTouchUpInside];
    [btnWhite addTarget:self action:@selector(updateColorWhite:) forControlEvents:UIControlEventTouchUpInside];
    
    [btnBackImage1 addTarget:self action:@selector(updateStyleImage1:) forControlEvents:UIControlEventTouchUpInside];
    [btnBackImage2 addTarget:self action:@selector(updateStyleImage2:) forControlEvents:UIControlEventTouchUpInside];
    [btnBackImage3 addTarget:self action:@selector(updateStyleImage3:) forControlEvents:UIControlEventTouchUpInside];
    [btnBackImage4 addTarget:self action:@selector(updateStyleImage4:) forControlEvents:UIControlEventTouchUpInside];
    [btnBackImage5 addTarget:self action:@selector(updateStyleImage5:) forControlEvents:UIControlEventTouchUpInside];
    [btnBackImage6 addTarget:self action:@selector(updateStyleImage6:) forControlEvents:UIControlEventTouchUpInside];
    [btnBackImage7 addTarget:self action:@selector(updateStyleImage7:) forControlEvents:UIControlEventTouchUpInside];
    [btnBackImage8 addTarget:self action:@selector(updateStyleImage8:) forControlEvents:UIControlEventTouchUpInside];
    [btnBackImage9 addTarget:self action:@selector(updateStyleImage9:) forControlEvents:UIControlEventTouchUpInside];
    [btnBackImage10 addTarget:self action:@selector(updateStyleImage10:) forControlEvents:UIControlEventTouchUpInside];
    [btnBackImage11 addTarget:self action:@selector(updateStyleImage11:) forControlEvents:UIControlEventTouchUpInside];
    [btnBackImage12 addTarget:self action:@selector(updateStyleImage12:) forControlEvents:UIControlEventTouchUpInside];
    [btnBackImage13 addTarget:self action:@selector(updateStyleImage13:) forControlEvents:UIControlEventTouchUpInside];
    [btnBackImage14 addTarget:self action:@selector(updateStyleImage14:) forControlEvents:UIControlEventTouchUpInside];
    [btnBackImage15 addTarget:self action:@selector(updateStyleImage15:) forControlEvents:UIControlEventTouchUpInside];
    [btnBackImage16 addTarget:self action:@selector(updateStyleImage16:) forControlEvents:UIControlEventTouchUpInside];
    [btnBackImage17 addTarget:self action:@selector(updateStyleImage17:) forControlEvents:UIControlEventTouchUpInside];
    [btnBackImage18 addTarget:self action:@selector(updateStyleImage18:) forControlEvents:UIControlEventTouchUpInside];
    [btnBackImage19 addTarget:self action:@selector(updateStyleImage19:) forControlEvents:UIControlEventTouchUpInside];
    [btnBackImage20 addTarget:self action:@selector(updateStyleImage20:) forControlEvents:UIControlEventTouchUpInside];

    [self setVisibleStyles:sgmStyle.selectedSegmentIndex];
}

- (void) setVisibleStyles:(int)style
{
    if (style == 0) {
        [scrollBackImage setHidden:YES];
        [btnBackImage1 setHidden:YES];
        [btnBackImage2 setHidden:YES];
        [btnBackImage3 setHidden:YES];
        [btnBackImage4 setHidden:YES];
        [btnBackImage5 setHidden:YES];
        [btnBackImage6 setHidden:YES];
        [btnBackImage7 setHidden:YES];
        [btnBackImage8 setHidden:YES];
        [btnBackImage9 setHidden:YES];
        [btnBackImage10 setHidden:YES];
        [btnBackImage11 setHidden:YES];
        [btnBackImage12 setHidden:YES];
        [btnBackImage13 setHidden:YES];
        [btnBackImage14 setHidden:YES];
        [btnBackImage15 setHidden:YES];
        [btnBackImage16 setHidden:YES];
        [btnBackImage17 setHidden:YES];
        [btnBackImage18 setHidden:YES];
        [btnBackImage19 setHidden:YES];
        [btnBackImage20 setHidden:YES];
        
        [sliderColorRed setHidden:NO];
        [sliderColorGreen setHidden:NO];
        [sliderColorBlur setHidden:NO];
        [btnBlack setHidden:NO];
        [btnWhite setHidden:NO];
    } else {
        [scrollBackImage setHidden:NO];
        [btnBackImage1 setHidden:NO];
        [btnBackImage2 setHidden:NO];
        [btnBackImage3 setHidden:NO];
        [btnBackImage4 setHidden:NO];
        [btnBackImage5 setHidden:NO];
        [btnBackImage6 setHidden:NO];
        [btnBackImage7 setHidden:NO];
        [btnBackImage8 setHidden:NO];
        [btnBackImage9 setHidden:NO];
        [btnBackImage10 setHidden:NO];
        [btnBackImage11 setHidden:NO];
        [btnBackImage12 setHidden:NO];
        [btnBackImage13 setHidden:NO];
        [btnBackImage14 setHidden:NO];
        [btnBackImage15 setHidden:NO];
        [btnBackImage16 setHidden:NO];
        [btnBackImage17 setHidden:NO];
        [btnBackImage18 setHidden:NO];
        [btnBackImage19 setHidden:NO];
        [btnBackImage20 setHidden:NO];
        
        [sliderColorRed setHidden:YES];
        [sliderColorGreen setHidden:YES];
        [sliderColorBlur setHidden:YES];
        [btnBlack setHidden:YES];
        [btnWhite setHidden:YES];
    }
}

- (void) updateColorRed: (UISlider *) slider
{
    [scrollBack setBackgroundColor:[UIColor colorWithRed:slider.value green:sliderColorGreen.value blue:sliderColorBlur.value alpha:1.0f]];
}

- (void) updateColorGreen: (UISlider *) slider
{
    [scrollBack setBackgroundColor:[UIColor colorWithRed:sliderColorRed.value green:slider.value blue:sliderColorBlur.value alpha:1.0f]];
}

- (void) updateColorBlur: (UISlider *) slider
{
    [scrollBack setBackgroundColor:[UIColor colorWithRed:sliderColorRed.value green:sliderColorGreen.value blue:slider.value alpha:1.0f]];
}

- (void) updateSegValue: (UISegmentedControl *) segment
{
    [self setVisibleStyles:sgmStyle.selectedSegmentIndex];
}

- (void) updateColorBlack: (UIButton *) button
{
    [sliderColorRed setValue:0.0f];
    [sliderColorGreen setValue:0.0f];
    [sliderColorBlur setValue:0.0f];

    [scrollBack setBackgroundColor:[UIColor colorWithRed:sliderColorRed.value green:sliderColorGreen.value blue:sliderColorBlur.value alpha:1.0f]];
}

- (void) updateColorWhite: (UIButton *) button
{
    [sliderColorRed setValue:1.0f];
    [sliderColorGreen setValue:1.0f];
    [sliderColorBlur setValue:1.0f];
    
    [scrollBack setBackgroundColor:[UIColor colorWithRed:sliderColorRed.value green:sliderColorGreen.value blue:sliderColorBlur.value alpha:1.0f]];
}

- (void) updateStyleImage1: (UIButton *) button
{
    [scrollBackImage setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"style_1.png" ofType:nil]]];
}

- (void) updateStyleImage2: (UIButton *) button
{
    [scrollBackImage setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"style_2.png" ofType:nil]]];
}

- (void) updateStyleImage3: (UIButton *) button
{
    [scrollBackImage setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"style_3.png" ofType:nil]]];
}

- (void) updateStyleImage4: (UIButton *) button
{
    [scrollBackImage setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"style_4.png" ofType:nil]]];
}

- (void) updateStyleImage5: (UIButton *) button
{
    [scrollBackImage setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"style_5.png" ofType:nil]]];
}

- (void) updateStyleImage6: (UIButton *) button
{
    [scrollBackImage setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"style_6.png" ofType:nil]]];
}

- (void) updateStyleImage7: (UIButton *) button
{
    [scrollBackImage setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"style_7.png" ofType:nil]]];
}

- (void) updateStyleImage8: (UIButton *) button
{
    [scrollBackImage setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"style_8.png" ofType:nil]]];
}

- (void) updateStyleImage9: (UIButton *) button
{
    [scrollBackImage setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"style_9.png" ofType:nil]]];
}

- (void) updateStyleImage10: (UIButton *) button
{
    [scrollBackImage setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"style_10.png" ofType:nil]]];
}

- (void) updateStyleImage11: (UIButton *) button
{
    [scrollBackImage setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"style_11.png" ofType:nil]]];
}

- (void) updateStyleImage12: (UIButton *) button
{
    [scrollBackImage setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"style_12.png" ofType:nil]]];
}

- (void) updateStyleImage13: (UIButton *) button
{
    [scrollBackImage setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"style_13.png" ofType:nil]]];
}

- (void) updateStyleImage14: (UIButton *) button
{
    [scrollBackImage setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"style_14.png" ofType:nil]]];
}

- (void) updateStyleImage15: (UIButton *) button
{
    [scrollBackImage setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"style_15.png" ofType:nil]]];
}

- (void) updateStyleImage16: (UIButton *) button
{
    [scrollBackImage setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"style_16.png" ofType:nil]]];
}

- (void) updateStyleImage17: (UIButton *) button
{
    [scrollBackImage setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"style_17.png" ofType:nil]]];
}

- (void) updateStyleImage18: (UIButton *) button
{
    [scrollBackImage setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"style_18.png" ofType:nil]]];
}

- (void) updateStyleImage19: (UIButton *) button
{
    [scrollBackImage setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"style_19.png" ofType:nil]]];
}

- (void) updateStyleImage20: (UIButton *) button
{
    [scrollBackImage setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"style_20.png" ofType:nil]]];
}

- (void) pickImage:(int)imageTag
{
    nCurrentImage = imageTag;
    UIImagePickerController* pickerController = [[UIImagePickerController alloc] init];
	pickerController.delegate = self;
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
		pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) 
        {
            if(popoverController != nil) 
            {
                [popoverController release];
                popoverController = nil;
            }
            UIPopoverController* popover = [[UIPopoverController alloc] initWithContentViewController:pickerController];
            popoverController = popover;
            popoverController.delegate = self;
            [popover presentPopoverFromRect:CGRectMake(0, 0, 200, 800) 
                                     inView:self.view
                   permittedArrowDirections:UIPopoverArrowDirectionAny 
                                   animated:YES];
        }
        else
        {
            [self presentModalViewController:pickerController animated:YES];
        }
    }
}

#pragma mark -
#pragma mark UIImagePickerControllerDelegate

// this get called when an image has been chosen from the library or taken from the camera
//
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	[self dismissModalViewControllerAnimated:YES];
	UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:image forKey:@"image"];
    
    [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(didPickerProc:) userInfo:dict repeats:NO];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	[self dismissModalViewControllerAnimated:YES];
}

- (void) didPickerProc:(NSTimer*)myTimer
{
    NSMutableDictionary *dict = [myTimer userInfo];
    UIImage* image = [dict objectForKey:@"image"];
    
    [myTimer invalidate];
    myTimer = nil;
    
    //image size change function------
    // ???
    //--------------------------------
    
    [self resizeImageView:image];
}

- (void) resizeImageView:(UIImage*)image
{
    if (nCurrentImage == IMAGE1_VIEW_TAG) {
        [image1 setImage:image];

        fRotateImage1 = 0;
        bFlipImage1 = NO;
        
        [image1 setSelected:YES];
        [image1 setFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
        [self fitImageToScroll:image1 SCROLL:scrollView1];
    } else if (nCurrentImage == IMAGE2_VIEW_TAG) {
        [image2 setImage:image];
        
        fRotateImage2 = 0;
        bFlipImage2 = NO;
        
        [image2 setSelected:YES];
        [image2 setFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
        [self fitImageToScroll:image2 SCROLL:scrollView2];
    } else if (nCurrentImage == IMAGE3_VIEW_TAG) {
        [image3 setImage:image];
        
        fRotateImage3 = 0;
        bFlipImage3 = NO;
        
        [image3 setSelected:YES];
        [image3 setFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
        [self fitImageToScroll:image3 SCROLL:scrollView3];
    } else if (nCurrentImage == IMAGE4_VIEW_TAG) {
        [image4 setImage:image];
        
        fRotateImage4 = 0;
        bFlipImage4 = NO;
        
        [image4 setSelected:YES];
        [image4 setFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
        [self fitImageToScroll:image4 SCROLL:scrollView4];
    }
}

- (void) resizeImageViewWithScrollView
{
    if (nStyle >= 1) {
        [self fitImageToScroll:image1 SCROLL:scrollView1];
    }
    if (nStyle >= 2) {
        [self fitImageToScroll:image2 SCROLL:scrollView2];
    }
    if (nStyle >= 3) {
        [self fitImageToScroll:image3 SCROLL:scrollView3];
    }
    if (nStyle >= 4) {
        [self fitImageToScroll:image4 SCROLL:scrollView4];
    }
}

- (void) fitImageToScroll:(MyImageView*)imgView SCROLL:(UIScrollView*)scrView
{
    if (imgView.selected) {
        float rateScr = scrView.frame.size.height / scrView.frame.size.width;
        float rateImg = imgView.frame.size.height / imgView.frame.size.width;
        
        float rateWidth = scrView.frame.size.width / imgView.frame.size.width;
        float rateHeight = scrView.frame.size.height / imgView.frame.size.height;
        
        float rateFit = rateScr < rateImg ? rateWidth : rateHeight;
        
        CGSize szImage = CGSizeMake(imgView.frame.size.width * rateFit+2, imgView.frame.size.height * rateFit+2);
        
        [imgView setFrame:CGRectMake(0, 0, szImage.width, szImage.height)];
        [scrView setContentSize:imgView.frame.size];
    }
    else 
    {
        [imgView setFrame:CGRectMake(0, 0, scrView.frame.size.width, scrView.frame.size.height)];
        [scrView setContentSize:imgView.frame.size];
    }
}

- (UIImage*)captureView:(UIView *)view 
{
    CGRect rect = view.frame;//[[UIScreen mainScreen] bounds];  
    UIGraphicsBeginImageContext(rect.size);  
    CGContextRef context = UIGraphicsGetCurrentContext();  
    [view.layer renderInContext:context];  
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();  
    UIGraphicsEndImageContext();  
    return img;
}

- (void)saveScreenshotToPhotosAlbum:(UIView *)view 
{
    UIImageWriteToSavedPhotosAlbum([self captureView:view], nil, nil, nil);
}

- (CGRect) getScrollFrame1
{
    CGRect rc;
    float scroll_width = 0;
    float scroll_height = 0;

    if (nStyle == 1) {
        scroll_width = scrollBack.frame.size.width - nMargin * 2;
        scroll_height = scrollBack.frame.size.height - nMargin * 2;
    } else if (nStyle == 2) {
        if (nSubStyle == 1) {
            scroll_width = (scrollBack.frame.size.width - nMargin * 3 ) / 2;
            scroll_height = scrollBack.frame.size.height - nMargin * 2;
        } else if (nSubStyle == 2) {
            scroll_width = scrollBack.frame.size.width - nMargin * 2;
            scroll_height = (scrollBack.frame.size.height - nMargin * 3 ) / 2;
        }
    } else if (nStyle == 3) {
        if (nSubStyle == 1) {
            scroll_width = (scrollBack.frame.size.width - nMargin * 3 ) * 2 / 5;
            scroll_height = scrollBack.frame.size.height - nMargin * 2;
        } else if (nSubStyle == 2) {
            scroll_width = (scrollBack.frame.size.width - nMargin * 3 ) * 3 / 5;
            scroll_height = (scrollBack.frame.size.height - nMargin * 3 ) / 2;
        } else if (nSubStyle == 3) {
            scroll_width = scrollBack.frame.size.width - nMargin * 2;
            scroll_height = (scrollBack.frame.size.height - nMargin * 3 ) * 2 / 5;
        } else if (nSubStyle == 4) {
            scroll_width = (scrollBack.frame.size.width - nMargin * 3 ) / 2;
            scroll_height = (scrollBack.frame.size.height - nMargin * 3 ) * 3 / 5;
        } else if (nSubStyle == 5) {
            scroll_width = (scrollBack.frame.size.width - nMargin * 4 ) / 3;
            scroll_height = scrollBack.frame.size.height - nMargin * 2;
        } else if (nSubStyle == 6) {
            scroll_width = scrollBack.frame.size.width - nMargin * 2;
            scroll_height = (scrollBack.frame.size.height - nMargin * 4 ) / 3;
        }
    } else if (nStyle == 4) {
        if (nSubStyle == 1) {
            scroll_width = (scrollBack.frame.size.width - nMargin * 3 ) / 2;
            scroll_height = (scrollBack.frame.size.height - nMargin * 3 ) / 2;
        } else if (nSubStyle == 2) {
            scroll_width = (scrollBack.frame.size.width - nMargin * 5 ) / 4;
            scroll_height = scrollBack.frame.size.height - nMargin * 2;
        } else if (nSubStyle == 3) {
            scroll_width = scrollBack.frame.size.width - nMargin * 2;
            scroll_height = (scrollBack.frame.size.height - nMargin * 5 ) / 4;
        } else if (nSubStyle == 4) {
            scroll_width = (scrollBack.frame.size.width - nMargin * 3 ) * 2 / 5;
            scroll_height = scrollBack.frame.size.height - nMargin * 2;
        } else if (nSubStyle == 5) {
            scroll_width = (scrollBack.frame.size.width - nMargin * 3 ) * 3 / 5;
            scroll_height = (scrollBack.frame.size.height - nMargin * 4 ) / 3;
        } else if (nSubStyle == 6) {
            scroll_width = scrollBack.frame.size.width - nMargin * 2;
            scroll_height = (scrollBack.frame.size.height - nMargin * 3 ) * 2 / 5;
        } else if (nSubStyle == 7) {
            scroll_width = (scrollBack.frame.size.width - nMargin * 4 ) / 3;
            scroll_height = (scrollBack.frame.size.height - nMargin * 3 ) * 3 / 5;
        }
    }
        
    rc = CGRectMake(nMargin, nMargin, scroll_width, scroll_height);
    
    return rc;
}

- (CGRect) getScrollFrame2
{
    CGRect rc;
    
    float scroll_width = 0;
    float scroll_height = 0;
    
    float nLeftMargin = 0;
    float nTopMargin = 0;
    
    if (nStyle == 1) {
    } else if (nStyle == 2) {
        if (nSubStyle == 1) {
            scroll_width = (scrollBack.frame.size.width - nMargin * 3 ) / 2;
            scroll_height = scrollBack.frame.size.height - nMargin * 2;
            nLeftMargin = scrollBack.frame.size.width - nMargin - scroll_width;
            nTopMargin = nMargin;
        } else if (nSubStyle == 2) {
            scroll_width = scrollBack.frame.size.width - nMargin * 2;
            scroll_height = (scrollBack.frame.size.height - nMargin * 3 ) / 2;
            nTopMargin = scrollBack.frame.size.height - nMargin - scroll_height;
            nLeftMargin = nMargin;
        }
    } else if (nStyle == 3) {
        if (nSubStyle == 1) {
            scroll_width = (scrollBack.frame.size.width - nMargin * 3 ) * 3 / 5;
            scroll_height = (scrollBack.frame.size.height - nMargin * 3 ) / 2;
            nLeftMargin = scrollBack.frame.size.width - nMargin - scroll_width;
            nTopMargin = nMargin;
        } else if (nSubStyle == 2) {
            scroll_width = (scrollBack.frame.size.width - nMargin * 3 ) * 2 / 5;
            scroll_height = (scrollBack.frame.size.height - nMargin * 2 );
            nLeftMargin = scrollBack.frame.size.width - nMargin - scroll_width;
            nTopMargin = nMargin;
        } else if (nSubStyle == 3) {
            scroll_width = (scrollBack.frame.size.width - nMargin * 3 ) / 2;
            scroll_height = (scrollBack.frame.size.height - nMargin * 3 ) * 3 / 5;
            nTopMargin = scrollBack.frame.size.height - nMargin - scroll_height;
            nLeftMargin = nMargin;
        } else if (nSubStyle == 4) {
            scroll_width = (scrollBack.frame.size.width - nMargin * 3 ) / 2;
            scroll_height = (scrollBack.frame.size.height - nMargin * 3 ) * 3 / 5;
            nLeftMargin = scrollBack.frame.size.width - nMargin - scroll_width;
            nTopMargin = nMargin;
        } else if (nSubStyle == 5) {
            scroll_width = (scrollBack.frame.size.width - nMargin * 4 ) / 3;
            scroll_height = scrollBack.frame.size.height - nMargin * 2;
            nTopMargin = nMargin;
            nLeftMargin = nMargin * 2 + scroll_width;
        } else if (nSubStyle == 6) {
            scroll_width = scrollBack.frame.size.width - nMargin * 2;
            scroll_height = (scrollBack.frame.size.height - nMargin * 4 ) / 3;
            nLeftMargin = nMargin;
            nTopMargin = nMargin * 2 + scroll_height;
        }
    } else if (nStyle == 4) {
        if (nSubStyle == 1) {
            scroll_width = (scrollBack.frame.size.width - nMargin * 3 ) / 2;
            scroll_height = (scrollBack.frame.size.height - nMargin * 3 ) / 2;
            nTopMargin = nMargin;
            nLeftMargin = nMargin * 2 + scroll_width;
        } else if (nSubStyle == 2) {
            scroll_width = (scrollBack.frame.size.width - nMargin * 5 ) / 4;
            scroll_height = scrollBack.frame.size.height - nMargin * 2;
            nTopMargin = nMargin;
            nLeftMargin = nMargin * 2 + scroll_width;
        } else if (nSubStyle == 3) {
            scroll_width = scrollBack.frame.size.width - nMargin * 2;
            scroll_height = (scrollBack.frame.size.height - nMargin * 5 ) / 4;
            nLeftMargin = nMargin;
            nTopMargin = nMargin * 2 + scroll_height;
        } else if (nSubStyle == 4) {
            scroll_width = (scrollBack.frame.size.width - nMargin * 3 ) * 3 / 5;
            scroll_height = (scrollBack.frame.size.height - nMargin * 4 ) / 3;
            nLeftMargin = scrollBack.frame.size.width - nMargin - scroll_width;
            nTopMargin = nMargin;
        } else if (nSubStyle == 5) {
            scroll_width = (scrollBack.frame.size.width - nMargin * 3 ) * 2 / 5;
            scroll_height = (scrollBack.frame.size.height - nMargin * 2 );
            nLeftMargin = scrollBack.frame.size.width - nMargin - scroll_width;
            nTopMargin = nMargin;
        } else if (nSubStyle == 6) {
            scroll_width = (scrollBack.frame.size.width - nMargin * 4 ) / 3;
            scroll_height = (scrollBack.frame.size.height - nMargin * 3 ) * 3 / 5;
            nTopMargin = scrollBack.frame.size.height - nMargin - scroll_height;
            nLeftMargin = nMargin;
        } else if (nSubStyle == 7) {
            scroll_width = (scrollBack.frame.size.width - nMargin * 4 ) / 3;
            scroll_height = (scrollBack.frame.size.height - nMargin * 3 ) * 3 / 5;
            nTopMargin = nMargin;
            nLeftMargin = nMargin * 2 + scroll_width;
        }
    }
    
    rc = CGRectMake(nLeftMargin, nTopMargin, scroll_width, scroll_height);
    return rc;
}

- (CGRect) getScrollFrame3
{
    CGRect rc;
    
    float scroll_width = 0;
    float scroll_height = 0;
    
    float nLeftMargin = 0;
    float nTopMargin = 0;
    
    if (nStyle == 3) {
        if (nSubStyle == 1) {
            scroll_width = (scrollBack.frame.size.width - nMargin * 3 ) * 3 / 5;
            scroll_height = (scrollBack.frame.size.height - nMargin * 3 ) / 2;
            nLeftMargin = scrollBack.frame.size.width - nMargin - scroll_width;
            nTopMargin = scrollBack.frame.size.height - nMargin - scroll_height;
        } else if (nSubStyle == 2) {
            scroll_width = (scrollBack.frame.size.width - nMargin * 3 ) * 3 / 5;
            scroll_height = (scrollBack.frame.size.height - nMargin * 3 ) / 2;
            nTopMargin = scrollBack.frame.size.height - nMargin - scroll_height;
            nLeftMargin = nMargin;
        } else if (nSubStyle == 3) {
            scroll_width = (scrollBack.frame.size.width - nMargin * 3 ) / 2;
            scroll_height = (scrollBack.frame.size.height - nMargin * 3 ) * 3 / 5;
            nTopMargin = scrollBack.frame.size.height - nMargin - scroll_height;
            nLeftMargin = scrollBack.frame.size.width - nMargin - scroll_width;
        } else if (nSubStyle == 4) {
            scroll_width = (scrollBack.frame.size.width - nMargin * 2 );
            scroll_height = (scrollBack.frame.size.height - nMargin * 3 ) * 2 / 5;
            nTopMargin = scrollBack.frame.size.height - nMargin - scroll_height;
            nLeftMargin = nMargin;
        } else if (nSubStyle == 5) {
            scroll_width = (scrollBack.frame.size.width - nMargin * 4 ) / 3;
            scroll_height = scrollBack.frame.size.height - nMargin * 2;
            nTopMargin = nMargin;
            nLeftMargin = nMargin * 3 + scroll_width * 2;
        } else if (nSubStyle == 6) {
            scroll_width = scrollBack.frame.size.width - nMargin * 2;
            scroll_height = (scrollBack.frame.size.height - nMargin * 4 ) / 3;
            nLeftMargin = nMargin;
            nTopMargin = nMargin * 3 + scroll_height * 2;
        }
    } else if (nStyle == 4) {
        if (nSubStyle == 1) {
            scroll_width = (scrollBack.frame.size.width - nMargin * 3 ) / 2;
            scroll_height = (scrollBack.frame.size.height - nMargin * 3 ) / 2;
            nLeftMargin = nMargin;
            nTopMargin = nMargin * 2 + scroll_height;
        } else if (nSubStyle == 2) {
            scroll_width = (scrollBack.frame.size.width - nMargin * 5 ) / 4;
            scroll_height = scrollBack.frame.size.height - nMargin * 2;
            nTopMargin = nMargin;
            nLeftMargin = nMargin * 3 + scroll_width * 2;
        } else if (nSubStyle == 3) {
            scroll_width = scrollBack.frame.size.width - nMargin * 2;
            scroll_height = (scrollBack.frame.size.height - nMargin * 5 ) / 4;
            nLeftMargin = nMargin;
            nTopMargin = nMargin * 3 + scroll_height * 2;
        } else if (nSubStyle == 4) {
            scroll_width = (scrollBack.frame.size.width - nMargin * 3 ) * 3 / 5;
            scroll_height = (scrollBack.frame.size.height - nMargin * 4 ) / 3;
            nLeftMargin = scrollBack.frame.size.width - nMargin - scroll_width;
            nTopMargin = nMargin * 2 + scroll_height;
        } else if (nSubStyle == 5) {
            scroll_width = (scrollBack.frame.size.width - nMargin * 3 ) * 3 / 5;
            scroll_height = (scrollBack.frame.size.height - nMargin * 4 ) / 3;
            nTopMargin = nMargin * 2 + scroll_height;
            nLeftMargin = nMargin;
        } else if (nSubStyle == 6) {
            scroll_width = (scrollBack.frame.size.width - nMargin * 4 ) / 3;
            scroll_height = (scrollBack.frame.size.height - nMargin * 3 ) * 3 / 5;
            nTopMargin = scrollBack.frame.size.height - nMargin - scroll_height;
            nLeftMargin = nMargin * 2 + scroll_width;
        } else if (nSubStyle == 7) {
            scroll_width = (scrollBack.frame.size.width - nMargin * 4 ) / 3;
            scroll_height = (scrollBack.frame.size.height - nMargin * 3 ) * 3 / 5;
            nTopMargin = nMargin;
            nLeftMargin = nMargin * 3 + scroll_width * 2;
        }
    }
    
    rc = CGRectMake(nLeftMargin, nTopMargin, scroll_width, scroll_height);
    return rc;
}

- (CGRect) getScrollFrame4
{
    CGRect rc;
    
    float scroll_width = 0;
    float scroll_height = 0;
    
    float nLeftMargin = 0;
    float nTopMargin = 0;
    
    if (nStyle == 4) {
        if (nSubStyle == 1) {
            scroll_width = (scrollBack.frame.size.width - nMargin * 3 ) / 2;
            scroll_height = (scrollBack.frame.size.height - nMargin * 3 ) / 2;
            nLeftMargin = nMargin * 2 + scroll_width;
            nTopMargin = nMargin * 2 + scroll_height;
        } else if (nSubStyle == 2) {
            scroll_width = (scrollBack.frame.size.width - nMargin * 5 ) / 4;
            scroll_height = scrollBack.frame.size.height - nMargin * 2;
            nTopMargin = nMargin;
            nLeftMargin = nMargin * 4 + scroll_width * 3;
        } else if (nSubStyle == 3) {
            scroll_width = scrollBack.frame.size.width - nMargin * 2;
            scroll_height = (scrollBack.frame.size.height - nMargin * 5 ) / 4;
            nLeftMargin = nMargin;
            nTopMargin = nMargin * 4 + scroll_height * 3;
        } else if (nSubStyle == 4) {
            scroll_width = (scrollBack.frame.size.width - nMargin * 3 ) * 3 / 5;
            scroll_height = (scrollBack.frame.size.height - nMargin * 4 ) / 3;
            nLeftMargin = scrollBack.frame.size.width - nMargin - scroll_width;
            nTopMargin = nMargin * 3 + scroll_height * 2;
        } else if (nSubStyle == 5) {
            scroll_width = (scrollBack.frame.size.width - nMargin * 3 ) * 3 / 5;
            scroll_height = (scrollBack.frame.size.height - nMargin * 4 ) / 3;
            nTopMargin = nMargin * 3 + scroll_height * 2;
            nLeftMargin = nMargin;
        } else if (nSubStyle == 6) {
            scroll_width = (scrollBack.frame.size.width - nMargin * 4 ) / 3;
            scroll_height = (scrollBack.frame.size.height - nMargin * 3 ) * 3 / 5;
            nTopMargin = scrollBack.frame.size.height - nMargin - scroll_height;
            nLeftMargin = nMargin * 3 + scroll_width * 2;
        } else if (nSubStyle == 7) {
            scroll_width = (scrollBack.frame.size.width - nMargin * 2 );
            scroll_height = (scrollBack.frame.size.height - nMargin * 3 ) * 2 / 5;
            nLeftMargin = nMargin;
            nTopMargin = scrollBack.frame.size.height - nMargin - scroll_height;
        }
    }
    
    rc = CGRectMake(nLeftMargin, nTopMargin, scroll_width, scroll_height);
    return rc;
}

- (void) activeSliders
{
    if (nStyle == 1) {
        [sliderAdjustRow setHidden:YES];
        [sliderAdjustCol setHidden:YES];
    } else if (nStyle == 2) {
        if (nSubStyle == 1) {
            [sliderAdjustCol setHidden:YES];
            sliderAdjustRow.frame = CGRectMake(40, 350, 240, 10);
            if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                sliderAdjustRow.frame = CGRectMake(84, 860, 600, 10);
        } else if (nSubStyle == 2) {
            [sliderAdjustRow setHidden:YES];
            sliderAdjustCol.frame = CGRectMake(40, 350, 240, 10);
            if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                sliderAdjustCol.frame = CGRectMake(84, 860, 600, 10);
        }
    } else if (nStyle == 3) {
        if (nSubStyle == 5) {
            [sliderAdjustCol setHidden:YES];
            sliderAdjustRow.frame = CGRectMake(40, 350, 240, 10);
            if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                sliderAdjustRow.frame = CGRectMake(84, 860, 600, 10);
        } else if (nSubStyle == 6) {
            [sliderAdjustRow setHidden:YES];
            sliderAdjustCol.frame = CGRectMake(40, 350, 240, 10);
            if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                sliderAdjustCol.frame = CGRectMake(84, 860, 600, 10);
        }
    } else if (nStyle == 4) {
        if (nSubStyle == 2) {
            [sliderAdjustCol setHidden:YES];
            sliderAdjustRow.frame = CGRectMake(40, 350, 240, 10);
            if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                sliderAdjustRow.frame = CGRectMake(84, 860, 600, 10);
        } else if (nSubStyle == 3) {
            [sliderAdjustRow setHidden:YES];
            sliderAdjustCol.frame = CGRectMake(40, 350, 240, 10);
            if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                sliderAdjustCol.frame = CGRectMake(84, 860, 600, 10);
        }
    }
}

- (void) setAdjustLimitWidth
{
    int nLimitChange = 0;
    
    if (nStyle == 2) {
        if (nSubStyle == 1) {
            nLimitChange = ( scrollBack.frame.size.width - nMargin * 3 ) / 4;
        }
    } else if (nStyle == 3) {
        if (nSubStyle == 1) {
            nLimitChange = ( scrollBack.frame.size.width - nMargin * 3 ) / 5;
        } else if (nSubStyle == 2) {
            nLimitChange = ( scrollBack.frame.size.width - nMargin * 3 ) / 5;
        } else if (nSubStyle == 3) {
            nLimitChange = ( scrollBack.frame.size.width - nMargin * 3 ) / 4;
        } else if (nSubStyle == 4) {
            nLimitChange = ( scrollBack.frame.size.width - nMargin * 3 ) / 4;
        } else if (nSubStyle == 5) {
            nLimitChange = ( scrollBack.frame.size.width - nMargin * 4 ) / 6;
        }
    } else if (nStyle == 4) {
        if (nSubStyle == 1) {
            nLimitChange = ( scrollBack.frame.size.width - nMargin * 3 ) / 4;
        } else if (nSubStyle == 2) {
            nLimitChange = ( scrollBack.frame.size.width - nMargin * 5 ) / 8;
        } else if (nSubStyle == 4) {
            nLimitChange = ( scrollBack.frame.size.width - nMargin * 3 ) / 5;
        } else if (nSubStyle == 5) {
            nLimitChange = ( scrollBack.frame.size.width - nMargin * 3 ) / 5;
        } else if (nSubStyle == 6) {
            nLimitChange = ( scrollBack.frame.size.width - nMargin * 4 ) / 6;
        } else if (nSubStyle == 7) {
            nLimitChange = ( scrollBack.frame.size.width - nMargin * 4 ) / 6;
        }
    }
    
    [sliderAdjustRow setMinimumValue:0.0f];
    [sliderAdjustRow setMaximumValue:nLimitChange*2];
    [sliderAdjustRow setValue:nLimitChange];
    
    nChangeWidth = nLimitChange;
}

- (void) setAdjustLimitHeight
{
    int nLimitChange = 0;
    
    if (nStyle == 2) {
        if (nSubStyle == 2) {
            nLimitChange = ( scrollBack.frame.size.height - nMargin * 3 ) / 4;
        }
    } else if (nStyle == 3) {
        if (nSubStyle == 1) {
            nLimitChange = ( scrollBack.frame.size.height - nMargin * 3 ) / 4;
        } else if (nSubStyle == 2) {
            nLimitChange = ( scrollBack.frame.size.height - nMargin * 3 ) / 4;
        } else if (nSubStyle == 3) {
            nLimitChange = ( scrollBack.frame.size.height - nMargin * 3 ) / 5;
        } else if (nSubStyle == 4) {
            nLimitChange = ( scrollBack.frame.size.height - nMargin * 3 ) / 5;
        } else if (nSubStyle == 6) {
            nLimitChange = ( scrollBack.frame.size.height - nMargin * 4 ) / 6;
        }
    } else if (nStyle == 4) {
        if (nSubStyle == 1) {
            nLimitChange = ( scrollBack.frame.size.height - nMargin * 3 ) / 4;
        } else if (nSubStyle == 3) {
            nLimitChange = ( scrollBack.frame.size.height - nMargin * 5 ) / 8;
        } else if (nSubStyle == 4) {
            nLimitChange = ( scrollBack.frame.size.height - nMargin * 3 ) / 6;
        } else if (nSubStyle == 5) {
            nLimitChange = ( scrollBack.frame.size.height - nMargin * 3 ) / 6;
        } else if (nSubStyle == 6) {
            nLimitChange = ( scrollBack.frame.size.height - nMargin * 4 ) / 5;
        } else if (nSubStyle == 7) {
            nLimitChange = ( scrollBack.frame.size.height - nMargin * 4 ) / 5;
        }
    }
    
    [sliderAdjustCol setMinimumValue:0.0f];
    [sliderAdjustCol setMaximumValue:nLimitChange*2];
    [sliderAdjustCol setValue:nLimitChange];
    
    nChangeHeight = nLimitChange;
}

- (void) showImageTabBar:(int)imageTag ANI:(BOOL)ani
{
    nCurrentImage = imageTag;
    if (nTabBarState == TAB_IMAGEEDT) {
        return;
    }
    UIImage* tab_image1 = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"tab_replace.png" ofType:nil]];
    UIImage* tab_image2 = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"tab_rotate_right.png" ofType:nil]];
    UIImage* tab_image3 = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"tab_rotate_left.png" ofType:nil]];
    UIImage* tab_image4 = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"tab_flip.png" ofType:nil]];
    UIImage* tab_image5 = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"tab_done.png" ofType:nil]];
    
    UITabBarItem* item1 = [[UITabBarItem alloc] initWithTitle:@"Replace" image:tab_image1 tag:TAB_REPLACE];
    UITabBarItem* item2 = [[UITabBarItem alloc] initWithTitle:@"Rotate" image:tab_image2 tag:TAB_ROTATE1];
    UITabBarItem* item3 = [[UITabBarItem alloc] initWithTitle:@"Rotate" image:tab_image3 tag:TAB_ROTATE2];
    UITabBarItem* item4 = [[UITabBarItem alloc] initWithTitle:@"Flip" image:tab_image4 tag:TAB_FLIP];
    UITabBarItem* item5 = [[UITabBarItem alloc] initWithTitle:@"Done" image:tab_image5 tag:TAB_DONE];

    [tabBar setItems:[NSArray arrayWithObjects:item1,item2,item3,item4,item5,nil] animated:ani];
    
    [item1 release];
    [item2 release];
    [item3 release];
    [item4 release];
    [item5 release];
    
    nTabBarState = TAB_IMAGEEDT;
}

- (void) showAdvancedTabBar
{
    UIImage* tab_image1 = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"frame.png" ofType:nil]];
    UIImage* tab_image2 = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"corner.png" ofType:nil]];
    UIImage* tab_image3 = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"color.png" ofType:nil]];
    UIImage* tab_image4 = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"adjust.png" ofType:nil]];
    
    UITabBarItem* item1 = [[UITabBarItem alloc] initWithTitle:@"Frame" image:tab_image1 tag:TAB_FRAME];
    UITabBarItem* item2 = [[UITabBarItem alloc] initWithTitle:@"Corner" image:tab_image2 tag:TAB_CORNER];
    UITabBarItem* item3 = [[UITabBarItem alloc] initWithTitle:@"Style" image:tab_image3 tag:TAB_STYLE];
    UITabBarItem* item4 = [[UITabBarItem alloc] initWithTitle:@"Adjust" image:tab_image4 tag:TAB_ADJUST];
    
    [tabBar setItems:[NSArray arrayWithObjects:item1,item2,item3,item4,nil] animated:YES];

    [item1 release];
    [item2 release];
    [item3 release];
    [item4 release];
    
    nTabBarState = TAB_ADVANCED;
}

- (void) rotateImage:(int)rotateType
{
    UIImageView* image;
    if (nCurrentImage == IMAGE1_VIEW_TAG) {
        image = image1;
        if (rotateType == ROTATE_RIGHT) {
            fRotateImage1 += 90;
            if (fRotateImage1 == 360) {
                fRotateImage1 = 0;
            }
            CGAffineTransform rotate = CGAffineTransformMakeRotation( fRotateImage1 / 180.0 * 3.14 );
            [image1 setTransform:rotate];
        } else if (rotateType == ROTATE_LEFT) {
            fRotateImage1 -= 90;
            if (fRotateImage1 == -360) {
                fRotateImage1 = 0;
            }
            CGAffineTransform rotate = CGAffineTransformMakeRotation( fRotateImage1 / 180.0 * 3.14 );
            [image1 setTransform:rotate];
        } else if (rotateType == ROTATE_FLIP) {
            int state = abs(fRotateImage1);
            image1.image = [self flipImageVertically:image1.image direction:state % 180 == 0?@"y":@"x"];
        }
        [self fitImageToScroll:image1 SCROLL:scrollView1];
    } else if (nCurrentImage == IMAGE2_VIEW_TAG) {
        image = image2;
        if (rotateType == ROTATE_RIGHT) {
            fRotateImage2 += 90;
            if (fRotateImage2 == 360) {
                fRotateImage2 = 0;
            }
            CGAffineTransform rotate = CGAffineTransformMakeRotation( fRotateImage2 / 180.0 * 3.14 );
            [image2 setTransform:rotate];
        } else if (rotateType == ROTATE_LEFT) {
            fRotateImage2 -= 90;
            if (fRotateImage2 == -360) {
                fRotateImage2 = 0;
            }
            CGAffineTransform rotate = CGAffineTransformMakeRotation( fRotateImage2 / 180.0 * 3.14 );
            [image2 setTransform:rotate];
        } else if (rotateType == ROTATE_FLIP) {
            int state = abs(fRotateImage2);
            image2.image = [self flipImageVertically:image2.image direction:state % 180 == 0?@"y":@"x"];
        }
        [self fitImageToScroll:image2 SCROLL:scrollView2];
    } else if (nCurrentImage == IMAGE3_VIEW_TAG) {
        image = image3;
        if (rotateType == ROTATE_RIGHT) {
            fRotateImage3 += 90;
            if (fRotateImage3 == 360) {
                fRotateImage3 = 0;
            }
            CGAffineTransform rotate = CGAffineTransformMakeRotation( fRotateImage3 / 180.0 * 3.14 );
            [image3 setTransform:rotate];
        } else if (rotateType == ROTATE_LEFT) {
            fRotateImage3 -= 90;
            if (fRotateImage3 == -360) {
                fRotateImage3 = 0;
            }
            CGAffineTransform rotate = CGAffineTransformMakeRotation( fRotateImage3 / 180.0 * 3.14 );
            [image3 setTransform:rotate];
        } else if (rotateType == ROTATE_FLIP) {
            int state = abs(fRotateImage3);
            image3.image = [self flipImageVertically:image3.image direction:state % 180 == 0?@"y":@"x"];
        }
        [self fitImageToScroll:image3 SCROLL:scrollView3];
    } else if (nCurrentImage == IMAGE4_VIEW_TAG) {
        image = image4;
        if (rotateType == ROTATE_RIGHT) {
            fRotateImage4 += 90;
            if (fRotateImage4 == 360) {
                fRotateImage4 = 0;
            }
            CGAffineTransform rotate = CGAffineTransformMakeRotation( fRotateImage4 / 180.0 * 3.14 );
            [image4 setTransform:rotate];
        } else if (rotateType == ROTATE_LEFT) {
            fRotateImage4 -= 90;
            if (fRotateImage4 == -360) {
                fRotateImage4 = 0;
            }
            CGAffineTransform rotate = CGAffineTransformMakeRotation( fRotateImage4 / 180.0 * 3.14 );
            [image4 setTransform:rotate];
        } else if (rotateType == ROTATE_FLIP) {
            int state = abs(fRotateImage4);
            image4.image = [self flipImageVertically:image4.image direction:state % 180 == 0?@"y":@"x"];
        }
        [self fitImageToScroll:image4 SCROLL:scrollView4];
    }
}

- (UIImage *) flipImageVertically:(UIImage *)originalImage direction:(NSString *)axis 
{
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:originalImage];
    
    UIGraphicsBeginImageContext(tempImageView.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGAffineTransform flipVertical = CGAffineTransformMake(0, 0, 0, 0, 0, 0);
    if([axis isEqualToString:@"x"])
    {
        flipVertical = CGAffineTransformMake(
                                             1, 0, 0, -1, 0, tempImageView.frame.size.height
                                             );
    }
    else if([axis isEqualToString:@"y"] )
    {
        flipVertical = CGAffineTransformMake(
                                             -1, 0, 0, 1, tempImageView.frame.size.width, 0
                                             );
    }
    CGContextConcatCTM(context, flipVertical);  
    
    [tempImageView.layer renderInContext:context];
    
    UIImage *flipedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [tempImageView release];
    
    return flipedImage;
}  

@end

