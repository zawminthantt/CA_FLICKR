//
//  AppDelegate.h
//  CA_FLICKR
//
//  Created by 劉炳成 on 11/8/13.
//  Copyright (c) 2013 劉炳成. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UINavigationController *navigationController;
@property (strong, nonatomic) AVAudioPlayer *audioPlayer;

@end
