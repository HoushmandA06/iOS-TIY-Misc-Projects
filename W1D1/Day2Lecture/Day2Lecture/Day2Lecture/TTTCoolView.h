//
//  TTTCoolView.h
//  Day2Lecture
//
//  Created by Ali Houshmand on 4/1/14.
//  Copyright (c) 2014 Ali Houshmand. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTTCoolView : UIView

@property (nonatomic) NSString *coolTitle;

+ (NSNumber *)randomNumber;

- (NSString *)whatIsMyTitle;

- (void)changeTitle:(NSString*)newTitle;

@end
