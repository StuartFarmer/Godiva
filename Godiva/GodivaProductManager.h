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

#define PRODUCT_CEILING 300
#define PRODUCT_FLOOR 100
#define PRODUCT_CHUNK 20

@interface GodivaProductManager : NSObject

@property (strong, nonatomic) NSString *context;
@property (nonatomic) BOOL isUpdating;

@property (strong, nonatomic) NSArray *categories;

@property (strong, nonatomic) RLMRealm *realm;
@property (strong, nonatomic) RLMResults<Product *> *products;

+(GodivaProductManager *)sharedInstance;

+(Product *)currentProduct;

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

-(void)getProductFor:(NSString *)type number:(int)amount for:(int)chunks;
-(void)updateForContextType:(NSString *)type;
-(Product *)getAnyProductsWithType:(NSString *)type;
-(NSArray *)getCategoriesWithCompletion:(void (^)(BOOL finished))completion;

@end
