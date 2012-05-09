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
@synthesize imageView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
}

- (void)viewDidUnload
{
    [self setImageView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)abrirBiblioteca:(id)sender {
    imagePicker.sourceType  = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentModalViewController:imagePicker animated:YES];
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

@end
