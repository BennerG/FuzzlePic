//
//  FuzzlePicObject.m
//  FuzzlePic
//
//  Created by Benjamin Thomas Gurrola on 11/21/15.
//  Copyright © 2015 Benjamin Thomas Gurrola. All rights reserved.
//

#import "FuzzlePicObject.h"

@implementation FuzzlePicObject

- (BOOL)isComplete {
    return [self isOrdered:self.currentState];
}

- (BOOL)isOrdered:(NSString *)currentState {
    NSMutableArray  *numberReferences = [NSMutableArray new];
    // for each number in String.
    numberReferences = [[currentState componentsSeparatedByString:@","] mutableCopy];
    // test if the array is ordered
    for (int j = 0; j < numberReferences.count; j++) {
        if (numberReferences[j] > numberReferences[j + 1]) return NO;
    }
    // if all indexes are in order return YES
    return YES;
}

@end
