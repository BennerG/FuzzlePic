//
//  FuzzlePicObjectController.h
//  FuzzlePic
//
//  Created by Benjamin Thomas Gurrola on 11/11/15.
//  Copyright © 2015 Benjamin Thomas Gurrola. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FuzzlePicObject.h"
#import "Stack.h"

@interface FuzzlePicObjectController : NSObject

@property (strong,nonatomic,readonly) NSArray *workingFuzzles;
@property (strong,nonatomic,readonly) NSArray *completedFuzzles;

+ (FuzzlePicObjectController *)sharedInstance;
- (FuzzlePicObject *)createFuzzlePicObjectWithImagePath:(NSString *)imagePath currentState:(NSString *)currentState;
- (void)removeFuzzlePicObject:(FuzzlePicObject *)fuzzlePic;

@end
