//
//  ShapeGameView.m
//  Owen
//
//  Created by Max Barry on 12/2/17.
//  Copyright © 2017 Max Barry. All rights reserved.
//

#import "ShapeGameView.h"
#import "StarView.h"

#define BORDER_PADDING      20.0f

@interface ShapeGameView ()

@property (nonatomic, strong)   NSMutableArray      *shapes;
@property (nonatomic, strong)    Shape               *star;

@end

@implementation ShapeGameView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initShapeGameView];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initShapeGameView];
    }
    return self;
}

- (void)initShapeGameView {
//    _shapes = [[NSMutableArray alloc] init];
//    [_shapes addObject:[[StarView alloc] initStarViewWithNumPoints:5]];
    _star = [[StarView alloc] initStarViewWithNumPoints:5];
    _star.color = [self getRandomColor];
    _star.fillImage = [self getImageForShape];
    [self addSubview:_star];
}

- (void)layoutSubviews {
    _star.frame = CGRectMake(20.0f, 20.0f, 125.0f, 125.0f);
}

- (UIImage *)getImageForShape {
    if ([GlobalUtils is2Parents]) {
        return [GlobalUtils getPortraitImageFor:arc4random_uniform(2)];
    } else {
        return [GlobalUtils getPortraitImageFor:0];
    }
}

- (UIColor *)getRandomColor {
    CGFloat hue = ( arc4random() % 256 / 256.0 );
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;
    UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    return color;
}

@end

