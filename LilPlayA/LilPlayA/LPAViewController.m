//
//  LPAViewController.m
//  LilPlayA
//
//  Created by Ali Houshmand on 5/13/14.
//  Copyright (c) 2014 Ali Houshmand. All rights reserved.
//



#import "LPAViewController.h"



 // 2. touched moved does not work well, especially scrubbing left SEE ACTIONS REQUIRED IN TOUCHES MOVED
 // 4. volume button sometimes causes seekButton to jump


@interface LPAViewController ()
{

    
    AVAudioPlayer * player;
    
    UIView * seekButton;
    UIButton * playButton;
    UIButton * stopButton;
    UIView * progressBar;
    UISlider * volume;
    UILabel * currentTimeLabel;
    UILabel * songLengthLabel;
    UIView * touchFrame;
    
    
    
    float oldX, oldY;
    BOOL dragging;
}

@end

@implementation LPAViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
       
        self.view.backgroundColor = [UIColor lightGrayColor];
        
        songLengthLabel = [[UILabel alloc] initWithFrame:CGRectMake(250, 260, 50, 30)];
        songLengthLabel.backgroundColor = [UIColor clearColor];
        songLengthLabel.textColor = [UIColor orangeColor];
        [self.view addSubview:songLengthLabel];
        
        stopButton = [[UIButton alloc] initWithFrame:CGRectMake(250,220,50,50)];
         [stopButton setImage:[UIImage imageNamed:@"stop"] forState:UIControlStateNormal];
        stopButton.backgroundColor = [UIColor clearColor];
      
        [self.view addSubview:stopButton];
        
        playButton = [[UIButton alloc] initWithFrame:CGRectMake(25,220,50,50)];
        [playButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
        [playButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateSelected];
        playButton.backgroundColor = [UIColor clearColor];
       
        [self.view addSubview:playButton];
        
        progressBar = [[UIView alloc] initWithFrame:CGRectMake(85, 250, 150, 4)];
        progressBar.layer.cornerRadius = 2;
        progressBar.backgroundColor = [UIColor darkGrayColor];
        [self.view addSubview:progressBar];
        
        
        touchFrame = [[UIView alloc] initWithFrame:CGRectMake(85,250,150,25)];
        touchFrame.backgroundColor = [UIColor clearColor];
        [self.view addSubview:touchFrame];
        
        
        seekButton = [[UIView alloc] initWithFrame:CGRectMake(80, 247, 10, 10)];
        seekButton.backgroundColor = [UIColor orangeColor];
        seekButton.layer.cornerRadius = 5;
        [self.view addSubview:seekButton];
        
        volume = [[UISlider alloc] initWithFrame:CGRectMake(85, 325, 150, 4)];
        volume.layer.cornerRadius = 2;
        [volume addTarget:self action:@selector(setVolume:) forControlEvents:UIControlEventTouchUpInside];
        volume.tintColor = [UIColor blueColor];
        [self.view addSubview:volume];
        
        [stopButton addTarget:self action:@selector(stop) forControlEvents:UIControlEventTouchUpInside];
        [playButton addTarget:self action:@selector(play:) forControlEvents:UIControlEventTouchUpInside];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, (unsigned long)NULL), ^{
            
        NSURL * url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/147445565/download?client_id=2d87025c8392069f828c446b965862e3"];
            
        NSData * data = [NSData dataWithContentsOfURL:url];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            player = [[AVAudioPlayer alloc] initWithData:data error:nil];
            NSLog(@"player ready");
            });
        });
        
        // prepare to play with AVAudioPlayer
        // connect to URL
        // UIView "progress bar" with circle for "time remaining"
        
    }
    return self;
}

-(void)setVolume:(UISlider *)slider
{
    player.volume = 0;
    
    player.volume = slider.value;
    
}


-(void)play:(UIButton *)sender
{
    if([player isPlaying])
    {
        [player pause];
        [self.timer invalidate];
        playButton.selected = NO;

    } else {
 
        playButton.selected = YES;
        [player play];
        
        [self.timer invalidate];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateProgressBar:) userInfo:nil repeats:YES];
    }
    
}

