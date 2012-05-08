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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
}

- (void)viewDidUnload
{
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

@end
