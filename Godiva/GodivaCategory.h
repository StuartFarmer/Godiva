//
//  GodivaCategory.h
//  Godiva
//
//  Created by Stuart Farmer on 2/17/16.
//  Copyright © 2016 app.kitchen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GodivaCategory : NSObject

@property (nonatomic) NSInteger identifier;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *shopStyleID;
@property (strong, nonatomic) NSString *shopStyleParentID;

@end
