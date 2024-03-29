//
//  BrowseViewController.m
//  Godiva
//
//  Created by Stuart Farmer on 11/29/15.
//  Copyright © 2015 app.kitchen. All rights reserved.
//

#import "BrowseViewController.h"
#import "GodivaProductManager.h"
#import "LoginViewController.h"
#import "GodivaCategory.h"
#import "UIColor+Godiva.h"
#import <MBProgressHUD/MBProgressHUD.h>

#define M_PHI 1.61803398874989484820
#define M_RATIO 1.3

@interface BrowseViewController () {
    NSArray *collectionViewCells;
    NSUserDefaults *userDefaults;
    GodivaProductManager *productManager;
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
    NSLog(@"%@", [userDefaults stringForKey:@"authenticationToken"]);
    NSLog(@"%@", [userDefaults stringForKey:@"email"]);
    [userDefaults setBool:NO forKey:@"gotCategories"];
    
    // set up product manager
    productManager = [GodivaProductManager sharedInstance];
    
    [self setTitle:@"Browse"];
    
    // set up tab bar stuff
    [[self.tabBarController.tabBar.items objectAtIndex:0] setTitle:@"Browse"];
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"selectedObject"]) [[self.tabBarController.tabBar.items objectAtIndex:1] setTitle:[[NSUserDefaults standardUserDefaults] stringForKey:@"selectedObject"]];
    else [[self.tabBarController.tabBar.items objectAtIndex:1] setTitle:@"Discover"];
    [[self.tabBarController.tabBar.items objectAtIndex:2] setTitle:@"Wishlist"];
    [[UITabBar appearance] setTintColor:[UIColor godivaBlue]];
    [[UITabBar appearance] setAlpha:1];
}

- (void)getCategories {
    self.view.userInteractionEnabled = NO;
    // Show HUD
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Connecting to Athena";
    [[GodivaProductManager sharedInstance] getCategoriesWithCompletion:^(BOOL finished) {
        if (finished) {
            // Cool, we're good to go.
            NSLog(@"Loaded Categories.");
            [hud hide:YES];
            self.view.userInteractionEnabled = YES;
            [userDefaults setBool:YES forKey:@"gotCategories"];
        } else {
            [hud hide:YES];
            // Alert that there was an error
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error Getting Category Data"
                                                                           message:@"There was trouble getting categories over the network. Check your connection and press OK to try again."
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            // reset text when user presses okay to prep them for another entry
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK"
                                                                    style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {
                                                                      [self getCategories];
                                                                  }];
            
            // add action and display
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];

}

- (void)viewDidAppear:(BOOL)animated {
    if (![userDefaults stringForKey:@"authenticationToken"]) {
        // Log in
        LoginViewController *loginViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        [self presentViewController:loginViewController animated:YES completion:nil];
    } else if (![userDefaults boolForKey:@"gotCategories"]) [self getCategories];
    
    if (![userDefaults stringForKey:@"selectedObject"]) [[self.tabBarController.tabBar.items objectAtIndex:1] setEnabled:NO];
    else [[self.tabBarController.tabBar.items objectAtIndex:1] setEnabled:YES];
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
    [userDefaults setObject:object.category forKey:@"selectedObject"];
    NSLog(@"Selected: %@", [userDefaults stringForKey:@"selectedObject"]);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"contextChanged" object:nil];
    
    // move user over to card controller
    [self.tabBarController setSelectedIndex:1];
}

// set each cell size to half the screen minus the inset padding
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat cellWidth = (self.view.frame.size.width/2)-15;
    return CGSizeMake(cellWidth, cellWidth * M_RATIO);
}

@end
