//
//  ViewController.h
//  myComics
//
//  Created by Antonio Lazaro Borges on 07/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface ViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIImagePickerController *imagePicker;
}
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

- (IBAction)abrirBiblioteca:(id)sender;

- (IBAction)abrirCamera:(id)sender;

- (IBAction)build;
- (IBAction)build2:(id)sender;

@end
