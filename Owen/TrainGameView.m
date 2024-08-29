//
//  TrainGameView.m
//  Owen
//
//  Created by Max Barry on 5/1/16.
//  Copyright © 2016 Max Barry. All rights reserved.
//

#import "TrainGameView.h"
#import <AVFoundation/AVFoundation.h>

#define SIGNAL_RATIO    (2.0f / 3.0f)
#define ANIMATION_DURATION  5.0f

@interface TrainGameView ()

@property (nonatomic, strong)   UIImageView     *train;
@property (nonatomic, strong)   UIImageView     *trainSignal;
@property (nonatomic, strong)   UIImageView     *trainSignalArm;
@property (nonatomic, strong)   UIImageView     *trainLight1;
@property (nonatomic, strong)   UIImageView     *trainLight2;
@property (nonatomic, strong)   UIButton        *armButton;
@property (nonatomic)           BOOL            armIsDown;
@property (nonatomic)           BOOL            animating;
@property (nonatomic, assign)   BOOL            isAnimatingTrain;
@property (nonatomic, strong)   AVAudioPlayer   *audioPlayer;

@end

@implementation TrainGameView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initTrainGameView];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initTrainGameView];
    }
    return self;
}

- (void)initTrainGameView {
    _armIsDown = YES;
    _isAnimatingTrain = NO;
    
    _train = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"train.png"]];
    _train.contentMode = UIViewContentModeScaleAspectFit;
    //_train.hidden = YES;
    [self addSubview:_train];
    
    _trainLight1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"train_signal_light.png"]];
    _trainLight1.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_trainLight1];
    
    _trainLight2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"train_signal_light.png"]];
    _trainLight2.contentMode = UIViewContentModeScaleAspectFit;
    _trainLight2.alpha = 0.5f;
    [self addSubview:_trainLight2];
    
    _trainSignal = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"train_signal_no_arm.png"]];
    _trainSignal.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_trainSignal];
    
    _trainSignalArm = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"train_signal_arm.png"]];
    _trainSignalArm.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_trainSignalArm];
    _trainSignalArm.layer.anchorPoint = CGPointMake(0.82f, 0.6f);
    
    _armButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_armButton addTarget:self action:@selector(moveArm) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_armButton];
}

- (void)layoutSubviews {
    _trainLight1.frame = CGRectMake(50.0f, 20.0f, 80.0f, 80.0f);
    _trainLight2.frame = CGRectMake(self.bounds.size.width - 120.0f, 20.0f, 80.0f, 80.0f);
    
    CGSize size = CGSizeMake(ceilf(self.bounds.size.width * SIGNAL_RATIO), ceilf(self.bounds.size.height * SIGNAL_RATIO));
    CGPoint point = CGPointMake(20.0f, 120.0f);
    
    _trainSignal.frame = CGRectMake(point.x, point.y, size.width, size.height);
    if (!_animating) {
        _trainSignalArm.frame = CGRectMake(point.x, point.y, size.width, size.height);
        _armButton.frame = _trainSignalArm.frame;
    }
    
    if (!_isAnimatingTrain) {
        CGSize trainSize = [_train sizeThatFits:CGSizeZero];
        CGFloat exposeLength = 300.0f;
        if (!IS_IPAD) {
            exposeLength = 200.0f;
            trainSize = CGSizeMake(ceilf(trainSize.width * 0.8f), ceilf(trainSize.height * 0.8f));
        }
        _train.frame = CGRectMake(ceilf(self.bounds.size.width - exposeLength), CGRectGetMaxY(_trainSignal.frame) - trainSize.height - ceilf((1.0f/4.0f) * _trainSignal.bounds.size.height), trainSize.width, trainSize.height);
    }
    [self bringSubviewToFront:_trainSignal];
}

- (void)moveArm {
    if (_animating) {
        return;
    }
    [self playTrainSignal];
    [self animateTrain];
    _animating = YES;
    
    [UIView animateWithDuration:ANIMATION_DURATION animations:^{
        self->_trainSignalArm.transform = CGAffineTransformRotate(self->_trainSignalArm.transform, (self->_armIsDown ? 1 : -1) * M_PI_2);
    } completion:^(BOOL finished) {
        self->_armIsDown = !self->_armIsDown;
        self->_animating = NO;
        [self->_audioPlayer stop];
    }];

    [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionAutoreverse animations:^ {
        [UIView setAnimationRepeatCount:10.0f/2.0f];
        self->_trainLight1.alpha = 0.2f;
        self->_trainLight2.alpha = 1.0f;
    } completion:^(BOOL finished) {
        self->_trainLight1.alpha = 1.0f;
        self->_trainLight2.alpha = 0.2f;
    }];
}

- (void)playTrainSignal {
    if (!_audioPlayer) {
        NSString* path = [[NSBundle mainBundle] pathForResource:@"trainsignal" ofType:@"mp3"];
        NSURL* file = [NSURL fileURLWithPath:path];
        
        _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:file error:nil];
        [_audioPlayer prepareToPlay];
    }
    [_audioPlayer play];
}

- (void)animateTrain {
    if (_isAnimatingTrain) {
        return;
    }
    
    _isAnimatingTrain = YES;
    [UIView animateWithDuration:ANIMATION_DURATION animations:^{
        self->_train.frame = CGRectMake(0.0f - self->_train.frame.size.width, self->_train.frame.origin.y, self->_train.frame.size.width, self->_train.frame.size.height);
    } completion:^(BOOL completed) {
        self->_train.frame = CGRectMake(self.bounds.size.width + 1.0f, self->_train.frame.origin.y, self->_train.frame.size.width, self->_train.frame.size.height);
        
        [UIView animateWithDuration:1.0f animations:^{
            CGFloat exposeLength = IS_IPAD ? 300.0f : 200.0f;
            //_train.frame = CGRectMake(ceilf(self.bounds.size.width - exposeLength), self.bounds.size.height - _train.frame.size.height, _train.frame.size.width, _train.frame.size.height);
            CGSize trainSize = self->_train.frame.size;
            self->_train.frame = CGRectMake(ceilf(self.bounds.size.width - exposeLength), CGRectGetMaxY(self->_trainSignal.frame) - trainSize.height - ceilf((1.0f/4.0f) * self->_trainSignal.bounds.size.height), trainSize.width, trainSize.height);
        } completion:^(BOOL finished) {
            [self->_audioPlayer stop];
            self->_isAnimatingTrain = NO;
        }];
    }];
}

@end
