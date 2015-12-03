//
//  ImageBlock.m
//  FuzzlePic
//
//  Created by Benjamin Thomas Gurrola on 12/2/15.
//  Copyright © 2015 Benjamin Thomas Gurrola. All rights reserved.
//

#import "ImageBlock.h"

@implementation ImageBlock

- (instancetype)initImageBlockWithSourceLocation:(NSInteger)sourceLocation image:(UIImage *)image {
    self.initialImageIndex = sourceLocation;
    self.blockImageView.image = image;
    return self;
}

@end
