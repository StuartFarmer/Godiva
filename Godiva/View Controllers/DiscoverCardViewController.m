//
//  DiscoverCardViewController.m
//  Godiva
//
//  Created by Stuart Farmer on 12/11/15.
//  Copyright © 2015 app.kitchen. All rights reserved.
//

#import "DiscoverCardViewController.h"
#import "CGPoint+Vector.h"

@interface DiscoverCardViewController () {
    NSNotificationCenter *notificationCenter;
    NSUserDefaults *userDefaults;
    CGPoint initialPoint;
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
    
    [notificationCenter addObserver:self selector:@selector(resetCard:) name:@"resetCard" object:nil];
    
    // Initiate user defaults
    [NSUserDefaults standardUserDefaults];
    
    initialPoint = self.view.center;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewIsWithinValidZone:(NSNotification *)notification {
    //self.view.backgroundColor = [UIColor greenColor];
    self.view.alpha = 1.0f;
    self.view.layer.borderWidth = 5;
    self.view.layer.borderColor = [[UIColor greenColor] CGColor];
}

- (void)viewIsNotWithinValidZone:(NSNotification *)notification {
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.alpha = 0.5f;
    self.view.layer.borderWidth = 0;
    self.view.layer.borderColor = [[UIColor whiteColor] CGColor];
}

- (void)viewDroppedWithinValidZone:(NSNotification *)notification {

}

- (void)viewDroppedNotWithinValidZone:(NSNotification *)notification {

}

- (void)resetCard:(NSNotification *)notification {
    // load a new card
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.alpha = 1.0f;
    self.view.layer.borderWidth = 0;
}

- (void)resetView {
    
}

@end
