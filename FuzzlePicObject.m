//
//  FuzzlePicObject.m
//  FuzzlePic
//
//  Created by Benjamin Thomas Gurrola on 12/2/15.
//  Copyright © 2015 Benjamin Thomas Gurrola. All rights reserved.
//

#import "FuzzlePicObject.h"

@implementation FuzzlePicObject

- (BOOL)isComplete {
    return [self isOrdered:self.currentState];
}

- (BOOL)isOrdered:(NSString *)currentState {
    NSArray *numberReferences = [currentState componentsSeparatedByString:@","];
    NSMutableArray *intValReferences = [NSMutableArray new];
    // for each number in String.
    for (int i = 0; i < numberReferences.count; i++) {
        NSNumber *intVal = [NSNumber numberWithInteger:[[numberReferences objectAtIndex:i] integerValue]];
        [intValReferences addObject:intVal];
    }
    // test if the array is ordered
    for (int j = 0; j < numberReferences.count; j++) {
        if ([numberReferences[j] integerValue] > [numberReferences[j + 1] integerValue]) return NO;
    }
    // if all indexes are in order return YES
    return YES;
}

@end
