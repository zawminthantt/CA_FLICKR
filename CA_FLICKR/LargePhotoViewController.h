//
//  LargePhotoViewController.h
//  Flickr
//
//  Created by 劉炳成 on 9/8/13.
//  Copyright (c) 2013 劉炳成. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <Social/Social.h>
#import "DataContainer.h"

@interface LargePhotoViewController : UIViewController<UIActionSheetDelegate, UIAlertViewDelegate, MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UILabel *labelPhotoTitle;

@property (strong, nonatomic) IBOutlet UIImageView *detailImageVIew;

@property (strong, nonatomic) NSString *photoTitle;
@property (strong, nonatomic) NSString *detailPhotourlLarge;
@property (strong, nonatomic) NSString *detailPhotoUrlSmall;
@property (strong, nonatomic) UIAlertView *alert;

- (void) chooseAction:(id)sender;

@end
