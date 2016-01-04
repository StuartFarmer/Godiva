//
//  Product.h
//  Godiva
//
//  Created by Stuart Farmer on 1/3/16.
//  Copyright © 2016 app.kitchen. All rights reserved.
//

#import <Realm/Realm.h>

@interface Product : RLMObject

@property NSString *type;
@property NSDate *timeSaved;

@property NSData *image;
@property float price;

@property NSString *productType;
@property NSString *productName;
@property NSString *brandName;

@property NSString *affiliateURL;

@end
RLM_ARRAY_TYPE(Product)
