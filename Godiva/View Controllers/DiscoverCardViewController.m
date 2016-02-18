//
//  DiscoverCardViewController.m
//  Godiva
//
//  Created by Stuart Farmer on 12/11/15.
//  Copyright © 2015 app.kitchen. All rights reserved.
//

#import "DiscoverCardViewController.h"
#import "CGPoint+Vector.h"
#import "GodivaProductManager.h"

@interface DiscoverCardViewController () {
    NSNotificationCenter *notificationCenter;
    NSUserDefaults *userDefaults;
    CGPoint initialPoint;
    Product *product;
}

@end

@implementation DiscoverCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set up notification center
    notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(viewIsWithinValidZone:) name:@"viewIsWithinValidZone" object:nil];
    
    [notificationCenter addObserver:self selector:@selector(viewIsNotWithinValidZone:) name:@"viewIsNotWithinValidZone" object:nil];
    
    [notificationCenter addObserver:self selector:@selector(viewDroppedWithinValidZone:) name:@"viewDroppedWithinValidZone" object:nil];
    
    [notificationCenter addObserver:self selector:@selector(viewDroppedNotWithinValidZone:) name:@"viewDroppedNotWithinValidZone" object:nil];
    
    [notificationCenter addObserver:self selector:@selector(saveProduct:) name:@"saveProduct" object:nil];
    
    [notificationCenter addObserver:self selector:@selector(resetCard:) name:@"resetCard" object:nil];
    
    // Initiate user defaults
    [NSUserDefaults standardUserDefaults];
    
    self.view.layer.cornerRadius = 8.0f;
    initialPoint = self.view.center;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewIsWithinValidZone:(NSNotification *)notification {

}

- (void)viewIsNotWithinValidZone:(NSNotification *)notification {

}

- (void)viewDroppedWithinValidZone:(NSNotification *)notification {

}

- (void)viewDroppedNotWithinValidZone:(NSNotification *)notification {

}

- (void)resetCard:(NSNotification *)notification {
    NSLog(@"Resetting card...");
    self.view.layer.cornerRadius = 8.0f;
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.alpha = 1.0f;
    self.view.layer.borderWidth = 0;
    NSLog(@"type: %@", [[NSUserDefaults standardUserDefaults] stringForKey:@"selectedObject"]);
    product = [[GodivaProductManager sharedInstance] getAnyProductsWithType:[[NSUserDefaults standardUserDefaults] stringForKey:@"selectedObject"]];
    self.imageView.image = [UIImage imageWithData:product.image];
    self.productLabel.text = product.name;
    self.priceLabel.text = [NSString stringWithFormat:@"$%@0", product.price];
    [[NSUserDefaults standardUserDefaults] setURL:[NSURL URLWithString:product.clickURL] forKey:@"url"];
}

- (void)saveProduct:(NSNotification *)notification {
    NSLog(@"This is happening");
    
    [[RLMRealm defaultRealm] beginWriteTransaction];
    product.type = @"saved";
    [[RLMRealm defaultRealm] addOrUpdateObject:product];
    [[RLMRealm defaultRealm] commitWriteTransaction];
}

- (void)resetView {
    
}

@end
