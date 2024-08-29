//
//  AppDelegate.h
//  Owen
//
//  Created by Max Barry on 4/11/16.
//  Copyright © 2016 Max Barry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, AVAudioPlayerDelegate>

@property (strong, nonatomic) UIWindow                  *window;
@property (nonatomic, strong) AVAudioPlayer             *audioPlayer;

- (void)turnBackgroundMusicOn:(BOOL)on;
- (BOOL)isBackgroundMusicPlaying;

@end

