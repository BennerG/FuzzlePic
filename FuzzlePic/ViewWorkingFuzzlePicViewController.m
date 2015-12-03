//
//  ViewWorkingFuzzlePicViewController.m
//  FuzzlePic
//
//  Created by Benjamin Thomas Gurrola on 11/5/15.
//  Copyright © 2015 Benjamin Thomas Gurrola. All rights reserved.
//

#import "ViewWorkingFuzzlePicViewController.h"

@interface ViewWorkingFuzzlePicViewController ()

@property (strong,nonatomic) NSMutableArray *currentState;

@end

@implementation ViewWorkingFuzzlePicViewController

NSMutableArray <UIView *> *imageViewArray;
const NSArray <UIView *> *constImageViewArray;
NSMutableArray *imageViewCentersArray;
UIImageView *savedImageView;
CGPoint emptySpot, tapCenter, left, right, top, bottom;
bool leftIsEmpty, rightIsEmpty, topIsEmpty, bottomIsEmpty;
NSInteger emptySquare;
CGFloat singleSquareWidth;
NSInteger removedImageViewIndex;
UIView *imagesView;
UIImageView *squareImageView;
NSMutableArray *imageLocationIntegerValue;
NSNumber *emptyValue;
NSInteger emptyValueLocation;

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFuzzlePicView:) name:FuzzleTileWasMoved object:nil];
//    
    
    
    [self loadFuzzlePicView];

    [self randomizeImages];
    
    // register the touches
    // The only reason why we need this 'cursor' is to explicitly specify which square's center we're setting
    int cursor = 0;
    for (UIImageView *aSquareImageView in constImageViewArray) {
        // tap
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(updateFuzzlePicView:)];
        [singleTap setNumberOfTapsRequired:1];
        [aSquareImageView addGestureRecognizer:singleTap];
        aSquareImageView.center = [constImageViewArray objectAtIndex:cursor].center;
        cursor++;
    }
}

- (UIImage *)makeImageClipFrom:(UIImage *)image xPosition:(CGFloat)xPosition yPosition:(CGFloat)yPosition width:(CGFloat)width height:(CGFloat)height {
    CGImageRef tempImage = image.CGImage;
    CGImageRef imageClipRef = CGImageCreateWithImageInRect(tempImage, CGRectMake(xPosition,yPosition,width,height));
    UIImage *imageClip = [UIImage imageWithCGImage:imageClipRef];
    CGImageRelease(imageClipRef);
    return imageClip;
}

- (IBAction)deleteFuzzlePic:(id)sender {
    // delete coreData object and image stored in its path
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
    removedImageViewIndex = (NSInteger)(pow([self.fuzzlePicObject.fuzzleWidth doubleValue],2) - 1);
    
    NSArray *randomIntArray = [self stringToIntegerArray:self.fuzzlePicObject.currentState];
    CGPoint randomLocation;
    
    NSMutableArray *tempImageViews = [constImageViewArray mutableCopy];
    NSMutableArray *finalTempImageViews = [NSMutableArray new];
    
    NSArray *tempImageViewCenters = [NSArray arrayWithArray:imageViewCentersArray];
    
    for (int i = 0; i <= removedImageViewIndex; i++) {
    
        NSInteger cursor = [randomIntArray[i] integerValue];
        
        UIView *eachView = [tempImageViews objectAtIndex:i];
        
        randomLocation = [[tempImageViewCenters objectAtIndex:cursor] CGPointValue];
        
        NSNumber *intAsNumber = [[NSNumber alloc] initWithInteger:cursor];
        imageLocationIntegerValue[i] = intAsNumber;
        
        eachView.center = randomLocation;
        [finalTempImageViews addObject:eachView];
    }
    
    for (UIView *eachView in tempImageViews) {
        [imagesView addSubview:eachView];
    }
    
    emptyValue = [[NSNumber alloc] initWithInteger:removedImageViewIndex];
    emptyValueLocation = [imageLocationIntegerValue indexOfObject:emptyValue];
    savedImageView = [finalTempImageViews objectAtIndex:emptyValueLocation];
    emptySpot = savedImageView.center;
    [savedImageView removeFromSuperview];
}

// this method calls the updateFuzzlePicView to draw the pic, but then saves the last image
// I need to have 2 separate functions... one to create the fuzzlePic, and one to

- (void)loadFuzzlePicView {
    imageViewArray = [NSMutableArray new];
    imageViewCentersArray = [NSMutableArray new];
    
    singleSquareWidth = self.fuzzlePicImageView.frame.size.width / self.fuzzleWidth;
    self.fuzzlePicImageView.backgroundColor = [UIColor lightGrayColor];
    
    imagesView = [[UIView alloc] initWithFrame:CGRectMake(7.0, 154.0, 360.0, 360.0)];
    [self.view addSubview:imagesView];
    
    // create an array of images from picture
    NSMutableArray <UIImage *> *realImageArray = [NSMutableArray new];
    
    CGFloat xCenter = singleSquareWidth / 2;
    CGFloat yCenter = singleSquareWidth / 2;
    
    for (int i = 0; i < self.fuzzleWidth; i++) {
        for (int j = 0; j < self.fuzzleWidth; j++) {
            
            squareImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, singleSquareWidth, singleSquareWidth)];
            
            CGPoint currentCenter = CGPointMake(xCenter, yCenter); // just switched these
            [imageViewCentersArray addObject:[NSValue valueWithCGPoint:currentCenter]];
    
            UIImage *img = [self makeImageClipFrom:self.workingImage xPosition:(j * singleSquareWidth) yPosition:(i * singleSquareWidth) width:singleSquareWidth height: singleSquareWidth];
            
            [realImageArray addObject:img];
            squareImageView.center = currentCenter;
            squareImageView.image = img;
            squareImageView.userInteractionEnabled = YES;
            [imageViewArray addObject:squareImageView];
            xCenter += singleSquareWidth;
        }
        yCenter += singleSquareWidth;
        xCenter = singleSquareWidth / 2;
    }
    constImageViewArray = [NSArray arrayWithArray:imageViewArray];
    
    NSInteger fuzWidthLength = pow((double)self.fuzzleWidth, 2.0);
    imageLocationIntegerValue = [NSMutableArray new];
    for (NSInteger k = 0; k < fuzWidthLength; k++) {
        NSNumber *currentNumber = [[NSNumber alloc] initWithInteger:k];
        [imageLocationIntegerValue addObject:currentNumber];
    }
}

