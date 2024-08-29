//
//  Shape.m
//  Owen
//
//  Created by Max Barry on 12/2/17.
//  Copyright © 2017 Max Barry. All rights reserved.
//

#import "Shape.h"

@implementation Shape

- (instancetype)init {
    self = [super init];
    if (self) {
        _path = [UIBezierPath bezierPath];
        _hasPath = NO;
        _color = [UIColor blueColor];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setPath:(UIBezierPath *)path {
    _path = path;
    _hasPath = YES;
}

@end
