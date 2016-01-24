//
//  GodivaProductManager.m
//  Godiva
//
//  Created by Stuart Farmer on 1/24/16.
//  Copyright © 2016 app.kitchen. All rights reserved.
//

#import "GodivaProductManager.h"

#define PRODUCT_CEILING 300
#define PRODUCT_FLOOR 100

@implementation GodivaProductManager {
    NSUserDefaults *userDefaults;
    RLMRealm *realm;
    RLMResults<Product *> *products;
}

+(GodivaProductManager *)sharedInstance {
    static GodivaProductManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(void)update {
    // set the context to the current product type
    userDefaults = [NSUserDefaults standardUserDefaults];
    realm = [RLMRealm defaultRealm];
    
    self.context = [userDefaults stringForKey:@"selectedObject"];
    
    // check if there are enough products in the current context
    if (!self.isUpdating) {
        self.isUpdating = true;
        products = [Product allObjects];
        
        // if not, update
        if (products.count < PRODUCT_FLOOR) {
            // query for more objects
        }
    }
}

@end
