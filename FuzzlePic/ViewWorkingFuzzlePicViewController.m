//
//  ViewWorkingFuzzlePicViewController.m
//  FuzzlePic
//
//  Created by Benjamin Thomas Gurrola on 11/5/15.
//  Copyright © 2015 Benjamin Thomas Gurrola. All rights reserved.
//

#import "ViewWorkingFuzzlePicViewController.h"

@interface ViewWorkingFuzzlePicViewController ()

@property (strong,nonatomic) NSArray *orderedBlocks;

@end

@implementation ViewWorkingFuzzlePicViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadBlocksForView];
    
    
    //

}

- (void)loadBlocksForView {
    self.orderedBlocks = [NSMutableArray new];
//    NSInteger fuzzleWidth = self.fuzzlePicObject;
    
    
    
}


- (UIImage *)makeImageClipFrom:(UIImage *)image xPosition:(CGFloat)xPosition yPosition:(CGFloat)yPosition width:(CGFloat)width height:(CGFloat)height {
    CGImageRef tempImage = image.CGImage;
    CGImageRef imageClipRef = CGImageCreateWithImageInRect(tempImage, CGRectMake(xPosition,yPosition,width,height));
    UIImage *imageClip = [UIImage imageWithCGImage:imageClipRef];
    CGImageRelease(imageClipRef);
    return imageClip;
}

- (IBAction)deleteFuzzlePic:(id)sender {
    
    // delete image from NSFileManager
    NSString *imageString = self.fuzzlePicObject.imageID;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPathString = [paths objectAtIndex:0];
    NSString *fuzzlePicImageDirectoryPathString = [documentsDirectoryPathString stringByAppendingPathComponent:@"/FuzzlePicImages/"];
    NSString *imageLocationPath = [fuzzlePicImageDirectoryPathString stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",imageString]];
    // deleted
    BOOL imageDeleted = [[NSFileManager defaultManager] removeItemAtPath:imageLocationPath error:nil];
    NSLog(@"imageDeleted=%d",imageDeleted);
    // delete coreData object
    [[FuzzlePicObjectController sharedInstance] removeFuzzlePicObject:self.fuzzlePicObject];
    // send NSNotification that image was removed
    [[NSNotificationCenter defaultCenter] postNotificationName:@"fuzzlePicImageWasDeleted" object:nil];
    // dismissViewController
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.type = kCATransitionReveal;
    transition.subtype = kCATransitionFromLeft;
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    [self.navigationController popViewControllerAnimated:NO];
}

@end
