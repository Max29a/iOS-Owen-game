//
//  AppDelegate.m
//  Owen
//
//  Created by Max Barry on 4/11/16.
//  Copyright © 2016 Max Barry. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (nonatomic)   BOOL    musicPlaying;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    NSString *soundFilePath = [NSString stringWithFormat:@"%@/popsicleDreams.mp3", [[NSBundle mainBundle] resourcePath]];
    NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:nil];
    _audioPlayer.numberOfLoops = -1;
    _audioPlayer.delegate = self;
    _audioPlayer.volume = 0.2f;
    [_audioPlayer prepareToPlay];
    
    _musicPlaying = NO;
    
    if ([GlobalUtils isBackgroundMusicEnabled]) {
        [self turnBackgroundMusicOn:YES];
     }

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.

}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)turnBackgroundMusicOn:(BOOL)on {
    if (on) {
        [_audioPlayer play];
    } else {
        [_audioPlayer stop];
    }
    _musicPlaying = on;
}

- (BOOL)isBackgroundMusicPlaying {
    return _musicPlaying;
}

@end
