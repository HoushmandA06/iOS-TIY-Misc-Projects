//
//  DLAStageScribble.m
//  DrawLinesApp
//
//  Created by Ali Houshmand on 4/15/14.
//  Copyright (c) 2014 Ali Houshmand. All rights reserved.
//

#import "DLAStageScribble.h"

@implementation DLAStageScribble
{
    NSMutableArray * scribbles;
    UIButton * redColorButton;
    UIButton * greenColorButton;
    UIButton * blueColorButton;
    UISlider * widthSlider;
    NSArray * sliderRange;
 }


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        
        scribbles = [@[] mutableCopy];
        self.lineWidth = 2.0;  // default width
        self.lineColor = [UIColor colorWithWhite:0.3 alpha:1.0];  // default color
        
        /*
        redColorButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-300, SCREEN_HEIGHT * .85, 50, 50)];
        [redColorButton setTitle:@"Red" forState:UIControlStateNormal];
        [redColorButton addTarget:self action:@selector(changeLineColor:) forControlEvents:UIControlEventTouchUpInside];
        [redColorButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        redColorButton.backgroundColor = [UIColor redColor];
        redColorButton.layer.cornerRadius = 25;
        [self addSubview:redColorButton];
        
        greenColorButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-240, SCREEN_HEIGHT * .85, 50, 50)];
        [greenColorButton setTitle:@"Green" forState:UIControlStateNormal];
        [greenColorButton addTarget:self action:@selector(changeLineColor:) forControlEvents:UIControlEventTouchUpInside];
        [greenColorButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        greenColorButton.backgroundColor = [UIColor greenColor];
        greenColorButton.layer.cornerRadius = 25;
        [self addSubview:greenColorButton];
        
        blueColorButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-180, SCREEN_HEIGHT * .85, 50, 50)];
        [blueColorButton setTitle:@"Blue" forState:UIControlStateNormal];
        [blueColorButton addTarget:self action:@selector(changeLineColor:) forControlEvents:UIControlEventTouchUpInside];
        [blueColorButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        blueColorButton.backgroundColor = [UIColor blueColor];
        blueColorButton.layer.cornerRadius = 25;
        [self addSubview:blueColorButton];
       
        widthSlider = [[UISlider alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-300, SCREEN_HEIGHT * .75,170,40)];
        widthSlider.backgroundColor = [UIColor blackColor];
        // [widthSlider addTarget:self action:@selector(setwidth) forControlEvents:...]
        widthSlider.layer.cornerRadius = 6;
        [self addSubview:widthSlider]; */
    
    }
    return self;
}




//-(void)changeLineColor:(UIButton *)sender
//{
//    [self setLineColor:sender.backgroundColor];
//}

-(void)setLineWidth:(float)lineWidth
{

    _lineWidth = lineWidth;
    [self setNeedsDisplay];

}

    
-(void)setLineColor:(UIColor *)lineColor
{
    _lineColor = lineColor;
    [self setNeedsDisplay];
}


- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, self.lineWidth);
    CGContextClearRect(context, rect);
    
    
    [self.lineColor set];
    
    for (NSArray * scribble in scribbles)
    {
        NSLog(@"%d",[scribble count]);
        CGPoint start = [scribble[0] CGPointValue];
        CGContextMoveToPoint(context, start.x, start.y);
        for (NSValue * value in scribble) {

            //int index = [scribble indexOfObject:value];
            
            CGPoint point = [value CGPointValue];

            //if (index > 0 || [scribble count] < 3)
                CGContextAddLineToPoint(context, point.x, point.y);
        }
        CGContextStrokePath(context); //run this to break up a line or shape
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    for (UITouch * touch in touches) {
        CGPoint location = [touch locationInView:self];
        [scribbles addObject:[@[
                                [NSValue valueWithCGPoint:location]]
                                mutableCopy]];
        
    }
    [self setNeedsDisplay];
    
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch * touch in touches) {
        CGPoint location = [touch locationInView:self];
        [[scribbles lastObject] addObject:[NSValue valueWithCGPoint:location]];
    

    }
    [self setNeedsDisplay];
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch * touch in touches) {
        CGPoint location = [touch locationInView:self];
        [[scribbles lastObject] addObject:[NSValue valueWithCGPoint:location]];

    }
    [self setNeedsDisplay];
}




@end