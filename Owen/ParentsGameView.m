//
//  ParentsGameView.m
//  Owen
//
//  Created by Max Barry on 4/11/16.
//  Copyright © 2016 Max Barry. All rights reserved.
//

#import "ParentsGameView.h"
#import "CircularView.h"
#import <AVFoundation/AVFoundation.h>

#define BORDER_WIDTH                        (IS_IPAD ? 30.0f : 10.0f)
#define NUMBER_ALPHA                        0.3f
#define FOOD_DISCREPANCY_BEFORE_COMPLAIN    5
#define HIGHLIGHT_BORDER                    3.0f

@interface ParentsGameView ()

@property (nonatomic, strong) IBOutlet      CircularView    *face1;
@property (nonatomic, strong)               UIView          *hover1View;
@property (nonatomic, strong) IBOutlet      CircularView    *face2;
@property (nonatomic, strong)               UIView          *hover2View;
@property (nonatomic, strong) IBOutlet      UIButton        *createFoodButton;
@property (nonatomic, strong)               UIImageView     *food;
@property (nonatomic, strong) IBOutlet      UILabel         *face1Count;
@property (nonatomic, strong) IBOutlet      UILabel         *face2Count;
@property (nonatomic, strong)               NSArray         *foods;
@property (nonatomic, strong)               AVAudioPlayer   *audioPlayer;
@property (nonatomic, assign)               BOOL            have2Parents;

@end

@implementation ParentsGameView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initParentsGameView];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initParentsGameView];
    }
    return self;
}

- (void)initParentsGameView {
    _foods = @[
               @"broccoli.png",
               @"apple.png",
               @"bellpepper.png",
               @"donut.png",
               @"grapes.png",
               @"greenbeans.png",
               @"hotdog.png",
               @"icecream.png",
               @"pizza.png",
               ];
    _have2Parents = [GlobalUtils is2Parents];
        
    _hover1View = [[UIView alloc] init];
    _hover1View.backgroundColor = [UIColor grayColor];
    _hover1View.hidden = YES;
    [self addSubview:_hover1View];
    
    _face1 = [[CircularView alloc] init];
    _face1.content = [GlobalUtils getPortraitImageFor:1];
    _face1.borderColor = [UIColor darkGrayColor];
    [self addSubview:_face1];
    
    _hover2View = [[UIView alloc] init];
    _hover2View.backgroundColor = [UIColor grayColor];
    _hover2View.hidden = YES;
    [self addSubview:_hover2View];
    
    _face2 = [[CircularView alloc] init];
    _face2.content = [GlobalUtils getPortraitImageFor:2];
    _face2.borderColor = [UIColor darkGrayColor];
    if (!_have2Parents) {
        _face2.hidden = YES;
    }
    [self addSubview:_face2];
    
    _createFoodButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_createFoodButton setTitle:@"Create Food" forState:UIControlStateNormal];
    [_createFoodButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _createFoodButton.layer.cornerRadius = 4.0f;
    _createFoodButton.layer.borderWidth = 1.0f;
    _createFoodButton.layer.borderColor = [UIColor blackColor].CGColor;
    [_createFoodButton setBackgroundColor:[UIColor lightGrayColor]];
    _createFoodButton.contentEdgeInsets = UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f);
    [_createFoodButton addTarget:self action:@selector(createFood) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_createFoodButton];
}

- (void)layoutSubviews {
    
    _face1.frame = CGRectMake(BORDER_WIDTH, self.bounds.size.height/2.0f, FACE_WIDTH, FACE_HEIGHT);
    _hover1View.frame = CGRectMake(_face1.frame.origin.x - HIGHLIGHT_BORDER, _face1.frame.origin.y - HIGHLIGHT_BORDER, _face1.frame.size.width + (2.0f * HIGHLIGHT_BORDER), _face1.frame.size.height + ( 2.0f * HIGHLIGHT_BORDER));
    _hover1View.layer.cornerRadius = ceilf(_hover1View.bounds.size.width / 2.0f);

    if (!_face2.hidden) {
        _face2.frame = CGRectMake(self.bounds.size.width - BORDER_WIDTH - FACE_WIDTH, self.bounds.size.height/2.0f, FACE_WIDTH, FACE_HEIGHT);
        _hover2View.frame = CGRectMake(_face2.frame.origin.x - HIGHLIGHT_BORDER, _face2.frame.origin.y - HIGHLIGHT_BORDER, _face2.frame.size.width + ( 2.0f *HIGHLIGHT_BORDER), _face2.frame.size.height + (2.0f * HIGHLIGHT_BORDER));
        _hover2View.layer.cornerRadius = ceilf(_hover2View.bounds.size.width / 2.0f);
    }
    
    CGSize owenButtonSize = [_createFoodButton sizeThatFits:CGSizeMake(150.0f, 120.0f)];
    _createFoodButton.frame = CGRectMake(self.bounds.size.width - BORDER_WIDTH - owenButtonSize.width, (BORDER_WIDTH * 2), owenButtonSize.width, 44.0f);
    
    CGSize face1CountSize = [_face1Count sizeThatFits:CGSizeZero];
    CGRect countFrame = CGRectMake(0.0f, _face1.frame.origin.y - face1CountSize.height, face1CountSize.width, face1CountSize.height);
    countFrame.origin.x = BORDER_WIDTH + floorf((_face1.frame.size.width/2.0f) - (face1CountSize.width/2.0f));
    _face1Count.frame = countFrame;
    
    if (!_face2Count.hidden) {
        CGSize face2CountSize = [_face2Count sizeThatFits:CGSizeZero];
        countFrame = CGRectMake(0.0f, _face2.frame.origin.y - face2CountSize.height, face2CountSize.width, face2CountSize.height);
        countFrame.origin.x = _face2.frame.origin.x + floorf((_face2.frame.size.width/2.0f) - (face2CountSize.width/2.0f));
        _face2Count.frame = countFrame;
    }
}

