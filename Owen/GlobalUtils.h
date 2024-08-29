//
//  GlobalUtils.h
//  Owen
//
//  Created by Max Barry on 11/16/16.
//  Copyright © 2016 Max Barry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobalUtils : NSObject

+ (UIImage *)getPortraitImageFor:(NSUInteger)item;
//+ (NSData *)getAudioTrack:(NSUInteger)item;
+ (NSString *)getPathForAudioTrack:(NSUInteger)item;
+ (CGPoint)getMouthPointFor:(NSUInteger)item;
+ (BOOL)is2Parents;
+ (BOOL)isBackgroundMusicEnabled;

@end
