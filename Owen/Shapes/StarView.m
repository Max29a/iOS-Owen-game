//
//  StarView.m
//  Owen
//
//  Created by Max Barry on 12/2/17.
//  Copyright © 2017 Max Barry. All rights reserved.
//

#import "StarView.h"

@interface StarView ()

@property (nonatomic)   int     numPoints;

@end

@implementation StarView

- (instancetype)init {
    self = [super init];
    if (self) {
        _numPoints = 5;
    }
    return self;
}

- (instancetype)initStarViewWithNumPoints:(int)points {
    self = [self init];
    if (self) {
        _numPoints = points;
    }
    return self;
}

- (CGPoint)pointFrom:(CGFloat)angle radius:(CGFloat)radius offset:(CGPoint)offset {
    return CGPointMake(radius * cos(angle) + offset.x, radius * sin(angle) + offset.y);
}

-(void)drawRect:(CGRect)rect {
    if (!self.hasPath) {
        self.path = [self getStarPathForRect:rect];
    }
    
    UIColor *fill = [UIColor colorWithPatternImage:self.fillImage];
    [fill setFill];
    [self.color setStroke];
    self.path.lineWidth = 2.0f;
    [self.path stroke];
    [self.path fill];
}

- (UIBezierPath *)getStarPathForRect:(CGRect)rect {
    CGFloat starExtrusion = 30.0f;
    
    CGPoint center = CGPointMake(rect.size.width / 2.0, rect.size.height / 2.0);
    
    CGFloat angle = -1.0f * (M_PI / 2.0);
    CGFloat angleIncrement = (M_PI * 2.0 / (double)_numPoints);
    CGFloat radius = rect.size.width / 2.0;
    
    BOOL firstPoint = YES;
    
    for (int i = 0; i < _numPoints; i++) {
        
        CGPoint point = [self pointFrom:angle radius:radius offset:center];
        CGPoint nextPoint = [self pointFrom:(angle + angleIncrement) radius:radius offset:center];
        CGPoint midPoint = [self pointFrom:(angle + angleIncrement / 2.0) radius:starExtrusion offset:center];
        
        if (firstPoint) {
            firstPoint = NO;
            [self.path moveToPoint:point];
        }
        
        [self.path addLineToPoint:midPoint];
        [self.path addLineToPoint:nextPoint];
        
        angle += angleIncrement;
    }
    
    [self.path closePath];
    return self.path;
}


@end
