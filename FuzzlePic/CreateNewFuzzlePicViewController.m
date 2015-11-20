//
//  CreateNewFuzzlePicViewController.m
//  FuzzlePic
//
//  Created by Benjamin Thomas Gurrola on 10/28/15.
//  Copyright © 2015 Benjamin Thomas Gurrola. All rights reserved.
//

#import "CreateNewFuzzlePicViewController.h"
#import "WorkingFuzzlePicCollectionViewController.h"
#import <UIKit/UIKit.h>

@interface CreateNewFuzzlePicViewController () <UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong,nonatomic) UIView *sliceView;
@property (strong,nonatomic) UIImagePickerController *imagePicker;
@property (strong,nonatomic) NSArray* fuzzleSizeSelectorArray;
@property (strong,nonatomic) NSMutableArray* verticalViews;
@property (strong,nonatomic) NSMutableArray* horizontalViews;
@property (assign,nonatomic) NSInteger widthNum;
@end

@implementation CreateNewFuzzlePicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.fuzzleSizeSelectorArray = [[NSArray alloc]initWithObjects:[NSNumber numberWithInt:3],[NSNumber numberWithInt:4],[NSNumber numberWithInt:5], nil];
    [self.fuzzleSizeSelector selectedRowInComponent:0];
    NSInteger defaultFuzzleWidth = 3;
    self.fuzzleWidth = [NSNumber numberWithInteger:defaultFuzzleWidth];
    
    
    [self.imageView setUserInteractionEnabled:YES];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleImageTap)];
    [singleTap setNumberOfTapsRequired:1];
    [self.imageView addGestureRecognizer:singleTap];
}

#pragma mark - fuzzeSizeSelector DataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView { return 1; }

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.fuzzleSizeSelectorArray.count;
}

#pragma mark - fuzzeSizeSelector Delegate

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 40.0;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view {
    
    UILabel *pickerViewRowTitle = (UILabel *)view;
    pickerViewRowTitle = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, [pickerView rowSizeForComponent:component].width, [pickerView rowSizeForComponent:component].height)];
    pickerViewRowTitle.font = [UIFont fontWithName:@"AvenirNext-Bold" size:36.0];
    pickerViewRowTitle.textAlignment = NSTextAlignmentCenter;
    NSNumber *width = [self.fuzzleSizeSelectorArray objectAtIndex:row];
    pickerViewRowTitle.text = [NSString stringWithFormat:@"%@ x %@", width, width];
    return pickerViewRowTitle;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.fuzzleWidth = [self.fuzzleSizeSelectorArray objectAtIndex:row];
    [self triggerSliceView];
}

