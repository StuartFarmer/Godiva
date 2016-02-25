//
//  DiscoverCardViewController.m
//  Godiva
//
//  Created by Stuart Farmer on 12/11/15.
//  Copyright © 2015 app.kitchen. All rights reserved.
//

#import "DiscoverCardViewController.h"
#import "CGPoint+Vector.h"
#import "GodivaProductManager.h"
#import "NSData+Base64.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface DiscoverCardViewController () {
    NSNotificationCenter *notificationCenter;
    NSUserDefaults *userDefaults;
    CGPoint initialPoint;
    Product *product;
    NSMutableArray *productArray;
    MBProgressHUD *hud;
}

@end

@implementation DiscoverCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set up notification center
    notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(saveProduct:) name:@"saveProduct" object:nil];
    [notificationCenter addObserver:self selector:@selector(deleteProduct:) name:@"deleteProduct" object:nil];
    [notificationCenter addObserver:self selector:@selector(resetCard:) name:@"resetCard" object:nil];
    [notificationCenter addObserver:self selector:@selector(contextChanged:) name:@"contextChanged" object:nil];
    [notificationCenter addObserver:self selector:@selector(productsAtProductFloor:) name:@"productsAtProductFloor" object:nil];
    [notificationCenter addObserver:self selector:@selector(productsAtProductCeiling:) name:@"productsAtProductCeiling" object:nil];
    
    // Initiate user defaults
    [NSUserDefaults standardUserDefaults];
    
    productArray = (NSMutableArray *)[[GodivaProductManager sharedInstance] getProductsWithType:[[NSUserDefaults standardUserDefaults] stringForKey:@"selectedObject"]];
    
    if ([[GodivaProductManager sharedInstance] productsExistForContext:[[NSUserDefaults standardUserDefaults] stringForKey:@"selectedObject"]]) product = [productArray objectAtIndex:0];
    
    self.view.layer.cornerRadius = 8.0f;
    initialPoint = self.view.center;
    
    //Set up as if there are no cards present
    [self hideUIElements];
    
    // Load the first card
    [self resetView];
    
    if ([[GodivaProductManager sharedInstance] productsExistForContext:[[NSUserDefaults standardUserDefaults] stringForKey:@"selectedObject"]]) [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"loading"];
    else [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"loading"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)resetCard:(NSNotification *)notification {
    NSLog(@"Resetting card.");
    self.view.layer.cornerRadius = 8.0f;
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.alpha = 1.0f;
    self.view.layer.borderWidth = 0;
    [self resetView];
}

- (void)saveProduct:(NSNotification *)notification {
    NSLog(@"Saving Card.");
    
    Product *copy = [[Product alloc] init];
    copy.identifier = product.identifier;
    copy.userID = product.userID;
    copy.productID = product.productID;
    
    // Remove card from product array
    [productArray removeObject:product];
    
    // Update card in realm
    if ([[GodivaProductManager sharedInstance] productsExistForContext:[[NSUserDefaults standardUserDefaults] stringForKey:@"selectedObject"]]) {
        Product *update = [Product objectForPrimaryKey:product.uuid];
        [[RLMRealm defaultRealm] beginWriteTransaction];
        product.type = @"saved";
        [[RLMRealm defaultRealm] addOrUpdateObject:update];
        [[RLMRealm defaultRealm] commitWriteTransaction];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"productSaved" object:nil];
    } else {
        NSLog(@"Woohoo.");
    }
    
    // send back POST
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [self sendBackPOSTRequest:YES ForObject:copy];
    });
}

- (void)deleteProduct:(NSNotification *)notification {
    NSLog(@"Deleting Card.");
    Product *copy = [[Product alloc] init];
    copy.identifier = product.identifier;
    copy.userID = product.userID;
    copy.productID = product.productID;
    
    // Remove card from product array
    [productArray removeObject:product];
    
    // Update card in realm
    if ([[GodivaProductManager sharedInstance] productsExistForContext:[[NSUserDefaults standardUserDefaults] stringForKey:@"selectedObject"]]) {
        //dispatch_async(dispatch_queue_create("db", DISPATCH_QUEUE_SERIAL), ^{
            Product *update = [Product objectForPrimaryKey:product.uuid];
            [[RLMRealm defaultRealm] beginWriteTransaction];
            [[RLMRealm defaultRealm] deleteObject:update];
            [[RLMRealm defaultRealm] commitWriteTransaction];
        //});
    } else {
        NSLog(@"Woohoo.");
    }
    
    // send back POST
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [self sendBackPOSTRequest:NO ForObject:copy];
    });
    
}

