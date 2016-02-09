//
//  BrowseCollectionCellDataSourceBuilder.m
//  Godiva
//
//  Created by Stuart Farmer on 11/29/15.
//  Copyright © 2015 app.kitchen. All rights reserved.
//

#import "BrowseCollectionCellDataSourceBuilder.h"
#import "BrowseCollectionViewObject.h"
#import "GodivaProductManager.h"

@implementation BrowseCollectionCellDataSourceBuilder

+ (NSMutableArray *) collectionCells {
    // Build the data source array
    NSMutableArray *collectionViewCells = [[NSMutableArray alloc] init];
    
    BrowseCollectionViewObject *tops = [[BrowseCollectionViewObject alloc] init];
    tops.image = [UIImage imageNamed:@"tops.jpg"];
    tops.name = @"Tops";
    tops.category = [GodivaProductManager idForTops];
    [collectionViewCells addObject:tops];
    
    BrowseCollectionViewObject *pants = [[BrowseCollectionViewObject alloc] init];
    pants.image = [UIImage imageNamed:@"pants.jpg"];
    pants.name = @"Pants";
    pants.category = [GodivaProductManager idForPants];
    [collectionViewCells addObject:pants];
    
    BrowseCollectionViewObject *dresses = [[BrowseCollectionViewObject alloc] init];
    dresses.image = [UIImage imageNamed:@"dresses.jpg"];
    dresses.name = @"Dresses";
    dresses.category = [GodivaProductManager idForDresses];
    [collectionViewCells addObject:dresses];
    
    BrowseCollectionViewObject *skirts = [[BrowseCollectionViewObject alloc] init];
    skirts.image = [UIImage imageNamed:@"skirts.jpg"];
    skirts.name = @"Skirts & Shorts";
    skirts.category = [GodivaProductManager idForSkirtsAndShorts];
    [collectionViewCells addObject:skirts];
    
    BrowseCollectionViewObject *sweaters = [[BrowseCollectionViewObject alloc] init];
    sweaters.image = [UIImage imageNamed:@"sweaters.jpg"];
    sweaters.name = @"Sweaters";
    sweaters.category = [GodivaProductManager idForSweaters];
    [collectionViewCells addObject:sweaters];
    
    BrowseCollectionViewObject *sportswear = [[BrowseCollectionViewObject alloc] init];
    sportswear.image = [UIImage imageNamed:@"sportswear.jpg"];
    sportswear.name = @"Sportswear";
    sportswear.category = [GodivaProductManager idForSportswear];
    [collectionViewCells addObject:sportswear];
    
    BrowseCollectionViewObject *outerwear = [[BrowseCollectionViewObject alloc] init];
    outerwear.image = [UIImage imageNamed:@"outerwear.jpg"];
    outerwear.name = @"Outerwear";
    outerwear.category = [GodivaProductManager idForOuterwear];
    [collectionViewCells addObject:outerwear];
    
    BrowseCollectionViewObject *shoes = [[BrowseCollectionViewObject alloc] init];
    shoes.image = [UIImage imageNamed:@"shoes.jpg"];
    shoes.name = @"Shoes";
    shoes.category = [GodivaProductManager idForShoes];
    [collectionViewCells addObject:shoes];
    
    BrowseCollectionViewObject *bags = [[BrowseCollectionViewObject alloc] init];
    bags.image = [UIImage imageNamed:@"bags.jpg"];
    bags.name = @"Bags";
    bags.category = [GodivaProductManager idForBags];
    [collectionViewCells addObject:bags];
    
    BrowseCollectionViewObject *jewelry = [[BrowseCollectionViewObject alloc] init];
    jewelry.image = [UIImage imageNamed:@"jewelry.jpg"];
    jewelry.name = @"Jewelry";
    jewelry.category = [GodivaProductManager idForJewelry];
    [collectionViewCells addObject:jewelry];
    
    BrowseCollectionViewObject *intimates = [[BrowseCollectionViewObject alloc] init];
    intimates.image = [UIImage imageNamed:@"intimates.jpg"];
    intimates.name = @"Intimates";
    intimates.category = [GodivaProductManager idForIntimates];
    [collectionViewCells addObject:intimates];
    
    BrowseCollectionViewObject *accessories = [[BrowseCollectionViewObject alloc] init];
    accessories.image = [UIImage imageNamed:@"accessories.jpg"];
    accessories.name = @"Accessories";
    accessories.category = [GodivaProductManager idForAccessories];
    [collectionViewCells addObject:accessories];
    
    return collectionViewCells;
}

@end
