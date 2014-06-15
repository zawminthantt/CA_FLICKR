//
//  SearchPhotoViewController.m
//  Flickr
//
//  Created by 劉炳成 on 9/8/13.
//  Copyright (c) 2013 劉炳成. All rights reserved.
//

#import "SearchPhotoViewController.h"

@interface SearchPhotoViewController ()

@end

@implementation SearchPhotoViewController

@synthesize chooseFromGallery, camera;
@synthesize searchBarPhotoSearchButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [searchBarPhotoSearchButton setShowsCancelButton:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showFavoriteList:(id)sender {
    
    ShowFavoriteListViewController *showFavoriteListViewController = [[ShowFavoriteListViewController alloc] init];
    [self.navigationController pushViewController:showFavoriteListViewController animated:YES];
}

- (IBAction)getPhoto:(id)sender
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;

    if ((UIButton *) sender == chooseFromGallery) {
        
        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    }
    else{
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    ImageViewFromGalleryViewController *imageViewController = [[ImageViewFromGalleryViewController alloc] init];
    imageViewController.imageFromSearch = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    [self.navigationController pushViewController:imageViewController animated:YES];
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBarPhotoSearchButton resignFirstResponder];
    searchBarPhotoSearchButton.text = @"";
   
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBarPhotoSearchButton resignFirstResponder];
    SearchPhotoResultViewController *searchResultViewController = [[SearchPhotoResultViewController alloc] init];
    searchResultViewController.photoName = searchBarPhotoSearchButton.text;
    [self.navigationController pushViewController:searchResultViewController animated:YES];
    searchBarPhotoSearchButton.text=@"";
    
}

@end
