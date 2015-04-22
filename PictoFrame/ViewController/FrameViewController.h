//
//  FrameViewController.h
//  PictoFrame
//
//  Created by KRS on 9/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FrameViewController : UIViewController {
    IBOutlet UISegmentedControl*    segment;
    IBOutlet UIButton*              btnFrame1;
    IBOutlet UIButton*              btnFrame2;
    IBOutlet UIButton*              btnFrame3;
    IBOutlet UIButton*              btnFrame4;
    IBOutlet UIButton*              btnFrame5;
    IBOutlet UIButton*              btnFrame6;
    IBOutlet UIButton*              btnFrame7;
    IBOutlet UIButton*              btnFrame8;
    IBOutlet UIButton*              btnFrame9;
    IBOutlet UIButton*              btnFrame10;
    IBOutlet UIButton*              btnFrame11;
    IBOutlet UIButton*              btnFrame12;
    IBOutlet UIButton*              btnFrame13;
    IBOutlet UIButton*              btnFrame14;
    IBOutlet UIButton*              btnFrame15;
    IBOutlet UIButton*              btnFrame16;
    int                             nMode;
}

- (IBAction) onBtnFrame1:(id)sender;
- (IBAction) onBtnFrame2:(id)sender;
- (IBAction) onBtnFrame3:(id)sender;
- (IBAction) onBtnFrame4:(id)sender;
- (IBAction) onBtnFrame5:(id)sender;
- (IBAction) onBtnFrame6:(id)sender;
- (IBAction) onBtnFrame7:(id)sender;
- (IBAction) onBtnFrame8:(id)sender;
- (IBAction) onBtnFrame9:(id)sender;
- (IBAction) onBtnFrame10:(id)sender;
- (IBAction) onBtnFrame11:(id)sender;
- (IBAction) onBtnFrame12:(id)sender;
- (IBAction) onBtnFrame13:(id)sender;
- (IBAction) onBtnFrame14:(id)sender;
- (IBAction) onBtnFrame15:(id)sender;
- (IBAction) onBtnFrame16:(id)sender;
- (void) setFrameType:(int)mode;
- (void) selectFrame:(int)style SUB:(int)sub;

@end
