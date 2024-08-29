//
//  CircularView.m
//  Owen
//
//  Created by Max Barry on 8/6/17.
//  Copyright © 2017 Max Barry. All rights reserved.
//

#import "CircularView.h"

@interface CircularView()

@property (nonatomic, strong) UIImageView       *contentImage;

@end

@implementation CircularView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self circularViewInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self circularViewInit];
    }
    return self;
}

- (void)circularViewInit {
    self.clipsToBounds = YES;
    [self setBorderWidth:1.0f];
}

- (void)layoutSubviews {
    self.layer.cornerRadius = (self.bounds.size.width / 2.0f);
    _contentImage.frame = self.bounds;
}

- (void)setBorderColor:(UIColor *)borderColor {
    _borderColor = borderColor;
    self.layer.borderColor = borderColor.CGColor;
}

- (void)setBorderWidth:(NSUInteger)borderWidth {
    _borderWidth = borderWidth;
    self.layer.borderWidth = borderWidth;
}

- (void)setContent:(UIImage *)content {
    _content = content;
    _contentImage = [[UIImageView alloc] initWithImage:_content];
    _contentImage.contentMode = UIViewContentModeScaleAspectFit;
    if (!_contentImage.superview) {
        [self addSubview:_contentImage];
    }
    [self setNeedsLayout];
}

@end
