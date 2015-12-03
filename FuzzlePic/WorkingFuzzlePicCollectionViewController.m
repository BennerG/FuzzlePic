//
//  FuzzlePicCollectionViewController.m
//  FuzzlePic
//
//  Created by Benjamin Thomas Gurrola on 10/28/15.
//  Copyright © 2015 Benjamin Thomas Gurrola. All rights reserved.
//

#import "WorkingFuzzlePicCollectionViewController.h"
#import "ViewWorkingFuzzlePicViewController.h"
#import "FuzzlePicObject.h"

@interface WorkingFuzzlePicCollectionViewController ()

@property (strong,nonatomic) NSArray *workingImages;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation WorkingFuzzlePicCollectionViewController

@dynamic collectionView;

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // add observer for NSNotification Image Saved
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadImages) name:NewImageSaved object:nil];
    // add observer for NSNotification Image Deleted
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadImages) name:FuzzlePicImageWasDeleted object:nil];
}

// method to be triggered on observation
- (void)reloadImages {
    NSMutableArray *tempImages = [NSMutableArray new];
    
    for (FuzzlePicObject *fuzzlePic in [FuzzlePicObjectController sharedInstance].workingFuzzles) {
        NSString *imageString = fuzzlePic.imageID;
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectoryPathString = [paths objectAtIndex:0];
        NSString *fuzzlePicImageDirectoryPathString = [documentsDirectoryPathString stringByAppendingPathComponent:@"/FuzzlePicImages/"];
        NSString *imageLocationPath = [fuzzlePicImageDirectoryPathString stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",imageString]];
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfFile:imageLocationPath]];
        if (image) {
            [tempImages addObject:image];
        }
    }
    

    self.workingImages = tempImages;
    
    [self.collectionView reloadData];
    NSLog(@"pause");
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self reloadImages];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (WorkingFuzzlePicCollectionViewController *)sharedInstance {
    static WorkingFuzzlePicCollectionViewController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [WorkingFuzzlePicCollectionViewController new];
    });
    return sharedInstance;
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.workingImages.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FuzzlePicCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.image.image = [self.workingImages objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     if ([segue.identifier isEqualToString:@"ViewWorking"]) {
     
         FuzzlePicCollectionViewCell *cell = (FuzzlePicCollectionViewCell *)sender;
         NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
         ViewWorkingFuzzlePicViewController *viewController = [segue destinationViewController];
         // verify destination type
         if ([[segue destinationViewController] isKindOfClass:[ViewWorkingFuzzlePicViewController class]]) {
             // set a property rather than the view that hasn't loaded yet.
             viewController.workingImage = [self.workingImages objectAtIndex:indexPath.row];
             viewController.fuzzlePicObject = [[FuzzlePicObjectController sharedInstance].workingFuzzles objectAtIndex:indexPath.row];
             NSLog(@"Pause");
         }
     }
 }

@end
