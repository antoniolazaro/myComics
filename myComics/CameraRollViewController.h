//
//  CameraRollViewController.h
//  myComics
//
//  Created by Antonio Lazaro Borges on 14/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <MediaPlayer/MediaPlayer.h>

@interface CameraRollViewController : UIViewController<UIImagePickerControllerDelegate>{
    NSMutableArray *imagesListFromLibrary;
    UIImagePickerController *imagePicker;
    MPMoviePlayerController *player;
}

@property (strong, nonatomic) IBOutlet UIImageView *previewFromLibrary;

-(IBAction)openPhotoLibrary;

-(IBAction)gerarImagemPhotoLibrary;

-(IBAction)generateImageFromLibrary;

@end
