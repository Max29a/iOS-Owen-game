//
//  GlobalUtils.m
//  Owen
//
//  Created by Max Barry on 11/16/16.
//  Copyright © 2016 Max Barry. All rights reserved.
//

#import "GlobalUtils.h"

@implementation GlobalUtils

+ (UIImage *)getPortraitImageFor:(NSUInteger)item {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *keyName = [NSString stringWithFormat:@"file%lu", (unsigned long)item];
    NSString *filePath = [userDefaults valueForKey:keyName];
    if (filePath) {
        UIImage *customImage = [UIImage imageWithContentsOfFile:filePath];
        if (customImage) {
            return customImage;
        }
    }
    
    UIImage *customImage = [UIImage imageNamed:@"man_shape.gif"];
    return customImage;
}

+ (CGPoint)getMouthPointFor:(NSUInteger)item {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *keyName = [NSString stringWithFormat:@"mouthPoint%lu", (unsigned long)item];
    NSString *point = [userDefaults valueForKey:keyName];
    return CGPointFromString(point);
}

+ (NSString *)getPathForAudioTrack:(NSUInteger)item {
    return [NSString stringWithFormat:@"%@/audio%lu.caf", DOCUMENTS_FOLDER, (unsigned long)item];
}

+ (BOOL)is2Parents {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [[userDefaults valueForKey:@"is2parents"] boolValue];
}

+ (BOOL)isBackgroundMusicEnabled {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults valueForKey:@"backgroundMusicOn"]) {
        return [[userDefaults valueForKey:@"backgroundMusicOn"] boolValue];
    } else {
        return NO;
    }

}

@end
