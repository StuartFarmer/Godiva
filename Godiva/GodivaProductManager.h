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

@interface GodivaProductManager : NSObject

@property (strong, nonatomic) NSString *context;
@property (nonatomic) BOOL isUpdating;

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

-(void)update;

@end
