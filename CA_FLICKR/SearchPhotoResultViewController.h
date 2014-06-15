                                                                 //
//  SearchPhotoResultViewController.h
//  Flickr
//
//  Created by 劉炳成 on 9/8/13.
//  Copyright (c) 2013 劉炳成. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LargePhotoViewController.h"

@interface SearchPhotoResultViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, NSURLConnectionDataDelegate, UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *myTableView;

@property (strong, nonatomic) NSString *photoName;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;
@end
