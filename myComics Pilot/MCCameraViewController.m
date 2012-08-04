//
//  MCSecondViewController.m
//  myComics Pilot
//
//  Created by Marcus Vínicius Oliveira on 6/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MCCameraViewController.h"

@interface MCCameraViewController ()

@end

@implementation MCCameraViewController
@synthesize stopButton;
@synthesize preview,previewLayer,captureSession,previewUIImageView;


- (void)viewDidLoad
{
    
    [super viewDidLoad];

    //Começar já gravando.
    [self recording];
    [self customizeButton];
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{

    [self setCaptureSession:nil];
    [self setPreviewLayer:nil];
    [self setPreview:nil];
    [self setStopButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

/* Método do delegate AVCaptureVideoDataOutputSampleBufferDelegate que escreve o resultado da saida da captura
 */
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{
    
    UIImage *image = [self imageFromSampleBuffer:sampleBuffer];
    
    previewUIImageView.image = image;
    
    [imagesList addObject:image];
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
    //UIImage *image = [UIImage imageWithCGImage:quartzImage];
    
    //cria a imagem com a orientação correta...
    UIImage *image = [UIImage imageWithCGImage:quartzImage scale:1.0
                                   orientation:UIImageOrientationRight];
    
    
    // Release the Quartz image
    CGImageRelease(quartzImage);
    
    return (image);
}

-(void) customizeButton{
    
    [self.stopButton setBackgroundImage:[[UIImage imageNamed:@"red_button.png"]
                                           stretchableImageWithLeftCapWidth:8.0f
                                           topCapHeight:0.0f]
                                 forState:UIControlStateNormal];
    
    [self.stopButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.stopButton.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    self.stopButton.titleLabel.shadowColor = [UIColor lightGrayColor];
    self.stopButton.titleLabel.shadowOffset = CGSizeMake(0, -1);
}

-(void) recording{
    
    imagesList = [[NSMutableArray alloc]init];
    captureSession = [[AVCaptureSession alloc] init];
    
    // Configure the session to produce lower resolution video frames, if your 
    // processing algorithm can cope. We'll specify medium quality for the
    // chosen device.
    captureSession.sessionPreset = AVCaptureSessionPresetMedium;
    
    // Find a suitable AVCaptureDevice
    AVCaptureDevice *device = [AVCaptureDevice
                               defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    NSError *error = nil;
    // Create a device input with the device and add it to the session.
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device 
                                                                        error:&error];
    if (!input) {
        // Handling the error appropriately.
    }
    [captureSession addInput:input];
    
    // Create a VideoDataOutput and add it to the session
    AVCaptureVideoDataOutput *output = [[AVCaptureVideoDataOutput alloc] init];
    [captureSession addOutput:output];
    
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
    
    if (conn.supportsVideoMinFrameDuration){
        conn.videoMinFrameDuration = CMTimeMake(1, 30);
    }
    if (conn.supportsVideoMaxFrameDuration){
        conn.videoMaxFrameDuration = CMTimeMake(1, 120);
    }
    
    CMTimeShow(conn.videoMinFrameDuration);
    CMTimeShow(conn.videoMaxFrameDuration);
    
    // Start the session running to start the flow of data
    [captureSession startRunning];
    
    previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:captureSession];
    
    previewLayer.frame = preview.bounds; // Assume you want the preview layer to fill the view.
    
    [preview.layer addSublayer:previewLayer];
}

- (IBAction)stopRecording {

    [captureSession stopRunning];
    [self processignComic:imagesList];
}

- (UIImage *)imageFromLayer:(CALayer *)layer{
    
    UIGraphicsBeginImageContext([layer frame].size);
    
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return outputImage;
    
}

- (UIImage *)imageWithRoundedBorderFromImage:(UIImage *)image{
    
    CALayer *sublayer = [CALayer layer];
    sublayer.backgroundColor = [UIColor blueColor].CGColor;
    sublayer.shadowOffset = CGSizeMake(0, 3);
    // não precisa da sombra
    //sublayer.shadowRadius = 5.0;
    //sublayer.shadowColor = [UIColor blackColor].CGColor;
    sublayer.shadowOpacity = 0.8;
    sublayer.frame = CGRectMake(30, 30, 128, 192);
    sublayer.borderColor = [UIColor blackColor].CGColor;
    sublayer.borderWidth = 2.0;
    sublayer.cornerRadius = 10.0;
    
    CALayer *imageLayer = [CALayer layer];
    imageLayer.frame = sublayer.bounds;
    imageLayer.cornerRadius = 10.0;
    imageLayer.contents = (id) image.CGImage;
    imageLayer.masksToBounds = YES;
    [sublayer addSublayer:imageLayer];
    
    return [self imageFromLayer:sublayer];
    
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

- (void)processignComic:(NSMutableArray*)images {
    
    for(UIView *subview in [self.view subviews]) {
        [subview removeFromSuperview];
    }
    
    CGSize newSize = CGSizeMake(620, 877*3);
    
    int linha = 1;
    int coluna = 1;
    
    UIImage *currentImage = nil; 
    
    // Inicia a escrita da HQ
    UIGraphicsBeginImageContext( newSize );
    
    for (int i = 0; i < images.count; i++) {
        
        if (i % 8 == 0) {
            
            currentImage = [images objectAtIndex:i];
            
            GPUImageToonFilter *applyFilterToon = [[GPUImageToonFilter alloc] init];
//            GPUImageVignetteFilter *applyFilterVignett = [[GPUImageVignetteFilter alloc] init];
            //            UIImage *quickFilteredImage =
            
            currentImage = [applyFilterToon imageByFilteringImage:currentImage];
//            currentImage = [applyFilterVignett imageByFilteringImage:currentImage];
            
            // cria a borda
            currentImage = [self imageWithRoundedBorderFromImage:currentImage];
            
            // cria o quadrinho
            CGRect square = [self criarQuadroNalinha:linha naColuna:coluna comQuadrinhoMaior:NO];
            
            // cria a imagem no quadrinho
            [currentImage drawInRect:square];
            
            if (coluna == 2) {
                linha++;
                coluna = 1;
            } else {
                coluna++;
            }
            
        }
        
    }
    
    UIImage *comicImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    // cria o imageView para mostrar a imagem
    UIImageView *newImageView =  [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 460*3)];
    newImageView.image = comicImage;
    
    comic = comicImage;
    
    UIScrollView* scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
    
    [scrollView setContentSize:CGSizeMake(320, 877*3)];
    [scrollView addSubview:newImageView];
    
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(save:)];
//    
//    [tap setNumberOfTapsRequired:2];
//    [tap setNumberOfTouchesRequired:1];
//    
    //create the button
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    //set the position of the button
    button.frame = CGRectMake(100, 170, 100, 30);
    
    //set the button's title
    [button setTitle:@"Play Again!" forState:UIControlStateNormal];
    
    //listen for clicks
    [button addTarget:self action:@selector(buttonPressed)
     forControlEvents:UIControlEventTouchUpInside];
    
    [scrollView addSubview:button];
    
    // Add the gesture to the view
//    [[self view] addGestureRecognizer:tap];
    
    [self.view addSubview:scrollView];
    
}

-(void) buttonPressed{
    
    
    for(UIView *subview in [self.view subviews]) {
        [subview removeFromSuperview];
    }
    
    [preview addSubview:stopButton];
    [self.view addSubview:preview];
    [self recording];
}

-(void)save:(UIImage *) image{
    
    UIImageWriteToSavedPhotosAlbum(comic, self, @selector(saveComplete:didFinishSavingWithError:contextInfo:), nil);
    
}

-(void)saveComplete:(UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo{
    
    if(! [error isEqual:[NSNull null]]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Salvo!" message:@"Imagem salva com sucesso!!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        
        [alert show];
    }
    
}
@end