//
//  MCGalleryViewController.h
//  myComics Pilot
//
//  Created by Marcus Vínicius Oliveira on 6/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "GPUImageToonFilter.h"

@interface MCGalleryViewController : UIViewController <UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    
    UIImagePickerController *imagePickController;
    MPMoviePlayerController *player;
    NSMutableArray *imagesList;
    AVAssetImageGenerator *imageGenerator;
}

@property (strong, nonatomic) IBOutlet UIImageView *preview;

-(IBAction)openLibrary;
-(IBAction)generateComics;

@end
