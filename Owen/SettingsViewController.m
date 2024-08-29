//
//  SettingsViewController.m
//  Owen
//
//  Created by Max Barry on 6/5/16.
//  Copyright © 2016 Max Barry. All rights reserved.
//

#import <CoreImage/CoreImage.h>
#import <ImageIO/ImageIO.h>
#import "SettingsViewController.h"

@interface SettingsViewController ()

@property (nonatomic, strong) IBOutlet  SettingsView      *settingsView;

@end

@implementation SettingsViewController

- (id)init {
    self = [super init];
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSettingsViewController];
}

- (void)viewWillAppear:(BOOL)animated {
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate turnBackgroundMusicOn:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    if ([GlobalUtils isBackgroundMusicEnabled]) {
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [delegate turnBackgroundMusicOn:YES];
    }
}

- (void)initSettingsViewController {
    
    UIImage *pic = [GlobalUtils getPortraitImageFor:1];
    if (pic) {
        _settingsView.user1image.image = pic;
    }

    pic = [GlobalUtils getPortraitImageFor:2];
    if (pic) {
        _settingsView.user2image.image = pic;
    }
    
    _settingsView.settingsViewDelegate = self;
    [_settingsView setNeedsLayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)requestTakePhoto {
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

- (void)requestSelectPhoto {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    _settingsView.currentImage.image = chosenImage;
    
    CGPoint mouthPoint = [self detectMouthIn:chosenImage];
    
    // save image to disk
    NSString *imageName = [NSString stringWithFormat:@"image%lu.png", (unsigned long)_settingsView.currentImageNum];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,  NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    NSString *dataPath = [documentsDirectoryPath  stringByAppendingPathComponent:imageName];
    NSData *settingsData = UIImagePNGRepresentation(chosenImage);
    
    [settingsData writeToFile:dataPath atomically:YES];
    
    // save path to image in settings
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:dataPath forKey:[NSString stringWithFormat:@"file%lu", (unsigned long)_settingsView.currentImageNum]];
    [userDefaults setObject:NSStringFromCGPoint(mouthPoint) forKey:[NSString stringWithFormat:@"mouthPoint%lu", (unsigned long)_settingsView.currentImageNum]];
    [userDefaults synchronize];
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (CGPoint)detectMouthIn:(UIImage *)inputImage {
    
    CGPoint mouthPos = CGPointZero;

    CIDetector* detector = [CIDetector detectorOfType:CIDetectorTypeFace
        context:nil options:[NSDictionary dictionaryWithObject:CIDetectorAccuracyHigh forKey:CIDetectorAccuracy]];
    
    CIImage *ciImage = [CIImage imageWithCGImage:inputImage.CGImage];
    
    NSDictionary* imageOptions = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:inputImage.imageOrientation] forKey:CIDetectorImageOrientation];
    NSArray *features = [detector featuresInImage:ciImage options:imageOptions];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:inputImage];
    CGAffineTransform transform = CGAffineTransformMakeScale(1, -1);
    transform = CGAffineTransformTranslate(transform, 0.0f, -imageView.bounds.size.height);

    NSMutableArray *faces = [[NSMutableArray alloc] init];
    for (CIFaceFeature* faceFeature in features)
    {
        if (faceFeature.hasMouthPosition) {
            [faces addObject:faceFeature];
        }
    }
    if ([faces count] > 1) {
        CIFaceFeature *bestFace = (CIFaceFeature*)faces[0];
        for (CIFaceFeature *face in faces) {
            if (ABS(face.faceAngle) < ABS(bestFace.faceAngle)) {
                bestFace = face;
            }
        }
        mouthPos = CGPointApplyAffineTransform(bestFace.mouthPosition, transform);
    } else if ([faces count] == 1) {
        mouthPos = CGPointApplyAffineTransform(((CIFaceFeature*)faces[0]).mouthPosition, transform);
    }
        
    return mouthPos;
}

@end
