//
//  LoginViewController.m
//  Godiva
//
//  Created by Stuart Farmer on 1/24/16.
//  Copyright © 2016 app.kitchen. All rights reserved.
//

#import "LoginViewController.h"

#define KEYBOARD_HEIGHT 120
// 220 for iPhone 4
// 160 for iPhone 5
// 120 for iPhone 6

@interface LoginViewController () <UITextFieldDelegate> {
    NSUserDefaults *userDefaults;
}

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    userDefaults = [NSUserDefaults standardUserDefaults];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.emailAddressTextField.delegate = self;
    self.emailAddressTextField.keyboardType = UIKeyboardTypeEmailAddress;
    self.passwordTextField.delegate = self;
    self.passwordTextField.keyboardType = UIKeyboardTypeDefault;
    self.passwordTextField.secureTextEntry = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma UITextFieldDelegate Methods
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    // move everything up
    [UIView animateWithDuration:0.3 animations:^{
        self.view.center = CGPointMake(self.view.center.x, self.view.center.y-KEYBOARD_HEIGHT);
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.emailAddressTextField) {
        [textField resignFirstResponder];
        [self.passwordTextField becomeFirstResponder];
    } else if (textField == self.passwordTextField) {
        [textField resignFirstResponder];
        [self signInPressed:nil];
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    // move everything down
    [UIView animateWithDuration:0.2 animations:^{
        self.view.center = CGPointMake(self.view.center.x, self.view.center.y+KEYBOARD_HEIGHT);
    }];
}

- (IBAction)signInPressed:(id)sender {
    NSURL *url = [NSURL URLWithString:@"http://godiva.logiclabs.systems/api/v1/"];
    NSDictionary *params = @{@"data" : @{
                                     @"type" : @"account",
                                     @"attributes" : @{
                                             @"email" : self.emailAddressTextField.text,
                                             @"password" : self.passwordTextField.text,
                                             @"password_confirmation" : self.passwordTextField.text
                                             }
                                     }
                             };
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"%@", jsonString);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[jsonData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody: jsonData];
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)signIn {
    
}
@end
