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

@end