- (void)createFood {
    NSString *foodType = _foods[arc4random_uniform((int)[_foods count])];
    _food = [[UIImageView alloc] initWithImage:[UIImage imageNamed:foodType]];
    [self addSubview:_food];
    _food.userInteractionEnabled = YES;

    CGSize foodSize = [_food sizeThatFits:CGSizeZero];
    _food.frame = CGRectMake(floorf(self.bounds.size.width/2.0f - foodSize.width/2.0f), CGRectGetMaxY(_createFoodButton.frame) + 10.0f, foodSize.width, foodSize.height);

    UIPanGestureRecognizer *panner = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(foodWasDragged:)];
    [_food addGestureRecognizer:panner];
}

- (void)playAudio:(NSUInteger)number {
    SystemSoundID audioEffect;
    NSString *path = [GlobalUtils getPathForAudioTrack:number];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSURL *pathURL = [NSURL fileURLWithPath:path];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef) pathURL, &audioEffect);
        AudioServicesPlaySystemSound(audioEffect);
    }
}

- (void)foodWasDragged:(UIPanGestureRecognizer *)panner {
    UIView *draggedView = panner.view;
    CGPoint offset = [panner translationInView:draggedView.superview];
    CGPoint center = draggedView.center;
    draggedView.center = CGPointMake(center.x + offset.x, center.y + offset.y);
    
    // Reset translation to zero so on the next `panWasRecognized:` message, the
    // translation will just be the additional movement of the touch since now.
    [panner setTranslation:CGPointZero inView:draggedView.superview];
    
    if (_hover1View.hidden && CGRectIntersectsRect(draggedView.frame, _face1.frame)) {
        _hover1View.hidden = NO;
    } else if (!_hover1View.hidden && !CGRectIntersectsRect(draggedView.frame, _face1.frame)) {
        _hover1View.hidden = YES;
    }
    if (_hover2View.hidden && CGRectIntersectsRect(draggedView.frame, _face2.frame)) {
        _hover2View.hidden = NO;
    } else if (!_hover2View.hidden && !CGRectIntersectsRect(draggedView.frame, _face2.frame)) {
        _hover2View.hidden = YES;
    }

    if(panner.state == UIGestureRecognizerStateEnded) {

        _hover1View.hidden = YES;
        _hover2View.hidden = YES;
        
        BOOL isUnfair = _face2Count.hidden ? NO : labs(_face1Count.text.integerValue - _face2Count.text.integerValue) >= FOOD_DISCREPANCY_BEFORE_COMPLAIN;
        BOOL droppedOnHead = CGRectIntersectsRect(draggedView.frame, _face1.frame) || CGRectIntersectsRect(draggedView.frame, _face2.frame);

        if (droppedOnHead) {
            UIView *whichHead = _face1;
            UIView *personBehindOnFood = _face1;
            UILabel *whichLabel = _face1Count;
            NSUInteger eatingSound = 1;
            NSUInteger complainSound = 2;
            
            if (CGRectIntersectsRect(draggedView.frame, _face2.frame)) {
                whichHead = _face2;
                whichLabel = _face2Count;
                eatingSound = 3;
            }
            if (_face1Count.text.integerValue > _face2Count.text.integerValue) {
                personBehindOnFood = _face2;
                complainSound = 4;
            }

            whichLabel.text = [NSString stringWithFormat:@"%ld", (long)[whichLabel.text integerValue] + 1];

            if (isUnfair && whichHead != personBehindOnFood) {
                [self playAudio:complainSound];
                
                [UIView animateWithDuration:0.5f animations:^{
                    personBehindOnFood.layer.backgroundColor = [UIColor greenColor].CGColor;
                } completion:^(BOOL completed) {
                    [UIView animateWithDuration:0.5f animations:^{
                        personBehindOnFood.layer.backgroundColor = [UIColor clearColor].CGColor;
                    } completion:^(BOOL completed) {
                        [UIView animateWithDuration:0.5f animations:^{
                            personBehindOnFood.layer.backgroundColor = [UIColor greenColor].CGColor;
                        } completion:^(BOOL completed) {
                            personBehindOnFood.layer.backgroundColor = [UIColor clearColor].CGColor;
                        }];
                    }];
                }];
            } else {
                [self playAudio:eatingSound];
            }
            
        }
                
        if (droppedOnHead) {
            [draggedView removeFromSuperview];
            draggedView = nil;
        }
    }
}

@end
