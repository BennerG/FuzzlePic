//
//  ViewCompletedFuzzleViewController.m
//  FuzzlePic
//
//  Created by Benjamin Thomas Gurrola on 11/4/15.
//  Copyright © 2015 Benjamin Thomas Gurrola. All rights reserved.
//

#import "ViewCompletedFuzzleViewController.h"

@interface ViewCompletedFuzzleViewController ()

@end

@implementation ViewCompletedFuzzleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.completedFuzzlePicImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.completedFuzzlePicImageView.clipsToBounds = YES;
    self.completedFuzzlePicImageView.image = self.completedImage;
    
    [self.visualEffectView setUserInteractionEnabled:YES];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
    [singleTap setNumberOfTapsRequired:1];
    [self.visualEffectView addGestureRecognizer:singleTap];
}

- (void)handleTap {
    [self dismissViewControllerAnimated:YES completion:nil];
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
