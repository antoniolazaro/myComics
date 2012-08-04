//
//  MCSecondViewController.h
//  myComics Pilot
//
//  Created by Marcus Vínicius Oliveira on 6/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreImage/CoreImage.h>
#import "GPUImage.h"

@interface MCCameraViewController : UIViewController <AVCaptureVideoDataOutputSampleBufferDelegate>
{    
    NSMutableArray *imagesList;
    UIImage *comic;
}

@property (weak, nonatomic) IBOutlet UIButton *stopButton;
@property (weak, nonatomic) IBOutlet UIView *preview;

@property (strong, nonatomic) AVCaptureSession *captureSession;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *previewLayer;
@property (weak, nonatomic) IBOutlet UIImageView *previewUIImageView;


- (IBAction)stopRecording;

@end