- (NSMutableArray *)stringToIntegerArray:(NSString *)string {
    // take fuzzlePicObject.currentState and create a mutable array
    NSMutableArray  *numberReferences = [NSMutableArray new];
    numberReferences = [[string componentsSeparatedByString:@","] mutableCopy];
    return numberReferences;
}

- (NSString *)arrayToString:(NSArray *)array {
    return [array componentsJoinedByString:@","];
}

- (void)updateFuzzlePicView:(UIGestureRecognizer *)sender {
    tapCenter = sender.view.center;
    left = CGPointMake(tapCenter.x - singleSquareWidth, tapCenter.y);
    right = CGPointMake(tapCenter.x + singleSquareWidth, tapCenter.y);
    top = CGPointMake(tapCenter.x, tapCenter.y - singleSquareWidth);
    bottom = CGPointMake(tapCenter.x, tapCenter.y + singleSquareWidth);
    
    if ([[NSValue valueWithCGPoint:left] isEqual:[NSValue valueWithCGPoint:emptySpot]]) {
        leftIsEmpty = true;
        emptySquare = leftSquareIsEmpty;
    }
    if ([[NSValue valueWithCGPoint:right] isEqual:[NSValue valueWithCGPoint:emptySpot]]) {
        rightIsEmpty = true;
        emptySquare = rightSquareIsEmpty;
    }
    if ([[NSValue valueWithCGPoint:top] isEqual:[NSValue valueWithCGPoint:emptySpot]]) {
        topIsEmpty = true;
        emptySquare = topSquareIsEmpty;
    }
    if ([[NSValue valueWithCGPoint:bottom] isEqual:[NSValue valueWithCGPoint:emptySpot]]) {
        bottomIsEmpty = true;
        emptySquare = bottomSquareIsEmpty;
    }

    
    if (leftIsEmpty || rightIsEmpty || topIsEmpty || bottomIsEmpty) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.5];
        sender.view.center = emptySpot;
        // at the sma time I need to update the imageLocationIntegerValue
        [UIView commitAnimations];
        
//        NSMutableArray *currentStateArray = [self stringToIntegerArray:self.fuzzlePicObject.currentState];
        NSInteger emptyIndex = ([imageLocationIntegerValue indexOfObject:emptyValue] == 0) ? 0 : [imageLocationIntegerValue indexOfObject:emptyValue];
        
        // @"5,1,8,
        //   2,4,7,
        //   0,6,3"
        
        // + 1 || - 1 || + (fuzzleWidth) || - (fuzzleWidth);
        
        switch (emptySquare) {
            case leftSquareIsEmpty:
                // swap values in currentState array
                [imageLocationIntegerValue exchangeObjectAtIndex:emptyIndex withObjectAtIndex:emptyIndex + 1];
                break;
            case rightSquareIsEmpty:
                // swap values in currentState array
                [imageLocationIntegerValue exchangeObjectAtIndex:emptyIndex withObjectAtIndex:emptyIndex - 1];
                break;
            case topSquareIsEmpty:
                // swap values in currentState array
                [imageLocationIntegerValue exchangeObjectAtIndex:emptyIndex withObjectAtIndex:emptyIndex - (self.fuzzleWidth)];
                break;
            case bottomSquareIsEmpty:
                // swap values in currentState array
                [imageLocationIntegerValue exchangeObjectAtIndex:emptyIndex withObjectAtIndex:emptyIndex + (self.fuzzleWidth)];
                break;
            default: // do nothing
                break;
        }
        
        NSString *currentStateString = [imageLocationIntegerValue componentsJoinedByString:@","];
        self.fuzzlePicObject.currentState = currentStateString;
        [[FuzzlePicObjectController sharedInstance] saveToPersistentStorage];
        
        emptySpot = tapCenter;
        leftIsEmpty = false; rightIsEmpty = false; topIsEmpty = false; bottomIsEmpty = false;
    }
    
//    // my update function needs to:
//    // 1. take self.fuzzlePicObject.currentState convert it to an array
//    
//    // 2. read the current state of the objects from the view and compare their state to eachother
//    if ([imageLocationIntegerValue isEqualToArray:currentStateArray]) {
//        return; // do nothing and exit the method
//    } else {
//        
//        
//        
//    }
//    //   convert the view objects array order back to a string
//    //   self.fuzzlePicObject.currentState = view objects array order string;
//    //   [FuzzlePicObjectController sharedInstance] saveToPersistantStorage]; // make sure this works
//    // }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
