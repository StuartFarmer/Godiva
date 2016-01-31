//
//  PassOrSaveViewController.m
//  Godiva
//
//  Created by Stuart Farmer on 12/11/15.
//  Copyright © 2015 app.kitchen. All rights reserved.
//

#import "PassOrSaveViewController.h"

@interface PassOrSaveViewController ()

@end

@implementation PassOrSaveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.passButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [self.questionButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [self.likeButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
    
    self.view.layer.cornerRadius = 8.0f;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)likeButtonPressed:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"likeButtonPressed" object:nil];
}

- (IBAction)passButtonPressed:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"passButtonPressed" object:nil];
}

- (IBAction)questionButtonPressed:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"questionButtonPressed" object:nil];
}

@end
