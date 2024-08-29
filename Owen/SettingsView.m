//
//  SettingsView.m
//  Owen
//
//  Created by Max Barry on 6/5/16.
//  Copyright © 2016 Max Barry. All rights reserved.
//

#import "SettingsView.h"
#import "AppDelegate.h"

#define MARGIN_TOP              25.0f
#define MARGIN_LEFT             10.0f
#define BUTTON_HEIGHT           (IS_IPAD ? 50.0f : 40.0f)
#define FONT_SIZE               (IS_IPAD ? 24.0f : 14.0f)
#define BUTTON_MARGIN_VERTICAL  10.0f
#define BUTTON_INTERNAL_MARGIN  10.0f

@interface SettingsView ()

@property (nonatomic, strong)   UIScrollView                *scrollView;
@property (nonatomic, strong)   UILabel                     *musicOffLabel;
@property (nonatomic, strong)   UILabel                     *musicOnLabel;
@property (nonatomic, strong)   UISwitch                    *musicSwitch;
@property (nonatomic, strong)   UILabel                     *oneParentLabel;
@property (nonatomic, strong)   UILabel                     *twoParentsLabel;
@property (nonatomic, strong)   UISwitch                    *numParentsSwitch;
@property (nonatomic, strong)   UIButton                    *recordButton1;
@property (nonatomic, strong)   UIButton                    *recordButton2;
@property (nonatomic, strong)   UIButton                    *recordButton3;
@property (nonatomic, strong)   UIButton                    *recordButton4;
@property (nonatomic, strong)   AVAudioRecorder             *recorder;
@property (nonatomic, strong)   NSMutableDictionary         *recordSetting;
@property (nonatomic, strong)   AVAudioPlayer               *player;
@property (nonatomic, strong)   UIButton                    *playButton1;
@property (nonatomic, strong)   UIButton                    *playButton2;
@property (nonatomic, strong)   UIButton                    *playButton3;
@property (nonatomic, strong)   UIButton                    *playButton4;
@property (nonatomic, strong)   UIButton                    *takePhotoButton1;
@property (nonatomic, strong)   UIButton                    *selectPhotoButton1;
@property (nonatomic, strong)   UIButton                    *takePhotoButton2;
@property (nonatomic, strong)   UIButton                    *selectPhotoButton2;
@property (nonatomic, strong)   NSString                    *audioFilePath;
@property (nonatomic, strong)   NSFileManager               *fileManager;

@end

@implementation SettingsView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSettingsView];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initSettingsView];
    }
    return self;
}

