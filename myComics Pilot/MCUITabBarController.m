//
//  MCUITabBarController.m
//  myComics Pilot
//
//  Created by Marcus Vínicius Oliveira on 6/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MCUITabBarController.h"

@interface MCUITabBarController ()

@end

@implementation MCUITabBarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
    
    CGRect frame = CGRectMake(0.0, 0, self.view.bounds.size.width, 48);
    
    UIView *view = [[UIView alloc] initWithFrame:frame];
    
    [view setBackgroundColor:[[UIColor alloc] initWithRed:1.0
                                                 green:0.0
                                                  blue:0.0
                                                 alpha:0.1]];
    
    [tabBar insertSubview:view atIndex:0];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
