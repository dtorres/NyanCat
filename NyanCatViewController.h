//
//  NyanCatViewController.h
//  NyanCat
//
//  Created by Diego Torres on 17-04-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "FontLabel.h"


@interface NyanCatViewController : UIViewController {
	AVAudioPlayer *plyr;
    CGFloat tiempo;
    FontLabel *tiempotxt;
    UIView *controlBar;
    UIImageView *IMGV;
}
+(NyanCatViewController *)instance;
-(void)TweetTime;
-(void)hideControlBar;
-(void)showControlBar;
-(void)updateTime;
@property (nonatomic, retain)  AVAudioPlayer *plyr;
@property (nonatomic) CGFloat tiempo;
@property (nonatomic, retain) FontLabel *tiempotxt;
@property (nonatomic, retain) UIImageView *IMGV;
@property (nonatomic, retain) UIView *controlBar;
@end