- (void)initSettingsView {
    _fileManager = [NSFileManager defaultManager];
    
    _currentImage = _user1image;
    _currentImageNum = 1;

    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    [self addSubview:_scrollView];
    
    _musicOffLabel = [[UILabel alloc] init];
    _musicOffLabel.text = @"Background Music Off";
    _musicOffLabel.font = [UIFont fontWithName:@"Helvetica" size:FONT_SIZE];
    _musicOffLabel.textColor = [UIColor blackColor];
    [_scrollView addSubview:_musicOffLabel];
    
    _musicOnLabel = [[UILabel alloc] init];
    _musicOnLabel.text = @"On";
    _musicOnLabel.font = [UIFont fontWithName:@"Helvetica" size:FONT_SIZE];
    _musicOnLabel.textColor = [UIColor blackColor];
    [_scrollView addSubview:_musicOnLabel];
    
    _musicSwitch = [[UISwitch alloc] init];
    [_musicSwitch addTarget:self action:@selector(enableBackgroundMusicTouched:) forControlEvents:UIControlEventValueChanged];
    _musicSwitch.on = [GlobalUtils isBackgroundMusicEnabled];
    [_scrollView addSubview:_musicSwitch];

    _oneParentLabel = [[UILabel alloc] init];
    _oneParentLabel.text = @"One Parent";
    _oneParentLabel.font = [UIFont fontWithName:@"Helvetica" size:FONT_SIZE];
    _oneParentLabel.textColor = [UIColor blackColor];
    [_scrollView addSubview:_oneParentLabel];
    
    _twoParentsLabel = [[UILabel alloc] init];
    _twoParentsLabel.text = @"Two Parents";
    _twoParentsLabel.font = [UIFont fontWithName:@"Helvetica" size:FONT_SIZE];
    _twoParentsLabel.textColor = [UIColor blackColor];
    [_scrollView addSubview:_twoParentsLabel];
    
    _numParentsSwitch = [[UISwitch alloc] init];
    [_numParentsSwitch addTarget:self action:@selector(numParentsTouched:) forControlEvents:UIControlEventValueChanged];
    _numParentsSwitch.on = [GlobalUtils is2Parents];
    [_scrollView addSubview:_numParentsSwitch];
    
    _recordButton1 = [[UIButton alloc] init];
    [_recordButton1 addTarget:self action:@selector(recordClicked:) forControlEvents:UIControlEventTouchUpInside];
    _recordButton1.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:FONT_SIZE];
    [_recordButton1 setTitle:@"Record Happy Parent 1" forState:UIControlStateNormal];
    [_recordButton1 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    _recordButton1.backgroundColor = [UIColor lightGrayColor];
    _recordButton1.layer.cornerRadius = 4.0f;
    _recordButton1.layer.borderColor = [UIColor blackColor].CGColor;
    _recordButton1.layer.borderWidth = 1.0f;
    [_scrollView addSubview:_recordButton1];
    
    _recordButton2 = [[UIButton alloc] init];
    [_recordButton2 addTarget:self action:@selector(recordClicked:) forControlEvents:UIControlEventTouchUpInside];
    _recordButton2.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:FONT_SIZE];
    [_recordButton2 setTitle:@"Record Sad Parent 1" forState:UIControlStateNormal];
    [_recordButton2 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    _recordButton2.backgroundColor = [UIColor lightGrayColor];
    _recordButton2.layer.cornerRadius = 4.0f;
    _recordButton2.layer.borderColor = [UIColor blackColor].CGColor;
    _recordButton2.layer.borderWidth = 1.0f;
    _recordButton2.hidden = !_numParentsSwitch.on;
    [_scrollView addSubview:_recordButton2];
    
    _recordButton3 = [[UIButton alloc] init];
    [_recordButton3 addTarget:self action:@selector(recordClicked:) forControlEvents:UIControlEventTouchUpInside];
    _recordButton3.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:FONT_SIZE];
    [_recordButton3 setTitle:@"Record Happy Parent 2" forState:UIControlStateNormal];
    [_recordButton3 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    _recordButton3.backgroundColor = [UIColor lightGrayColor];
    _recordButton3.layer.cornerRadius = 4.0f;
    _recordButton3.layer.borderColor = [UIColor blackColor].CGColor;
    _recordButton3.layer.borderWidth = 1.0f;
    _recordButton3.hidden = !_numParentsSwitch.on;
    [_scrollView addSubview:_recordButton3];
    
    _recordButton4 = [[UIButton alloc] init];
    [_recordButton4 addTarget:self action:@selector(recordClicked:) forControlEvents:UIControlEventTouchUpInside];
    _recordButton4.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:FONT_SIZE];
    [_recordButton4 setTitle:@"Record Sad Parent 2" forState:UIControlStateNormal];
    [_recordButton4 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    _recordButton4.backgroundColor = [UIColor lightGrayColor];
    _recordButton4.layer.cornerRadius = 4.0f;
    _recordButton4.layer.borderColor = [UIColor blackColor].CGColor;
    _recordButton4.layer.borderWidth = 1.0f;
    _recordButton4.hidden = !_numParentsSwitch.on;
    [_scrollView addSubview:_recordButton4];
    
    _playButton1 = [[UIButton alloc] init];
    [_playButton1 addTarget:self action:@selector(playClicked:) forControlEvents:UIControlEventTouchUpInside];
    _playButton1.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:FONT_SIZE];
    [_playButton1 setTitle:@"Play" forState:UIControlStateNormal];
    [_playButton1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _playButton1.backgroundColor = [UIColor lightGrayColor];
    _playButton1.layer.cornerRadius = 4.0f;
    _playButton1.layer.borderColor = [UIColor blackColor].CGColor;
    _playButton1.layer.borderWidth = 1.0f;
    _playButton1.enabled = [_fileManager fileExistsAtPath:[NSString stringWithFormat:@"%@/audio1.caf", DOCUMENTS_FOLDER]];
    [_scrollView addSubview:_playButton1];
    
    _playButton2 = [[UIButton alloc] init];
    [_playButton2 addTarget:self action:@selector(playClicked:) forControlEvents:UIControlEventTouchUpInside];
    _playButton2.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:FONT_SIZE];
    [_playButton2 setTitle:@"Play" forState:UIControlStateNormal];
    [_playButton2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _playButton2.backgroundColor = [UIColor lightGrayColor];
    _playButton2.layer.cornerRadius = 4.0f;
    _playButton2.layer.borderColor = [UIColor blackColor].CGColor;
    _playButton2.layer.borderWidth = 1.0f;
    _playButton2.enabled = [_fileManager fileExistsAtPath:[NSString stringWithFormat:@"%@/audio2.caf", DOCUMENTS_FOLDER]];
    [_scrollView addSubview:_playButton2];
    
    _playButton3 = [[UIButton alloc] init];
    [_playButton3 addTarget:self action:@selector(playClicked:) forControlEvents:UIControlEventTouchUpInside];
    _playButton3.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:FONT_SIZE];
    [_playButton3 setTitle:@"Play" forState:UIControlStateNormal];
    [_playButton3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _playButton3.backgroundColor = [UIColor lightGrayColor];
    _playButton3.layer.cornerRadius = 4.0f;
    _playButton3.layer.borderColor = [UIColor blackColor].CGColor;
    _playButton3.layer.borderWidth = 1.0f;
    _playButton3.enabled = [_fileManager fileExistsAtPath:[NSString stringWithFormat:@"%@/audio3.caf", DOCUMENTS_FOLDER]];
    [_scrollView addSubview:_playButton3];
    
    _playButton4 = [[UIButton alloc] init];
    [_playButton4 addTarget:self action:@selector(playClicked:) forControlEvents:UIControlEventTouchUpInside];
    _playButton4.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:FONT_SIZE];
    [_playButton4 setTitle:@"Play" forState:UIControlStateNormal];
    [_playButton4 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _playButton4.backgroundColor = [UIColor lightGrayColor];
    _playButton4.layer.cornerRadius = 4.0f;
    _playButton4.layer.borderColor = [UIColor blackColor].CGColor;
    _playButton4.layer.borderWidth = 1.0f;
    _playButton4.enabled = [_fileManager fileExistsAtPath:[NSString stringWithFormat:@"%@/audio4.caf", DOCUMENTS_FOLDER]];
    [_scrollView addSubview:_playButton4];
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    NSError *err = nil;
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error: nil];

    if (err) {
        NSLog(@"audioSession: %@ %ld %@", [err domain], (long)[err code], [[err userInfo] description]);
    }
    
    [audioSession setActive:YES error:&err];
    err = nil;
    
    if (err) {
        NSLog(@"audioSession: %@ %ld %@", [err domain], (long)[err code], [[err userInfo] description]);
    }
    
    _recordSetting = [[NSMutableDictionary alloc] init];
    
    [_recordSetting setValue:[NSNumber numberWithInt:kAudioFormatAppleIMA4] forKey:AVFormatIDKey];
    [_recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [_recordSetting setValue:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
    [_recordSetting setValue:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    [_recordSetting setValue:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
    [_recordSetting setValue:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
    
    _user1image = [[UIImageView alloc] init];
    _user1image.contentMode = UIViewContentModeScaleAspectFit;
    _user1image.layer.borderColor = [UIColor blackColor].CGColor;
    _user1image.layer.borderWidth = 1.0f;
    [_scrollView addSubview:_user1image];
    
    _user2image = [[UIImageView alloc] init];
    _user2image.contentMode = UIViewContentModeScaleAspectFit;
    _user2image.layer.borderColor = [UIColor blackColor].CGColor;
    _user2image.layer.borderWidth = 1.0f;
    _user2image.hidden = !_numParentsSwitch.on;
    [_scrollView addSubview:_user2image];
    
    _takePhotoButton1 = [[UIButton alloc] init];
    [_takePhotoButton1 addTarget:self action:@selector(takePhoto1) forControlEvents:UIControlEventTouchUpInside];
    _takePhotoButton1.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:FONT_SIZE];
    [_takePhotoButton1 setTitle:@"Take Pic" forState:UIControlStateNormal];
    [_takePhotoButton1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _takePhotoButton1.backgroundColor = [UIColor lightGrayColor];
    _takePhotoButton1.layer.cornerRadius = 4.0f;
    _takePhotoButton1.layer.borderColor = [UIColor blackColor].CGColor;
    _takePhotoButton1.layer.borderWidth = 1.0f;
    [_scrollView addSubview:_takePhotoButton1];
    
    _selectPhotoButton1 = [[UIButton alloc] init];
    [_selectPhotoButton1 addTarget:self action:@selector(selectPhoto1) forControlEvents:UIControlEventTouchUpInside];
    _selectPhotoButton1.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:FONT_SIZE];
    [_selectPhotoButton1 setTitle:@"Existing Pic" forState:UIControlStateNormal];
    [_selectPhotoButton1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _selectPhotoButton1.backgroundColor = [UIColor lightGrayColor];
    _selectPhotoButton1.layer.cornerRadius = 4.0f;
    _selectPhotoButton1.layer.borderColor = [UIColor blackColor].CGColor;
    _selectPhotoButton1.layer.borderWidth = 1.0f;
    [_scrollView addSubview:_selectPhotoButton1];
    
    _takePhotoButton2 = [[UIButton alloc] init];
    [_takePhotoButton2 addTarget:self action:@selector(takePhoto2) forControlEvents:UIControlEventTouchUpInside];
    _takePhotoButton2.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:FONT_SIZE];
    [_takePhotoButton2 setTitle:@"Take Pic" forState:UIControlStateNormal];
    [_takePhotoButton2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _takePhotoButton2.backgroundColor = [UIColor lightGrayColor];
    _takePhotoButton2.layer.cornerRadius = 4.0f;
    _takePhotoButton2.layer.borderColor = [UIColor blackColor].CGColor;
    _takePhotoButton2.layer.borderWidth = 1.0f;
    _takePhotoButton2.hidden = !_numParentsSwitch.on;
    [_scrollView addSubview:_takePhotoButton2];
    
    _selectPhotoButton2 = [[UIButton alloc] init];
    [_selectPhotoButton2 addTarget:self action:@selector(selectPhoto2) forControlEvents:UIControlEventTouchUpInside];
    _selectPhotoButton2.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:FONT_SIZE];
    [_selectPhotoButton2 setTitle:@"Existing Pic" forState:UIControlStateNormal];
    [_selectPhotoButton2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _selectPhotoButton2.backgroundColor = [UIColor lightGrayColor];
    _selectPhotoButton2.layer.cornerRadius = 4.0f;
    _selectPhotoButton2.layer.borderColor = [UIColor blackColor].CGColor;
    _selectPhotoButton2.layer.borderWidth = 1.0f;
    _selectPhotoButton2.hidden = !_numParentsSwitch.on;
    [_scrollView addSubview:_selectPhotoButton2];
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        _takePhotoButton1.userInteractionEnabled = NO;
        [_takePhotoButton1 setTitle:@"No Camera" forState:UIControlStateNormal];
        [_takePhotoButton1 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _takePhotoButton1.layer.borderColor = [UIColor grayColor].CGColor;
        
        _takePhotoButton2.userInteractionEnabled = NO;
        [_takePhotoButton2 setTitle:@"No Camera" forState:UIControlStateNormal];
        [_takePhotoButton2 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _takePhotoButton2.layer.borderColor = [UIColor grayColor].CGColor;
    }
}

- (void)layoutSubviews {
    
    CGFloat nextY;
    
    CGSize musicLabel = [_musicOffLabel sizeThatFits:CGSizeZero];
    _musicOffLabel.frame = CGRectMake(MARGIN_LEFT, MARGIN_TOP, musicLabel.width, musicLabel.height);
    
    CGSize buttonSize = [_musicSwitch sizeThatFits:CGSizeZero];
    _musicSwitch.frame = CGRectMake(CGRectGetMaxX(_musicOffLabel.frame) + BUTTON_INTERNAL_MARGIN, MARGIN_TOP, buttonSize.width, buttonSize.height);
    
    musicLabel = [_musicOnLabel sizeThatFits:CGSizeZero];
    _musicOnLabel.frame = CGRectMake(CGRectGetMaxX(_musicSwitch.frame) + BUTTON_INTERNAL_MARGIN, MARGIN_TOP, musicLabel.width, musicLabel.height);
    
    nextY = CGRectGetMaxY(_musicSwitch.frame);

    CGSize parentLabelSize = [_oneParentLabel sizeThatFits:CGSizeZero];
    _oneParentLabel.frame = CGRectMake(MARGIN_LEFT, nextY + BUTTON_MARGIN_VERTICAL, parentLabelSize.width, parentLabelSize.height);
    
    buttonSize = [_numParentsSwitch sizeThatFits:CGSizeZero];
    _numParentsSwitch.frame = CGRectMake(CGRectGetMaxX(_oneParentLabel.frame) + BUTTON_INTERNAL_MARGIN, nextY + BUTTON_MARGIN_VERTICAL, buttonSize.width, buttonSize.height);
    
    parentLabelSize = [_twoParentsLabel sizeThatFits:CGSizeZero];
    _twoParentsLabel.frame = CGRectMake(CGRectGetMaxX(_numParentsSwitch.frame) + BUTTON_INTERNAL_MARGIN, nextY + BUTTON_MARGIN_VERTICAL, parentLabelSize.width, parentLabelSize.height);
    
    CGFloat buttonWidth = [_recordButton1 sizeThatFits:CGSizeZero].width + BUTTON_INTERNAL_MARGIN;
    _recordButton1.frame = CGRectMake(MARGIN_LEFT, CGRectGetMaxY(_numParentsSwitch.frame) + BUTTON_MARGIN_VERTICAL, buttonWidth, BUTTON_HEIGHT);
    
    buttonWidth = [_playButton1 sizeThatFits:CGSizeZero].width + BUTTON_INTERNAL_MARGIN;
    _playButton1.frame = CGRectMake(CGRectGetMaxX(_recordButton1.frame) + MARGIN_LEFT, _recordButton1.frame.origin.y, buttonWidth, BUTTON_HEIGHT);
    
    UIButton *buttonToFollow = _playButton1;
    
    if (!_recordButton2.hidden) {
        buttonWidth = [_recordButton2 sizeThatFits:CGSizeZero].width + BUTTON_INTERNAL_MARGIN;
        _recordButton2.frame = CGRectMake(MARGIN_LEFT, CGRectGetMaxY(_recordButton1.frame) + BUTTON_MARGIN_VERTICAL, buttonWidth, BUTTON_HEIGHT);

        buttonWidth = [_recordButton3 sizeThatFits:CGSizeZero].width + BUTTON_INTERNAL_MARGIN;
        _recordButton3.frame = CGRectMake(MARGIN_LEFT, CGRectGetMaxY(_recordButton2.frame) + BUTTON_MARGIN_VERTICAL, buttonWidth, BUTTON_HEIGHT);

        buttonWidth = [_recordButton4 sizeThatFits:CGSizeZero].width + BUTTON_INTERNAL_MARGIN;
        _recordButton4.frame = CGRectMake(MARGIN_LEFT, CGRectGetMaxY(_recordButton3.frame) + BUTTON_MARGIN_VERTICAL, buttonWidth, BUTTON_HEIGHT);

        buttonWidth = [_playButton2 sizeThatFits:CGSizeZero].width + BUTTON_INTERNAL_MARGIN;
        _playButton2.frame = CGRectMake(CGRectGetMaxX(_recordButton2.frame) + BUTTON_INTERNAL_MARGIN, _recordButton2.frame.origin.y, buttonWidth, BUTTON_HEIGHT);

        buttonWidth = [_playButton3 sizeThatFits:CGSizeZero].width + BUTTON_INTERNAL_MARGIN;
        _playButton3.frame = CGRectMake(CGRectGetMaxX(_recordButton3.frame) + BUTTON_INTERNAL_MARGIN, _recordButton3.frame.origin.y, buttonWidth, BUTTON_HEIGHT);

        buttonWidth = [_playButton4 sizeThatFits:CGSizeZero].width + BUTTON_INTERNAL_MARGIN;
        _playButton4.frame = CGRectMake(CGRectGetMaxX(_recordButton4.frame) + BUTTON_INTERNAL_MARGIN, _recordButton4.frame.origin.y, buttonWidth, BUTTON_HEIGHT);
        
        buttonToFollow = _recordButton4;
    }
    
    _user1image.frame = CGRectMake(MARGIN_LEFT, CGRectGetMaxY(buttonToFollow.frame) + BUTTON_MARGIN_VERTICAL, FACE_WIDTH, FACE_HEIGHT);

    _user2image.frame = CGRectMake(MARGIN_LEFT, CGRectGetMaxY(_user1image.frame) + BUTTON_MARGIN_VERTICAL, FACE_WIDTH, FACE_HEIGHT);

    buttonWidth = [_takePhotoButton1 sizeThatFits:CGSizeZero].width + BUTTON_INTERNAL_MARGIN;
    _takePhotoButton1.frame =  CGRectMake(CGRectGetMaxX(_user1image.frame) + MARGIN_LEFT, CGRectGetMinY(_user1image.frame), buttonWidth, BUTTON_HEIGHT);
    
    buttonWidth = [_selectPhotoButton1 sizeThatFits:CGSizeZero].width + BUTTON_INTERNAL_MARGIN;
    _selectPhotoButton1.frame = CGRectMake(CGRectGetMaxX(_takePhotoButton1.frame) + MARGIN_LEFT, CGRectGetMinY(_user1image.frame), buttonWidth, BUTTON_HEIGHT);

    buttonWidth = [_takePhotoButton2 sizeThatFits:CGSizeZero].width + BUTTON_INTERNAL_MARGIN;
    _takePhotoButton2.frame = CGRectMake(CGRectGetMaxX(_user2image.frame) + MARGIN_LEFT, CGRectGetMinY(_user2image.frame), buttonWidth, BUTTON_HEIGHT);
    
    buttonWidth = [_selectPhotoButton2 sizeThatFits:CGSizeZero].width + BUTTON_INTERNAL_MARGIN;
    _selectPhotoButton2.frame = CGRectMake(CGRectGetMaxX(_takePhotoButton2.frame) + MARGIN_LEFT, CGRectGetMinY(_user2image.frame), buttonWidth, BUTTON_HEIGHT);
    
    _scrollView.frame = self.bounds;
    CGFloat bottom = (_user2image.hidden ? CGRectGetMaxY(_user1image.frame) : CGRectGetMaxY(_user2image.frame));
    _scrollView.contentSize = CGSizeMake(self.bounds.size.width, bottom + MARGIN_TOP);
}

- (void)numParentsTouched:(UISwitch *)theSwitch {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:theSwitch.on forKey:@"is2parents"];
    [userDefaults synchronize];

    BOOL isOn = theSwitch.on;
    _user2image.hidden = !isOn;
    _takePhotoButton2.hidden = !isOn;
    _selectPhotoButton2.hidden = !isOn;
    _recordButton3.hidden = !isOn;
    _recordButton4.hidden = !isOn;
    _playButton2.hidden = !isOn;
    _playButton3.hidden = !isOn;
    _playButton4.hidden = !isOn;
    [self setNeedsLayout];
}

- (void)enableBackgroundMusicTouched:(UISwitch *)theSwitch {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:theSwitch.on forKey:@"backgroundMusicOn"];
    [userDefaults synchronize];    
}

- (void)recordClicked:(UIButton *)recordButton {
    
    if (recordButton == _recordButton1) {
        _currentSound = 1;
        _recordButton2.enabled = NO;
        _recordButton3.enabled = NO;
        _recordButton4.enabled = NO;
        _audioFilePath = [NSString stringWithFormat:@"%@/audio1.caf", DOCUMENTS_FOLDER];
    } else if (recordButton == _recordButton2) {
        _currentSound = 2;
        _recordButton1.enabled = NO;
        _recordButton3.enabled = NO;
        _recordButton4.enabled = NO;
        _audioFilePath = [NSString stringWithFormat:@"%@/audio2.caf", DOCUMENTS_FOLDER];
    } else if (recordButton == _recordButton3) {
        _currentSound = 3;
        _recordButton1.enabled = NO;
        _recordButton2.enabled = NO;
        _recordButton4.enabled = NO;
        _audioFilePath = [NSString stringWithFormat:@"%@/audio3.caf", DOCUMENTS_FOLDER];
    } else if (recordButton == _recordButton4) {
        _currentSound = 4;
        _recordButton1.enabled = NO;
        _recordButton2.enabled = NO;
        _recordButton3.enabled = NO;
        _audioFilePath = [NSString stringWithFormat:@"%@/audio4.caf", DOCUMENTS_FOLDER];
    }

    _playButton1.enabled = NO;
    _playButton2.enabled = NO;
    _playButton3.enabled = NO;
    _playButton4.enabled = NO;

    [recordButton setTitle:@"Stop" forState:UIControlStateNormal];
    [recordButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [recordButton removeTarget:self action:@selector(recordClicked:) forControlEvents:UIControlEventTouchUpInside];
    [recordButton addTarget:self action:@selector(stopRecording) forControlEvents:UIControlEventTouchUpInside];

    AVAudioSession *audioSession = [AVAudioSession sharedInstance];

    NSURL *url = [NSURL fileURLWithPath:_audioFilePath];
    NSError *err = nil;
    
    _recorder = [[AVAudioRecorder alloc] initWithURL:url settings:_recordSetting error:&err];
    
    if (!_recorder) {
        NSLog(@"recorder: %@ %ld %@", [err domain], (long)[err code], [[err userInfo] description]);
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle: @"Warning"
                                   message: [err localizedDescription]
                                  delegate: nil
                         cancelButtonTitle:@"OK"
                         otherButtonTitles:nil];
        [alert show];
        return;
    }

    [_recorder prepareToRecord];

    if (!audioSession.inputAvailable) {
        UIAlertView *cantRecordAlert =
        [[UIAlertView alloc] initWithTitle: @"Warning"
                                   message: @"Audio input hardware not available"
                                  delegate: nil
                         cancelButtonTitle:@"OK"
                         otherButtonTitles:nil];
        [cantRecordAlert show];
        return;
    }

    // start recording
    [_recorder recordForDuration:(NSTimeInterval)10];

}

- (void)stopRecording {
    [_recorder stop];
    
    UIButton *recordButton;
    
    switch (_currentSound) {
        case 1: {
            recordButton = _recordButton1;
            break;
        }
        case 2: {
            recordButton = _recordButton2;
            break;
        }
        case 3: {
            recordButton = _recordButton3;
            break;
        }
        case 4: {
            recordButton = _recordButton4;
        }
        default:
            break;
    }

    [recordButton setTitle:@"Record" forState:UIControlStateNormal];
    [recordButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [recordButton removeTarget:self action:@selector(stopRecording) forControlEvents:UIControlEventTouchUpInside];
    [recordButton addTarget:self action:@selector(recordClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    NSURL *url = [NSURL fileURLWithPath:_audioFilePath];
    NSError *err = nil;
    NSData *audioData = [NSData dataWithContentsOfFile:[url path] options:0 error:&err];
    
    if(!audioData) {
        NSLog(@"audio data: %@ %ld %@", [err domain], (long)[err code], [[err userInfo] description]);
        return;
    }
    
    _playButton1.enabled = [_fileManager fileExistsAtPath:[NSString stringWithFormat:@"%@/audio1.caf", DOCUMENTS_FOLDER]];
    _playButton2.enabled = [_fileManager fileExistsAtPath:[NSString stringWithFormat:@"%@/audio2.caf", DOCUMENTS_FOLDER]];
    _playButton3.enabled = [_fileManager fileExistsAtPath:[NSString stringWithFormat:@"%@/audio3.caf", DOCUMENTS_FOLDER]];
    _playButton4.enabled = [_fileManager fileExistsAtPath:[NSString stringWithFormat:@"%@/audio4.caf", DOCUMENTS_FOLDER]];
    
}

- (void)playClicked:(UIButton *)playButton {
    _recordButton1.enabled = NO;
    _recordButton2.enabled = NO;
    _recordButton3.enabled = NO;
    _recordButton4.enabled = NO;
    
    if (playButton == _playButton1) {
        _audioFilePath = [NSString stringWithFormat:@"%@/audio1.caf", DOCUMENTS_FOLDER];
    } else if (playButton == _playButton2) {
        _audioFilePath = [NSString stringWithFormat:@"%@/audio2.caf", DOCUMENTS_FOLDER];
    } else if (playButton == _playButton3) {
        _audioFilePath = [NSString stringWithFormat:@"%@/audio3.caf", DOCUMENTS_FOLDER];
    } else if (playButton == _playButton4) {
        _audioFilePath = [NSString stringWithFormat:@"%@/audio4.caf", DOCUMENTS_FOLDER];
    }
    
    [playButton setTitle:@"Stop" forState:UIControlStateNormal];
    [playButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [playButton removeTarget:self action:@selector(playClicked:) forControlEvents:UIControlEventTouchUpInside];
    [playButton addTarget:self action:@selector(stopPlaying) forControlEvents:UIControlEventTouchUpInside];

    // Init audio with playback capability
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    NSURL *url = [NSURL fileURLWithPath:_audioFilePath];
    NSError *error;
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    _player.delegate = self;
    _player.numberOfLoops = 0;

    [_player play];
}

- (void)stopPlaying {
    [_player stop];
    _player.currentTime = 0.0f;

    [_playButton1 setTitle:@"Play" forState:UIControlStateNormal];
    [_playButton1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_playButton1 removeTarget:self action:@selector(stopPlaying) forControlEvents:UIControlEventTouchUpInside];
    [_playButton1 addTarget:self action:@selector(playClicked:) forControlEvents:UIControlEventTouchUpInside];

    [_playButton2 setTitle:@"Play" forState:UIControlStateNormal];
    [_playButton2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_playButton2 removeTarget:self action:@selector(stopPlaying) forControlEvents:UIControlEventTouchUpInside];
    [_playButton2 addTarget:self action:@selector(playClicked:) forControlEvents:UIControlEventTouchUpInside];

    [_playButton3 setTitle:@"Play" forState:UIControlStateNormal];
    [_playButton3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_playButton3 removeTarget:self action:@selector(stopPlaying) forControlEvents:UIControlEventTouchUpInside];
    [_playButton3 addTarget:self action:@selector(playClicked:) forControlEvents:UIControlEventTouchUpInside];

    [_playButton4 setTitle:@"Play" forState:UIControlStateNormal];
    [_playButton4 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_playButton4 removeTarget:self action:@selector(stopPlaying) forControlEvents:UIControlEventTouchUpInside];
    [_playButton4 addTarget:self action:@selector(playClicked:) forControlEvents:UIControlEventTouchUpInside];

    _recordButton1.enabled = YES;
    _recordButton2.enabled = YES;
    _recordButton3.enabled = YES;
    _recordButton4.enabled = YES;
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    [self stopPlaying];
}

- (void)takePhoto1 {
    _currentImage = _user1image;
    _currentImageNum = 1;
    
    if ([_settingsViewDelegate respondsToSelector:@selector(requestTakePhoto)]) {
        [_settingsViewDelegate requestTakePhoto];
    }
}

- (void)takePhoto2 {
    _currentImage = _user2image;
    _currentImageNum = 2;
    
    if ([_settingsViewDelegate respondsToSelector:@selector(requestTakePhoto)]) {
        [_settingsViewDelegate requestTakePhoto];
    }
}


- (void)selectPhoto1 {
    _currentImage = _user1image;
    _currentImageNum = 1;
    
    if ([_settingsViewDelegate respondsToSelector:@selector(requestSelectPhoto)]) {
        [_settingsViewDelegate requestSelectPhoto];
    }
}

- (void)selectPhoto2 {
    _currentImage = _user2image;
    _currentImageNum = 2;
    
    if ([_settingsViewDelegate respondsToSelector:@selector(requestSelectPhoto)]) {
        [_settingsViewDelegate requestSelectPhoto];
    }
}

@end
