//
//  DPAPondViewController.m
//  DigitalPond
//
//  Created by Ali Houshmand on 5/14/14.
//  Copyright (c) 2014 Ali Houshmand. All rights reserved.
//

#import "DPAPondViewController.h"
#import "DPARipple.h"

@interface DPAPondViewController ()

@end

@implementation DPAPondViewController
{
    NSArray * colors;
    NSMutableArray * backgrounds;
    UIButton * swipeArea;
    int currentBackground;
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.view.multipleTouchEnabled = YES;
        backgrounds = [@[]mutableCopy];
        currentBackground = 0;

        colors = @[
                             [UIColor colorWithRed:0.349f green:0.894f blue:0.553f alpha:1.0f],
                             [UIColor colorWithRed:0.945f green:0.337f blue:0.149f alpha:1.0f],
                             [UIColor colorWithRed:0.914f green:0.090f blue:0.420f alpha:1.0f],
                             [UIColor colorWithRed:0.255f green:0.075f blue:0.780f alpha:1.0f],
                             [UIColor colorWithRed:0.298f green:0.729f blue:0.867f alpha:1.0f]
                             ];
        
        swipeArea= [[UIButton alloc] initWithFrame:CGRectMake(20, 20, 280,40)];
        swipeArea.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.1];
        [swipeArea setTitle:@"<< swipe >>" forState:UIControlStateNormal];
        [swipeArea setTitleColor:colors[currentBackground] forState:UIControlStateNormal];
        [self.view addSubview:swipeArea];
        
        UISwipeGestureRecognizer * swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
        
        swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
        
        [swipeArea addGestureRecognizer:swipeRight];
        
        UISwipeGestureRecognizer * swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
        
        swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
        
        [swipeArea addGestureRecognizer:swipeLeft];
        
    }
    return self;
}


-(void)swipe:(UISwipeGestureRecognizer *)gesture
{
    
    NSLog(@"%@", gesture);
    NSLog(@"%d", (int)gesture.direction);
    
    int direction = (gesture.direction == 1) ? 1 : -1;
    
    currentBackground += direction;
    
    if(currentBackground == [colors count]) currentBackground = 0;
    if(currentBackground == -1) currentBackground = (int)[colors count] - 1;
    
    float w = self.view.frame.size.width;
    float h = self.view.frame.size.height;
    
    
    UIView * presentingBGView = [[UIView alloc] initWithFrame:CGRectMake(w * -direction, 0, w, h)];
    
    presentingBGView.backgroundColor = colors[currentBackground];
    
    
    [self.view insertSubview:presentingBGView atIndex:0];
    
    [backgrounds addObject:presentingBGView];
    
    for (UIView * view in backgrounds) {
    
        [UIView animateWithDuration:1.0 animations:^{
            
            view.frame = CGRectMake(view.frame.origin.x + (w * direction), 0, w, h);
            [swipeArea setTitleColor:colors[currentBackground] forState:UIControlStateNormal];
            
        
            
        } completion:^(BOOL finished) {
            
            if(index == 0)
            {
                [view removeFromSuperview];
                [backgrounds removeObject:view];
            }
            
        }];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}


-(void)viewWillAppear:(BOOL)animated
{
    UIView * bgView = [[UIView alloc] initWithFrame:self.view.frame];
    bgView.backgroundColor = colors[currentBackground];

    [self.view insertSubview:bgView atIndex:0];
    [backgrounds addObject:bgView];
}



-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
   
    NSMutableArray * otherColors = [colors mutableCopy];
    [otherColors removeObjectAtIndex:currentBackground];
    
    for (UITouch * touch in touches) {
        
        int random = arc4random_uniform((int)[otherColors count]);
        int random2 = arc4random_uniform((int)[otherColors count]);
        
        CGPoint location = [touch locationInView:self.view];
        
        DPARipple * ripple = [[DPARipple alloc] initWithFrame:CGRectMake(location.x, location.y, 0, 0)];
        
        ripple.layer.borderColor = ((UIColor *)otherColors[random2]).CGColor;
        
        ripple.tintColor = otherColors[random];
        
        ripple.rippleCount = 3;
        ripple.rippleLifeTime = 5;
        
        [self.view addSubview:ripple];
    }
    
}


-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    [self touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event];
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
