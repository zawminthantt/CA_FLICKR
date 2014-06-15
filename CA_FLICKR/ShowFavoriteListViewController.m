//
//  ShowFavoriteListViewController.m
//  Flickr
//
//  Created by 劉炳成 on 9/8/13.
//  Copyright (c) 2013 劉炳成. All rights reserved.
//

#import "ShowFavoriteListViewController.h"

@interface ShowFavoriteListViewController ()
{
    NSMutableArray  *titleOfPhotoArray;
    NSMutableArray  *urlOfLargePhotoArray;
    NSMutableArray  *urlOfSmallPhotoArray;
    NSMutableArray *commentArray;
    
}

@end

@implementation ShowFavoriteListViewController

@synthesize dataContainer;
@synthesize showFavouriteTableView;
@synthesize showFavouriteDetailController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Favourite List";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    // Do any additional setup after loading the view from its nib.
    [[self showFavouriteTableView] setDelegate:self];
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
  //  self.navigationItem.rightBarButtonItems = @[self.editButtonItem, updateComment];
    
    
    titleOfPhotoArray = [[NSMutableArray alloc] init];
    urlOfLargePhotoArray = [[NSMutableArray alloc] init];
    urlOfSmallPhotoArray = [[NSMutableArray alloc] init];
    commentArray = [[NSMutableArray alloc] init];
    
    dataContainer = [[DataContainer alloc] init];
    
    NSLog(@"This is ShowFavoriteListViewController");
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [titleOfPhotoArray removeAllObjects];
    [urlOfLargePhotoArray removeAllObjects];
    [urlOfSmallPhotoArray removeAllObjects];
    [commentArray removeAllObjects];
  
    [dataContainer createOrOpenDatabase];
        
    NSString *selectSQL = [NSString stringWithFormat:@"SELECT PHOTOTITLE, LARGEPHOTOURL, SMALLPHOTOURL, COMMENT FROM FAVOURITE"];
    
    sqlite3_stmt *statement;
    
    const char *quer_stmt = [selectSQL UTF8String];
    sqlite3_prepare_v2(dataContainer.contactDB, quer_stmt, -1, &statement, NULL);
    
    while (sqlite3_step(statement) == SQLITE_ROW) {
        
        NSString *title = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
        NSString *largephoto = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
        NSString *smallphoto = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
        NSString *comment = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)];
       
        [titleOfPhotoArray addObject:title];
        [urlOfLargePhotoArray addObject:largephoto];
        [urlOfSmallPhotoArray addObject:smallphoto];
        [commentArray addObject:comment];
        
    }
    sqlite3_finalize(statement);
    
    [showFavouriteTableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [titleOfPhotoArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.textLabel.text = [titleOfPhotoArray objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [commentArray objectAtIndex:indexPath.row];
    
    NSURL *iurl = [NSURL URLWithString:[urlOfSmallPhotoArray objectAtIndex:indexPath.row]];
    NSData *image = [NSData dataWithContentsOfURL:iurl];
    cell.imageView.image = [UIImage imageWithData:image];
    
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
      //  dataContainer = [[DataContainer alloc] init];
        [dataContainer createOrOpenDatabase];
        [dataContainer deleteFromFavouriteList:[urlOfLargePhotoArray objectAtIndex:indexPath.row]];
        
        [titleOfPhotoArray removeObjectAtIndex:indexPath.row];
        [showFavouriteTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated{
    
    [super setEditing:editing animated:animated];
    [self.showFavouriteTableView setEditing:editing animated:animated];
    if (editing) {
        // you might disable other widgets here... (optional)
    } else {
        // re-enable disabled widgets (optional)
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    showFavouriteDetailController = [[ShowFavouriteDetailViewController alloc] init];
    showFavouriteDetailController.photoTitle = [titleOfPhotoArray objectAtIndex:indexPath.row];
    showFavouriteDetailController.largePhotoUrl = [urlOfLargePhotoArray objectAtIndex:indexPath.row];
    showFavouriteDetailController.smallPhotoUrl = [urlOfSmallPhotoArray objectAtIndex:indexPath.row];
    showFavouriteDetailController.comment = [commentArray objectAtIndex:indexPath.row];
    
    [self.navigationController pushViewController:showFavouriteDetailController animated:YES];
}

- (int) execsql:(NSString *)stmt{
    
    sqlite3_stmt *statement;
    
    const char *sql_stmt = [stmt UTF8String];
    
    sqlite3_prepare_v2(dataContainer.contactDB, sql_stmt, -1, &statement, NULL);
    return (sqlite3_step(statement));
}

- (void) updateComment:(id)sender{
    
    NSLog(@"CLicked");
}

- (void)viewWillDisappear:(BOOL)animated{
    
}
 
@end
