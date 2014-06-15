//
//  LargePhotoViewController.m
//  Flickr
//
//  Created by 劉炳成 on 9/8/13.
//  Copyright (c) 2013 劉炳成. All rights reserved.
//

#import "LargePhotoViewController.h"

@interface LargePhotoViewController ()

@end

@implementation LargePhotoViewController

@synthesize photoTitle, detailPhotourlLarge, detailPhotoUrlSmall, detailImageVIew, labelPhotoTitle;

@synthesize alert;

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
    
    //UIBarItem For ActionSheet
    UIBarButtonItem *actionButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(chooseAction:)];
    
    UIBarButtonItem *goHome = [[UIBarButtonItem alloc] initWithTitle:@"Home" style:UIBarButtonItemStylePlain target:self action:@selector(goToHome:)];
    
    UIBarButtonItem *addToFavourite = [[UIBarButtonItem alloc] initWithTitle:@"Add To Favourite" style:UIBarButtonItemStylePlain target:self action:@selector(addToFavourite:)];
    
    self.navigationItem.rightBarButtonItems = @[actionButton,addToFavourite, goHome];

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    labelPhotoTitle.text = photoTitle;
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:detailPhotourlLarge]];
    detailImageVIew.image = [UIImage imageWithData:imageData];
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
            
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:detailPhotourlLarge]];
            
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
            
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:detailPhotourlLarge]];
            
            [controller addImage:[UIImage imageWithData:data]];
            
            [self presentViewController:controller animated:YES completion:Nil];
            
        }
        else{
            
            NSLog(@"UnAvailable");
        }
        
    }
    
    if(buttonIndex == 2)
    {
        
        NSData *imagedata = [NSData dataWithContentsOfURL:[NSURL URLWithString:detailPhotourlLarge]];
        MFMailComposeViewController *emailViewController=[[MFMailComposeViewController alloc]init];
        emailViewController.mailComposeDelegate = self;
        [emailViewController setSubject:@"Flickr Photo Link"];
        [emailViewController setMessageBody:[NSString stringWithFormat:@"Here is the Original link of photo. \n %@",detailPhotourlLarge] isHTML:NO];
        [emailViewController addAttachmentData:imagedata mimeType:@"image/jpg" fileName:photoTitle];
        
        [self presentViewController:emailViewController animated:YES completion:nil];
    }

}

-(void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)addToFavourite:(id)sender {
    
    alert = [[UIAlertView alloc] initWithTitle:@"Comment" message:@"Enter Your Comment" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
        NSString *cm = [[alert textFieldAtIndex:0] text];
        DataContainer *dc = [[DataContainer alloc] init];
        [dc createOrOpenDatabase];
        [dc addFavourite:photoTitle andlargePhotoURL:detailPhotourlLarge andsmallPhotoURL:detailPhotoUrlSmall andComment:cm];
    }
}

- (void) goToHome:(id) sender{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
