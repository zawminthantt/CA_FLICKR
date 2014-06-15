//
//  ShowFavouriteDetailViewController.h
//  Flickr
//
//  Created by 劉炳成 on 11/8/13.
//  Copyright (c) 2013 劉炳成. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataContainer.h"
#import "LargePhotoViewController.h"

@interface ShowFavouriteDetailViewController : UIViewController<UITextFieldDelegate, UITextViewDelegate, UIActionSheetDelegate, UIAlertViewDelegate, MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *favouriteDetailIageView;

@property (strong, nonatomic) NSString *photoTitle;
@property (strong, nonatomic) NSString *largePhotoUrl;
@property (strong, nonatomic) NSString *smallPhotoUrl;
@property (strong, nonatomic) NSString *comment;

@property (strong, nonatomic) DataContainer *dContainer;

@property (strong, nonatomic) IBOutlet UITextView *commentBeforeUpdate;

@end
