//
//  ViewController.h
//  myComics
//
//  Created by Antonio Lazaro Borges on 07/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>

@interface ViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIImage *singleFrameImage;
    UIImagePickerController *imagePicker;
}
@property (strong, nonatomic) IBOutlet UIImageView *imageFromVideo;

- (IBAction)abrirBiblioteca:(id)sender;

- (IBAction)abrirCamera:(id)sender;

@end
