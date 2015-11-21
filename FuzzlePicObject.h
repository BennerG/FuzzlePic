//
//  FuzzlePicObject.h
//  FuzzlePic
//
//  Created by Benjamin Thomas Gurrola on 11/21/15.
//  Copyright © 2015 Benjamin Thomas Gurrola. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface FuzzlePicObject : NSManagedObject

- (BOOL)isComplete;

@end

NS_ASSUME_NONNULL_END

#import "FuzzlePicObject+CoreDataProperties.h"
