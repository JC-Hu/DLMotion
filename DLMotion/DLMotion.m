//
//  DLMotion.m
//  AskView
//
//  Created by XueYulun on 15/4/16.
//  Copyright (c) 2015年 DL. All rights reserved.
//

#import "DLMotion.h"
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

static DLMotion * motion;
@implementation DLMotion

+ (instancetype)DefulatMotion {
    
    @synchronized(self)
    {
        if (!motion) {
            
            motion = [[DLMotion alloc] init];
            [motion initilizedMotion];
        }
        return motion;
    }
}

- (void)UpdateDeviceMotion:(UpdateOriention)updateBlock {
    
    _mMotionManager = [[CMMotionManager alloc] init];
    if (_mMotionManager.deviceMotionAvailable) {
        _mMotionManager.deviceMotionUpdateInterval = 0.01f;
        [_mMotionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMDeviceMotion *data, NSError *error) {
            
            CGFloat x_d = data.gravity.x;
            CGFloat y_d = data.gravity.y;
            CGFloat angle = atan2(y_d, x_d);
            
            NSString * orientationString = @"";
            
            if(angle >= -2.25 && angle <= -0.75) {
                
                orientationString = @"MotionOrientation - Portrait";
                tempOrientation = UIInterfaceOrientationPortrait;
            }
            else if(angle >= -0.5 && angle <= 0.5) {
                
                orientationString = @"MotionOrientation - Left";
                tempOrientation = UIInterfaceOrientationLandscapeLeft;
            }
            else if(angle >= 1.0 && angle <= 2.0) {
                
                orientationString = @"MotionOrientation - UpsideDown";
                tempOrientation = UIInterfaceOrientationPortraitUpsideDown;
            }
            else if(angle <= -2.5 || angle >= 2.5) {
                
                orientationString = @"MotionOrientation - Right";
                tempOrientation = UIInterfaceOrientationLandscapeRight;
            }
            
            if (currentOriention != tempOrientation) {
                currentOriention = tempOrientation;
                
                if (tempOrientation == UIInterfaceOrientationLandscapeRight) {
                    
                    updateBlock(-M_PI_2);
                }
                
                if (tempOrientation == UIInterfaceOrientationPortrait) {
                    
                    updateBlock(0);
                }
                
                if (tempOrientation == UIInterfaceOrientationLandscapeLeft) {
                    
                    updateBlock(M_PI_2);
                }
                
                if (tempOrientation == UIInterfaceOrientationPortraitUpsideDown) {
                    
                    updateBlock(M_PI);
                }
            }
        }];
    }
}

- (void)beginMotion {
    
    NSLog(@"Begin Motion Updates!");
    
    if ( ![self.motionManager isAccelerometerAvailable] ) {
        _updateSuccess = NO;
        return;
    }
    [self.motionManager startAccelerometerUpdatesToQueue:self.operationQueue withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
        [self accelerometerUpdateWithData:accelerometerData error:error];
    }];
}

- (void)EndMotion {
    
    NSLog(@"End Motion Updates!");
    
    [_motionManager stopAccelerometerUpdates];
    orientation = UIInterfaceOrientationPortrait;
}

- (void)initilizedMotion {
    
    self.operationQueue = [[NSOperationQueue alloc] init];
    
    self.motionManager = [[CMMotionManager alloc] init];
    self.motionManager.accelerometerUpdateInterval = 0.03;
}

- (void)accelerometerUpdateWithData:(CMAccelerometerData *)accelerometerData error:(NSError *)error {
    
    CMAcceleration acceleration = accelerometerData.acceleration;
    
    CGFloat x_d = acceleration.x;
    CGFloat y_d = acceleration.y;
    CGFloat angle = atan2(y_d, x_d);
    
    _degrees = atan2(x_d, y_d) - M_PI;
    
    NSString * orientationString = @"";
    
    if(angle >= -2.25 && angle <= -0.75) {
        
        _newInterfaceOrientation = UIInterfaceOrientationPortrait;
        _newDeviceOrientation = UIDeviceOrientationPortrait;
        orientationString = @"MotionOrientation - Portrait";
    }
    else if(angle >= -0.5 && angle <= 0.5) {
        
        _newInterfaceOrientation = UIInterfaceOrientationLandscapeLeft;
        _newDeviceOrientation = UIDeviceOrientationLandscapeLeft;
        orientationString = @"MotionOrientation - Left";
    }
    else if(angle >= 1.0 && angle <= 2.0) {
        
        _newInterfaceOrientation = UIInterfaceOrientationPortraitUpsideDown;
        _newDeviceOrientation = UIDeviceOrientationPortraitUpsideDown;
        orientationString = @"MotionOrientation - UpsideDown";
    }
    else if(angle <= -2.5 || angle >= 2.5) {
        
        _newInterfaceOrientation = UIInterfaceOrientationLandscapeRight;
        _newDeviceOrientation = UIDeviceOrientationLandscapeRight;
        orientationString = @"MotionOrientation - Right";
    }
    
    _updateSuccess = YES;
    
    if (orientation != _newInterfaceOrientation) {
        orientation = _newInterfaceOrientation;
        NSLog(@"%@", orientationString);
        
        [self affineTransform];
        [self POSTNotification];
    }
}

- (CGAffineTransform)affineTransform {
    int rotationDegree = 0;
    
    switch (self.newInterfaceOrientation) {
        case UIInterfaceOrientationPortrait:
            rotationDegree = 0;
            break;
            
        case UIInterfaceOrientationLandscapeLeft:
            rotationDegree = 270;
            break;
            
        case UIInterfaceOrientationPortraitUpsideDown:
            rotationDegree = 180;
            break;
            
        case UIInterfaceOrientationLandscapeRight:
            rotationDegree = 90;
            break;
            
        default:
            break;
    }
    
    return CGAffineTransformMakeRotation(MO_degreesToRadian(rotationDegree));
}

- (void)POSTNotification {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:MO_AffineTransformChanged object:nil];
}

@end
