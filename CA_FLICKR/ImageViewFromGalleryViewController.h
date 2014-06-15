//
//  ImageViewFromGalleryViewController.h
//  Flickr
//
//  Created by 劉炳成 on 10/8/13.
//  Copyright (c) 2013 劉炳成. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <Social/Social.h>

@interface ImageViewFromGalleryViewController : UIViewController < UIActionSheetDelegate, MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) UIImage *imageFromSearch;

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@end
