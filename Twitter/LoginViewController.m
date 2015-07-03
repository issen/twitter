//
//  LoginViewController.m
//  Twitter
//
//  Created by Issen Su on 7/2/15.
//  Copyright (c) 2015 Issen Su. All rights reserved.
//

#import "LoginViewController.h"
#import "TwitterClient.h"
#import "HomeTimeLineController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController
- (IBAction)onLogin:(id)sender {
//    [[TwitterClient sharedInstance].requestSerializer removeAccessToken];
//    [[TwitterClient sharedInstance] fetchRequestTokenWithPath:@"oauth/request_token"
//                                                       method:@"GET"
//                                                  callbackURL:[NSURL URLWithString:@"iosStudy://oauth"]
//                                                        scope:nil
//                                                      success:^(BDBOAuth1Credential *requestToken){
//                                                          NSLog(@"got the request token");
//                                                          
//                                                          NSURL *authURL = [NSURL URLWithString:[NSString
//                                                                                                 stringWithFormat:@"https://api.twitter.com/oauth/authorize?oauth_token=%@", requestToken.token]];
//                                                          [[UIApplication sharedApplication] openURL:authURL];
//                                                      }
//                                                      failure:^(NSError *error){
//                                                          NSLog(@"%@", error);
//                                                          NSLog(@"Failed to get the request token");
//                                                      }];
    [[TwitterClient sharedInstance] loginWithCompletion:^(User *user, NSError *error) {
        if (user != nil) {
            NSLog(@"login succeed : %@", user.name);
            UIStoryboard *sb = self.storyboard;
            HomeTimeLineController *controller = [sb instantiateViewControllerWithIdentifier:@"HomeTimeLine"];
            [self presentViewController:controller animated:YES completion:nil];
        } else {
            NSLog(@"login failed");
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
