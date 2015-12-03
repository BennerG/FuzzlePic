//
//  ViewWorkingFuzzlePicViewController.h
//  FuzzlePic
//
//  Created by Benjamin Thomas Gurrola on 11/5/15.
//  Copyright © 2015 Benjamin Thomas Gurrola. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WorkingFuzzlePicCollectionViewController.h"
#import "FuzzlePicObject.h"

static NSString * const FuzzleTileWasMoved = @"fuzzleTileWasMoved";

typedef NS_ENUM(NSInteger, squareIsEmpty) {
    topSquareIsEmpty,
    rightSquareIsEmpty,
    bottomSquareIsEmpty,
    leftSquareIsEmpty
};

@interface ViewWorkingFuzzlePicViewController : UIViewController
@property (weak,nonatomic) IBOutlet UIImageView *fuzzlePicImageView;

@property (strong,nonatomic) FuzzlePicObject *fuzzlePicObject;
@property (strong,nonatomic) UIImage *workingImage;
@property (assign,nonatomic) NSInteger fuzzleWidth;

@end
