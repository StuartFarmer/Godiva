//
//  DiscoverViewController.m
//  Godiva
//
//  Created by Stuart Farmer on 11/29/15.
//  Copyright © 2015 app.kitchen. All rights reserved.
//

#import "DiscoverViewController.h"
#import "CGPoint+Vector.h"
#import "UIColor+Godiva.h"

@import SafariServices;

#define VIEWWIDTH 80
#define VIEWHEIGHT 20

#define DISTANCETHRESHOLD 50
#define ANGLETHRESHOLD 50

#define CARDMARGIN 20

@interface DiscoverViewController () {
    UIView *swipeView;
    CGPoint startingPoint;
    CGPoint firstPoint;
    CGPoint currentPoint;
    CGPoint rightVector;
    CGPoint leftVector;
    CGPoint upVector;
    float totalDistance;
    
    NSNotificationCenter *notificationCenter;
    NSUserDefaults *userDefaults;
    
    GodivaProductManager *productManager;
    
}

@end

@implementation DiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set rightVector and leftVector for comparing angles against
    
    // pass
    rightVector.x = -1;
    rightVector.y = 0;
    
    // save
    leftVector.x = 1;
    leftVector.y = 0;
    
    // question
    upVector.x = 0;
    upVector.y = 1;
    
    // Setup swipe view
    swipeView = self.cardView;
    
    // Start notifications & defaults
    notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(discoverCardReset:) name:@"discoverCardReset" object:nil];
    [notificationCenter addObserver:self selector:@selector(likeButtonPressed:) name:@"likeButtonPressed" object:nil];
    [notificationCenter addObserver:self selector:@selector(questionButtonPressed:) name:@"questionButtonPressed" object:nil];
    [notificationCenter addObserver:self selector:@selector(passButtonPressed:) name:@"passButtonPressed" object:nil];
    
    userDefaults = [NSUserDefaults standardUserDefaults];
    
    // start the product manager for updating info
    productManager = [GodivaProductManager sharedInstance];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // Get the starting touch
    UITouch *touch = [touches anyObject];
    startingPoint = swipeView.center;
    firstPoint = [touch locationInView:self.view];
    currentPoint = [touch locationInView:self.view];
    
    // Reset the total distance
    totalDistance = 0;
    [userDefaults setFloat:startingPoint.x forKey:@"startingPointX"];
    [userDefaults setFloat:startingPoint.y forKey:@"startingPointY"];
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // Move the view (or view in this case) to the amount dragged on the screen
    CGPoint newPoint = [[touches anyObject] locationInView:self.view];
    CGPoint difference = CGPointSubtract(newPoint, currentPoint);
    swipeView.center = CGPointAdd(swipeView.center, difference);
    
    // Color UI elements if view is within valid zone
    if ([self viewIsPointingTowards:swipeView Vector:leftVector]) {
        [notificationCenter postNotificationName:@"viewIsWithinValidZone" object:nil];
        [UIView animateWithDuration:0.2 animations:^{
            self.view.backgroundColor = [UIColor godivaGreen];
        }];
        
    } else if ([self viewIsPointingTowards:swipeView Vector:rightVector]) {
        [UIView animateWithDuration:0.2 animations:^{
            self.view.backgroundColor = [UIColor godivaRed];
        }];
    } else if ([self viewIsPointingTowards:swipeView Vector:upVector]) {
        [UIView animateWithDuration:0.2 animations:^{
            self.view.backgroundColor = [UIColor godivaBlue];
        }];
    } else {
        [notificationCenter postNotificationName:@"viewIsNotWithinValidZone" object:nil];
        [UIView animateWithDuration:0.2 animations:^{
            self.view.backgroundColor = [UIColor godivaWhite];
        }];
    }
    
    // Set current point to new point
    currentPoint = newPoint;
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // Check if the view is in valid zone
    if ([self viewIsPointingTowards:swipeView Vector:leftVector] || [self viewIsPointingTowards:swipeView Vector:rightVector]) {
        // Animate view away if it needs to
        [self.view setUserInteractionEnabled:NO];
        [UIView animateWithDuration:0.3 animations:^{
            CGPoint difference = CGPointSubtract(swipeView.center, startingPoint);
            CGPoint multiple = CGPointMultiply(difference, 10);
            CGPointNormalize(multiple);
            CGPointMultiply(multiple, 10);
            swipeView.center = CGPointAdd(swipeView.center, multiple);
            swipeView.alpha = 0;
        } completion:^(BOOL finished) {
            // Reset the view
            swipeView.center = startingPoint;
            swipeView.backgroundColor = [UIColor whiteColor];
            
            [notificationCenter postNotificationName:@"resetCard" object:nil];
            
            [self.view setUserInteractionEnabled:YES];
        }];
    } else {
        if ([self viewIsPointingTowards:swipeView Vector:upVector]) {
            // show the URL in a safari modal
            SFSafariViewController *safariViewController = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:@"http://google.com"]];
            [self presentViewController:safariViewController animated:YES completion:nil];
        }
        
        [self.view setUserInteractionEnabled:NO];
        [UIView animateWithDuration:0.2 animations:^{
            swipeView.center = startingPoint;
            swipeView.backgroundColor = [UIColor whiteColor];
        } completion:^(BOOL finished) {
            [self.view setUserInteractionEnabled:YES];
        }];
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        swipeView.alpha = 1;
        self.view.backgroundColor = [UIColor godivaWhite];
    }];
}

