//
//  GodivaCardHelper.h
//  Godiva
//
//  Created by Stuart Farmer on 1/31/16.
//  Copyright © 2016 app.kitchen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GodivaCardHelper : NSObject

@property CGPoint startingPoint;

+ (GodivaCardHelper *)sharedInstance;

+ (CGPoint)passVector;
+ (CGPoint)questionVector;
+ (CGPoint)likeVector;

@end
