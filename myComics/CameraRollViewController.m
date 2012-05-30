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

@synthesize imagePickerController;

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
    
    self.imagePickerController = [[UIImagePickerController alloc] init];
    self.imagePickerController.delegate = self;
    self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.imagePickerController.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
    
    
    imagesListFromLibrary = [[NSMutableArray alloc]init];
    
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


-(IBAction)openLibrary{
    [self presentModalViewController:self.imagePickerController animated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSLog(@"Escolheu um video...");
    
    NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
    [self generateImageFromVideoLibrary:videoURL];
    
    NSLog(@"tamanho final array -> %i",imagesListFromLibrary.count);
}

-(void)generateImageFromVideoLibrary:(NSURL *)videoURL
{
    AVURLAsset *asset=[[AVURLAsset alloc] initWithURL:videoURL options:nil];
    
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    
    CMTime thumbTime = CMTimeMakeWithSeconds(0,30);
    NSValue *thumbnailTime = [NSValue valueWithCMTime:thumbTime];
    NSArray *imageGenerationTimes = [NSArray arrayWithObject:thumbnailTime];    
    
    AVAssetImageGeneratorCompletionHandler handler =
    ^(CMTime requestedTime, CGImageRef image, CMTime actualTime,
      AVAssetImageGeneratorResult result, NSError *error) {
        if (result != AVAssetImageGeneratorSucceeded) {
            NSLog(@"Couldn't generate thumbnail, error:%@", error);
        }
        NSLog(@"vai gravar imagem ");
        [imagesListFromLibrary addObject:[UIImage imageWithCGImage:image]];
    };
    
    [imageGenerator generateCGImagesAsynchronouslyForTimes:imageGenerationTimes
                                         completionHandler:handler];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    NSLog(@"Cancelou a selecao de um video..");
    [imagePickerController dismissModalViewControllerAnimated:YES];
}

@end
