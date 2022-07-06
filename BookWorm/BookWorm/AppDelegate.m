//
//  AppDelegate.m
//  BookWorm
//
//  Created by Ramya Prabakar on 7/5/22.
//

#import "AppDelegate.h"
#import "Parse/Parse.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>//

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    ParseClientConfiguration *config = [ParseClientConfiguration  configurationWithBlock:^(id<ParseMutableClientConfiguration> configuration) {

            configuration.applicationId = @"DPg6h9RRorCT14BpKiNn649Q4WdPHsndyIHEchD5";
            configuration.clientKey = @"nixeQNoSANEGpqu7l3vDstB9IrSdamoYK22RNThS";
            configuration.server = @"https://parseapi.back4app.com";
        }];

    [Parse initializeWithConfiguration:config];
    
    PFObject *gameScore = [PFObject objectWithClassName:@"GameScore"];
    gameScore[@"score"] = @1337;
    gameScore[@"playerName"] = @"Sean Plott";
    gameScore[@"cheatMode"] = @NO;
    [gameScore saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"Object saved!");
        } else {
            NSLog(@"Error: %@", error.description);
        }
    }];

    [[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
    
    return handled;
}

#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
