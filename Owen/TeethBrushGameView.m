//
//  TeethBrushGameVIew.m
//  Owen
//
//  Created by Max Barry on 8/7/17.
//  Copyright © 2017 Max Barry. All rights reserved.
//

#import "TeethBrushGameView.h"
#import "CircularView.h"

#define BORDER_PADDING      20.0f

@interface TeethBrushGameView ()

@property (nonatomic, strong)       CircularView            *face1;
@property (nonatomic, strong)       CircularView            *face2;
@property (nonatomic, strong)       UIImageView             *teeth1;
@property (nonatomic, strong)       UIImageView             *teeth2;
@property (nonatomic, strong)       UIImageView             *toothpasteTube;
@property (nonatomic, strong)       UIView                  *toothPaste;
@property (nonatomic, assign)       BOOL                    have2Parents;
@property (nonatomic, strong)       UIImageView             *toothBrush;
@property (nonatomic, strong)       UIPanGestureRecognizer  *panner;
@property (nonatomic, strong)       UITapGestureRecognizer  *tapper;
@property (nonatomic, strong)       AVAudioPlayer           *audioPlayer;
@property (nonatomic, assign)       BOOL                    playingAudio;
@property (nonatomic, assign)       BOOL                    toothpasteShown;
@property (nonatomic, assign)       NSUInteger              brushCount;
@property (nonatomic, assign)       CGPoint                 mouth1Point;
@property (nonatomic, assign)       CGPoint                 mouth2Point;

@end

@implementation TeethBrushGameView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initTeethBrushGameView];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initTeethBrushGameView];
    }
    return self;
}

- (void)initTeethBrushGameView {
    _have2Parents = [GlobalUtils is2Parents];
    _playingAudio = NO;
    _toothpasteShown = NO;
    _brushCount = 0;
        
    _face1 = [[CircularView alloc] init];
    _face1.borderColor = [UIColor darkGrayColor];
    _face1.content = [GlobalUtils getPortraitImageFor:1];
    [self addSubview:_face1];
    
    _mouth1Point = [GlobalUtils getMouthPointFor:1];
    _mouth2Point = [GlobalUtils getMouthPointFor:2];
    
    _teeth1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"teeth.png"]];
    _teeth1.contentMode = UIViewContentModeScaleAspectFit;
    [_face1 addSubview:_teeth1];
    
    if (_have2Parents) {
        _face2 = [[CircularView alloc] init];
        _face2.borderColor = [UIColor darkGrayColor];
        _face2.content = [GlobalUtils getPortraitImageFor:2];
        [self addSubview:_face2];
        
        _teeth2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"teeth.png"]];
        _teeth2.contentMode = UIViewContentModeScaleAspectFit;
        [_face2 addSubview:_teeth2];
    }
    
    _toothBrush = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"toothbrush.png"]];
    _toothBrush.contentMode = UIViewContentModeScaleAspectFit;
    _toothBrush.frame = CGRectMake(self.bounds.size.width - 130.0f - BORDER_PADDING, ceilf(self.bounds.size.height / 2.0f) - 25.0f, 130.0f, 70.0f);
    _toothBrush.userInteractionEnabled = YES;
    [self addSubview:_toothBrush];
    
    _panner = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(toothBrushMoved:)];
    [_toothBrush addGestureRecognizer:_panner];
    
    _toothPaste = [[UIView alloc] init];
    _toothPaste.backgroundColor = [UIColor blueColor];
    _toothPaste.frame = CGRectMake(BORDER_PADDING + 20.0f, BORDER_PADDING + 5.0f, 45.0f, 15.0f);
    _toothPaste.layer.cornerRadius = 15.0f;
    [self addSubview:_toothPaste];
    
    _toothpasteTube = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"toothpasteTube.png"]];
    _toothpasteTube.contentMode = UIViewContentModeScaleAspectFit;
    _toothpasteTube.userInteractionEnabled = YES;
    _toothpasteTube.frame = CGRectMake(BORDER_PADDING, BORDER_PADDING, 75.0f, 30.0f);
    [self addSubview:_toothpasteTube];
    
    _tapper = [[UITapGestureRecognizer alloc] init];
    [_tapper addTarget:self action:@selector(toothPasteTapped)];
    [_toothpasteTube addGestureRecognizer:_tapper];
    
    NSString *soundFilePath = [NSString stringWithFormat:@"%@/toothBrushSound.mp3",[[NSBundle mainBundle] resourcePath]];
    NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:nil];
    _audioPlayer.delegate = self;
    [_audioPlayer prepareToPlay];
}

