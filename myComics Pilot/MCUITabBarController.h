//
//  MCUITabBarController.h
//  myComics Pilot
//
//  Created by Marcus Vínicius Oliveira on 6/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MCUITabBarController : UITabBarController{
    IBOutlet UITabBar *tabBar;
}

@property(nonatomic, retain) UITabBar *tabBar;
@end
