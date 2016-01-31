//
//  ProductResource.h
//  Godiva
//
//  Created by Stuart Farmer on 1/31/16.
//  Copyright © 2016 app.kitchen. All rights reserved.
//

#import <JSONAPI/JSONAPI.h>
#import <JSONAPI/JSONAPIResourceBase.h>
#import <JSONAPI/JSONAPIErrorResource.h>
#import <JSONAPI/JSONAPIPropertyDescriptor.h>
#import <JSONAPI/JSONAPIResource.h>
#import <JSONAPI/JSONAPIResourceDescriptor.h>
#import <JSONAPI/JSONAPIResourceParser.h>

@interface ProductResource : JSONAPIResourceBase

@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *priceLabel;
@property (strong, nonatomic) NSURL *clickURL;
@property (strong, nonatomic) NSURL *imageURL;

@end