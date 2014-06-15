//
//  ShowFavoriteListViewController.h
//  Flickr
//
//  Created by 劉炳成 on 9/8/13.
//  Copyright (c) 2013 劉炳成. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataContainer.h"
#import "ShowFavouriteDetailViewController.h"

@interface ShowFavoriteListViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) DataContainer *dataContainer;

@property (strong, nonatomic) IBOutlet UITableView *showFavouriteTableView;
@property (strong, nonatomic) ShowFavouriteDetailViewController *showFavouriteDetailController;

@end
