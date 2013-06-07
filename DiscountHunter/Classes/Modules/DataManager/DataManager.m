//
//  DataManager.m
//  DiscountHunter
//
//  Created by iMac HS on 07-06-13.
//  Copyright (c) 2013 Happyshop. All rights reserved.
//

#import "DataManager.h"
#import "Definitions.h"

@implementation DataManager 

static DataManager *_instance;

+ (DataManager *)currentData{
    
  	@synchronized(self) {
		
        if (_instance == nil) {
			
            _instance = [[self alloc] init];
            
        }
    }
    
    return _instance;
    
}

- (id)init{
    self = [super init];
    if (self) {
        
        [Parse setApplicationId:app_id
                      clientKey:client_key];
        
        PFUser *currentUser = [PFUser currentUser];

        if (!currentUser) {
            // Dummy username and password
            PFUser *user = [PFUser user];
            user.username = @"Test";
            user.password = @"Test";
            user.email = @"test@hs.com";
            
            [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (error) {
                    // Assume the error is because the user already existed.
                    [PFUser logInWithUsername:@"Test" password:@"password"];
                }
            }];
        }
        
        PFGeoPoint *userGeoPoint = [PFGeoPoint geoPointWithLatitude:37.856965
                                                          longitude:-122.483826];
        
        
        /*
        PFQuery *query = [PFQuery new];
        
        [query getObjectInBackgroundWithId:@"Discount" block:^(PFObject *object, NSError *error) {
            
        }];
        */
        PFQuery *query = [PFQuery queryWithClassName:@"Discount"];
        
        [query whereKey:@"location" nearGeoPoint:userGeoPoint withinMiles:10.0];
        
        NSArray *placeObjects = [query findObjects];
        
        PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
        [testObject setObject:@"bar" forKey:@"foo"];
        
        [testObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                // The gameScore saved successfully.
            } else {
                // There was an error saving the gameScore.
            }
        }];
         
    }
    return self;
}


@end
