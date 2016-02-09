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
#define PRODUCT_CHUNK 20

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
        products = [Product objectsWhere:[NSString stringWithFormat:@"type = '%@'", self.context]];
        
        // if not, update
        if (products.count < PRODUCT_FLOOR) {
            // query for more objects
            dispatch_async(dispatch_get_main_queue(), ^{

            });
        }
    }
}

- (void)getProductFor:(NSString *)type number:(int)amount {
    userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *categoryString;
    
    // determine the ID for the type
    if ([type isEqualToString:[GodivaProductManager idForAccessories]]) categoryString = @"3";
    else if ([type isEqualToString:[GodivaProductManager idForBags]]) categoryString = @"161";
    else if ([type isEqualToString:[GodivaProductManager idForDresses]]) categoryString = @"35";
    else if ([type isEqualToString:[GodivaProductManager idForIntimates]]) categoryString = @"40";
    else if ([type isEqualToString:[GodivaProductManager idForJewelry]]) categoryString = @"58";
    else if ([type isEqualToString:[GodivaProductManager idForOuterwear]]) categoryString = @"79"; // 53
    else if ([type isEqualToString:[GodivaProductManager idForPants]]) categoryString = @"86"; // 25
    else if ([type isEqualToString:[GodivaProductManager idForShoes]]) categoryString = @"170";
    else if ([type isEqualToString:[GodivaProductManager idForSkirtsAndShorts]]) categoryString = @"120"; // 119
    else if ([type isEqualToString:[GodivaProductManager idForSportswear]]) categoryString = @"14";
    else if ([type isEqualToString:[GodivaProductManager idForSweaters]]) categoryString = @"125";
    else if ([type isEqualToString:[GodivaProductManager idForTops]]) categoryString = @"149";
    else categoryString = @"149";
    
    NSLog(@"%@", type);
    NSLog(@"%@", categoryString);
    
    // set up query parameters
    NSDictionary *params = @{@"user_email" : [userDefaults objectForKey:@"email"], @"user_token" : [userDefaults objectForKey:@"authenticationToken"], @"number_records" : [NSString stringWithFormat:@"%i", amount], @"category" : categoryString};
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    // get a response
    [manager GET:@"http://godiva.logiclabs.systems/api/v1/user_products/" parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

#pragma Identifiers for different types of categories
+(NSString *)idForAccessories {
    return @"accessories";
}

+(NSString *)idForBags {
    return @"bags";
}

+(NSString *)idForDresses {
    return @"dresses";
}

+(NSString *)idForIntimates {
    return @"intimates";
}

+(NSString *)idForJewelry {
    return @"jewelry";
}

+(NSString *)idForOuterwear {
    return @"outerwear";
}

+(NSString *)idForPants {
    return @"pants";
}

+(NSString *)idForShoes {
    return @"shoes";
}

+(NSString *)idForSkirtsAndShorts {
    return @"skirts&shorts";
}

+(NSString *)idForSportswear {
    return @"sportswear";
}

+(NSString *)idForSweaters {
    return @"sweaters";
}

+(NSString *)idForTops {
    return @"tops";
}

@end
