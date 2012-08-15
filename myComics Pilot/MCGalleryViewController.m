//
//  MCFirstViewController.m
//  myComics Pilot
//
//  Created by Marcus Vínicius Oliveira on 6/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MCGalleryViewController.h"

@interface MCGalleryViewController ()

@end

@implementation MCGalleryViewController
@synthesize preview;

- (void)viewDidLoad
{
    [super viewDidLoad];

    [[UITabBar appearance] setTintColor:[UIColor grayColor]];
    [[UITabBar appearance] setSelectedImageTintColor:[UIColor greenColor]];

    imagePickController = [[UIImagePickerController alloc]init];
    imagePickController.sourceType =  UIImagePickerControllerSourceTypeSavedPhotosAlbum;
//    imagePickController.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickController.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
    
    imagePickController.allowsEditing = NO;
    imagePickController.delegate= self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieDuration:)
												 name:MPMovieDurationAvailableNotification object:nil];
    
    
    
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(thumbnailAvailable:)
												 name:MPMoviePlayerThumbnailImageRequestDidFinishNotification object:nil];
    
    
}

- (void)viewDidUnload
{
    [self setPreview:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


-(IBAction)openLibrary{
     [self presentModalViewController:imagePickController animated:YES];
}

-(IBAction)generateComics{
    [self processignComic:imagesList];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissModalViewControllerAnimated:YES];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"Vai escolher filme a ser tratado...");

//    NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
//
//    NSLog(@"%@",videoURL);
//    
//    player = [[MPMoviePlayerController alloc] initWithContentURL:videoURL];
//    
//    NSArray *time = [NSArray arrayWithObjects:
//					 [NSNumber numberWithFloat:0.5],
//					 [NSNumber numberWithFloat:1],
//					 [NSNumber numberWithFloat:1.5],
//					 [NSNumber numberWithFloat:35],nil];
//	
//	[player requestThumbnailImagesAtTimes:time timeOption:MPMovieTimeOptionExact];
    
    
    
    AVURLAsset *movie = [[AVURLAsset alloc] initWithURL:[info objectForKey:UIImagePickerControllerMediaURL] options:nil];
    
    Float64 durationSeconds = CMTimeGetSeconds([movie duration]);
    
    NSLog(@"duracao %f...",durationSeconds);
    
    CMTime thumbTime = CMTimeMakeWithSeconds(0,durationSeconds);
    
    CMTime firstThird = CMTimeMakeWithSeconds(durationSeconds/3.0, 600);
    CMTime secondThird = CMTimeMakeWithSeconds(durationSeconds*2.0/3.0, 600);
    CMTime end = CMTimeMakeWithSeconds(durationSeconds, 600);

    NSArray *times = [NSArray arrayWithObjects:[NSValue valueWithCMTime:thumbTime],
    [NSValue valueWithCMTime:end],nil];
    
    
    //NSArray  *times = [NSArray arrayWithObject:[NSValue valueWithCMTime:thumbTime]];
    
    imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:movie];
    imageGenerator.appliesPreferredTrackTransform = YES;
    
    imagesList = [[NSMutableArray alloc]init];
    
    AVAssetImageGeneratorCompletionHandler handler =
    ^(CMTime requestedTime, CGImageRef im, CMTime actualTime,
      AVAssetImageGeneratorResult result, NSError *error) {
        if (result != AVAssetImageGeneratorSucceeded) {
            NSLog(@"Couldn't generate thumbnail, error:%@", error);
        }
        [imagesList addObject:[UIImage imageWithCGImage:im]];
        preview.image = [UIImage imageWithCGImage:im];
        NSLog(@"Inseriu uma imagem na lista...");
        NSLog(@"make sure generator is used in this block and it'll work %@", imageGenerator);
    };
    
    [imageGenerator generateCGImagesAsynchronouslyForTimes:times
                                    completionHandler:handler];
        
    
    
    [self dismissModalViewControllerAnimated:YES];
}

- (void)processignComic:(NSMutableArray*)images {
    
    NSLog(@"Tamanho imagens %i ",images.count);
    
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

    
    UIScrollView* scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
    
    [scrollView setContentSize:CGSizeMake(320, 877*3)];
    [scrollView addSubview:newImageView];
    
    [self.view addSubview:scrollView];
    
    //    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(save:)];
    //
    //    [tap setNumberOfTapsRequired:2];
    //    [tap setNumberOfTouchesRequired:1];
    //
    // Add the gesture to the view
    //    [[self view] addGestureRecognizer:tap];
    
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

- (UIImage *)imageFromLayer:(CALayer *)layer{
    
    UIGraphicsBeginImageContext([layer frame].size);
    
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return outputImage;
    
}



//
//-(void)thumbnailAvailable:(NSNotification *)notification
//{
//	NSDictionary *dict = [notification userInfo];
//
//	UIImage *image = [dict objectForKey:MPMoviePlayerThumbnailImageKey];
//	
//	float tempo = [[dict objectForKey:MPMoviePlayerThumbnailTimeKey] floatValue];
//	
//	if (tempo==0.5)
//	{
//		preview.image = image;
//	}
//    
//}
//
//-(void)movieDuration:(NSNotification *)notification
//{
//	player = [notification object];
//	
//	NSLog(@"%@",[NSString stringWithFormat:@"Duracao de %.2f segundos",player.duration]);
//	
//	[[NSNotificationCenter defaultCenter] removeObserver:self name:MPMovieDurationAvailableNotification object:nil];
//}


@end
