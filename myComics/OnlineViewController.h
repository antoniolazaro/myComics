//
//  OnlineViewController.h
//  myComics
//
//  Created by Antonio Lazaro Borges on 13/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface OnlineViewController : UIViewController <AVCaptureVideoDataOutputSampleBufferDelegate>{
    NSMutableArray *imagesList;
}

@property (weak, nonatomic) IBOutlet UIImageView *previewUIImageView;

@property (weak, nonatomic) IBOutlet UIView *previewUIView;

@property (strong, nonatomic) AVCaptureSession *captureSession;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *previewLayer;

- (IBAction) startRecording;

- (IBAction) stopRecording;

- (IBAction) breakVideoInFrames;

@end
