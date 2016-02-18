//
//  GodivaProductManager.m
//  Godiva
//
//  Created by Stuart Farmer on 1/24/16.
//  Copyright © 2016 Logic Labs Ltd. All rights reserved.
//

#import "GodivaProductManager.h"
#import "GodivaCategory.h"

#define PRODUCT_CEILING 300
#define PRODUCT_FLOOR 100
#define PRODUCT_CHUNK 20



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
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // get a response
            
        [manager GET:categoriesURL parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSArray *data = responseObject[@"data"];
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

- (void)update {
    // set the context to the current product type
    userDefaults = [NSUserDefaults standardUserDefaults];
    _realm = [RLMRealm defaultRealm];
    
    self.context = [userDefaults stringForKey:@"selectedObject"];
    
    // check if there are enough products in the current context
    if (!self.isUpdating) {
        self.isUpdating = true;
        _products = [Product objectsWhere:[NSString stringWithFormat:@"type = '%@'", self.context]];
        
        // if not, update
        if (_products.count < PRODUCT_FLOOR) {
            // query for more objects until it reaches the ceiling
            [self getProductFor:self.context number:PRODUCT_CHUNK for:(int)PRODUCT_FLOOR/PRODUCT_CEILING];
        }
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
            if ([category.name isEqualToString:@"Accessories"]) [returnArray addObject:category];
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
            if ([category.name isEqualToString:@"Accessories"]) [returnArray addObject:category];
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
    
    return returnString;
}

- (NSString *)categoryIDforProductID:(NSString *)type {
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
    
    return categoryString;
}

- (NSString *)productIDforCategoryID:(NSString *)category {
    
    NSString *categoryString = category;
    
    if ([categoryString isEqualToString:@"3"]) return [GodivaProductManager idForAccessories];
    else if ([categoryString isEqualToString:@"161"]) return [GodivaProductManager idForBags];
    else if ([categoryString isEqualToString:@"35"]) return [GodivaProductManager idForDresses];
    else if ([categoryString isEqualToString:@"40"]) return [GodivaProductManager idForIntimates];
    else if ([categoryString isEqualToString:@"58"]) return [GodivaProductManager idForJewelry];
    else if ([categoryString isEqualToString:@"79"]) return [GodivaProductManager idForOuterwear];
    else if ([categoryString isEqualToString:@"86"]) return [GodivaProductManager idForPants];
    else if ([categoryString isEqualToString:@"170"]) return [GodivaProductManager idForShoes];
    else if ([categoryString isEqualToString:@"120"]) return [GodivaProductManager idForSkirtsAndShorts];
    else if ([categoryString isEqualToString:@"14"]) return [GodivaProductManager idForSportswear];
    else if ([categoryString isEqualToString:@"125"]) return [GodivaProductManager idForSweaters];
    else if ([categoryString isEqualToString:@"149"]) return [GodivaProductManager idForTops];
    else return @"149";
    
}

- (void)getProductFor:(NSString *)type number:(int)amount for:(int)chunks{
    userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *categoryString = [self URLParameterStringForArbitraryContextString:type];
    NSLog(@"%@", categoryString);
    
    NSLog(@"Get request for %i %@", amount, type);
    
    // set up query parameters
    NSDictionary *params = @{@"user_email" : [userDefaults objectForKey:@"email"], @"user_token" : [userDefaults objectForKey:@"authenticationToken"], @"number_records" : [NSString stringWithFormat:@"%i", amount], @"category" : categoryString};
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // get a response
        [manager GET:@"http://godiva.logiclabs.systems/api/v1/user_products/" parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            // Put JSON into Product data object and put into Realm
            NSLog(@"JSON: %@", responseObject);
            NSArray *data = responseObject[@"data"];
            for (NSDictionary *item in data) {
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
                product.type = [self productIDforCategoryID:type];
                
                NSLog(@"%@", product.brandName.class);
                NSLog(@"%@", product.clickURL.class);
                NSLog(@"%@", product.image.class);
                NSLog(@"%@", product.name.class);
                NSLog(@"%@", product.userID.class);
                NSLog(@"%@", product.productID.class);
                NSLog(@"%@", product.identifier.class);
                NSLog(@"%@", product.type.class);
                
                NSLog(@"%@", product.userID);
                NSLog(@"%@", product.productID);
                
                // add it to the database
                [_realm beginWriteTransaction];
                [_realm addObject:product];
                [_realm commitWriteTransaction];
            }
            // recursively get another set
            if (data.count > 0) [self getProductFor:type number:amount for:chunks-1];
            
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
    });
    
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
