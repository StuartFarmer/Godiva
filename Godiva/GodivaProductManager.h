//
//  GodivaProductManager.h
//  Godiva
//
//  Created by Stuart Farmer on 1/24/16.
//  Copyright © 2016 Logic Labs Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>
#import <AFNetworking/AFNetworking.h>
#import "Product.h"

#define PRODUCT_CEILING 100
#define PRODUCT_FLOOR 40
#define PRODUCT_CHUNK 20

@interface GodivaProductManager : NSObject

@property (strong, nonatomic) NSString *context;
@property (nonatomic) BOOL isUpdating;

@property (strong, nonatomic) NSArray *categories;

@property (strong, nonatomic) RLMRealm *realm;
@property (strong, nonatomic) RLMResults<Product *> *products;

@property (nonatomic) dispatch_queue_t realmQueue;

+(GodivaProductManager *)sharedInstance;

+(NSString *)idForTops;
+(NSString *)idForPants;
+(NSString *)idForDresses;
+(NSString *)idForSkirtsAndShorts;
+(NSString *)idForSweaters;
+(NSString *)idForSportswear;
+(NSString *)idForOuterwear;
+(NSString *)idForShoes;
+(NSString *)idForBags;
+(NSString *)idForJewelry;
+(NSString *)idForIntimates;
+(NSString *)idForAccessories;
+(dispatch_queue_t)dispatchQueue;

-(void)getProductFor:(NSString *)type number:(int)amount for:(int)chunks;
-(void)updateForContextType:(NSString *)type;
-(Product *)getAnyProductsWithType:(NSString *)type;
-(NSArray *)getCategoriesWithCompletion:(void (^)(BOOL finished))completion;
-(BOOL)productsExistForContext:(NSString *)type;
-(NSUInteger)productCountForContext:(NSString *)type;
-(NSArray *)getProductsWithType:(NSString *)type;
-(void)updateCategoriesWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler;

@end
