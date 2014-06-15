//
//  SearchPhotoViewController.h
//  Flickr
//
//  Created by 劉炳成 on 9/8/13.
//  Copyright (c) 2013 劉炳成. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchPhotoResultViewController.h"
#import "ShowFavoriteListViewController.h"
#import "ImageViewFromGalleryViewController.h"

@interface SearchPhotoViewController : UIViewController<UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UISearchBarDelegate>


@property (strong, nonatomic) IBOutlet UIButton *chooseFromGallery;
@property (strong, nonatomic) IBOutlet UIButton *camera;

- (IBAction)showFavoriteList:(id)sender;

- (IBAction)getPhoto:(id)sender;

@property (strong, nonatomic) IBOutlet UISearchBar *searchBarPhotoSearchButton;

@end