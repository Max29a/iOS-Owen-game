//
//  CircularView.h
//  Owen
//
//  Created by Max Barry on 8/6/17.
//  Copyright © 2017 Max Barry. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface CircularView : UIView

@property (nonatomic, strong) IBInspectable  UIColor     *borderColor;
@property (nonatomic, assign) IBInspectable  NSUInteger  borderWidth;
@property (nonatomic, strong)   UIImage     *content;

- (void)setBorderColor:(UIColor *)borderColor;
- (void)setBorderWidth:(NSUInteger)borderWidth;
- (void)setContent:(UIImage *)content;

@end
