//
//  ImageViewFromGalleryViewController.m
//  Flickr
//
//  Created by 劉炳成 on 10/8/13.
//  Copyright (c) 2013 劉炳成. All rights reserved.
//

#import "ImageViewFromGalleryViewController.h"

@interface ImageViewFromGalleryViewController ()

@end

@implementation ImageViewFromGalleryViewController
@synthesize imageFromSearch;
@synthesize imageView;

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
    imageView.image = imageFromSearch;
    
    UIBarButtonItem *actionButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(chooseAction:)];
    self.navigationItem.rightBarButtonItem = actionButton;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{

    
        
}

- (void) chooseAction:(id)sender
{
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"Share With" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Facebook", @"Twitter", @"Gmail ", nil];
    
    [action showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
        if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
            
            SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
            
            SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result){
                if (result == SLComposeViewControllerResultCancelled) {
                    NSLog(@"Cancelled");
                } else
                {
                    NSLog(@"Successfully Posted to FaceBook");
                }
                [controller dismissViewControllerAnimated:YES completion:Nil];
            };
            controller.completionHandler =myBlock;
            
            [controller setInitialText:@"Test Post from ZECK"];
            
            [controller addImage:imageView.image];
            
            [self presentViewController:controller animated:YES completion:Nil];
            
        }
        
        else{
            NSLog(@"UnAvailable");
        }
        
    }
    
    if (buttonIndex == 1) {
        
        if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
            
            SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
            
            SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result){
                if (result == SLComposeViewControllerResultCancelled) {
                    NSLog(@"Cancelled");
                } else
                {
                    NSLog(@"Successful Posted to Twitter");
                }
                [controller dismissViewControllerAnimated:YES completion:Nil];
            };
            controller.completionHandler =myBlock;
            
            [controller setInitialText:@"This is a tweet from iOS 6 Social Framework"];
            
            [controller addImage:imageView.image];
            
            [self presentViewController:controller animated:YES completion:Nil];
            
        }
        else{
            
            NSLog(@"UnAvailable");
        }
        
    }
    
    if(buttonIndex == 2)
    {
        NSData *imagedata = UIImageJPEGRepresentation(imageView.image, 0.5);
        
        MFMailComposeViewController *emailViewController=[[MFMailComposeViewController alloc]init];
        emailViewController.mailComposeDelegate = self;
        [emailViewController setSubject:@"Photo Attachement"];
        [emailViewController setMessageBody:[NSString stringWithFormat:@"Sharing some Memory with you!"] isHTML:NO];
        [emailViewController addAttachmentData:imagedata mimeType:@"image/jpg" fileName:@"Some Memoriable"];
        
        [self presentViewController:emailViewController animated:YES completion:nil];
    }
    
}

-(void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    
    [controller dismissViewControllerAnimated:YES completion:nil];
}

@end
