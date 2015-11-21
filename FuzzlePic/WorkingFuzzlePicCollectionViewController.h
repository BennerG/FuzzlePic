//
//  FuzzlePicCollectionViewController.h
//  FuzzlePic
//
//  Created by Benjamin Thomas Gurrola on 10/28/15.
//  Copyright © 2015 Benjamin Thomas Gurrola. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FuzzlePicCollectionViewCell.h"
#import "FuzzlePicObjectController.h"

static NSString * const NewImageSaved = @"newImageSaved";
static NSString * const FuzzlePicImageWasDeleted = @"fuzzlePicImageWasDeleted";

@interface WorkingFuzzlePicCollectionViewController : UICollectionViewController <UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, assign) BOOL isWorkingCollection;

@property (strong,nonatomic,readonly) NSArray *workingImages;

+ (WorkingFuzzlePicCollectionViewController *)sharedInstance;

@end
