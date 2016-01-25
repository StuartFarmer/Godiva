//
//  GodivaProductManager.h
//  Godiva
//
//  Created by Stuart Farmer on 1/24/16.
//  Copyright © 2016 app.kitchen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>
#import <AFNetworking/AFNetworking.h>
#import "Product.h"

@interface GodivaProductManager : NSObject

@property NSString *context;
@property BOOL isUpdating;

+(GodivaProductManager *)sharedInstance;

-(void)update;

@end
