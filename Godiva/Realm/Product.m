//
//  Product.m
//  Godiva
//
//  Created by Stuart Farmer on 1/3/16.
//  Copyright © 2016 app.kitchen. All rights reserved.
//

#import "Product.h"

@implementation Product

+ (NSString *)primaryKey
{
    return @"uuid";
}

+ (NSDictionary *)defaultPropertyValues
{
    return @{@"uuid": [[NSUUID UUID] UUIDString]};
}

//+ (NSArray *)ignoredProperties
//{
//    return @[];
//}

@end
