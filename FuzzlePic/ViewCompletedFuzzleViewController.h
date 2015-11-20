//
//  ViewCompletedFuzzleViewController.h
//  FuzzlePic
//
//  Created by Benjamin Thomas Gurrola on 11/4/15.
//  Copyright © 2015 Benjamin Thomas Gurrola. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CompletedFuzzlePicCollectionViewController.h"

@interface ViewCompletedFuzzleViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIVisualEffectView *visualEffectView;
@property (weak, nonatomic) IBOutlet UIImageView *completedFuzzlePicImageView;

@property (nonatomic, strong) UIImage *completedImage;

@end
