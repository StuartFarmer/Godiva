//
//  GodivaProductManager.m
//  Godiva
//
//  Created by Stuart Farmer on 1/24/16.
//  Copyright © 2016 Logic Labs Ltd. All rights reserved.
//

#import "GodivaProductManager.h"
#import "GodivaCategory.h"

NSString * const categoriesURL = @"http://godiva.logiclabs.systems/api/v1/categories";

@implementation GodivaProductManager {
    NSUserDefaults *userDefaults;
    Product *currentProduct;
}

+(GodivaProductManager *)sharedInstance {
    static GodivaProductManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(NSArray *)getCategoriesWithCompletion:(void (^)(BOOL finished))completion {
    NSMutableArray *categories = [[NSMutableArray alloc] init];
    
    // set up query parameters
    NSDictionary *params = @{@"user_email" : [[NSUserDefaults standardUserDefaults] objectForKey:@"email"], @"user_token" : [[NSUserDefaults standardUserDefaults] objectForKey:@"authenticationToken"]};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    dispatch_async(dispatch_queue_create("db", DISPATCH_QUEUE_SERIAL), ^{
        // get a response
        [manager GET:categoriesURL parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSArray *data = responseObject[@"data"];
            NSLog(@"%@", responseObject);
            for (NSDictionary *item in data) {
                GodivaCategory *category = [[GodivaCategory alloc] init];
                category.identifier = [item[@"id"] integerValue];
                category.type = item[@"type"];
                category.name = item[@"attributes"][@"name"];
                category.shopStyleID = item[@"attributes"][@"shopstyle_id"];
                category.shopStyleParentID = item[@"attributes"][@"shopstyle_parent_id"];
                
                if (category.name.class == [NSNull null].class) category.name = @"";
                
                [categories addObject:category];
            }
            completion(true);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@", error);
            completion(false);
        }];
    });
    self.categories = categories;
    return (NSArray *)categories;
}

- (NSArray *)getProductsWithType:(NSString *)type {
    RLMResults<Product *> *products = [Product objectsWhere:[NSString stringWithFormat:@"type = '%@'", type]];
    NSMutableArray *returnArray = [[NSMutableArray alloc] init];
    for (Product *product in products) {
        [returnArray addObject:product];
    }
    return (NSArray *)returnArray;
}

- (Product *)getAnyProductsWithType:(NSString *)type {
    RLMResults<Product *> *products = [Product objectsWhere:[NSString stringWithFormat:@"type = '%@'", type]];
    return [products objectAtIndex:0];
}

- (BOOL)productsExistForContext:(NSString *)type {
    RLMResults<Product *> *products = [Product objectsWhere:[NSString stringWithFormat:@"type = '%@'", type]];
    if (products.count > 0) return true;
    return false;
}

- (NSUInteger)productCountForContext:(NSString *)type {
    RLMResults<Product *> *products = [Product objectsWhere:[NSString stringWithFormat:@"type = '%@'", type]];
    return products.count;
}

- (void)updateForContextType:(NSString *)type; {
    // set the context to the current product type
    userDefaults = [NSUserDefaults standardUserDefaults];
    _realm = [RLMRealm defaultRealm];
    _isUpdating = YES;
    // check if there are enough products in the current context
    _products = [Product objectsWhere:[NSString stringWithFormat:@"type = '%@'", type]];
    if (_products.count <= PRODUCT_FLOOR) {
        NSLog(@"%lu", _products.count);
        // if not, update
        NSLog(@"%i", (int)(PRODUCT_CEILING-_products.count)/PRODUCT_CHUNK);
//        for (int i = 0; i < (int)PRODUCT_CEILING/PRODUCT_CHUNK; i++) {
//            [self getProductFor:type number:PRODUCT_CHUNK for:1];
//        }
        [self getProductFor:type number:PRODUCT_CHUNK for:(int)PRODUCT_CEILING/PRODUCT_CHUNK];
    }
}

