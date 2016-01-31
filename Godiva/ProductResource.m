//
//  ProductResource.m
//  Godiva
//
//  Created by Stuart Farmer on 1/31/16.
//  Copyright © 2016 app.kitchen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProductResource.h"

@implementation ProductResource

static JSONAPIResourceDescriptor *__descriptor = nil;

+ (JSONAPIResourceDescriptor*)descriptor {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [__descriptor addProperty:@"type" withJsonName:@"type"];
        [__descriptor addProperty:@"name" withJsonName:@"name"];
        [__descriptor addProperty:@"priceLabel" withJsonName:@"price-label"];
        [__descriptor addProperty:@"clickURL" withJsonName:@"click-url"];
        
        [__descriptor addProperty:@"title"];
    });
    
    return __descriptor;
}

@end