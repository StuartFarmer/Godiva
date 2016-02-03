//
//  WishlistViewController.h
//  Godiva
//
//  Created by Stuart Farmer on 11/29/15.
//  Copyright © 2015 app.kitchen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Realm/Realm.h>

@interface WishlistViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *wishListView;
@property (weak, nonatomic) IBOutlet UIView *initialWishListView;

@end