- (NSString *)URLParameterStringForArbitraryContextString:(NSString *)context {
    // Returns the URL parameter string that takes a context string and matches it to ShopStyles categories defined as GodivaCategories so that we can make calls with ease and not have to swap things over.
    NSMutableArray *returnArray = [[NSMutableArray alloc] init];
    NSString *returnString = @"";
    for (GodivaCategory *category in self.categories) {
        if ([context isEqualToString:[GodivaProductManager idForAccessories]]) {
            if ([category.name isEqualToString:@"Accessories"]) [returnArray addObject:category];
        }
        else if ([context isEqualToString:[GodivaProductManager idForBags]]) {
            if ([category.name isEqualToString:@"Bags"]) [returnArray addObject:category];
            if ([category.name isEqualToString:@"Backpacks"]) [returnArray addObject:category];
            if ([category.name isEqualToString:@"Clutches"]) [returnArray addObject:category];
            if ([category.name isEqualToString:@"Evening Bags"]) [returnArray addObject:category];
            if ([category.name isEqualToString:@"Hobos"]) [returnArray addObject:category];
            if ([category.name isEqualToString:@"Satchels"]) [returnArray addObject:category];
            if ([category.name isEqualToString:@"Shoulder Bags"]) [returnArray addObject:category];
            if ([category.name isEqualToString:@"Duffels & Totes"]) [returnArray addObject:category];
            if ([category.name isEqualToString:@"Wallets"]) [returnArray addObject:category];
        }
        else if ([context isEqualToString:[GodivaProductManager idForDresses]]) {
            if ([category.name isEqualToString:@"Dresses"]) [returnArray addObject:category];
        }
        else if ([context isEqualToString:[GodivaProductManager idForIntimates]]) {
            if ([category.name isEqualToString:@"Intimates"]) [returnArray addObject:category];
        }
        else if ([context isEqualToString:[GodivaProductManager idForJewelry]]) {
            if ([category.name isEqualToString:@"Jewelry"]) [returnArray addObject:category];
        }
        else if ([context isEqualToString:[GodivaProductManager idForOuterwear]]) {
            if ([category.name isEqualToString:@"Outerwear"]) [returnArray addObject:category];
            if ([category.name isEqualToString:@"Jackets"]) [returnArray addObject:category];
        }
        else if ([context isEqualToString:[GodivaProductManager idForPants]]) {
            if ([category.name isEqualToString:@"Pants"]) [returnArray addObject:category];
            if ([category.name isEqualToString:@"Denim"]) [returnArray addObject:category];
        }
        else if ([context isEqualToString:[GodivaProductManager idForShoes]]) {
            if ([category.name isEqualToString:@"Shoes"]) [returnArray addObject:category];
            if ([category.name isEqualToString:@"Athletic Shoes"]) [returnArray addObject:category];
            if ([category.name isEqualToString:@"Boots"]) [returnArray addObject:category];
            if ([category.name isEqualToString:@"Evening Shoes"]) [returnArray addObject:category];
            if ([category.name isEqualToString:@"Flats"]) [returnArray addObject:category];
            if ([category.name isEqualToString:@"Mules & Clogs"]) [returnArray addObject:category];
            if ([category.name isEqualToString:@"Platforms"]) [returnArray addObject:category];
            if ([category.name isEqualToString:@"Pumps"]) [returnArray addObject:category];
            if ([category.name isEqualToString:@"Sandals"]) [returnArray addObject:category];
            if ([category.name isEqualToString:@"Sneakers"]) [returnArray addObject:category];
            if ([category.name isEqualToString:@"Wedges"]) [returnArray addObject:category];
        }
        else if ([context isEqualToString:[GodivaProductManager idForSkirtsAndShorts]]) {
            if ([category.name isEqualToString:@"Skirts"]) [returnArray addObject:category];
            if ([category.name isEqualToString:@"Shorts"]) [returnArray addObject:category];
        }
        else if ([context isEqualToString:[GodivaProductManager idForSportswear]]) {
            if ([category.name isEqualToString:@"Activewear"]) [returnArray addObject:category];
        }
        else if ([context isEqualToString:[GodivaProductManager idForSweaters]]) {
            if ([category.name isEqualToString:@"Sweaters"]) [returnArray addObject:category];
        }
        else if ([context isEqualToString:[GodivaProductManager idForTops]]) {
            if ([category.name isEqualToString:@"Tops"]) [returnArray addObject:category];
        }
        else {
            
        }
    }
    
    for (GodivaCategory *category in returnArray) {
        if (returnString.length > 0) {
            // add a comma
            returnString = [returnString stringByAppendingString:@","];
        }
        // append string with id
        returnString = [returnString stringByAppendingString:[NSString stringWithFormat:@"%lu", category.identifier]];
    }
    
    NSLog(@"return string for %@ is: %@", context, returnString);
    
    return returnString;
}

