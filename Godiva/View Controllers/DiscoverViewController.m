//
//  DiscoverViewController.m
//  Godiva
//
//  Created by Stuart Farmer on 11/29/15.
//  Copyright © 2015 app.kitchen. All rights reserved.
//

#import "DiscoverViewController.h"
#import "CGPoint+Vector.h"

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
    CGPoint upVector;
    float totalDistance;
    
    NSNotificationCenter *notificationCenter;
    NSUserDefaults *userDefaults;
}

@end

@implementation DiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Set upVector for comparing angles against
    upVector.x = -1;
    upVector.y = 0;
    
    // Setup swipe view
    swipeView = self.cardView;
    
    // Start notifications & defaults
    notificationCenter = [NSNotificationCenter defaultCenter];
    userDefaults = [NSUserDefaults standardUserDefaults];
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
    if ([self viewIsWithinValidZone:swipeView]) {
        [notificationCenter postNotificationName:@"viewIsWithinValidZone" object:nil];
    } else {
        [notificationCenter postNotificationName:@"viewIsNotWithinValidZone" object:nil];
    }
    
    // Set current point to new point
    currentPoint = newPoint;
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // Check if the view is in valid zone
    
    switch ([self viewStateInValidZone:swipeView]) {
        case 0:
            [notificationCenter postNotificationName:@"viewDroppedNotWithinValidZone" object:nil];
            break;
        case 1:
            swipeView.center = startingPoint;
            swipeView.alpha = 1;
            swipeView.backgroundColor = [UIColor whiteColor];
            break;
        case 2:
            [notificationCenter postNotificationName:@"viewDroppedWithinValidZone" object:nil];
        default:
            break;
    }
    
    if ([self viewStateInValidZone:swipeView] == 0 || [self viewStateInValidZone:swipeView] == 2) {
        // Animate view away if it needs to
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
            swipeView.alpha = 1;
            swipeView.backgroundColor = [UIColor whiteColor];
            [notificationCenter postNotificationName:@"resetCard" object:nil];
        }];
    }
}

-(int)viewStateInValidZone:(UIView *)view {
    // Calculate the current angle
    CGPoint distanceFromStartingPoint = CGPointSubtract(startingPoint, view.center);
    CGFloat angle = CGPointGetAngleBetween(distanceFromStartingPoint, upVector) * (180 / M_PI);
    
    // card is in proper angle and proper distance
    if (angle < ANGLETHRESHOLD && CGPointGetDistance(startingPoint, view.center) > DISTANCETHRESHOLD) return 2;
    
    // card is not in proper distance
    else if (CGPointGetDistance(startingPoint, view.center) < DISTANCETHRESHOLD) return 1;

    // card is in proper distance but wrong angle
    else return 0;
}

-(BOOL)viewIsWithinValidZone:(UIView *)view {
    // Calculate the current angle
    CGPoint distanceFromStartingPoint = CGPointSubtract(startingPoint, view.center);
    CGFloat angle = CGPointGetAngleBetween(distanceFromStartingPoint, upVector) * (180 / M_PI);
    
    // Color view appropriately if it is within the 'good' zone
    if (angle < ANGLETHRESHOLD && CGPointGetDistance(startingPoint, view.center) > DISTANCETHRESHOLD) return true;
    else return false;
}


@end
