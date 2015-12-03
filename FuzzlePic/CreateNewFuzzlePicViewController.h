//
//  CreateNewFuzzlePicViewController.h
//  FuzzlePic
//
//  Created by Benjamin Thomas Gurrola on 10/28/15.
//  Copyright © 2015 Benjamin Thomas Gurrola. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FuzzlePicObjectController.h"
#import "FuzzlePicObject.h"

@interface CreateNewFuzzlePicViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (weak, nonatomic) IBOutlet UIPickerView *fuzzleSizeSelector;
@property (assign,nonatomic) NSInteger fuzzleWidth;
@property (strong,nonatomic) FuzzlePicObject *fuzzlePicObject;



@end
