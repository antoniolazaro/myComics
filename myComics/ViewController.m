//
//  ViewController.m
//  myComics
//
//  Created by Antonio Lazaro Borges on 07/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize imageFromVideo;
@synthesize session;

@synthesize imageView;


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{

    imageFromVideo = nil;
    [self setImageFromVideo:nil];
    [self setSession:nil];

    [self setImageView:nil];

    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)abrirBiblioteca:(id)sender {
    
}


// Create and configure a capture session and start it running
- (void)setupCaptureSession 
{
    NSError *error = nil;
    
    // Create the session
    session = [[AVCaptureSession alloc] init];
    
    // Configure the session to produce lower resolution video frames, if your 
    // processing algorithm can cope. We'll specify medium quality for the
    // chosen device.
    session.sessionPreset = AVCaptureSessionPresetMedium;
    
    // Find a suitable AVCaptureDevice
    AVCaptureDevice *device = [AVCaptureDevice
                               defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Create a device input with the device and add it to the session.
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device 
                                                                        error:&error];
    if (!input) {
        // Handling the error appropriately.
    }
    [session addInput:input];
    
    // Create a VideoDataOutput and add it to the session
    AVCaptureVideoDataOutput *output = [[AVCaptureVideoDataOutput alloc] init];
    [session addOutput:output];
    
    // Configure your output.
    dispatch_queue_t queue = dispatch_queue_create("myQueue", NULL);
    [output setSampleBufferDelegate:self queue:queue];
    dispatch_release(queue);
    
    // Specify the pixel format
    output.videoSettings = 
    [NSDictionary dictionaryWithObject:
     [NSNumber numberWithInt:kCVPixelFormatType_32BGRA] 
                                forKey:(id)kCVPixelBufferPixelFormatTypeKey];
    
    
    // If you wish to cap the frame rate to a known value, such as 15 fps, set 
    // minFrameDuration.
    AVCaptureConnection *conn = [output connectionWithMediaType:AVMediaTypeVideo];
    
    
    CMTimeShow(conn.videoMinFrameDuration);
    CMTimeShow(conn.videoMaxFrameDuration);
    
    if (conn.supportsVideoMinFrameDuration)
        conn.videoMinFrameDuration = CMTimeMake(1, 15);
    if (conn.supportsVideoMaxFrameDuration)
        conn.videoMaxFrameDuration = CMTimeMake(1, 30);
    
    CMTimeShow(conn.videoMinFrameDuration);
    CMTimeShow(conn.videoMaxFrameDuration);
    
    // Start the session running to start the flow of data
    [session startRunning];
}

- (IBAction)abrirCamera:(id)sender {
    
    imagePicker.sourceType  = UIImagePickerControllerSourceTypeCamera;
    #warning buscar forma de tratar formato de videos apenas
    
    [imagePicker setMediaTypes:[NSArray arrayWithObject:@"public.movie"]];
    [imagePicker setCameraCaptureMode:UIImagePickerControllerCameraCaptureModeVideo];
    [self presentModalViewController:imagePicker animated:YES];
    
}

- (IBAction)build {

    UIImageView *backGround =  [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
    
    backGround.backgroundColor = [UIColor blackColor];
    
    UIImageView *ironMan =  [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 300, 200)];
    
    ironMan.image =[UIImage imageNamed:@"ironman.jpg"];
    
    UIImageView *hulk =  [[UIImageView alloc] initWithFrame:CGRectMake(10, 220, 145, 200)];
    
    hulk.image =[UIImage imageNamed:@"hulk.jpg"];
    
    UIImageView *thor =  [[UIImageView alloc] initWithFrame:CGRectMake(165, 220, 145, 200)];
    
    thor.image =[UIImage imageNamed:@"thor.jpg"];
    
    
    for(UIView *subview in [self.view subviews]) {
        [subview removeFromSuperview];
    }
    
    [self.view addSubview:backGround];
    [self.view addSubview:ironMan];
    [self.view addSubview:hulk];
    [self.view addSubview:thor];
    
}

