//
//  DLMotion.h
//  AskView
//
//  Created by XueYulun on 15/4/16.
//  Copyright (c) 2015年 DL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>
#import <UIKit/UIKit.h>

#define MO_degreesToRadian(x) (M_PI * (x) / 180.0)
#define MO_AffineTransformChanged @"AffineTransFormChangedNotificationKey"

//! @abstract Did update Oriention
typedef void (^UpdateOriention)(CGFloat DEGREE);

@interface DLMotion : NSObject {
    
    UIInterfaceOrientation orientation;
    UIInterfaceOrientation currentOriention;
    UIInterfaceOrientation tempOrientation;
}

//! @abstract Motion shareInstance
+ (instancetype)DefulatMotion;

//! @abstract motionManager
@property (nonatomic, strong) CMMotionManager * motionManager;

//! @abstract OperationQueue
@property (nonatomic, strong) NSOperationQueue * operationQueue;

//! @abstract DeviceOrientation
@property (nonatomic, assign) UIDeviceOrientation newDeviceOrientation;

//! @abstract newInterFaceOriention
@property (nonatomic, assign) UIInterfaceOrientation newInterfaceOrientation;

//! @abstract updateSuccess
@property (nonatomic, assign) BOOL updateSuccess;

//! @abstract affineTransform
@property (nonatomic, assign) CGAffineTransform affineTransform;

//! @abstract Degrees
@property (nonatomic, assign) CGFloat degrees;

//! @abstract Device motion Manager
@property (nonatomic, strong) CMMotionManager * mMotionManager;

- (void)UpdateDeviceMotion: (UpdateOriention)updateBlock;

/**
 *  Begin update Motion Data
 */
- (void)beginMotion;

/**
 *  End
 */
- (void)EndMotion;

@end
