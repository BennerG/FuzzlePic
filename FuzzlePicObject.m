//
//  FuzzlePicObject.m
//  FuzzlePic
//
//  Created by Benjamin Thomas Gurrola on 11/11/15.
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
    for (int i = 0; i < currentState.length; i++) {
        NSString *locationReference = [currentState substringWithRange:NSMakeRange(i,1)];
        NSNumber *numRef = [NSNumber numberWithInt:(int)[locationReference integerValue]];
        [numberReferences addObject:numRef];
    }
    // test if the array is ordered
    for (int j = 0; j < numberReferences.count; j++) {
        if (numberReferences[j] > numberReferences[j + 1]) return NO;
    }
    // if all indexes are in order return YES
    return YES;
}

@end