- (CGRect) criarQuadroNalinha:(int)linha naColuna:(int)coluna comQuadrinhoMaior:(BOOL)quadrinhoMaior {

    // diminui pois é baseado em zero
    coluna--;
    linha--;
    
    int espaco = 40;
    int larguraQuadrinhoMaior = 540;
    int larguraQuadrinhoMenor = 250;
    int alturaQuadrinho = 250;
    
    // sempre tem o espaco inicial e depois um conjunto quadrinho + espaco para cada linha
    int y = espaco + linha * (alturaQuadrinho + espaco);
    int x;
    int larguraQuadrinho;
    
    if (quadrinhoMaior) {
        // linha com quadrinho maior é espaco / quadrinho / espaco
        x = espaco;
        larguraQuadrinho = larguraQuadrinhoMaior;
    } else {
        // quadrinho menor é espaco e depois um conjunto quadrinho + espaco para cada coluna
        x = espaco + coluna * (larguraQuadrinhoMenor + espaco);
        larguraQuadrinho = larguraQuadrinhoMenor;
    }
    
    return CGRectMake(x, y, larguraQuadrinho, alturaQuadrinho);
    
}

- (IBAction)build2:(id)sender {
    
    for(UIView *subview in [self.view subviews]) {
        [subview removeFromSuperview];
    }
    
    UIImage *imageIron = [UIImage imageNamed:@"ironman.jpg"];
    UIImage *imageThor = [UIImage imageNamed:@"thor.jpg"];
    UIImage *imageHulk = [UIImage imageNamed:@"hulk.jpg"];
    
    CGSize newSize = CGSizeMake(620, 877);
    
    // Inicia a escrita da HQ
    UIGraphicsBeginImageContext( newSize );

    // escreve iron como um quadrinho maior na linha 1 e coluna 1 ocupando toda a linha
    [imageIron drawInRect:[self criarQuadroNalinha:1 naColuna:1 comQuadrinhoMaior:YES]];
    
    // escreve thor como um quadrinho menor na linha 1 coluna 1
    [imageThor drawInRect:[self criarQuadroNalinha:2 naColuna:1 comQuadrinhoMaior:NO]];
    
    // escreve hulk como um quadrinho menor na linha 1 coluna 2
    [imageHulk drawInRect:[self criarQuadroNalinha:2 naColuna:2 comQuadrinhoMaior:NO]];
    
    UIImage *comicImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    // cria o imageView para mostrar a imagem
    UIImageView *newImageView =  [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
    newImageView.image = comicImage;
    
    [self.view addSubview:newImageView];
    
}

- (IBAction)pararCamera:(id)sender{
    [session stopRunning];

}

// Delegate routine that is called when a sample buffer was written
- (void)captureOutput:(AVCaptureOutput *)captureOutput 
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer 
       fromConnection:(AVCaptureConnection *)connection
{ 
    // Create a UIImage from the sample buffer data
    UIImage *image = [self imageFromSampleBuffer:sampleBuffer];
    
    imageFromVideo.image = image;
    
}

// Create a UIImage from sample buffer data
- (UIImage *) imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer 
{
    // Get a CMSampleBuffer's Core Video image buffer for the media data
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer); 
    // Lock the base address of the pixel buffer
    CVPixelBufferLockBaseAddress(imageBuffer, 0); 
    
    // Get the number of bytes per row for the pixel buffer
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer); 
    
    // Get the number of bytes per row for the pixel buffer
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer); 
    // Get the pixel buffer width and height
    size_t width = CVPixelBufferGetWidth(imageBuffer); 
    size_t height = CVPixelBufferGetHeight(imageBuffer); 
    
    // Create a device-dependent RGB color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB(); 
    
    // Create a bitmap graphics context with the sample buffer data
    CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8, 
                                                 bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst); 
    // Create a Quartz image from the pixel data in the bitmap graphics context
    CGImageRef quartzImage = CGBitmapContextCreateImage(context); 
    // Unlock the pixel buffer
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
    
    // Free up the context and color space
    CGContextRelease(context); 
    CGColorSpaceRelease(colorSpace);
    
    // Create an image object from the Quartz image
    UIImage *image = [UIImage imageWithCGImage:quartzImage];
    
    // Release the Quartz image
    CGImageRelease(quartzImage);
    
    return (image);
}
@end


