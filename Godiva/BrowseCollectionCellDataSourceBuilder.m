//
//  BrowseCollectionCellDataSourceBuilder.m
//  Godiva
//
//  Created by Stuart Farmer on 11/29/15.
//  Copyright © 2015 app.kitchen. All rights reserved.
//

#import "BrowseCollectionCellDataSourceBuilder.h"
#import "BrowseCollectionViewObject.h"

@implementation BrowseCollectionCellDataSourceBuilder

+ (NSMutableArray *) collectionCells {
    // Build the data source array
    NSMutableArray *collectionViewCells = [[NSMutableArray alloc] init];
    
    BrowseCollectionViewObject *tops = [[BrowseCollectionViewObject alloc] init];
    tops.image = [UIImage imageNamed:@"tops.jpg"];
    tops.name = @"Tops";
    tops.category = @"tops";
    [collectionViewCells addObject:tops];
    
    BrowseCollectionViewObject *pants = [[BrowseCollectionViewObject alloc] init];
    pants.image = [UIImage imageNamed:@"pants.jpg"];
    pants.name = @"Pants";
    pants.category = @"pants";
    [collectionViewCells addObject:pants];
    
    BrowseCollectionViewObject *dresses = [[BrowseCollectionViewObject alloc] init];
    dresses.image = [UIImage imageNamed:@"dresses.jpg"];
    dresses.name = @"Dresses";
    dresses.category = @"dresses";
    [collectionViewCells addObject:dresses];
    
    BrowseCollectionViewObject *skirts = [[BrowseCollectionViewObject alloc] init];
    skirts.image = [UIImage imageNamed:@"skirts.jpg"];
    skirts.name = @"Skirts & Shorts";
    skirts.category = @"skirts&shorts";
    [collectionViewCells addObject:skirts];
    
    BrowseCollectionViewObject *sweaters = [[BrowseCollectionViewObject alloc] init];
    sweaters.image = [UIImage imageNamed:@"sweaters.jpg"];
    sweaters.name = @"Sweaters";
    sweaters.category = @"sweaters";
    [collectionViewCells addObject:sweaters];
    
    BrowseCollectionViewObject *sportswear = [[BrowseCollectionViewObject alloc] init];
    sportswear.image = [UIImage imageNamed:@"sportswear.jpg"];
    sportswear.name = @"Sportswear";
    sportswear.category = @"sportswear";
    [collectionViewCells addObject:sportswear];
    
    BrowseCollectionViewObject *outerwear = [[BrowseCollectionViewObject alloc] init];
    outerwear.image = [UIImage imageNamed:@"outerwear.jpg"];
    outerwear.name = @"Outerwear";
    outerwear.category = @"outerwear";
    [collectionViewCells addObject:outerwear];
    
    BrowseCollectionViewObject *shoes = [[BrowseCollectionViewObject alloc] init];
    shoes.image = [UIImage imageNamed:@"shoes.jpg"];
    shoes.name = @"Shoes";
    shoes.category = @"shoes";
    [collectionViewCells addObject:shoes];
    
    BrowseCollectionViewObject *bags = [[BrowseCollectionViewObject alloc] init];
    bags.image = [UIImage imageNamed:@"bags.jpg"];
    bags.name = @"Bags";
    bags.category = @"bags";
    [collectionViewCells addObject:bags];
    
    BrowseCollectionViewObject *jewelry = [[BrowseCollectionViewObject alloc] init];
    jewelry.image = [UIImage imageNamed:@"jewelry.jpg"];
    jewelry.name = @"Jewelry";
    jewelry.category = @"jewelry";
    [collectionViewCells addObject:jewelry];
    
    BrowseCollectionViewObject *intimates = [[BrowseCollectionViewObject alloc] init];
    intimates.image = [UIImage imageNamed:@"intimates.jpg"];
    intimates.name = @"Intimates";
    intimates.category = @"intimates";
    [collectionViewCells addObject:intimates];
    
    BrowseCollectionViewObject *accessories = [[BrowseCollectionViewObject alloc] init];
    accessories.image = [UIImage imageNamed:@"accessories.jpg"];
    accessories.name = @"Accessories";
    accessories.category = @"accessories";
    [collectionViewCells addObject:accessories];
    
    return collectionViewCells;
}

@end
