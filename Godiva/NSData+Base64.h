//
//  NSString+Base64.h
//  Godiva
//
//  Created by Stuart Farmer on 2/25/16.
//  Copyright © 2016 app.kitchen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Base64)

+ (NSData *)base64DataFromString: (NSString *)string;

@end
