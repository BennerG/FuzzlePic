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

@interface ViewWorkingFuzzlePicViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *fuzzlePicImageView;

@property (strong,nonatomic) FuzzlePicObject *fuzzlePicObject;
@property (strong,nonatomic) UIImage *workingImage;

@end
