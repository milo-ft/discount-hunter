//
//  LocationManager.h
//  HappyShop
//
//  Created by Emilio Figueroa Torres on 17-08-11.
//  Copyright 2011 none. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


#define minUpdateTimerInterval 10.0f
#define maxUpdateTimerInterval 60.0f

typedef enum{
    Valid = 1,
    ValidFirstLocation,
    ValidBestAccuracy,
    NotValidNearPrev,
    NotValidOverPrevAccuracy,
    NotValidOverAccuracyThreshold,
}typeLocationUpdate;

@interface LocationManager : NSObject <CLLocationManagerDelegate>{
    NSInteger countUpdates;
    BOOL updatingLocation;
    
}

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *currentLocation;
@property (nonatomic, strong) CLLocation *prevLocation;
@property (nonatomic, strong) NSTimer *updateTimer;
@property (nonatomic, assign) BOOL locationValid;

+ (LocationManager *)currentLocationManager;

- (void)startUpdatingLocation;
- (void)stopUpdatingLocation;

- (long long)getBlockId;
- (void)getBlockCenter;
- (typeLocationUpdate)locationIsValid:(CLLocation*)locationToValid
                         withDistance:(CLLocationDistance)distance;
- (void)checkShouldUpdate;
- (BOOL)checkShouldUpdateMinTime;
- (void)updatePrevLocation;
- (void)resetPrevLocation;

@end
