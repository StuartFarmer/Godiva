//
//  Product.h
//  Godiva
//
//  Created by Stuart Farmer on 1/3/16.
//  Copyright © 2016 app.kitchen. All rights reserved.
//

#import <Realm/Realm.h>
@import UIKit;

@interface Product : RLMObject

@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *brandName;
@property (strong, nonatomic) NSString *clickURL;
@property (strong, nonatomic) NSData *image;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *unbrandedName;
@property (strong, nonatomic) NSString *price;
@property (strong, nonatomic) NSString *userID;
@property (strong, nonatomic) NSString *productID;

@end
RLM_ARRAY_TYPE(Product)
