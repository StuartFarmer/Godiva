//
//  DiscoverCardViewController.h
//  Godiva
//
//  Created by Stuart Farmer on 12/11/15.
//  Copyright © 2015 app.kitchen. All rights reserved.
//

#import <UIKit/UIKit.h>
@import QuartzCore;

@interface DiscoverCardViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *productLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *outOfCardsLabel;

@end
