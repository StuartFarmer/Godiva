//
//  PassOrSaveViewController.h
//  Godiva
//
//  Created by Stuart Farmer on 12/11/15.
//  Copyright © 2015 app.kitchen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PassOrSaveViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *passButton;
@property (weak, nonatomic) IBOutlet UIButton *questionButton;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;

- (IBAction)passButtonPressed:(id)sender;
- (IBAction)questionButtonPressed:(id)sender;
- (IBAction)likeButtonPressed:(id)sender;

@end
