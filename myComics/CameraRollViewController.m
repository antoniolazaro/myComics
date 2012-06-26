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
    
    imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.allowsEditing = NO;
    imagePicker.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *) kUTTypeMovie, nil];
    imagePicker.delegate = self;
}


- (void)viewDidUnload
{
    [self setPreviewFromLibrary:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(IBAction)openPhotoLibrary{
    [self presentModalViewController:imagePicker animated:YES];
}

-(IBAction)gerarImagemPhotoLibrary{
    UIImage *thumbnail = [player thumbnailImageAtTime:0.0 timeOption:MPMovieTimeOptionExact];
    
    //NSArray *times = [NSArray arrayWithObjects:10,11,12,nil];
    //[player requestThumbnailImagesAtTimes:times timeOption:MPMovieTimeOptionExact];
    
    previewFromLibrary.image = thumbnail;
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    
    [nc addObserver:self selector:@selector(handleThumbnailImageRequestFinishNotification:) 
               name:MPMovieDurationAvailableNotification
             object:player];
    
    NSMutableArray *times = [[NSMutableArray alloc] init];
    float duration = [player duration];
	for(int i = 0; i < 20; i++) {
		float playbackTime = i * duration/20;
		NSLog(@"%f", playbackTime);
		[times addObject:[NSNumber numberWithInt:playbackTime]];
	}
    imagesListFromLibrary = [[NSMutableArray alloc]init];
    
    [player requestThumbnailImagesAtTimes:times timeOption:MPMovieTimeOptionExact];

}

-(void)handleThumbnailImageRequestFinishNotification:(NSNotification*)note
{
    NSLog(@"handleThumbnailImage...");
    NSDictionary *userinfo = [note userInfo];
    NSMutableDictionary *event = [NSMutableDictionary dictionary];
    NSError* value = [userinfo objectForKey:MPMoviePlayerThumbnailErrorKey];
    if (value!=nil)
    {
        [event setObject:[value description] forKey:@"error"];
    }
    else 
    {
        UIImage *image = [userinfo valueForKey:MPMoviePlayerThumbnailImageKey];
        previewFromLibrary.image = image;
        [imagesListFromLibrary addObject:image];
    }
    [event setObject:[userinfo valueForKey:MPMoviePlayerThumbnailTimeKey] forKey:@"time"];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    NSURL *videoUrl = [info objectForKey:UIImagePickerControllerMediaURL];
    
    player = [[MPMoviePlayerController alloc] initWithContentURL:videoUrl];
    [self dismissModalViewControllerAnimated:YES];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)createImage:(NSMutableArray*)images {
    
    for(UIView *subview in [self.view subviews]) {
        [subview removeFromSuperview];
    }
    
    CGSize newSize = CGSizeMake(620, 877*3);
    
    int linha = 1;
    int coluna = 1;
    
    // Inicia a escrita da HQ
    UIGraphicsBeginImageContext( newSize );
    
    for (int i = 0; i < images.count; i++) {
        
        if (i % 8 == 0) {
            
            // escreve iron como um quadrinho maior na linha 1 e coluna 1 ocupando toda a linha
            [[images objectAtIndex:i] drawInRect:[self criarQuadroNalinha:linha naColuna:coluna comQuadrinhoMaior:NO]];
            
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
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(save:)];
    
    [tap setNumberOfTapsRequired:2];
    [tap setNumberOfTouchesRequired:1];
    
    // Add the gesture to the view
    [[self view] addGestureRecognizer:tap];
    
    [self.view addSubview:scrollView];
    
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

-(IBAction)generateImageFromLibrary{
    [self createImage:imagesListFromLibrary];
}

-(void)save:(UIImage *) image{
    
    UIImageWriteToSavedPhotosAlbum(previewFromLibrary.image, self, @selector(saveComplete:didFinishSavingWithError:contextInfo:), nil);
    
}


@end
