//
//  HomeTimeLineController.m
//  Twitter
//
//  Created by Issen Su on 7/2/15.
//  Copyright (c) 2015 Issen Su. All rights reserved.
//

#import "HomeTimeLineController.h"
#import "ComposeViewcontroller.h"
#import "TweetDetailViewController.h"
#import "TwitterClient.h"
#import "Tweet.h"
#import "TweetCell.h"
#import "TweetDetailViewController.h"
#import <UIImageView+AFNetworking.h>

@interface HomeTimeLineController () <UITableViewDataSource, UITableViewDelegate, ComposeViewControllerDelegate>

@property (nonatomic, strong) NSArray *tweets;

@end


@implementation HomeTimeLineController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.timeLineTableView.delegate = self;
    self.timeLineTableView.dataSource = self;
    
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Compose" style:UIBarButtonItemStylePlain target:self action:@selector(onComposeButton)];
    self.title = @"Tweet";
    
    [self loadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [self loadData];
}

- (void)loadData {
    [[TwitterClient sharedInstance] homeTimelineWithParams:nil completion:^(NSArray *tweets, NSError *error) {
        NSLog(@"%@", tweets);
        if (tweets != nil) {
            self.tweets = tweets;
            [self.timeLineTableView reloadData];
        }
    }];
    NSLog(@"%@", self.tweets);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.tweets count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetCell *cell = [self.timeLineTableView dequeueReusableCellWithIdentifier:@"tweetCell"];
    
    Tweet *tweet = self.tweets[indexPath.row];
    cell.text.text = tweet.text;
    cell.userName.text = [NSString stringWithFormat:@"@%@", tweet.user.name];
    cell.screenName.text = tweet.user.screenName;
    [cell.profileImage setImageWithURL:[NSURL URLWithString:tweet.user.profileImageUrl]];
    int hours = floor([[NSDate date] timeIntervalSinceDate:tweet.createdAt] / 3600);
    cell.createdAtHour.text = [NSString stringWithFormat:@"%dh", hours];
    
    return cell;
}

- (void) onComposeButton {
    ComposeViewController *vc = [[ComposeViewController alloc] init];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)newTweet:(ComposeViewController *)sender tweetText:(NSString *)tweetText {
    NSLog(@"from compose");
    NSLog(@"tweet message = %@", tweetText);
    [[TwitterClient sharedInstance] tweet:tweetText repliesTo:nil completion:^(Tweet *tweet, NSError *error) {
        NSLog(@"new tweet");
    }];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.destinationViewController isKindOfClass:[TweetDetailViewController class]]){
        NSIndexPath *indexPath = [self.timeLineTableView indexPathForCell:sender];
        Tweet *tweet = self.tweets[indexPath.row];
        TweetDetailViewController *vc = segue.destinationViewController;
        vc.tweet = tweet;
    } else {
        ComposeViewController *vc = segue.destinationViewController;
        vc.delegate = self;
    }
}


@end
