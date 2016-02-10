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

#import "ProductResource.h"

@import SafariServices;

#define VIEWWIDTH 80
#define VIEWHEIGHT 20

#define DISTANCETHRESHOLD 50
#define ANGLETHRESHOLD 50

#define CARDMARGIN 20

#define DEFAULT_DISCARD_DISTANCE 500
#define ANIMATION_TIME 0.2

@interface DiscoverViewController () {
    UIView *swipeView;
    
    CGPoint startingPoint;
    CGPoint firstPoint;
    CGPoint currentPoint;

    float totalDistance;
    
    NSNotificationCenter *notificationCenter;
    NSUserDefaults *userDefaults;
    
    GodivaProductManager *productManager;
    GodivaCardHelper *cardHelper;

}

@end

@implementation DiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Setup swipe view
    swipeView = self.cardView;
    
    // Start notifications & defaults
    notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(discoverCardReset:) name:@"discoverCardReset" object:nil];
    [notificationCenter addObserver:self selector:@selector(likeButtonPressed:) name:@"likeButtonPressed" object:nil];
    [notificationCenter addObserver:self selector:@selector(questionButtonPressed:) name:@"questionButtonPressed" object:nil];
    [notificationCenter addObserver:self selector:@selector(passButtonPressed:) name:@"passButtonPressed" object:nil];
    
    userDefaults = [NSUserDefaults standardUserDefaults];
    NSLog(@"Auth Token: %@", [userDefaults stringForKey:@"authenticationToken"]);
    
    // set up card helper for helper methods regarding positioning
    cardHelper = [GodivaCardHelper sharedInstance];
    
    // start the product manager for updating info
    productManager = [GodivaProductManager sharedInstance];
    
    [productManager update];
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
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // Move the view (or view in this case) to the amount dragged on the screen
    CGPoint newPoint = [[touches anyObject] locationInView:self.view];
    CGPoint difference = CGPointSubtract(newPoint, currentPoint);
    swipeView.center = CGPointAdd(swipeView.center, difference);
    
    // Color UI elements if view is within valid zone
    UIColor *backgroundColor = [UIColor godivaWhite];
    
    if ([self view:swipeView IsPointingTowards:[GodivaCardHelper passVector]]) backgroundColor = [UIColor godivaRed];
    else if ([self view:swipeView IsPointingTowards:[GodivaCardHelper questionVector]]) backgroundColor = [UIColor godivaBlue];
    else if ([self view:swipeView IsPointingTowards:[GodivaCardHelper likeVector]]) backgroundColor = [UIColor godivaGreen];

    [UIView animateWithDuration:ANIMATION_TIME animations:^{
        self.view.backgroundColor = backgroundColor;
    }];
    
    // Set current point to new point
    currentPoint = newPoint;
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // Check if the view is in valid zone
    if ([self view:swipeView IsPointingTowards:[GodivaCardHelper passVector]] || [self view:swipeView IsPointingTowards:[GodivaCardHelper likeVector]]) {
        // Animate view away if it needs to
        [self.view setUserInteractionEnabled:NO];
        
        CGPoint difference = CGPointSubtract(swipeView.center, startingPoint);
        CGPoint multiple = CGPointMultiply(difference, 3);
        CGPointNormalize(multiple);
        //CGPointMultiply(multiple, 10);
        NSLog(@"multiple.x: %f multiple.y: %f", multiple.x, multiple.y);
        
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        [UIView animateWithDuration:ANIMATION_TIME animations:^{
            swipeView.center = CGPointAdd(swipeView.center, multiple);
            swipeView.alpha = 0;
        } completion:^(BOOL finished) {
            // Reset the view
            swipeView.center = startingPoint;
            swipeView.backgroundColor = [UIColor whiteColor];
            
            [notificationCenter postNotificationName:@"resetCard" object:nil];
            
            swipeView.alpha = 1;
            self.view.backgroundColor = [UIColor godivaWhite];
            
            [self.view setUserInteractionEnabled:YES];
        }];
    } else {
        if ([self view:swipeView IsPointingTowards:[GodivaCardHelper questionVector]]) {
            // show the URL in a safari modal
            SFSafariViewController *safariViewController = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:@"http://google.com"]];
            [self presentViewController:safariViewController animated:YES completion:nil];
        }
        
        [self.view setUserInteractionEnabled:NO];
        [UIView animateWithDuration:ANIMATION_TIME animations:^{
            swipeView.center = startingPoint;
            swipeView.backgroundColor = [UIColor whiteColor];
        } completion:^(BOOL finished) {
            
            swipeView.alpha = 1;
            self.view.backgroundColor = [UIColor godivaWhite];
            
            [self.view setUserInteractionEnabled:YES];
        }];
    }
    
    
    
}

-(BOOL)view:(UIView *)view IsPointingTowards:(CGPoint)vector {
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
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView animateWithDuration:ANIMATION_TIME animations:^{
        swipeView.center = CGPointMake(swipeView.center.x+DEFAULT_DISCARD_DISTANCE, swipeView.center.y);
        self.view.backgroundColor = [UIColor godivaGreen];
        swipeView.alpha = 0;
    } completion:^(BOOL finished) {
        // Reset the view
        [UIView animateWithDuration:ANIMATION_TIME animations:^{
            self.view.backgroundColor = [UIColor godivaWhite];
        }];
        swipeView.center = CGPointMake(swipeView.center.x-DEFAULT_DISCARD_DISTANCE, swipeView.center.y);
        swipeView.backgroundColor = [UIColor whiteColor];
        
        swipeView.layer.cornerRadius = 8.0f;
        
        [notificationCenter postNotificationName:@"resetCard" object:nil];
        swipeView.alpha = 1;
        [self.view setUserInteractionEnabled:YES];
    }];
}

- (void)questionButtonPressed:(NSNotification *)notification {
    [self.view setUserInteractionEnabled:NO];
    [UIView animateWithDuration:ANIMATION_TIME animations:^{
        // push view up and color
        swipeView.center = CGPointMake(swipeView.center.x, swipeView.center.y-200);
        self.view.backgroundColor = [UIColor godivaBlue];

    } completion:^(BOOL finished) {
        // Reset the view
        [UIView animateWithDuration:ANIMATION_TIME animations:^{
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
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView animateWithDuration:ANIMATION_TIME animations:^{
        swipeView.center = CGPointMake(swipeView.center.x-DEFAULT_DISCARD_DISTANCE, swipeView.center.y);
        self.view.backgroundColor = [UIColor godivaRed];
        swipeView.alpha = 0;
    } completion:^(BOOL finished) {
        // Reset the view
        // Reset the view
        [UIView animateWithDuration:ANIMATION_TIME animations:^{
            self.view.backgroundColor = [UIColor godivaWhite];
        }];
        swipeView.center = CGPointMake(swipeView.center.x+DEFAULT_DISCARD_DISTANCE, swipeView.center.y);
        swipeView.backgroundColor = [UIColor whiteColor];
        
        [notificationCenter postNotificationName:@"resetCard" object:nil];
        swipeView.alpha = 1;
        
        swipeView.layer.cornerRadius = 8.0f;
        
        [self.view setUserInteractionEnabled:YES];
    }];
}

@end
