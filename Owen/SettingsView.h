//
//  SettingsView.h
//  Owen
//
//  Created by Max Barry on 6/5/16.
//  Copyright © 2016 Max Barry. All rights reserved.
//

#import <UIKit/UIKit.h>
@import AVFoundation;

@protocol SettingsViewDelegate <NSObject>

- (void)requestTakePhoto;
- (void)requestSelectPhoto;

@end

@interface SettingsView : UIView <AVAudioPlayerDelegate>

@property (nonatomic, strong)   UIImageView                 *user1image;
@property (nonatomic, strong)   UIImageView                 *user2image;
@property (nonatomic, strong)   UIImageView                 *currentImage;
@property (nonatomic)           NSUInteger                  currentImageNum;
@property (nonatomic)           NSUInteger                  currentSound;
@property (nonatomic, weak)     id<SettingsViewDelegate>    settingsViewDelegate;

@end
