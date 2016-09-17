//
//  ViewController.m
//  ScaleTest
//
//  Created by Alexander Kormanovsky on 17.09.16.
//
//

#import "ViewController.h"



@interface ViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *imageView1;
@property (strong, nonatomic) IBOutlet UIImageView *imageView3;
@property (strong, nonatomic) IBOutlet UIImageView *imageView4;


@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setImages];
}

- (void)setImages
{
    // UIEdgeInsetsMake(8, 20, 8, 100) - arrow shifts down, unproportional vertical scaling
    // UIEdgeInsetsMake(0, 20, 0, 100) - image does not fit into image view
    
    UIImage *image = [[UIImage imageNamed:@"dropdown.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 20, 0, 100)];
    
    _imageView1.layer.borderWidth = 1.0;
    _imageView1.clipsToBounds = NO;
    _imageView1.contentMode = UIViewContentModeScaleAspectFit;
    _imageView1.image = image;
    
    _imageView3.layer.borderWidth = 1.0;
    _imageView3.clipsToBounds = NO;
    _imageView3.contentMode = UIViewContentModeTopLeft;
    _imageView3.image = image;
    
    _imageView4.layer.borderWidth = 1.0;
    _imageView4.clipsToBounds = NO;
    _imageView4.contentMode = UIViewContentModeScaleToFill;
    _imageView4.image = image;
    
}

@end
