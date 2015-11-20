//
//  CompletedFuzzlePicCollectionViewController.m
//  FuzzlePic
//
//  Created by Benjamin Thomas Gurrola on 10/28/15.
//  Copyright © 2015 Benjamin Thomas Gurrola. All rights reserved.
//

#import "CompletedFuzzlePicCollectionViewController.h"
#import "ViewCompletedFuzzleViewController.h"

@interface CompletedFuzzlePicCollectionViewController ()

@property (strong,nonatomic) NSArray *completedImages;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation CompletedFuzzlePicCollectionViewController

@dynamic collectionView;

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
//        self.completedImages = @[@"img01.JPG",@"img02.JPG",@"img03.JPG",@"img04.JPG",@"img05.JPG",@"img06.JPG"];
    self.completedImages = [FuzzlePicObjectController sharedInstance].completedFuzzles;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [self.collectionView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (CompletedFuzzlePicCollectionViewController *)sharedInstance {
    static CompletedFuzzlePicCollectionViewController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [CompletedFuzzlePicCollectionViewController new];
    });
    return sharedInstance;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ViewCompleted"]) {
        
        UICollectionViewCell *cell = (UICollectionViewCell *)sender;
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
        ViewCompletedFuzzleViewController *viewController = [segue destinationViewController];
        // set a property rather than the view that hasn't loaded yet.
        viewController.completedImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@",[self.completedImages objectAtIndex:indexPath.row]]];
    }
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.completedImages.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    FuzzlePicCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    NSString *imgString = [self.completedImages objectAtIndex:indexPath.row];
    cell.image.image = [UIImage imageNamed:imgString];
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
