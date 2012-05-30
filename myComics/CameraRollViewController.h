//
//  CameraRollViewController.h
//  myComics
//
//  Created by Antonio Lazaro Borges on 14/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface CameraRollViewController : UIViewController <MPMediaPickerControllerDelegate>{
    
    MPMediaPickerController *mediaPickerControler;

    NSMutableArray *imagesListFromLibrary;
}


@property (weak, nonatomic) IBOutlet UIImageView *previewFromLibrary;

-(IBAction)openLibrary;

@end
