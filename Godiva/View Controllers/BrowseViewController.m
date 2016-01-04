//
//  BrowseViewController.m
//  Godiva
//
//  Created by Stuart Farmer on 11/29/15.
//  Copyright © 2015 app.kitchen. All rights reserved.
//

#import "BrowseViewController.h"

#define M_PHI 1.61803398874989484820
#define M_RATIO 1.3

@interface BrowseViewController () {
    NSArray *collectionViewCells;
    NSUserDefaults *userDefaults;
}

@end

@implementation BrowseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    // set up data source to populate cells
    collectionViewCells = [BrowseCollectionCellDataSourceBuilder collectionCells];
    
    // set up user defaults
    userDefaults = [NSUserDefaults standardUserDefaults];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return collectionViewCells.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ClothingTypeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    BrowseCollectionViewObject *object = [collectionViewCells objectAtIndex:indexPath.row];
    
    cell.label.text = object.name;
    cell.imageView.image = object.image;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // set NSUserDefaults and move controller over.
    BrowseCollectionViewObject *object = [collectionViewCells objectAtIndex:indexPath.row];
    
    // set user defaults to selected object
    [userDefaults setObject:object.name forKey:@"selectedObject"];
    NSLog(@"Selected: %@", object.name);
    // move user over to card controller
    [self.tabBarController setSelectedIndex:1];
}

// set each cell size to half the screen minus the inset padding
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat cellWidth = (self.view.frame.size.width/2)-15;
    return CGSizeMake(cellWidth, cellWidth * M_RATIO);
}

@end
