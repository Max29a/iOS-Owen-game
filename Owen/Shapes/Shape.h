//
//  Shape.h
//  Owen
//
//  Created by Max Barry on 12/2/17.
//  Copyright © 2017 Max Barry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Shape : UIView

@property (nonatomic, strong)   UIBezierPath    *path;
@property (nonatomic, assign)   BOOL            hasPath;
@property (nonatomic, strong)   UIColor         *color;
@property (nonatomic, strong)   UIImage         *fillImage;

@end
