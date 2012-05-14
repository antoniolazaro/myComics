//
//  CameraRollViewController.m
//  myComics
//
//  Created by Antonio Lazaro Borges on 14/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CameraRollViewController.h"

@interface CameraRollViewController ()

@end

@implementation CameraRollViewController

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
	// Do any additional setup after loading the view.
    
    library = [[ALAssetsLibrary alloc] init];
    [self updateAssetsLibrary];
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

- (void)updateAssetsLibrary
{
	NSMutableArray *assetItems = [NSMutableArray arrayWithCapacity:0];
	ALAssetsLibrary *assetLibrary = library;
	
	[assetLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (group) {
            [group setAssetsFilter:[ALAssetsFilter allVideos]];
            [group enumerateAssetsUsingBlock:
             ^(ALAsset *asset, NSUInteger index, BOOL *stop)
             {
                 if (asset) {
                     ALAssetRepresentation *defaultRepresentation = [asset defaultRepresentation];
                     NSString *uti = [defaultRepresentation UTI];
                     NSURL *URL = [[asset valueForProperty:ALAssetPropertyURLs] valueForKey:uti];
                     NSString *title = [NSString stringWithFormat:@"%@ %i", NSLocalizedString(@"Video", nil), [assetItems count]+1];
//                     AssetBrowserItem *item = [[[AssetBrowserItem alloc] initWithURL:URL title:title] autorelease];
//                     
//                     [assetItems addObject:item];
                 }
             }];
        }
		// group == nil signals we are done iterating.
		else {
//			dispatch_async(dispatch_get_main_queue(), ^{
//				[self updateBrowserItemsAndSignalDelegate:assetItems];
//			});
		}
	}
                              failureBlock:^(NSError *error) {
                                  NSLog(@"error enumerating AssetLibrary groups %@\n", error);
                              }];
}

@end
