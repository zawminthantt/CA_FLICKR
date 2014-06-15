//
//  AppDelegate.m
//  CA_FLICKR
//
//  Created by 劉炳成 on 11/8/13.
//  Copyright (c) 2013 劉炳成. All rights reserved.
//

#import "AppDelegate.h"
#import "SearchPhotoViewController.h"

@implementation AppDelegate

@synthesize audioPlayer;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    SearchPhotoViewController *searchPhotoViewController = [[SearchPhotoViewController alloc] initWithNibName:@"SearchPhotoViewController" bundle:nil];
    
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:searchPhotoViewController];
    
    self.window.rootViewController = self.navigationController;
    
    [self.window makeKeyAndVisible];
    
    NSURL *audioFileUrlLocation = [[NSBundle mainBundle] URLForResource:@"04 Just Give Me a Reason (www.SongsLover.pk)" withExtension:@"mp3"];
    NSError *error;
    
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:audioFileUrlLocation error:&error];
    [audioPlayer setNumberOfLoops:-1];
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    [audioPlayer prepareToPlay];
    [audioPlayer play];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [audioPlayer stop];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [audioPlayer play];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [audioPlayer stop];
}

@end