-(BOOL)viewIsPointingTowards:(UIView *)view Vector:(CGPoint)vector {
    // Calculate the current angle
    CGPoint distanceFromStartingPoint = CGPointSubtract(startingPoint, view.center);
    CGFloat angle = CGPointGetAngleBetween(distanceFromStartingPoint, vector) * (180 / M_PI);
    
    // Color view appropriately if it is within the 'good' zone
    if (angle < ANGLETHRESHOLD && CGPointGetDistance(startingPoint, view.center) > DISTANCETHRESHOLD) return true;
    else return false;
}

#pragma NSNotificationCenter Methods
- (void)discoverCardReset:(NSNotification *)notification {
    
}

- (void)likeButtonPressed:(NSNotification *)notification {
    [self.view setUserInteractionEnabled:NO];
    [UIView animateWithDuration:0.2 animations:^{
        swipeView.center = CGPointMake(swipeView.center.x+1000, swipeView.center.y);
        self.view.backgroundColor = [UIColor godivaGreen];
        swipeView.alpha = 0;
    } completion:^(BOOL finished) {
        // Reset the view
        [UIView animateWithDuration:0.2 animations:^{
            self.view.backgroundColor = [UIColor godivaWhite];
        }];
        swipeView.center = CGPointMake(swipeView.center.x-1000, swipeView.center.y);
        swipeView.backgroundColor = [UIColor whiteColor];
        
        [notificationCenter postNotificationName:@"resetCard" object:nil];
        swipeView.alpha = 1;
        [self.view setUserInteractionEnabled:YES];
    }];
}

- (void)questionButtonPressed:(NSNotification *)notification {
    [self.view setUserInteractionEnabled:NO];
    [UIView animateWithDuration:0.2 animations:^{
        // push view up and color
        swipeView.center = CGPointMake(swipeView.center.x, swipeView.center.y-200);
        self.view.backgroundColor = [UIColor godivaBlue];

    } completion:^(BOOL finished) {
        // Reset the view
        [UIView animateWithDuration:0.2 animations:^{
            // push view down and decolor
            swipeView.center = CGPointMake(swipeView.center.x, swipeView.center.y+200);
            self.view.backgroundColor = [UIColor godivaWhite];
        }];
        // show the URL in a safari modal
        SFSafariViewController *safariViewController = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:@"http://google.com"]];
        [self presentViewController:safariViewController animated:YES completion:nil];
        
        [self.view setUserInteractionEnabled:YES];
    }];
}

- (void)passButtonPressed:(NSNotification *)notification {
    [self.view setUserInteractionEnabled:NO];
    [UIView animateWithDuration:0.2 animations:^{
        swipeView.center = CGPointMake(swipeView.center.x-1000, swipeView.center.y);
        self.view.backgroundColor = [UIColor godivaRed];
        swipeView.alpha = 0;
    } completion:^(BOOL finished) {
        // Reset the view
        // Reset the view
        [UIView animateWithDuration:0.2 animations:^{
            self.view.backgroundColor = [UIColor godivaWhite];
        }];
        swipeView.center = CGPointMake(swipeView.center.x+1000, swipeView.center.y);
        swipeView.backgroundColor = [UIColor whiteColor];
        
        [notificationCenter postNotificationName:@"resetCard" object:nil];
        swipeView.alpha = 1;
        [self.view setUserInteractionEnabled:YES];
    }];
}

@end
