//
//  DataContainer.m
//  CA_FlickerApp
//
//  Created by 劉炳成 on 9/8/13.
//  Copyright (c) 2013 劉炳成. All rights reserved.
//

#import "DataContainer.h"

@implementation DataContainer

@synthesize contactDB;

- (void) createOrOpenDatabase
{
    // Do any additional setup after loading the view, typically from a nib.
    NSString *docsDir = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    // Build the PATH to the DATABASE File
    databasePath = [[NSString alloc] initWithString:[docsDir stringByAppendingPathComponent:@"contacts.sqlite"]];
    
    NSFileManager *filemgr = [NSFileManager defaultManager];
    const char *dbpath = [databasePath UTF8String];
    
    if ([filemgr fileExistsAtPath:databasePath] == NO) {
        if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK) {
            
            char *errMsg;
            const char *sql_stmt = "CREATE TABLE IF NOT EXISTS FAVOURITE (ID INTEGER PRIMARY KEY AUTOINCREMENT, PHOTOTITLE TEXT, LARGEPHOTOURL TEXT, SMALLPHOTOURL TEXT, COMMENT TEXT)";
            
            if (sqlite3_exec(contactDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK) {
                
                NSLog(@"Process Error");
            }
        
        }
        
        else{
            
           NSLog(@"Failed to create table");
        }
    }
    else{
        sqlite3_open(dbpath, &contactDB);
    }
}

- (int) execsql:(NSString *)stmt{
    
    sqlite3_stmt *statement;
    
    const char *sql_stmt = [stmt UTF8String];
    
    sqlite3_prepare_v2(contactDB, sql_stmt, -1, &statement, NULL);
    return (sqlite3_step(statement));
}

- (void) addFavourite:(NSString *)title andlargePhotoURL:(NSString *) lphotourl andsmallPhotoURL:(NSString *) sphotourl andComment:(NSString *) comment
{
    NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO FAVOURITE (phototitle, largephotourl, smallphotourl, comment) VALUES (\"%@\", \"%@\", \"%@\", \"%@\")", title, lphotourl, sphotourl, comment];
    NSLog(@"%@", insertSQL);
    
    if ([self execsql:insertSQL] == SQLITE_DONE) {
    
        NSLog(@"Successfully Added to Favourite List");
    }
    else{
        NSLog(@"Insertion Failed");
    }
}

- (void) showFavoriteList
{
    NSString *selectSQL = [NSString stringWithFormat:@"SELECT PHOTOTITLE, LARGEPHOTOURL, SMALLPHOTOURL, COMMENT FROM FAVOURITE"];
    
    sqlite3_stmt *statement;
    
    const char *quer_stmt = [selectSQL UTF8String];
    sqlite3_prepare_v2(contactDB, quer_stmt, -1, &statement, NULL);
    
    while (sqlite3_step(statement) == SQLITE_ROW) {
        
        NSString *title = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
        NSString *largephoto = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
        NSString *smallphoto = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
        NSString *comment = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)];
        [titleOfPhotoArray addObject:title];
        [urlOfLargePhotoArray addObject:largephoto];
        [urlOfSmallPhotoArray addObject:smallphoto];
        [commentArray addObject:comment];
        
        NSLog(@"%@", title);
        NSLog(@"%@", largephoto);
        NSLog(@"%@", smallphoto);
        NSLog(@"%@", comment);
        
    }
    sqlite3_finalize(statement);
}

- (void)deleteFromFavouriteList:(NSString *) largePhotoUrl{
 
    NSString *deleteQuery = [NSString stringWithFormat: @"DELETE FROM FAVOURITE WHERE LARGEPHOTOURL = \"%@\" ",largePhotoUrl ];
    
    if ([self execsql:deleteQuery] == SQLITE_DONE){
        NSLog(@"Deleting Successful");
    }

}

- (void)updateComment:(NSString *)comment{
    
    NSString *updateSQL = [NSString stringWithFormat:@"UPDATE FAVOURITE SET comment = \"%@\" ",comment];
    
    if ([self execsql:updateSQL] == SQLITE_DONE) {
        NSLog(@"Updating Successed");
    }
    else{
        NSLog(@"Updating Failed");
    }
}
@end
