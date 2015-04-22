//
//  PhotoViewController.h
//  PictoFrame
//
//  Created by Thomas on 9/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FrameViewController;
@class MyImageView;

@interface PhotoViewController : UIViewController<UITabBarDelegate, UIScrollViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIPopoverControllerDelegate> {

    FrameViewController* delegate;
    //style attributes
    int             nStyle;
    int             nSubStyle;
    int             nMode;
    
    //frame attributes
    int             nCorner;
    int             nMargin;
    int             nFrameBack;//0:color 1:image
    int             nFrameColor;
    int             nFrameImage;
    
    MyImageView*    image1;
    MyImageView*    image2;
    MyImageView*    image3;
    MyImageView*    image4;
    
    IBOutlet UITabBar* tabBar;
    UIView*         scrollBack;
    UIImageView*    scrollBackImage;
    UIScrollView*   scrollView1;
    UIScrollView*   scrollView2;
    UIScrollView*   scrollView3;
    UIScrollView*   scrollView4;
    
    UISlider*       sliderCorner;
    UISlider*       sliderMargin;
    
    UISlider*       sliderAdjustRow;
    UISlider*       sliderAdjustCol;
    
    //style view
    IBOutlet UIView*    viewStyle;
    IBOutlet UISegmentedControl*    sgmStyle;
    IBOutlet UISlider*  sliderColorRed;
    IBOutlet UISlider*  sliderColorGreen;
    IBOutlet UISlider*  sliderColorBlur;
    IBOutlet UIButton*  btnBlack;
    IBOutlet UIButton*  btnWhite;
    
    IBOutlet UIButton*  btnBackImage1;
    IBOutlet UIButton*  btnBackImage2;
    IBOutlet UIButton*  btnBackImage3;
    IBOutlet UIButton*  btnBackImage4;
    IBOutlet UIButton*  btnBackImage5;
    IBOutlet UIButton*  btnBackImage6;
    IBOutlet UIButton*  btnBackImage7;
    IBOutlet UIButton*  btnBackImage8;
    IBOutlet UIButton*  btnBackImage9;
    IBOutlet UIButton*  btnBackImage10;
    IBOutlet UIButton*  btnBackImage11;
    IBOutlet UIButton*  btnBackImage12;
    IBOutlet UIButton*  btnBackImage13;
    IBOutlet UIButton*  btnBackImage14;
    IBOutlet UIButton*  btnBackImage15;
    IBOutlet UIButton*  btnBackImage16;
    IBOutlet UIButton*  btnBackImage17;
    IBOutlet UIButton*  btnBackImage18;
    IBOutlet UIButton*  btnBackImage19;
    IBOutlet UIButton*  btnBackImage20;
    
    int             nCurrentImage;
    
    CGRect          rcScroll1;
    CGRect          rcScroll2;
    CGRect          rcScroll3;
    CGRect          rcScroll4;
    
    int             nChangeWidth;
    int             nChangeHeight;
    int             nTabBarState;
    
    float           fRotateImage1;
    float           fRotateImage2;
    float           fRotateImage3;
    float           fRotateImage4;
    
    BOOL            bFlipImage1;
    BOOL            bFlipImage2;
    BOOL            bFlipImage3;
    BOOL            bFlipImage4;

	UIPopoverController* popoverController;
}

@property (nonatomic, retain)         FrameViewController* delegate;
@property (nonatomic) int             nStyle;
@property (nonatomic) int             nSubStyle;
@property (nonatomic) int             nMode;

@property (nonatomic) int             nCorner;
@property (nonatomic) int             nMargin;
@property (nonatomic) int             nFrameBack;
@property (nonatomic) int             nFrameColor;
@property (nonatomic) int             nFrameImage;

- (void) setStyleView;
- (void) setVisibleStyles:(int)style;
- (void) pickImage:(int)imageTag;
- (void) resizeImageView:(UIImage*)image;
- (UIImage*)captureView:(UIView *)view;
- (void)saveScreenshotToPhotosAlbum:(UIView *)view;
- (CGRect) getScrollFrame1;
- (CGRect) getScrollFrame2;
- (CGRect) getScrollFrame3;
- (CGRect) getScrollFrame4;
- (void) activeSliders;
- (void) setAdjustLimitWidth;
- (void) setAdjustLimitHeight;
- (void) resizeImageViewWithScrollView;
- (void) fitImageToScroll:(MyImageView*)imgView SCROLL:(UIScrollView*)scrView;
- (void) showImageTabBar:(int)imageTag ANI:(BOOL)ani;
- (void) showAdvancedTabBar;
- (void) rotateImage:(int)rotateType;
- (UIImage *) flipImageVertically:(UIImage *)originalImage direction:(NSString *)axis; 

@end
