//
//  WishlistViewController.m
//  Godiva
//
//  Created by Stuart Farmer on 11/29/15.
//  Copyright © 2015 app.kitchen. All rights reserved.
//

#import "WishlistViewController.h"
#import "ProductTableViewCell.h"
#import "Product.h"

@import SafariServices;
@import QuartzCore;

@interface WishlistViewController () {
    RLMRealm *realm;
    RLMResults *products;
    NSMutableArray *cells;
}

@end

@implementation WishlistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    
    self.initialWishListView.alpha = 0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productSaved:) name:@"productSaved" object:nil]
    ;
    [self loadCells];
}

- (void)loadCells {
    // get only the products that have been saved
    products = [Product objectsWhere:@"type = 'saved'"];
}

- (void)productSaved:(NSNotification *)notification {
    [self loadCells];
    [_tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return products.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // load wishlist cells
    //if (products.count > 1) {
    if (products.count < 1) self.initialWishListView.alpha = 1;
    ProductTableViewCell *cell = (ProductTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ProductTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    Product *product = [products objectAtIndex:indexPath.row];

    // Load cell assets
    cell.productLabel.text = product.name;
    cell.brandLabel.text = product.brandName;
    cell.priceLabel.text = [NSString stringWithFormat:@"$%.2f", [product.price floatValue]];
    UIImage *image = [UIImage imageWithData:product.image];
    cell.imageView.image = image;
    
    return cell;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Product *product = [products objectAtIndex:indexPath.row];
        [[RLMRealm defaultRealm] beginWriteTransaction];
        [[RLMRealm defaultRealm] deleteObject:product];
        [[RLMRealm defaultRealm] commitWriteTransaction];

        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

// present the affiliate link when tapped
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Product *product = [products objectAtIndex:indexPath.row];
    SFSafariViewController *safariViewController = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:product.clickURL]];
    [self presentViewController:safariViewController animated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
