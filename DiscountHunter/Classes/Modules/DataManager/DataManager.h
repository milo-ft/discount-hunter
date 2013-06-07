//
//  DataManager.h
//  DiscountHunter
//
//  Created by iMac HS on 07-06-13.
//  Copyright (c) 2013 Happyshop. All rights reserved.
//

#import <Foundation/Foundation.h>
 #import <Parse/Parse.h> 

@interface DataManager : NSObject

+ (DataManager *)currentData;

@property (strong, nonatomic) FBSession *session;

@end
