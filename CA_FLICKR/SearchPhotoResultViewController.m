//
//  SearchPhotoResultViewController.m
//  Flickr
//
//  Created by 劉炳成 on 9/8/13.
//  Copyright (c) 2013 劉炳成. All rights reserved.
//

#import "SearchPhotoResultViewController.h"

@interface SearchPhotoResultViewController ()
{
    NSMutableData *webData;
    NSURLConnection *urlConnection;
    
    NSMutableArray  *photoTitles;
    NSMutableArray  *photoSmallImageData; 
    NSMutableArray  *photoURLsLargeImage;
    UIImage *imagefromlink;
    
}

@end

@implementation SearchPhotoResultViewController

@synthesize photoName, myTableView;
@synthesize loadingIndicator;

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
    [[self myTableView] setDelegate:self];
    
    NSString *str = [photoName stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    
    NSString *urlString = [NSString stringWithFormat:@"http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=47e8ef879005b39fff23a889e1b44aa8&tags=%@&per_page=100&format=json&nojsoncallback=1",str];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    urlConnection = [NSURLConnection connectionWithRequest:request delegate:self];
    
    if (urlConnection) {
        webData = [[NSMutableData alloc] init];
    }
    
    photoTitles = [[NSMutableArray alloc] init];
    photoSmallImageData = [[NSMutableArray alloc] init];
    photoURLsLargeImage = [[NSMutableArray alloc] init];
    
    NSLog(@"%@", photoName);
    [loadingIndicator startAnimating];
    //[loadingIndicator makeTextWritingDirectionLeftToRight:@"Loading"];
   // [loadingIndicator setHidden:FALSE];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [webData setLength:0];
    NSLog(@"Connection Response Received");
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [webData appendData:data];
    NSLog(@"Data Received");
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Failed with Error!");
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSDictionary *allDataDictionary = [NSJSONSerialization JSONObjectWithData:webData options:0 error:nil];
    NSDictionary *photos = [allDataDictionary objectForKey:@"photos"];
    NSArray *arrayOfPhoto = [photos objectForKey:@"photo"];
    
   // NSLog(@"array of photos: %@",arrayOfPhoto);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
    for (NSDictionary *diction in arrayOfPhoto) {
        
        NSString *title = [diction objectForKey:@"title"];
        [photoTitles addObject:(title.length > 0 ? title : @"Untitled")];
        
        NSString *photoURLString =
        [NSString stringWithFormat:@"http://farm%@.static.flickr.com/%@/%@_%@_s.jpg",
         [diction objectForKey:@"farm"], [diction objectForKey:@"server"],
         [diction objectForKey:@"id"], [diction objectForKey:@"secret"]];
        
        NSLog(@"photo name founded at didFinishLaunching %@", photoURLString);
        [photoSmallImageData addObject:[NSURL URLWithString:photoURLString]];
        
        photoURLString =
        [NSString stringWithFormat:@"http://farm%@.static.flickr.com/%@/%@_%@_b.jpg",
         [diction objectForKey:@"farm"], [diction objectForKey:@"server"],
         [diction objectForKey:@"id"], [diction objectForKey:@"secret"]];
        [photoURLsLargeImage addObject:[NSURL URLWithString:photoURLString]];
        
    }
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            [[self myTableView] reloadData];
        });
        
        
    });
    
    [[self myTableView] reloadData];
    
        [loadingIndicator stopAnimating];
    
   // [loadingIndicator setHidden:TRUE];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [photoTitles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = [photoTitles objectAtIndex:indexPath.row];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[photoSmallImageData objectAtIndex:indexPath.row]]];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            cell.imageView.image = image;
            
        });
    });
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LargePhotoViewController *largePhotoViewController = [[LargePhotoViewController alloc] init];
    largePhotoViewController.photoTitle = [photoTitles objectAtIndex:indexPath.row];
    largePhotoViewController.detailPhotourlLarge = [photoURLsLargeImage objectAtIndex:indexPath.row];
    largePhotoViewController.detailPhotoUrlSmall = [photoSmallImageData objectAtIndex:indexPath.row];
    
    [self.navigationController pushViewController:largePhotoViewController animated:YES];
}

@end
