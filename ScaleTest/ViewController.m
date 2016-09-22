//
//  ViewController.m
//  ScaleTest
//
//  Created by Alexander Kormanovsky on 17.09.16.
//
//

#import "ViewController.h"
#import <ImageIO/ImageIO.h>

@interface ViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *imageView1;
@property (strong, nonatomic) IBOutlet UIImageView *imageView3;
@property (strong, nonatomic) IBOutlet UIImageView *imageView4;


@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)viewWillLayoutSubviews
{
    [self setImages];
}

- (void)setImages
{
    // UIEdgeInsetsMake(8, 20, 8, 100) - arrow shifts down, unproportional vertical scaling
    // UIEdgeInsetsMake(0, 20, 0, 100) - image does not fit into image view
    
    UIImage *image = [[UIImage imageNamed:@"dropdown.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 20, 0, 100)];
//    image = [self resizedImage:image byHeight:_imageView1.frame.size.height];
//    image = [self resizedImage:[UIImage imageNamed:@"dropdown.png"] byHeight:_imageView1.frame.size.height];
    image = [self resizeImageAtPath:@"dropdown.png" byHeight:_imageView1.frame.size.height];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0, 20, 0, 100)];
    
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

// some trials to resize image manually..

- (UIImage *)resizedImage:(UIImage *)image byHeight:(NSUInteger)height
{
    CGFloat originalWidth  = image.size.width;
    CGFloat originalHeight = image.size.height;
    CGFloat scaleRatio = height/originalHeight;
    
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, originalWidth * scaleRatio, height)];
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resizedImage;
}

- (UIImage *)resizeImageAtPath:(NSString *)imagePath byHeight:(CGFloat)height
{
    // Create the image source
    NSString *path = [[NSBundle mainBundle] pathForResource:imagePath ofType:nil];
    CGImageSourceRef src = CGImageSourceCreateWithURL((__bridge CFURLRef) [NSURL fileURLWithPath:path], NULL);
    // Create thumbnail options
    CFDictionaryRef options = (__bridge CFDictionaryRef) @{
                                                           (id) kCGImageSourceCreateThumbnailWithTransform : @YES,
                                                           (id) kCGImageSourceCreateThumbnailFromImageAlways : @YES,
                                                           (id) kCGImageSourceThumbnailMaxPixelSize : @(640)
                                                           };
    // Generate the thumbnail
    CGImageRef thumbnail = CGImageSourceCreateThumbnailAtIndex(src, 0, options);
    UIImage *newImage = [[UIImage alloc] initWithCGImage:thumbnail];
    
    CFRelease(src);
    
    return newImage;
}

// just a draft
- (UIImage *)resizedImage:(UIImage *)image byHeight:(NSUInteger)height withCapInsets:(UIEdgeInsets)insets
{
    CGFloat originalWidth  = image.size.width;
    CGFloat originalHeight = image.size.height;
    CGFloat scaleRatio = height / originalHeight;
    CGFloat screenScale = [[UIScreen mainScreen] scale];
    
    CGImageRef imageRef = image.CGImage;
    
    // resize the whole image
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 originalWidth * scaleRatio * screenScale,
                                                 height * screenScale,
                                                 CGImageGetBitsPerComponent(imageRef),
                                                 0,
                                                 CGImageGetColorSpace(imageRef),
                                                 kCGImageAlphaPremultipliedFirst);
    
    //    CGContextScaleCTM(context, screenScale, screenScale);
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    
    // left cap
    CGRect rect = CGRectMake(0, 0, insets.left * screenScale, height * screenScale * 2);
    CGImageRef leftCapRef = CGImageCreateWithImageInRect(image.CGImage, rect);
    rect = CGRectMake(0, 0, insets.left, height);
    CGContextDrawImage(context, rect, leftCapRef);
    //    UIImage *leftCap = [[UIImage alloc] initWithCGImage:leftCapRef];
    
    // right cap
    rect = CGRectMake((originalWidth * scaleRatio - insets.right) * screenScale, 0,
                      insets.right * screenScale, height * screenScale * 2);
    CGImageRef rightCapRef = CGImageCreateWithImageInRect(image.CGImage, rect);
    //    UIImage *rightCap = [[UIImage alloc] initWithCGImage:rightCapRef];
    rect = CGRectMake(originalWidth * scaleRatio - insets.right, 0, insets.right, height);
    CGContextDrawImage(context, rect, rightCapRef);
    
    CGContextSetLineWidth(context, 1.0);
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    rect = CGRectMake(originalWidth * scaleRatio - insets.right, 0, insets.right, height);
    CGContextAddRect(context,  rect);
    CGContextDrawPath(context, kCGPathStroke);
    
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextAddRect(context,  CGRectMake(0, 0, originalWidth * scaleRatio, height));
    CGContextDrawPath(context, kCGPathStroke);
    
    CGImageRef newImageRef = CGBitmapContextCreateImage(context);
    UIImage *newImage = [[UIImage alloc] initWithCGImage:newImageRef];
    
    
    
    
    //    CGFloat x = newImage.size.width - insets.right * screenScale;
    //    CGFloat width = insets.right * screenScale;
    //    CGImageRef middlePartImageRef = CGImageCreateWithImageInRect(newImage.CGImage, CGRectMake(x, 0, width, height * screenScale));
    //    UIImage *middlePartImage = [[UIImage alloc] initWithCGImage:middlePartImageRef];
    
    
    CGContextRelease(context);
    CGImageRelease(newImageRef);
    
    return newImage;
}

@end
