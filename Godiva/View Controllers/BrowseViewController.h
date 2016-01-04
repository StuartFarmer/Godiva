//
//  BrowseViewController.h
//  Godiva
//
//  Created by Stuart Farmer on 11/29/15.
//  Copyright © 2015 app.kitchen. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BrowseCollectionCellDataSourceBuilder.h"
#import "BrowseCollectionViewObject.h"
#import "ClothingTypeCollectionViewCell.h"

@interface BrowseViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@end
