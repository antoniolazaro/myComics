//
//  MCFirstViewController.m
//  myComics Pilot
//
//  Created by Marcus Vínicius Oliveira on 6/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MCGalleryViewController.h"

@interface MCGalleryViewController ()

@end

@implementation MCGalleryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [[UITabBar appearance] setTintColor:[UIColor grayColor]];
    [[UITabBar appearance] setSelectedImageTintColor:[UIColor greenColor]];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