- (void)getProductFor:(NSString *)type number:(int)amount for:(int)chunks{
    userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *categoryString = [self URLParameterStringForArbitraryContextString:type];
    NSLog(@"%@", categoryString);
    
    NSLog(@"Get request for %i %@", amount, type);
    
    // set up query parameters
    NSDictionary *params = @{@"user_email" : [userDefaults objectForKey:@"email"], @"user_token" : [userDefaults objectForKey:@"authenticationToken"], @"number_records" : [NSString stringWithFormat:@"%i", amount], @"category" : categoryString, @"max_price" : @"200"};
    
    NSLog(@"GET URL params: %@", params);
    
    if ([Product objectsWhere:[NSString stringWithFormat:@"type = '%@'", type]].count <= PRODUCT_CEILING) {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            // get a response
            [manager GET:@"http://godiva.logiclabs.systems/api/v1/user_products/" parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
                // Put JSON into Product data object and put into Realm
                NSLog(@"JSON: %@", responseObject);
                NSArray *data = responseObject[@"data"];
                for (NSDictionary *item in data) {
                    dispatch_async(dispatch_queue_create("db", DISPATCH_QUEUE_SERIAL), ^{
                        // create an object and fill it with the pulled data
                        Product *product = [[Product alloc] init];
                        product.brandName = item[@"attributes"][@"brand_name"];
                        product.clickURL = item[@"attributes"][@"click_url"];
                        product.image = [NSData dataWithContentsOfURL:[NSURL URLWithString:item[@"attributes"][@"image_url"]]];
                        product.name = item[@"attributes"][@"name"];
                        product.price = item[@"attributes"][@"price"];
                        product.userID = [NSString stringWithFormat:@"%@", item[@"attributes"][@"user_id"]];
                        product.productID = [NSString stringWithFormat:@"%@", item[@"attributes"][@"product_id"]];
                        product.identifier = item[@"id"];
                        product.type = type;
                        
                        // add it to the database
                        [[RLMRealm defaultRealm] beginWriteTransaction];
                        [[RLMRealm defaultRealm]addObject:product];
                        [[RLMRealm defaultRealm] commitWriteTransaction];
                    });
                }
                // recursively get another set
                if (data.count > 0) [self getProductFor:type number:amount for:chunks-1];
                
                // post notifications if there are enough objects in the database so that other parts of the application can pull in data
                if ([self productCountForContext:[[NSUserDefaults standardUserDefaults] stringForKey:@"selectedObject"]] > PRODUCT_FLOOR) [[NSNotificationCenter defaultCenter] postNotificationName:@"productsAtProductFloor" object:nil];
                if ([self productCountForContext:[[NSUserDefaults standardUserDefaults] stringForKey:@"selectedObject"]] >= PRODUCT_CEILING) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"productsAtProductCeiling" object:nil];
                    _isUpdating = NO;
                }
                
            } failure:^(NSURLSessionTask *operation, NSError *error) {
                NSLog(@"Error: %@", error);
            }];
        });
    }
}

#pragma Background Fetch Method
-(void)updateCategoriesWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    NSLog(@"This is working too!");
    [self getCategoriesWithCompletion:^(BOOL finished) {
        for (NSString *type in [GodivaProductManager ids]) {
            [self updateForContextType:type];
        }
    }];
}

#pragma Identifiers for different types of categories
+(NSArray *)ids {
    return @[[GodivaProductManager idForAccessories], [GodivaProductManager idForBags], [GodivaProductManager idForDresses], [GodivaProductManager idForIntimates], [GodivaProductManager idForJewelry], [GodivaProductManager idForOuterwear], [GodivaProductManager idForPants], [GodivaProductManager idForShoes], [GodivaProductManager idForSkirtsAndShorts], [GodivaProductManager idForSportswear], [GodivaProductManager idForSweaters], [GodivaProductManager idForTops]];
}

+(NSString *)idForAccessories {
    return @"Accessories";
}

+(NSString *)idForBags {
    return @"Bags";
}

+(NSString *)idForDresses {
    return @"Dresses";
}

+(NSString *)idForIntimates {
    return @"Intimates";
}

+(NSString *)idForJewelry {
    return @"Jewelry";
}

+(NSString *)idForOuterwear {
    return @"Outerwear";
}

+(NSString *)idForPants {
    return @"Pants";
}

+(NSString *)idForShoes {
    return @"Shoes";
}

+(NSString *)idForSkirtsAndShorts {
    return @"Skirts & Shorts";
}

+(NSString *)idForSportswear {
    return @"Sportswear";
}

+(NSString *)idForSweaters {
    return @"Sweaters";
}

+(NSString *)idForTops {
    return @"Tops";
}

+(dispatch_queue_t)dispatchQueue {
    return dispatch_queue_create("com.godiva.queue", NULL);
}

@end