- (void)triggerSliceView {

    [UIView animateWithDuration:0.15 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.sliceView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 360.0, 360)];
        self.sliceView.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.0];
        [self.imageView addSubview:self.sliceView];
        // for self.fuzzleWidth
        
        self.verticalViews = [NSMutableArray new];
        self.horizontalViews = [NSMutableArray new];
        self.widthNum = [self.fuzzleWidth integerValue];
        for (int i = 0; i < self.widthNum; i++) {
            if (i > 0) {
                UIView *verticalLineView = [[UIView alloc] initWithFrame:CGRectMake(i * (360.0/self.widthNum), 0.0, 1.5, 360.0)];
                verticalLineView.backgroundColor = [UIColor colorWithRed:(57.0/255.0) green:(255.0/255.0) blue:(20.0/255.0) alpha:1.0];
                UIView *horizontalLineView = [[UIView alloc] initWithFrame:CGRectMake(0.0, i * (360.0/self.widthNum), 360.0, 1.5)];
                horizontalLineView.backgroundColor = [UIColor colorWithRed:(57.0/255.0) green:(255.0/255.0) blue:(20.0/255.0) alpha:1.0];
                
                [self.verticalViews addObject:verticalLineView];
                [self.horizontalViews addObject:horizontalLineView];
                
                [self.sliceView addSubview:verticalLineView];
                [self.sliceView addSubview:horizontalLineView];
            }
        }
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1.0 delay:0.35 options:UIViewAnimationOptionCurveEaseOut animations:^{
            for (int j = 0; j < self.widthNum - 1; j++) {
                UIView *vertView = (UIView *)[self.verticalViews objectAtIndex:j];
                vertView.alpha = 0.0;
                UIView *horizView = (UIView *)[self.horizontalViews objectAtIndex:j];
                horizView.alpha = 0.0;
            }
        } completion:^(BOOL finished){
            for (int j = 0; j < self.widthNum - 1; j++) {
                [[self.verticalViews objectAtIndex:j] removeFromSuperview];
                [[self.horizontalViews objectAtIndex:j] removeFromSuperview];
            }
        }];
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveButtonTapped:(id)sender {
    // open up a path to documents
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPathString = [paths objectAtIndex:0];
    NSString *fuzzlePicImageDirectoryPathString = [documentsDirectoryPathString stringByAppendingPathComponent:@"/FuzzlePicImages/"];
    BOOL pathCreated = [[NSFileManager defaultManager] createDirectoryAtPath:fuzzlePicImageDirectoryPathString withIntermediateDirectories:YES attributes:nil error:nil];
    NSLog(@"pathCreated:%d", pathCreated);
    // create a uuid
    NSUUID *image = [NSUUID new];
    NSString *imageString = [image UUIDString];
    // append path to documents
    NSString *imageLocationPath = [fuzzlePicImageDirectoryPathString stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",imageString]];
    
    
    // resize image (returns image *)
    UIImage *imageCopy = self.imageView.image;
    // final copy of image declared outside of scope
    UIImage *finalImage;
    
//    // store aspect ratio width:height
//    CGFloat aspectRatio = imageCopy.size.width / imageCopy.size.height;
    
    // declare offset values
    CGFloat verticalOffsetFromOrigin = 0.0;
    CGFloat horizontalOffsetFromOrigin = 0.0;
    
    // set parameters for squaring image
    if (imageCopy.size.width < imageCopy.size.height) {
        verticalOffsetFromOrigin = (imageCopy.size.height - imageCopy.size.width) / 2;
    } else {
        horizontalOffsetFromOrigin = (imageCopy.size.width - imageCopy.size.height) / 2;
    }
    
    // cut image into a square based on parameters
    CGImageRef orignialRef = imageCopy.CGImage;
    CGImageRef newContextRef = CGImageCreateWithImageInRect(orignialRef, CGRectMake(horizontalOffsetFromOrigin, verticalOffsetFromOrigin, imageCopy.size.width - 2 * horizontalOffsetFromOrigin, imageCopy.size.height - 2 * verticalOffsetFromOrigin));
    UIImage *squareImage = [UIImage imageWithCGImage:newContextRef];
    CGImageRelease(orignialRef);
    CGImageRelease(newContextRef);
    
    // resize image
    CGSize imgSize = CGSizeMake(360.0, 360.0);
    UIGraphicsBeginImageContextWithOptions(imgSize, NO, 1.0);
    [squareImage drawInRect:CGRectMake(0.0,0.0, imgSize.width, imgSize.height)];
    finalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // set image scale
    NSLog(@"%f", finalImage.scale);
  
    // save image at this location
    NSData *imageData = UIImagePNGRepresentation(finalImage);
    BOOL successfullyStored = [imageData writeToFile:imageLocationPath atomically:YES];
    NSLog(@"succesfullyStored:%d",successfullyStored);
    
    self.fuzzlePicObject = [[FuzzlePicObjectController sharedInstance] createFuzzlePicObjectWithImagePath:imageString currentState:[self createRandomOrderArrayWithFuzzleWidth]];
    // reload tableView
    [[NSNotificationCenter defaultCenter] postNotificationName:NewImageSaved object:nil];
    // get rid of view controller so that user doesn't save same image to multiple locations
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSString *)createRandomOrderArrayWithFuzzleWidth {
    NSInteger fuzWidthLength = pow([self.fuzzleWidth doubleValue], 2.0);
    NSMutableArray *tempOrder = [NSMutableArray new];
    for (int k = 0; k < fuzWidthLength; k++) {
        NSNumber *currentNumber = [[NSNumber alloc] initWithInt:k];
        [tempOrder addObject:currentNumber];
    }
    NSMutableArray *tempOrderCopy = [tempOrder mutableCopy];
    NSInteger tempCount = tempOrderCopy.count;
    NSInteger randInt;
    for (int l = 0; l < tempCount; l++) {
        randInt = arc4random() % tempOrderCopy.count;
        tempOrder[l] = [tempOrderCopy objectAtIndex:randInt];
        [tempOrderCopy removeObjectAtIndex:randInt];
    }
    return [tempOrder componentsJoinedByString:@""];
}


- (IBAction)cancelButtonTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)handleImageTap {
    NSLog(@"This is self outside block: %@", self);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *openPhotoLibraryAction = [UIAlertAction actionWithTitle:@"Photo Library" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.imagePicker = [[UIImagePickerController alloc] init];
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        self.imagePicker.delegate = self;
        self.imagePicker.allowsEditing = YES;
        [self presentViewController:self.imagePicker animated:YES completion:nil];
    }];
    UIAlertAction *activateCameraAction = [UIAlertAction actionWithTitle:@"Take Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
#if TARGET_IPHONE_SIMULATOR
        UIAlertController *errorAlert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Camera is not available" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [errorAlert addAction:okAction];
        [self presentViewController:errorAlert animated:YES completion:nil];
        NSLog(@"This is self inside block: %@", self); // it's the same
#elif TARGET_OS_IPHONE
        self.imagePicker = [[UIImagePickerController alloc] init];
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        self.imagePicker.delegate = self;
        self.imagePicker.allowsEditing = YES;
        [self presentViewController:self.imagePicker animated:YES completion:nil];
#endif
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:openPhotoLibraryAction];
    [alertController addAction:activateCameraAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    NSData *imgData = UIImagePNGRepresentation([info objectForKey:@"UIImagePickerControllerEditedImage"]);
    UIImage *img = [[UIImage alloc] initWithData:imgData];    
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.clipsToBounds = YES;
    [self.imageView setImage:img];
    [self.imagePicker dismissViewControllerAnimated:YES completion:nil];
    
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    WorkingFuzzlePicCollectionViewController *collectionViewController = [segue destinationViewController];
//    // Pass the selected object to the new view controller.
//    [collectionViewController.collectionView reloadData];
//}

@end







































