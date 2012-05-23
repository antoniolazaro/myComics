//
//  ViewController.h
//  myComics
//
//  Created by Antonio Lazaro Borges on 07/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface ViewController : UIViewController<AVCaptureVideoDataOutputSampleBufferDelegate>
{
    UIImage *singleFrameImage;
    UIImagePickerController *imagePicker;
}
@property (strong, nonatomic) IBOutlet UIImageView *imageFromVideo;
@property (strong, nonatomic) AVCaptureSession *session;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;


- (IBAction)abrirBiblioteca:(id)sender;

- (IBAction)abrirCamera:(id)sender;

- (IBAction)pararCamera:(id)sender;

- (IBAction)build;
- (IBAction)build2:(id)sender;


@end
