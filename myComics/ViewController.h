//
//  ViewController.h
//  myComics
//
//  Created by Antonio Lazaro Borges on 07/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import <CoreVideo/CoreVideo.h>

@interface ViewController : UIViewController<AVCaptureVideoDataOutputSampleBufferDelegate>
{
    UIImage *singleFrameImage;
    UIImagePickerController *imagePicker;
}
@property (strong, nonatomic) IBOutlet UIImageView *imageFromVideo;
@property (strong, nonatomic) AVCaptureSession *session;

- (IBAction)abrirBiblioteca:(id)sender;

- (IBAction)abrirCamera:(id)sender;

- (IBAction)pararCamera:(id)sender;

@end
