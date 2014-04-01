//
//  CARWheel.m
//  Car
//
//  Created by Ali Houshmand on 4/1/14.
//  Copyright (c) 2014 Ali Houshmand. All rights reserved.
//

#import "CARWheel.h"

@implementation CARWheel

- (id)init
{
    self = [super init];
    if (self)
    {
        self.tirePressure = 30;
        self.flat = NO;
        
    }
    return self;
}

- (void)fillWithAir

{
    self.tirePressure = 30;
    self.flat = NO;
}


    
    /*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
