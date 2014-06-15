//
//  DataContainer.h
//  CA_FlickerApp
//
//  Created by 劉炳成 on 9/8/13.
//  Copyright (c) 2013 劉炳成. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"
//#import "ShowFavoriteListControllerViewController.h"

@interface DataContainer : NSObject
{
    sqlite3 *contactDB;
    NSString *databasePath;
    
    NSMutableArray  *titleOfPhotoArray;
    NSMutableArray  *urlOfLargePhotoArray;
    NSMutableArray  *urlOfSmallPhotoArray;
    NSMutableArray *commentArray;
}

@property (nonatomic, assign) sqlite3 *contactDB;

- (void) createOrOpenDatabase;

- (int) execsql: (NSString *)stmt;

- (void) addFavourite:(NSString *)title andlargePhotoURL:(NSString *) lphotourl andsmallPhotoURL:(NSString *) sphotourl andComment:(NSString *) comment;

- (void) showFavoriteList;

- (void)deleteFromFavouriteList:(NSString *) title;

- (void)updateComment:(NSString *)comment;

@end
