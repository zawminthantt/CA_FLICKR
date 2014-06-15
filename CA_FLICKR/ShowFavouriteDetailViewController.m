//
//  ShowFavouriteDetailViewController.m
//  Flickr
//
//  Created by 劉炳成 on 11/8/13.
//  Copyright (c) 2013 劉炳成. All rights reserved.
//

#import "ShowFavouriteDetailViewController.h"

@interface ShowFavouriteDetailViewController (){
    LargePhotoViewController *largePhotoViewr;
    UIBarButtonItem *updateComment;
    UIBarButtonItem *deleteFromFavourite;
    UIBarButtonItem *actionButton;
}

@end

@implementation ShowFavouriteDetailViewController

@synthesize dContainer;
@synthesize favouriteDetailIageView;
@synthesize photoTitle, largePhotoUrl, smallPhotoUrl, comment;
@synthesize commentBeforeUpdate;

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
    largePhotoViewr = [[LargePhotoViewController alloc] init];
    
    // Do any additional setup after loading the view from its nib.
    updateComment = [[UIBarButtonItem alloc] initWithTitle:@"Update Comment" style:UIBarButtonItemStylePlain target:self action:@selector(Update:)];
   
    deleteFromFavourite = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deleteFromFavourite:)];
    
    actionButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(chooseAction:)];
    self.navigationItem.rightBarButtonItems = @[actionButton, deleteFromFavourite, updateComment];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    
    NSURL *imageUrl = [NSURL URLWithString:largePhotoUrl];
    NSData *imageData = [NSData dataWithContentsOfURL:imageUrl];
    favouriteDetailIageView.image = [UIImage imageWithData:imageData];
    commentBeforeUpdate.text = comment;
    commentBeforeUpdate.editable = FALSE;
}

- (void)deleteFromFavourite:(id)sender{
    
    UIAlertView *confirmDelete = [[UIAlertView alloc] initWithTitle:@"Confirm Delete" message:@"Are You Sure?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete", nil];
    
    [confirmDelete show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
        
        dContainer = [[DataContainer alloc] init];
        [dContainer createOrOpenDatabase];
        [dContainer deleteFromFavouriteList:largePhotoUrl];
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }
}

- (void) updateComment:(id)sender{
        
    NSString *newComment = commentBeforeUpdate.text;
    
    dContainer = [[DataContainer alloc] init];
    [dContainer createOrOpenDatabase];
    [dContainer updateComment:newComment];
    [commentBeforeUpdate resignFirstResponder];
    self.navigationItem.rightBarButtonItems = @[actionButton, deleteFromFavourite, updateComment];
    commentBeforeUpdate.text = FALSE;
}

- (IBAction)Update:(id)sender{
    self.commentBeforeUpdate.editable = true;
    if(self.commentBeforeUpdate.editable == true)
    {
        
        [self.commentBeforeUpdate becomeFirstResponder];
        
    }
    UIBarButtonItem *update = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:nil action:@selector(updateComment:)];
    self.navigationItem.rightBarButtonItems = @[update];
}
- (void) chooseAction:(id)sender
{
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"Share With" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Facebook", @"Twitter", @"Gmail ", nil];
    [action showFromBarButtonItem:actionButton animated:YES];
   // [action showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
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
            NSURL *url = [NSURL URLWithString:largePhotoUrl];
            NSData *data = [NSData dataWithContentsOfURL:url];
            
            [controller addImage:[UIImage imageWithData:data]];
            
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
            NSURL *url = [NSURL URLWithString:largePhotoUrl];
            NSData *data = [NSData dataWithContentsOfURL:url];
            
            [controller addImage:[UIImage imageWithData:data]];
            
            [self presentViewController:controller animated:YES completion:Nil];
            
        }
        else{
            
            NSLog(@"UnAvailable");
        }
        
    }
    
    if(buttonIndex == 2)
    {
        NSURL *url = [NSURL URLWithString:largePhotoUrl];
        NSData *imagedata = [NSData dataWithContentsOfURL:url];
        MFMailComposeViewController *emailViewController=[[MFMailComposeViewController alloc]init];
        
        emailViewController.mailComposeDelegate = self;
        [emailViewController setSubject:@"Flickr Photo Link"];
        [emailViewController setMessageBody:[NSString stringWithFormat:@"Here is the Original link of photo. \n %@",largePhotoUrl] isHTML:NO];
        [emailViewController addAttachmentData:imagedata mimeType:@"image/jpg" fileName:photoTitle];
        
        [self presentViewController:emailViewController animated:YES completion:nil];
    }

}

-(void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    [controller dismissViewControllerAnimated:YES completion:nil];
}


@end
