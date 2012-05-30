//
//  CameraRollViewController.m
//  myComics
//
//  Created by Antonio Lazaro Borges on 14/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CameraRollViewController.h"

@interface CameraRollViewController ()

@end

@implementation CameraRollViewController
@synthesize previewFromLibrary;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    mediaPickerControler = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeMovie];
    mediaPickerControler.delegate = self;
    mediaPickerControler.prompt = @"Selecionar vídeo";
    imagesListFromLibrary = [[NSMutableArray alloc]init];
}


- (void)viewDidUnload
{
    previewFromLibrary = nil;
    [super viewDidUnload];
    [self setPreviewFromLibrary:nil];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


-(IBAction)openLibrary{
    [self presentModalViewController:mediaPickerControler animated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSLog(@"Escolheu um video...");
    
    NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
   // [self generateImageFromVideoLibrary:videoURL];

}



@end
