//
//  GodivaCardHelper.m
//  Godiva
//
//  Created by Stuart Farmer on 1/31/16.
//  Copyright © 2016 app.kitchen. All rights reserved.
//

#import "GodivaCardHelper.h"

@implementation GodivaCardHelper

+(GodivaCardHelper *)sharedInstance {
    static GodivaCardHelper *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

+ (CGPoint)passVector {
    return CGPointMake(1, 0);
}

+ (CGPoint)questionVector {
    return CGPointMake(0, 1);
}

+ (CGPoint)likeVector {
    return CGPointMake(-1, 0);
}

@end
