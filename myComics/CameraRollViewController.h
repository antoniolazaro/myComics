//
//  CameraRollViewController.h
//  myComics
//
//  Created by Antonio Lazaro Borges on 14/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreImage/CoreImage.h>
#import <CoreMedia/CoreMedia.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface CameraRollViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>{
    UIImagePickerController *imagePickerController;
    ALAssetsLibrary* library;
    NSMutableArray *imagesListFromLibrary;
}

@property (nonatomic, retain) UIImagePickerController *imagePickerController;

-(IBAction)openLibrary;

@end
