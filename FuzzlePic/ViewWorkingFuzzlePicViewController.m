//
//  ViewWorkingFuzzlePicViewController.m
//  FuzzlePic
//
//  Created by Benjamin Thomas Gurrola on 11/5/15.
//  Copyright © 2015 Benjamin Thomas Gurrola. All rights reserved.
//

#import "ViewWorkingFuzzlePicViewController.h"

@interface ViewWorkingFuzzlePicViewController ()

@property (strong,nonatomic) NSMutableDictionary *currentState;

@end

@implementation ViewWorkingFuzzlePicViewController

int mainRemovedImageIndex = 8;

NSMutableArray <UIImageView *> *imageViewArray;
NSMutableArray *imageViewCentersArray;
UIImageView *savedImageView;
CGPoint emptySpot, tapCenter, left, right, top, bottom;
bool leftIsEmpty, rightIsEmpty, topIsEmpty, bottomIsEmpty;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.currentState = [NSMutableDictionary new];
    
    CGFloat fuzzleWidth = 3.0;
    
    CGFloat singleSquareWidth = self.fuzzlePicImageView.frame.size.width / fuzzleWidth;
    self.fuzzlePicImageView.backgroundColor = [UIColor lightGrayColor];
    
//  Do any additional setup after loading the view.
    
//    self.fuzzlePicImageView.image = self.workingImage;
    
    // I need to reframe the actual picture to look like the thumbnail
    
//    NSMutableArray <NSString *> *imageArray  = [NSMutableArray new];
    
    NSMutableArray <UIImage *> *realImageArray = [NSMutableArray new];
    
    imageViewArray = [NSMutableArray new];
    imageViewCentersArray = [NSMutableArray new];
    

    
    UIView *imagesView = [[UIView alloc] initWithFrame:CGRectMake(7.0, 154.0, 360.0, 360.0)];
    [self.view addSubview:imagesView];
    
    CGFloat xCenter = 60.0;
    CGFloat yCenter = 60.0;
    
    int removedImageViewIndex = (int)(pow(fuzzleWidth,2) - 1);
    

    
    // take the picture, split it up into separate squares and recreate the square.
    
    for (int i = 0; i < (int)fuzzleWidth; i++) {
        for (int j = 0; j < (int)fuzzleWidth; j++) {
            
            UIImageView *squareImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 120.0, 120.0)];
            
            CGPoint currentCenter = CGPointMake(xCenter, yCenter);
            [imageViewCentersArray addObject:[NSValue valueWithCGPoint:currentCenter]];
            
//            NSString *imageInit = @"image";
//            NSString *imageString = [imageInit stringByAppendingString:[NSString stringWithFormat:@"%d%d.jpg",i,j]];
            
            UIImage *img = [self makeImageClipFrom:self.workingImage xPosition:(i * singleSquareWidth) yPosition:(j * singleSquareWidth) width:singleSquareWidth height: singleSquareWidth];
//            [imageArray addObject:imageString];
            [realImageArray addObject:img];
            
//            [self.currentState setObject:img forKey:imageString];
            
            squareImageView.center = currentCenter;
            squareImageView.image = img;
            squareImageView.userInteractionEnabled = YES;
            [imageViewArray addObject:squareImageView];
            [imagesView addSubview:squareImageView];
            yCenter += 120.0;
        }
        xCenter += 120.0;
        yCenter = 60.0;
    }
    
    savedImageView = [imageViewArray objectAtIndex:removedImageViewIndex];
    
    [[imageViewArray objectAtIndex:removedImageViewIndex] removeFromSuperview];
    [imageViewArray removeObjectAtIndex:removedImageViewIndex];
    
    
    
//    self.fuzzlePicImageView.animationImages = realImageArray;
//    self.fuzzlePicImageView.animationDuration = 10;
//    [self.fuzzlePicImageView startAnimating];
    
    
    // ranomize picture (set it equal to ranomized order in the model)
    
    // if (image is new) {
    
    
    
    [self randomizeImages];
    
    
    
    // } else {
    // self loadImageLocations from model
    // }
    
    
    // register the touches
    
    // The only reason why we need this 'cursor' is to explicitly specify which square's center we're setting
    int cursor = 0;
    for (UIImageView *aSquareImageView in imageViewArray) {
        // tap
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleFuzzleGuesture:)];
        [singleTap setNumberOfTapsRequired:1];
        [aSquareImageView addGestureRecognizer:singleTap];
        // swipe right
        UISwipeGestureRecognizer *swipeRightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleFuzzleGuesture:)];
        [swipeRightRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
        // swipe left
        UISwipeGestureRecognizer *swipeLeftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleFuzzleGuesture:)];
        [swipeLeftRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
        // swipe up
        UISwipeGestureRecognizer *swipeUpRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleFuzzleGuesture:)];
        [swipeUpRecognizer setDirection:UISwipeGestureRecognizerDirectionUp];
        // swipe down
        UISwipeGestureRecognizer *swipeDownRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleFuzzleGuesture:)];
        [swipeDownRecognizer setDirection:UISwipeGestureRecognizerDirectionDown];
        // set the image view center
        aSquareImageView.center = [imageViewArray objectAtIndex:cursor].center;
        cursor++;
    }
    
    // after each touch, send a messae to the controller to update the model

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

- (void)randomizeImages {
    NSMutableArray *centersCopy = [imageViewCentersArray mutableCopy];
    
    int randomInt;
    CGPoint randomLocation;
    
    for (UIView *eachView in imageViewArray) {
        randomInt = arc4random() % centersCopy.count;
        randomLocation = [[centersCopy objectAtIndex:randomInt] CGPointValue];
        
        eachView.center = randomLocation;
        [centersCopy removeObjectAtIndex:randomInt];
    }
    emptySpot = [[centersCopy objectAtIndex:0] CGPointValue];
}

- (void)handleFuzzleGuesture:(UIGestureRecognizer *)sender {
    tapCenter = sender.view.center;
    left = CGPointMake(tapCenter.x - 120.0, tapCenter.y);
    right = CGPointMake(tapCenter.x + 120.0, tapCenter.y);
    top = CGPointMake(tapCenter.x, tapCenter.y + 120.0);
    bottom = CGPointMake(tapCenter.x, tapCenter.y - 120.0);
    
    if ([[NSValue valueWithCGPoint:left] isEqual:[NSValue valueWithCGPoint:emptySpot]]) leftIsEmpty = true;
    if ([[NSValue valueWithCGPoint:right] isEqual:[NSValue valueWithCGPoint:emptySpot]]) rightIsEmpty = true;
    if ([[NSValue valueWithCGPoint:top] isEqual:[NSValue valueWithCGPoint:emptySpot]]) topIsEmpty = true;
    if ([[NSValue valueWithCGPoint:bottom] isEqual:[NSValue valueWithCGPoint:emptySpot]]) bottomIsEmpty = true;
    
    if (leftIsEmpty || rightIsEmpty || topIsEmpty || bottomIsEmpty) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.5];
        sender.view.center = emptySpot;
        [UIView commitAnimations];
        emptySpot = tapCenter;
        leftIsEmpty = false; rightIsEmpty = false; topIsEmpty = false; bottomIsEmpty = false;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// have touch functions defined here


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
