//
//  LoginViewController.m
//  Godiva
//
//  Created by Stuart Farmer on 1/24/16.
//  Copyright © 2016 app.kitchen. All rights reserved.
//

#import "LoginViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>

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
    
    self.stackView.frame = self.view.frame;
}

- (void)keyboardWillChange:(NSNotification *)notification {
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue *keyboardHeight = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    NSValue *keyboardHeight2 = [keyboardInfo valueForKey:UIKeyboardFrameEndUserInfoKey];
    NSLog(@"begin: %@/nend: %@", keyboardHeight, keyboardHeight2);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Loading";
    
    [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        [hud hide:YES];
        if (!error) {
            NSLog(@"Reply JSON: %@", responseObject);
            // set the authentication token to keep the user logged in and save the user email
            NSLog(@"Success!");
            NSString *authKey = responseObject[@"data"][@"attributes"][@"authentication_token"];
            [userDefaults setObject:authKey forKey:@"authenticationToken"];
            [userDefaults setObject:responseObject[@"data"][@"attributes"][@"email"] forKey:@"email"];
            
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
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Loading";
    
    [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        [hud hide:YES];
        
        if (!error) {
            NSLog(@"Reply JSON: %@", responseObject);
            // set the authentication token to keep the user logged in and save the user email
            NSLog(@"Success!");
            NSString *authKey = responseObject[@"data"][@"attributes"][@"authentication_token"];
            [userDefaults setObject:authKey forKey:@"authenticationToken"];
            [userDefaults setObject:responseObject[@"data"][@"attributes"][@"email"] forKey:@"email"];
            
            // set the succeeded flag to true so that we can carry onto the app!
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            // grab the error information and display it as an alert
            NSDictionary *errorDict = [NSJSONSerialization JSONObjectWithData:[error userInfo][AFNetworkingOperationFailingURLResponseDataErrorKey] options:0 error:&error];
            
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:errorDict[@"error"]
                                                                           message:errorDict[@"message"]
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            // reset text when user presses okay to prep them for another entry
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK"
                                                                    style:UIAlertActionStyleDefault
                                                                  handler:nil];
            
            // add action and display
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }] resume];
    
    if (succeeded) [self dismissViewControllerAnimated:YES completion:nil];
}
@end
