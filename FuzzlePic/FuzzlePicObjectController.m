//
//  FuzzlePicObjectController.m
//  FuzzlePic
//
//  Created by Benjamin Thomas Gurrola on 11/11/15.
//  Copyright © 2015 Benjamin Thomas Gurrola. All rights reserved.
//

#import "FuzzlePicObjectController.h"

static NSString *const AllFuzzlesKey = @"AllFuzzlesKey";
static NSString *const FuzzlePicObjectName = @"FuzzlePicObject";

@implementation FuzzlePicObjectController

#pragma mark - Manage

+ (FuzzlePicObjectController *)sharedInstance {
    static FuzzlePicObjectController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [FuzzlePicObjectController new];
    });
    return sharedInstance;
}

#pragma mark - Create

- (FuzzlePicObject *)createFuzzlePicObjectWithImagePath:(NSString *)imagePathID currentState:(NSString *)currentState fuzzleWidth:(NSInteger)fuzzleWidth {
    // create new NSManagedObject instance
    FuzzlePicObject *fuzzlePic = [NSEntityDescription insertNewObjectForEntityForName:FuzzlePicObjectName inManagedObjectContext:[Stack sharedInstance].managedObjectContext];
    // set properties
    fuzzlePic.imageID = imagePathID;
    fuzzlePic.currentState = currentState;
    // find the maximum in all of the current objects
    NSArray *allFuzzlePicImages = [self fetchObjects];
//    NSInteger i = 0;
    // instantiate an object from the bag of data
    fuzzlePic.imageIndex = [NSNumber numberWithInteger:[allFuzzlePicImages indexOfObject:allFuzzlePicImages.lastObject] + 1];
//    for (FuzzlePicObject *fuzzlePicObject in allFuzzlePicImages) {
//        if (i <= [fuzzlePicObject.imageIndex integerValue]) {
//            i = [fuzzlePicObject.imageIndex integerValue] + 1;
//        }
//    }
//    // set imageIndex
//    fuzzlePic.imageIndex = [NSNumber numberWithInteger:i];
    fuzzlePic.fuzzleWidth = [NSNumber numberWithInteger:fuzzleWidth];
    // store down small array to file
    [self saveToPersistentStorage];
    // return image
    return fuzzlePic;
}

#pragma mark - Read

- (NSArray *)workingFuzzles {
    
    NSArray *allFuzzlePicImages = [self fetchObjects];
    NSMutableArray *workingMutable = [NSMutableArray new];
    for (FuzzlePicObject *fuzzleObject in allFuzzlePicImages) {
        // create the fuzzle object...
        if (![fuzzleObject isComplete]) {
            [workingMutable addObject:fuzzleObject];
        }
    }
    // return working mutable
    return workingMutable;
}

- (NSArray *)completedFuzzles {
    NSArray *allFuzzlePicImages = [self fetchObjects];
    NSMutableArray *completedMutable = [NSMutableArray new];
    // instantiate an object from the bag of data then iterate through
    for (FuzzlePicObject *fuzzlePicObject in allFuzzlePicImages) {
        if ([fuzzlePicObject isComplete]) {
            [completedMutable addObject:fuzzlePicObject];
        }
    }
    // return completed mutable
    return completedMutable;
}

- (NSArray *)fetchObjects {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:FuzzlePicObjectName];
    // i really hope i can get this running <- haha
    [fetchRequest setSortDescriptors:@[[[NSSortDescriptor alloc] initWithKey:@"imageIndex" ascending:YES]]];
    NSArray *fetchedObjects = [[Stack sharedInstance].managedObjectContext executeFetchRequest:fetchRequest error:nil];
    return fetchedObjects;
}

#pragma mark - Update

// method to check and update model

- (void)saveToPersistentStorage {
    [[Stack sharedInstance].managedObjectContext save:nil];
}

#pragma mark - Delete

- (void)removeFuzzlePicObject:(FuzzlePicObject *)fuzzlePic {
    // NSFileManager to delete FuzzlePicImage at path
    NSString *imageString = fuzzlePic.imageID;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPathString = [paths objectAtIndex:0];
    NSString *fuzzlePicImageDirectoryPathString = [documentsDirectoryPathString stringByAppendingPathComponent:@"/FuzzlePicImages/"];
    NSString *imageLocationPath = [fuzzlePicImageDirectoryPathString stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",imageString]];
    // deleted
    BOOL imageDeleted = [[NSFileManager defaultManager] removeItemAtPath:imageLocationPath error:nil];
    NSLog(@"imageDeleted=%d",imageDeleted);
    
    [[Stack sharedInstance].managedObjectContext deleteObject:fuzzlePic];
}





@end
