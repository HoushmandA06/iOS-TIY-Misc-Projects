//
//  DLAAppDelegate.m
//  DrawLinesApp
//
//  Created by Ali Houshmand on 4/15/14.
//  Copyright (c) 2014 Ali Houshmand. All rights reserved.
//

#import "DLAAppDelegate.h"
#import "DLAViewController.h"

@implementation DLAAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.window.rootViewController = [[DLAViewController alloc] initWithNibName:nil bundle:nil];
    
    [self.window makeKeyAndVisible];
    return YES;
}

@end