- (void)sendBackPOSTRequest:(BOOL)saved ForObject:(Product *)AProduct {
    // 3.0
    NSDictionary *params = @{@"data" : @{
                                     @"id" : AProduct.identifier,
                                     @"type" : @"user_products",
                                     @"attributes" : @{
                                             @"user_id" : AProduct.userID,
                                             @"interaction_type" : saved ? @"r" : @"l",
                                             @"product_id" : AProduct.productID
                                             }
                                     }
                             };
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:0 error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:[NSString stringWithFormat:@"http://godiva.logiclabs.systems/api/v1/user_products/?user_email=%@&user_token=%@", [[NSUserDefaults standardUserDefaults] stringForKey:@"email"], [[NSUserDefaults standardUserDefaults] stringForKey:@"authenticationToken"]] parameters:nil error:nil];
    
    req.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue];
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [req setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSLog(@"%@", jsonString);
    
    [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (!error) {
            NSLog(@"Succeeded in sending back product to server.");
        } else {
            NSLog(@"%@", error);
        }
    }] resume];
}

- (void)contextChanged:(NSNotification *)notification {
    // get new objects and update view
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"url"];
    productArray = (NSMutableArray *)[[GodivaProductManager sharedInstance] getProductsWithType:[[NSUserDefaults standardUserDefaults] stringForKey:@"selectedObject"]];
    [self resetView];
}

- (void)productsAtProductFloor:(NSNotification *)notification {
    [hud hide:YES];
}

- (void)productsAtProductCeiling:(NSNotification *)notification {
    [self resetView];
    
    // remove hud
    [hud hide:YES];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"loading"];
}

- (void)hideUIElements {
    self.outOfCardsLabel.hidden = NO;
    self.imageView.hidden = YES;
    self.productLabel.hidden = YES;
    self.priceLabel.hidden = YES;
}

- (void)showUIElements {
    self.outOfCardsLabel.hidden = YES;
    self.imageView.hidden = NO;
    self.productLabel.hidden = NO;
    self.priceLabel.hidden = NO;
}

- (void)resetView {
    [hud hide:YES];
    
    if ([[GodivaProductManager sharedInstance] productCountForContext:[[NSUserDefaults standardUserDefaults] stringForKey:@"selectedObject"]] <= PRODUCT_FLOOR) [[GodivaProductManager sharedInstance] updateForContextType:[[NSUserDefaults standardUserDefaults] stringForKey:@"selectedObject"]];
    
    productArray = (NSMutableArray *)[[GodivaProductManager sharedInstance] getProductsWithType:[[NSUserDefaults standardUserDefaults] stringForKey:@"selectedObject"]];
    NSString *type = [[NSUserDefaults standardUserDefaults] stringForKey:@"selectedObject"];
    
    if ([[GodivaProductManager sharedInstance] productsExistForContext:type]) {
        [self showUIElements];
        [hud hide:YES];
        NSLog(@"type: %@", type);
        product = [productArray objectAtIndex:0];
        self.imageView.image = [UIImage imageWithData:product.image];
        self.productLabel.text = product.name;
        self.priceLabel.text = [NSString stringWithFormat:@"$%.2f", [product.price floatValue]];
        [[NSUserDefaults standardUserDefaults] setURL:[NSURL URLWithString:product.clickURL] forKey:@"url"];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"loading"];
    } else {
        NSLog(@"No cards to show...");
        [[GodivaProductManager sharedInstance] updateForContextType:[[NSUserDefaults standardUserDefaults] stringForKey:@"selectedObject"]];
        // show hud
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.labelText = @"Loading";
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"loading"];
        
        [self hideUIElements];
    }
}

@end
