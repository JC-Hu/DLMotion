# DLMotion
DLMotion, CoreMotion For your iphone oriention and degrees

---

####DLMotion

Add CoreMotion.Framework

`#import <CoreMotion/CoreMotion.h>`

Properties: 

```objective-c

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

```

Methods: 


```objective-c

- (void)UpdateDeviceMotion: (UpdateOriention)updateBlock;

/**
*  Begin update Motion Data
*/
- (void)beginMotion;

/**
*  End
*/
- (void)EndMotion;
```

For use:

```objective-c

    [[DLMotion DefulatMotion] UpdateDeviceMotion:^(CGFloat DEGREE) {
       
        
        [UIView animateWithDuration:.2 animations:^{
            
            _flashButton.transform = CGAffineTransformIdentity;
            _flashButton.transform = CGAffineTransformRotate(_flashButton.transform, DEGREE);
        }];
    }];
    
```

Or:

```objective-c
Add Notification and Call "[[DLMotion DefulatMotion] beginMotion];"
```