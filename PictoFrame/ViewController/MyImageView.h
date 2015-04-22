//
//  MyImageView.h
//  PictoFrame
//
//  Created by Thomas on 9/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PhotoViewController;

@interface MyImageView : UIImageView {
    PhotoViewController*    delegate;
    BOOL                    selected;
}

@property(nonatomic, retain) PhotoViewController*   delegate;
@property(nonatomic) BOOL                           selected;

@end
