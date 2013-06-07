//
//  LocationManager.m
//  HappyShop
//
//  Created by Emilio Figueroa Torres on 17-08-11.
//  Copyright 2011 none. All rights reserved.
//
@implementation NSString (LeftPadding)

- (NSString *)stringByPaddingLeftToLength:(NSUInteger)aLength withString:(NSString *)padString {
    NSInteger lengthToPad = aLength - [self length];
    
    if ( lengthToPad > 0 ) {
        NSString * padding = [@"" stringByPaddingToLength:lengthToPad withString:padString startingAtIndex:0];
        NSString * paddedString = [padding stringByAppendingString:self];
        
        return paddedString;
    } else {
        return [self copy];
    }
}

@end


#import "LocationManager.h"
#import "Definitions.h"
//#import "UtilsManager.h"

#define maxTimesUpdates 3

#define gpsUpdateTimerInterval 10.0f

#define firstTimeWait 10.0f

#define firtsTimeMaxThresholdRadius 200.0f

#define minAccuracyThreshold 100.0f
#define minDistanceThreshold 300.0f

#define minTimeThreshold 900.0f

#define lat -33.51772998901453
#define lng -70.59861660003662

static LocationManager *_instance;

@implementation LocationManager 

@synthesize locationManager;
@synthesize currentLocation;
@synthesize prevLocation;
@synthesize updateTimer;
@synthesize locationValid;

- (id)init{
    self = [super init];
    if (self) {
        
        self.locationManager = [CLLocationManager new];
        
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        locationManager.distanceFilter = kCLDistanceFilterNone;
        
        [[self locationManager] setDelegate:self];
        countUpdates = 0;
        
    #if (TARGET_IPHONE_SIMULATOR)
        self.currentLocation = [[CLLocation alloc] initWithLatitude:-33.4062093 longitude:-70.57691424];
    #endif
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(startUpdatingLocation)
                                                     name:UIApplicationDidBecomeActiveNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(stopUpdatingLocation)
                                                     name:UIApplicationWillResignActiveNotification
                                                   object:nil];
        
    }
    return self;
}

+ (LocationManager *)currentLocationManager{
  	@synchronized(self) {
		
        if (_instance == nil) {
			
            _instance = [[self alloc] init];
            
        }
    }
    return _instance;
    
}

- (void)startUpdatingLocation{
    //DLog(@"class %@ %s", [[self class] description],  __FUNCTION__);
    countUpdates = 0;
    self.updateTimer = nil;
    updatingLocation = TRUE;
    [locationManager startUpdatingLocation];
/*
#if (TARGET_IPHONE_SIMULATOR)
    self.currentLocation = [[CLLocation alloc] initWithLatitude:-33.4062093 longitude:-70.57691424];
    [[NSNotificationCenter defaultCenter] postNotificationName:didUpdateLocationObserver object:currentLocation];
    [self stopUpdatingLocation];
    [self getBlockId];
#else
    [locationManager startUpdatingLocation];
#endif
*/
}

- (void)stopUpdatingLocation{
    updatingLocation = FALSE;
    self.updateTimer = nil;
    [locationManager stopUpdatingLocation];
}

- (typeLocationUpdate)locationIsValid:(CLLocation*)locationToValid
                         withDistance:(CLLocationDistance)distance{
    
    typeLocationUpdate returnValue = ValidBestAccuracy;
    
    if (self.currentLocation){
        
        CLLocationAccuracy newLocationAccuracy = [locationToValid horizontalAccuracy];
        CLLocationAccuracy currentLocationAccuracy = [self.currentLocation horizontalAccuracy];

        if (newLocationAccuracy > minAccuracyThreshold){
            
            returnValue = NotValidOverAccuracyThreshold;
            
        }else{
            /*
            UtilsManager *uManager = [UtilsManager new];
            
            CLLocationDistance distance = [uManager getDistanceFromCurrentLocation:self.currentLocation
                                                                        toLocation:locationToValid];
            
            DLog(@"distance %.0f", distance);
             */
            if (distance < minDistanceThreshold){
                
                if (newLocationAccuracy > currentLocationAccuracy)
                    returnValue = NotValidOverPrevAccuracy;
               
                //returnValue = NotValidNearPrev;
                
            }
        }
    }else{
        returnValue = ValidFirstLocation;
    }
    
    if (returnValue == ValidBestAccuracy || returnValue == ValidFirstLocation)
        countUpdates++;
    
    if (countUpdates >= maxTimesUpdates)
        returnValue = Valid;
    
    //DLog(@"newLocation %@ returnValue %i count %i", [locationToValid description], returnValue, countUpdates);

    return returnValue;
    
}

