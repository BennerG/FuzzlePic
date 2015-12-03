//
//  ImageBlock.h
//  FuzzlePic
//
//  Created by Benjamin Thomas Gurrola on 12/2/15.
//  Copyright © 2015 Benjamin Thomas Gurrola. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ImageBlock : NSObject

@property (nonatomic,assign) NSInteger initialImageIndex;
@property (nonatomic,strong) UIImageView *blockImageView;

- (instancetype)initImageBlockWithSourceLocation:(NSInteger)sourceLocation image:(UIImage *)image;

@end
