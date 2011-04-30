//
//  NyanCatViewController.m
//  NyanCat
//
//  Created by Diego Torres on 17-04-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NyanCatViewController.h"
#import "FontManager.h"
@implementation NyanCatViewController
@synthesize tiempo, tiempotxt, controlBar, IMGV, plyr;

static NyanCatViewController * instance;
static NSTimer * timer;
+(NyanCatViewController *)instance {
	if (!instance) {
		instance = [[NyanCatViewController alloc] init];
	}
	return instance;
}

/*- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}*/

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


// Implement loadView to create a view hierarchy programmatically, without using a nib.

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];
    //This will show the control bar if it is hidden.
	if (touch.tapCount > 0) {
        if (controlBar.frame.origin.y == 320) {
            [self showControlBar];
        }
	}
}

-(void)TweetTime {
    //Lets tweet our achievement, but at least 15 seconds to do it.
	if (tiempo < 15) {
		UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"No Nyan :'(" message:@"You are not allowed tweet yet. Reach at least 15 seconds." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
		return;
	}
    NSString *tweeturl = [NSString stringWithFormat:@"http://twitter.com/intent/tweet?text=I+HAVE+NYANED+FOR+%.1f+SECONDS!&via=nyancatapp", tiempo];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:tweeturl]];
}
-(void)switchPlay:(UIButton *)sender{
    if (sender.selected) {
        //if playing, stop it and reset the counter
        tiempo = 0;
        [timer invalidate];
        [self.IMGV stopAnimating];
        self.IMGV.image = [UIImage imageNamed:@"poptart1red1-1 (arrastrado).tiff"];
        self.tiempotxt.text = @"0.0"; 
		[plyr pause];
    } else {
        //reset the counter just in case and start the NyanCating!
        tiempo = 0;
        timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
		plyr.currentTime = 0;		
        [plyr play];
        [self.IMGV startAnimating];
    }
    sender.selected = !sender.selected;
}
- (void)loadView
{
    //Using FontLabel Library open Silkscreen font.
    [[FontManager sharedManager] loadFont:@"Silkscreen"];
    
    //Now lets set the looped image
    int numberOfFrames = 12; //number of frames
    NSMutableArray *imagesArray = [NSMutableArray arrayWithCapacity:numberOfFrames]; //Array that will contain the images
    //lets add all the images.
    for (int i=1; numberOfFrames > i; ++i)
    {
        [imagesArray addObject:[UIImage imageNamed:
                                [NSString stringWithFormat:@"poptart1red1-%d (arrastrado).tiff", i]]];
    }
    
    //Create a Image Viewer to display the animation
    IMGV = [[[UIImageView alloc] initWithFrame:CGRectMake(0,-80,480,480)] autorelease];
    IMGV.animationImages = imagesArray; 
    IMGV.animationDuration = 1;
    
    //Start animation and add it to the view.
    [IMGV startAnimating];
    self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 480, 480)];
    [self.view addSubview:IMGV];
    
    
    //Now lets work the looped audio that makes the Nyan cat so special.
    NSError *error;
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/nyan-looped.mp3", [[NSBundle mainBundle] resourcePath]]]; //the path to the file as a url.
    plyr = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error]; //lets create an audio player to play the audio.
    plyr.numberOfLoops = -1; // -1 means infinite loops
    [plyr prepareToPlay]; //prepare the file to play
    [plyr play];//AND PLAY.
    
    //Lets set a Control Bar, initially shown.
    controlBar = [[UIView alloc] initWithFrame:CGRectMake(0, 260, 480, 60)];
    controlBar.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.65];
    
    //Button to tweet the amazing time and add it to the control bar (see TweetTime)
    UIButton *tweetit = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    tweetit.frame = CGRectMake(20, 10, 90, 40);
    [tweetit setTitle:@"TWEET IT" forState:UIControlStateNormal];
    [tweetit addTarget:self action:@selector(TweetTime) forControlEvents:UIControlEventTouchUpInside];
    [controlBar addSubview:tweetit];
    
    //Button to play and stop the cat.. it will also stop and reboot the counter (see switchPlay)
    UIButton *playPause = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    playPause.frame = CGRectMake(130, 10, 60, 40);
    [playPause setTitle:@"PLAY" forState:UIControlStateNormal];
    [playPause addTarget:self action:@selector(switchPlay:) forControlEvents:UIControlEventTouchUpInside];
    [playPause setTitle:@"STOP" forState:UIControlStateSelected];
    playPause.selected = YES;
    [controlBar addSubview:playPause];
    
    //Noew lets add the counter with silkscreen font using FontLabel
    tiempotxt = [[FontLabel alloc] initWithFrame:CGRectMake(0, 0, 400, 100) fontName:@"Silkscreen" pointSize:18.0f];
    tiempotxt.frame = CGRectMake(270, 0, 110, 60);
    tiempotxt.backgroundColor = [UIColor clearColor];
    tiempotxt.textColor = [UIColor whiteColor];
    tiempotxt.text = @"0.0";
    tiempotxt.textAlignment = UITextAlignmentRight;
    
    //Another Text, but this time static that states the unit used to measure time
    FontLabel * textoseg = [[FontLabel alloc] initWithFrame:CGRectMake(0, 0, 400, 100) fontName:@"Silkscreen" pointSize:18.0f];
    textoseg.frame = CGRectMake(385, 0, 120, 60);
    textoseg.backgroundColor = [UIColor clearColor];
    textoseg.textColor = [UIColor whiteColor];
    textoseg.text = @"seconds";
    
    //add the counter and static text to the control Bar and then to the app.
    [controlBar addSubview:tiempotxt];
    [controlBar addSubview:textoseg];
    [self.view addSubview:controlBar];
    //see viewdidload for controlbar hide.
    
    //Start the timer to count.
    tiempo = 0;
    timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
    [timer fire];
}
-(void)hideControlBar {
    //hide the control bar.
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:controlBar cache:YES];
    controlBar.frame = CGRectMake(0, 320, 480, 60);
    [UIView commitAnimations];
}

-(void)showControlBar {
    //Show the control bar and set a timer of 20 seconds to hide it again.
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:controlBar cache:YES];
    controlBar.frame = CGRectMake(0, 260, 480, 60);
    [UIView commitAnimations];
    NSTimer * timehide = [NSTimer timerWithTimeInterval:20 target:self selector:@selector(hideControlBar) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:timehide forMode:NSDefaultRunLoopMode];
}

- (void)updateTime {
    //simple method to update time.
    tiempo = tiempo + 0.1;
    tiempotxt.text = [NSString stringWithFormat:@"%.1f", tiempo];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    //now that the view has been loaded, lets set a timer that will hide the control bar at 10 seconds.
    NSTimer * timehide = [NSTimer timerWithTimeInterval:10 target:self selector:@selector(hideControlBar) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:timehide forMode:NSDefaultRunLoopMode];
    //for reappearing see touchesEnded
    [super viewDidLoad];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    //with this, the cat always looks right.
    return ((interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (interfaceOrientation == UIInterfaceOrientationLandscapeRight));
}

@end
