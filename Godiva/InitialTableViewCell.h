//
//  InitialTableViewCell.h
//  Godiva
//
//  Created by Stuart Farmer on 1/25/16.
//  Copyright © 2016 app.kitchen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InitialTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *ornamentLabel;

@end