- (void)layoutSubviews {
    
    if (_have2Parents) {
        CGFloat faceCircleSize = ceilf(self.bounds.size.width / 2.2f);
        _face1.frame = CGRectMake(BORDER_PADDING, ceilf(self.bounds.size.height / 2.5f) - faceCircleSize, faceCircleSize, faceCircleSize);
        
        CGFloat quarterFaceWidth = ceilf(faceCircleSize / 4.0f);
        if (CGPointEqualToPoint(_mouth1Point, CGPointZero)) {
            _teeth1.frame = CGRectMake(quarterFaceWidth, ceilf(quarterFaceWidth * 2.5f), faceCircleSize - (2.0f * quarterFaceWidth), 20.0f);
        } else {
            CGFloat scale = _face1.bounds.size.width / _face1.content.size.width;
            _teeth1.frame = CGRectMake(0.0f, 0.0f, faceCircleSize - (2.0f * quarterFaceWidth), 30.0f);
            _teeth1.center = CGPointMake(_mouth1Point.x * scale, _mouth1Point.y * scale);
        }
        
        _face2.frame = CGRectMake(BORDER_PADDING, CGRectGetMaxY(_face1.frame) + _face1.frame.origin.y, faceCircleSize, faceCircleSize);
        
        if (CGPointEqualToPoint(_mouth2Point, CGPointZero)) {
            _teeth2.frame = CGRectMake(quarterFaceWidth, ceilf(quarterFaceWidth * 2.5f), faceCircleSize - (2.0f * quarterFaceWidth), 20.0f);
        } else {
            CGFloat scale = _face2.bounds.size.width / _face2.content.size.width;
            _teeth2.frame = CGRectMake(0.0f, 0.0f, faceCircleSize - (2.0f * quarterFaceWidth), 30.0f);
            _teeth2.center = CGPointMake(_mouth2Point.x * scale, _mouth2Point.y * scale);
        }
    } else {
        CGFloat faceCircleSize = ceilf(self.bounds.size.width / 2.0f);
        _face1.frame = CGRectMake(0.0f, 0.0f, faceCircleSize, faceCircleSize);
        _face1.center = self.center;

        CGFloat quarterFaceWidth = ceilf(faceCircleSize / 4.0f);
        if (CGPointEqualToPoint(_mouth1Point, CGPointZero)) {
            _teeth1.frame = CGRectMake(quarterFaceWidth, ceilf(quarterFaceWidth * 2.5f), faceCircleSize - (2.0f * quarterFaceWidth), 20.0f);
        } else {
            CGFloat scale = _face1.bounds.size.width / _face1.content.size.width;
            _teeth1.frame = CGRectMake(0.0f, 0.0f, faceCircleSize - (2.0f * quarterFaceWidth), 30.0f);
            _teeth1.center = CGPointMake(_mouth1Point.x * scale, _mouth1Point.y * scale);
        }
    }
    
}

- (void)toothBrushMoved:(UIPanGestureRecognizer *)panner {
    UIView *draggedView = panner.view;
    CGPoint offset = [panner translationInView:draggedView.superview];
    CGPoint center = draggedView.center;
    draggedView.center = CGPointMake(center.x + offset.x, center.y + offset.y);
    
    if (_toothpasteShown) {
        _toothPaste.center = CGPointMake(_toothBrush.frame.origin.x + 10.0f, _toothBrush.frame.origin.y + 20.0f);
    }
    
    // Reset translation to zero so on the next `panWasRecognized:` message, the
    // translation will just be the additional movement of the touch since now.
    [panner setTranslation:CGPointZero inView:draggedView.superview];
    
    if (CGRectIntersectsRect(draggedView.frame, _face1.frame) || CGRectIntersectsRect(draggedView.frame, _face2.frame)) {
        if (!_playingAudio) {
            _playingAudio = YES;
            [_audioPlayer play];

            if (_toothpasteShown) {
                _brushCount++;
                
                if (_brushCount >= 3) {
                    _brushCount = 0;
                    _toothpasteShown = NO;
                    _toothPaste.frame = CGRectMake(BORDER_PADDING + 20.0f, BORDER_PADDING + 5.0f, 45.0f, 15.0f);
                }
            }
        }
    }
}

- (void)toothPasteTapped {
    if (_toothpasteShown) {
        return;
    }
    _toothpasteShown = YES;
    
    [UIView animateWithDuration:0.3f animations:^{
        self->_toothPaste.center = CGPointMake(self->_toothPaste.center.x + 50.0f, self->_toothPaste.center.y);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3f animations:^{
            self->_toothPaste.center = CGPointMake(self->_toothBrush.frame.origin.x + 10.0f, self->_toothBrush.frame.origin.y + 20.0f);
        } completion:^(BOOL finished2) {
        }];
    }];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    _playingAudio = NO;
}

@end
