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
    BOOL engaged;
    UITextField *lastTextField;
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
    
    //self.signInButton.layer.borderColor = [UIColor blackColor].CGColor;
    //self.signInButton.layer.borderWidth = 1.0f;
    self.signInButton.layer.cornerRadius = 4.0f;
    self.signUpButton.layer.cornerRadius = 4.0f;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (int)keyboardHeight {
    int frameHeight = (int)self.view.frame.size.height;
    switch (frameHeight) {
        case 480:
            return 220;
            break;
        case 568:
            // iPhone 5
            return 220;
            break;
        case 667:
            // iPhone 6
            return 200;
            break;
        case 736:
            // iPhone 6+
            return 230;
            break;
        default:
            return 0;
            break;
    }
}

- (void)animateViewUp {
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView animateWithDuration:0.3 animations:^{
        // check the height of the frame to determine how much to move the view
        self.view.center = CGPointMake(self.view.center.x, self.view.center.y-[self keyboardHeight]);
    }];
}

- (void)animateViewDown {
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView animateWithDuration:0.15
                     animations:^{
                         self.view.center = CGPointMake(self.view.center.x, self.view.center.y+[self keyboardHeight]);
                     }];
}

#pragma UITextFieldDelegate Methods
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    // move up
    [self animateViewUp];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.emailAddressTextField) {
        [textField resignFirstResponder];
        [self.passwordTextField becomeFirstResponder];
    } else if (textField == self.passwordTextField) {
        [textField resignFirstResponder];
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    // set the engaged flag so if the email address is the first responder, it won't trigger move down animations
    engaged = [self.emailAddressTextField isFirstResponder] ? true : false;
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    // move everything down
    [self animateViewDown];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // test if the user touches outside of the text boxes and then hide the keyboard
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:self.view];
    
    if (!(CGRectContainsPoint(self.passwordTextField.frame, touchLocation) && (CGRectContainsPoint(self.emailAddressTextField.frame, touchLocation)))) {
        [self.passwordTextField resignFirstResponder];
        [self.emailAddressTextField resignFirstResponder];
    }
}

- (IBAction)signInPressed:(id)sender {
    // 3.0
    NSDictionary *sessionsParams = @{@"data" : @{
                                             @"type" : @"users",
                                             @"attributes" : @{
                                                     @"email" : self.emailAddressTextField.text,
                                                     @"password" : self.passwordTextField.text
                                                     }
                                             }
                                     };
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:sessionsParams options:0 error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:@"http://godiva.logiclabs.systems/api/v1/sessions/" parameters:nil error:nil];
    
    req.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue];
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [req setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    
    [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (!error) {
            NSLog(@"Reply JSON: %@", responseObject);
            // set the authentication token to keep the user logged in and save the user email
            NSLog(@"Success!");
            NSString *authKey = responseObject[@"data"][@"attributes"][@"authentication_token"];
            [userDefaults setObject:authKey forKey:@"authenticationToken"];
            
            // set the succeeded flag to true so that we can carry onto the app!
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            // grab the error information and display it as an alert
            NSDictionary *errorDict = [NSJSONSerialization JSONObjectWithData:[error userInfo][AFNetworkingOperationFailingURLResponseDataErrorKey] options:0 error:&error];
            
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Had trouble logging in."
                                                                           message:errorDict[@"message"]
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            // reset text when user presses okay to prep them for another entry
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:nil];
            
            // add action and display
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }] resume];
}

- (IBAction)signUpPressed:(id)sender {
    // 3.0
    __block BOOL succeeded;
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
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:0 error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:@"http://godiva.logiclabs.systems/api/v1/accounts/" parameters:nil error:nil];
    
    req.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue];
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [req setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    
    [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (!error) {
            NSLog(@"Reply JSON: %@", responseObject);
            // set the authentication token to keep the user logged in and save the user email
            NSLog(@"Success!");
            NSString *authKey = responseObject[@"data"][@"attributes"][@"authentication_token"];
            [userDefaults setObject:authKey forKey:@"authenticationToken"];
            
            // set the succeeded flag to true so that we can carry onto the app!
            succeeded = true;
        } else {
            // grab the error information and display it as an alert
            NSDictionary *errorDict = [NSJSONSerialization JSONObjectWithData:[error userInfo][AFNetworkingOperationFailingURLResponseDataErrorKey] options:0 error:&error];
            
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:errorDict[@"error"]
                                                                           message:errorDict[@"message"]
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            // reset text when user presses okay to prep them for another entry
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK"
                                                                    style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {
                                                                      self.passwordTextField.text = @"";
                                                                      self.emailAddressTextField.text = @"";
                                                                  }];
            
            // add action and display
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }] resume];
    
    if (succeeded) [self dismissViewControllerAnimated:YES completion:nil];
}
@end
