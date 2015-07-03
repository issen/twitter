//
//  AppDelegate.m
//  Twitter
//
//  Created by Issen Su on 7/2/15.
//  Copyright (c) 2015 Issen Su. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "TwitterClient.h"
#import "User.h"
#import "Tweet.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
//    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    self.window.rootViewController = [[LoginViewController alloc] init];
//    [self.window makeKeyAndVisible];
//    
//    
//    
//    return YES;
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLogout) name:UserDidLogoutNotificaiton object:nil];
    
    UIScreen *screen = [UIScreen mainScreen];
    UIWindow *window = [[UIWindow alloc] initWithFrame:screen.bounds];
    window.screen = screen;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *mainViewController = [storyboard instantiateInitialViewController];
    window.rootViewController = mainViewController;
    self.window = window;
    
    User *user = [User currentUser];
    if (user != nil) {
        NSLog(@"welcome back %@", user);
            UIViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"NavigationController"];
            [self.window setRootViewController:controller];
            //[self.window.rootViewController presentViewController:controller animated:YES completion:nil];
    } else {
        NSLog(@"Not logged in");
            UIViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"LoginView"];
        [self.window setRootViewController:controller];
            //[self.window.rootViewController presentViewController:controller animated:YES completion:nil];
        //self.window.rootViewController = [[LoginViewController alloc] init];
    }
    
    //[self.window makeKeyAndVisible];
    return YES;
}

- (void)userDidLogout {
    NSLog(@"User has logged out, go to login page");
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"NavigationController" bundle:nil];
    UIViewController *mainViewController = [storyboard instantiateInitialViewController];
    self.window.rootViewController = mainViewController;
    [self.window makeKeyAndVisible];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    [[TwitterClient sharedInstance] openURL:url];
//    [[TwitterClient sharedInstance] fetchAccessTokenWithPath:@"oauth/access_token" method:@"POST" requestToken:[BDBOAuth1Credential credentialWithQueryString:url.query]
//                                                     success:^(BDBOAuth1Credential *accessToken) {
//                                                         NSLog(@"got the access token");
//                                                         [[TwitterClient sharedInstance].requestSerializer saveAccessToken:accessToken];
//                                                         
//                                                         [[TwitterClient sharedInstance] GET:@"1.1/account/verify_credentials.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                                                             //NSLog(@"current user: %@", responseObject);
//                                                             User *user = [[User alloc] initWithDictionary:responseObject];
//                                                             NSLog(@"current user name: %@", user.name);
//                                                         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                                                             NSLog(@"failed getting current user");
//                                                         }];
//                                                         
//                                                         [[TwitterClient sharedInstance] GET:@"1.1/statuses/home_timeline.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                                                             //NSLog(@"tweets: %@", responseObject);
//                                                             NSArray *tweets = [Tweet tweetsWithArray:responseObject];
//                                                             for (Tweet *tweet in tweets) {
//                                                                 NSLog(@"Tweet: %@, created: %@", tweet.text, tweet.createdAt);
//                                                             }
//                                                         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                                                             NSLog(@"failed getting timeline message");
//                                                         }];
//                                                         
//                                                         
//                                                     } failure:^(NSError *error) {
//                                                         NSLog(@"failed to get the access token!");
//                                                     }];
    
    return YES;
}

@end
