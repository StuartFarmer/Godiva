//
//  WishlistViewController.m
//  Godiva
//
//  Created by Stuart Farmer on 11/29/15.
//  Copyright © 2015 app.kitchen. All rights reserved.
//

#import "WishlistViewController.h"
#import "ProductTableViewCell.h"
#import "InitialTableViewCell.h"
#import "Product.h"

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
    
    // Set up Realm
    realm = [RLMRealm defaultRealm];
    
    Product *something = [[Product alloc] init];
    
    [realm beginWriteTransaction];
    something.productName = @"Super Duper Scarf Deluxe";
    something.productType = @"accessories";
    something.price = 20.00f;
    something.image = (UIImagePNGRepresentation([UIImage imageNamed:@"accessories.jpg"]));
    something.type = @"saved";
    something.brandName = @"H&M";
    [realm commitWriteTransaction];
    
    [self loadCells];
}

- (void)loadCells {
    // get only the products that have been saved
    //products = [Product objectsWhere:@"type = 'saved'"];
    products = [Product allObjects];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return products.count ? products.count : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (products.count > 0) {
        // load wishlist cells
        ProductTableViewCell *cell = (ProductTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ProductTableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        Product *product = [products objectAtIndex:indexPath.row];
        
        // Load cell assets
        cell.productLabel.text = product.productName;
        cell.brandLabel.text = product.brandName;
        cell.priceLabel.text = [NSString stringWithFormat:@"%0.2f", product.price];
        cell.imageView.image = [UIImage imageWithData:product.image];
        
        return cell;
        
    } else {
        // load initial cell
        [tableView registerClass:[InitialTableViewCell class] forCellReuseIdentifier:@"initialCell"];

        InitialTableViewCell *cell = (InitialTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"initialCell" forIndexPath:indexPath];
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"InitialTableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        return cell;
    }
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