- (void)checkShouldUpdate{
    BOOL shouldUpdate = FALSE;
    if (!prevLocation){
        [self updatePrevLocation];
        shouldUpdate = TRUE;
    }else {
        CLLocationDistance distance = [self.currentLocation distanceFromLocation:self.prevLocation]; 
  
        if (distance > minDistanceThreshold || ([[self.currentLocation timestamp] timeIntervalSinceDate:[self.prevLocation timestamp]] > minTimeThreshold)){
            [self updatePrevLocation];
            shouldUpdate = TRUE;
        }
    }
    /*
    if (shouldUpdate)
        [[NSNotificationCenter defaultCenter] postNotificationName:didUpdateLocationObserver object:self.currentLocation];
*/
}

- (BOOL)checkShouldUpdateMinTime{
    if (!prevLocation)
        return TRUE;
    return ([[self.currentLocation timestamp] timeIntervalSinceDate:[self.prevLocation timestamp]] > minUpdateTimerInterval);
}

- (void)updatePrevLocation{
    self.prevLocation = self.currentLocation;

}

- (void)resetPrevLocation{
    self.prevLocation = nil;
}

- (void)dealloc {
    [locationManager setDelegate:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidBecomeActiveNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationWillResignActiveNotification
                                                  object:nil];
}

#pragma mark - CLLocationManagerDelegate Methods

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error{
    /*
    AlertObject *aObject = [AlertObject new];
    [aObject setAlertTitle:@"Error"];
    [aObject setAlertMaintText:NSLocalizedString(@"LAYER_ERROR_CONNECTION_GPS", nil)];
    [aObject setAlertButtons:[NSArray arrayWithObjects:[NSNumber numberWithInt:typeOkButton], nil]];
    [[NSNotificationCenter defaultCenter] postNotificationName:showAlertNotification object:aObject];
    */
}

- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation{
    
    /*
    DLog(@"oldLocation %@", [oldLocation description]);
    DLog(@"newLocation %@", [newLocation description]);
    DLog(@"self.currentLocation %@", [self.currentLocation description]);
*/
    @synchronized(self) {
        
        if (updatingLocation){
            
            CLLocationDistance distance =  [self.currentLocation distanceFromLocation:newLocation];
            

            typeLocationUpdate locationUpdate = [self locationIsValid:newLocation
                                                         withDistance:distance];
            
            BOOL shouldFireTimer = FALSE;
            
            switch (locationUpdate) {
                case Valid:{
                    self.currentLocation = newLocation;
                    [self checkShouldUpdate];
                    shouldFireTimer = TRUE;
                    locationValid = TRUE;
                }
                    break;
                case ValidBestAccuracy:{
                    self.currentLocation = newLocation;
                    [self checkShouldUpdate];
                    shouldFireTimer = TRUE;
                    locationValid = TRUE;
                }
                    break;
                case NotValidNearPrev:{
                    locationValid = FALSE;

                }
                    break;
                case NotValidOverPrevAccuracy:{
                    locationValid = FALSE;

                }
                    break;
                case NotValidOverAccuracyThreshold:{
                    locationValid = FALSE;

                }
                    break;
                default:
                    break;
            }
            
            if (shouldFireTimer){
                [self stopUpdatingLocation];
                /*
                self.updateTimer = [NSTimer timerWithTimeInterval:gpsUpdateTimerInterval
                                                           target:self
                                                         selector:@selector(startUpdatingLocation)
                                                         userInfo:nil
                                                          repeats:NO];
                 */
                self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:gpsUpdateTimerInterval
                                                                    target:self
                                                                  selector:@selector(startUpdatingLocation)
                                                                  userInfo:nil
                                                                   repeats:NO];
            }
            
            /*
             if (validLocation){
             [[NSNotificationCenter defaultCenter] postNotificationName:didUpdateLocationObserver object:newLocation];
             }
             
             if (!self.currentLocation) {
             self.currentLocation = newLocation;
             [[NSNotificationCenter defaultCenter] postNotificationName:didUpdateLocationObserver object:newLocation];
             
             return;
             }else if (!self.updateTimer){
             
             }
             */
        }
        
    }

}




@end
