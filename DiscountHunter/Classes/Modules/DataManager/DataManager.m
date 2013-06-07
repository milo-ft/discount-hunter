//
//  DataManager.m
//  DiscountHunter
//
//  Created by iMac HS on 07-06-13.
//  Copyright (c) 2013 Happyshop. All rights reserved.
//

#import "DataManager.h"

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
