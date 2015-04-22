//
//  MyImageView.m
//  PictoFrame
//
//  Created by Thomas on 9/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MyImageView.h"
#import "PhotoViewController.h"

@implementation MyImageView
@synthesize delegate, selected;

- (void)dealloc
{
    [super dealloc];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event 
{
    if (selected) {
        [delegate showImageTabBar:(int)self.tag ANI:YES];
    } else {
        [delegate pickImage:(int)self.tag];
    }
}

@end