-(void)pause:(UIButton *)sender
{
    if(sender.selected == NO)
    {
        [player pause];
        [self.timer invalidate];
        playButton.selected = NO;
    }
    
}

-(void)stop
{
    [player stop];
    player.currentTime = 0;
    playButton.selected = NO;
    
   [self updateProgressBar:self.timer];
    
    [self.timer invalidate];
    self.timer = nil;
}






-(void)updateProgressBar:(NSTimer *)timer
{
    NSTimeInterval current = [player currentTime];
    NSTimeInterval length = [player duration];
    float progress = current/length;
    NSLog(@"%f",progress);
    
    float xPosition = progressBar.frame.origin.x + progress * progressBar.frame.size.width;
    
    seekButton.frame = CGRectMake(xPosition, 247, 10, 10);
    
    [currentTimeLabel removeFromSuperview];
    
    currentTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(seekButton.frame.origin.x, 260, 50, 30)];
    currentTimeLabel.backgroundColor = [UIColor clearColor];
    currentTimeLabel.textColor = [UIColor orangeColor];
 
    static NSDateFormatter *dateFormatter;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"mm:ss";
    }
   
    currentTimeLabel.text = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:current]];
    [self.view addSubview:currentTimeLabel];
    
    // move this to init
  
    
    /// leave this line here to update
    songLengthLabel.text = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:(length-current)]];

    
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self pause:nil];
    
    UITouch *aTouch = [touches anyObject];
    CGPoint location = [aTouch locationInView:touchFrame];   //
    CGPoint previousLocation = [aTouch previousLocationInView:touchFrame];
    
    BOOL isInsideSeek = CGRectContainsPoint(touchFrame.frame, [aTouch locationInView:self.view]);
    
    NSLog(@"Is Inside Seek %u",isInsideSeek);
    
    //// stop if not inside seek button
    if(!isInsideSeek) return;
    
    if(seekButton.frame.origin.x >= progressBar.frame.origin.x && seekButton.frame.origin.x <= progressBar.frame.size.width)
    {
    // make seek button position center of location.x
    seekButton.frame = CGRectOffset(seekButton.frame, (location.x - previousLocation.x), 0);

    player.currentTime = player.duration * ((seekButton.frame.origin.x - progressBar.frame.origin.x)/progressBar.frame.size.width);
    
    currentTimeLabel.frame = CGRectOffset(currentTimeLabel.frame, (location.x - previousLocation.x), 0);

//  float totalMin = floor(duration/60);
//  float totalSec = round(duration - totalMin * 60);
//  totalTimeLabel.text = [NSString stringWithFormat:@"%02d:%02d", (int)totalMin, (int)totalSec];

    static NSDateFormatter *dateFormatter;
    if (!dateFormatter) {
            dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = @"mm:ss";
    }
        
    currentTimeLabel.text = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:player.currentTime]];
    
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch * aTouch = [touches anyObject];
    
    if ([[aTouch.view class] isSubclassOfClass:[UIView class]]) {
        dragging = YES;
        
        [self pause:nil];
    }
}


-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    dragging = YES;
    
    for (UITouch * aTouch in touches) {
  //  CGPoint location = [aTouch locationInView:seekButton];
        
    
        CGPoint location = [aTouch locationInView:touchFrame];   //
     
        
        BOOL isInsideSeek = CGRectContainsPoint(touchFrame.frame, [aTouch locationInView:self.view]);
        
        NSLog(@"Is Inside Seek %u",isInsideSeek);
        
    //// stop if not inside seek button
        if(!isInsideSeek) return;
    
    
    ///// whatever you do in the touches moved to only listen for touches in fake rect ... do here as well
    ///// need != here too
        
    seekButton.frame = CGRectOffset(touchFrame.frame, (location.x), 0);
    currentTimeLabel.frame = CGRectOffset(currentTimeLabel.frame, (location.x), 0);
    player.currentTime = player.duration * ((seekButton.frame.origin.x - progressBar.frame.origin.x)/progressBar.frame.size.width);

    [self.timer invalidate];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateProgressBar:) userInfo:nil repeats:YES];

        
    }


}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
