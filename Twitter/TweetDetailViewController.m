//
//  TweetDetailViewController.m
//  Twitter
//
//  Created by Issen Su on 7/2/15.
//  Copyright (c) 2015 Issen Su. All rights reserved.
//

#import "TweetDetailViewController.h"
#import "TwitterClient.h"
#import "ComposeViewController.h"
#import <UIImageView+AFNetworking.h>

@interface TweetDetailViewController () <ComposeViewControllerDelegate>

@end

@implementation TweetDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tweetMessage.text = self.tweet.text;
    [self.profileImage setImageWithURL:[NSURL URLWithString:self.tweet.user.profileImageUrl]];
    self.screenName.text = self.tweet.user.screenName;
    self.name.text = [NSString stringWithFormat:@"@%@", self.tweet.user.name];
    self.retweetCount.text = [NSString stringWithFormat:@"%ld", self.tweet.RetweetsCount];
    self.favoriteCount.text = [NSString stringWithFormat:@"%ld", self.tweet.favoritesCount];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"EEEE MM d HH:mm:ss y";
    
    self.dateTimeLabel.text = [formatter stringFromDate:self.tweet.createdAt];
    
    if (self.tweet.isRetweet) {
        [self.btnRetweet setImage:[UIImage imageNamed:@"tweet_retweet_on.png"] forState:UIControlStateNormal];
    }
    
    if (self.tweet.isFavorite) {
        [self.btnFavoriate setImage:[UIImage imageNamed:@"tweet_favorite_on.png"] forState:UIControlStateNormal];
    }
    
    
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"tweet" style:UIBarButtonItemStylePlain target:self action:@selector(onCancelButton)];
//    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Tweet" style:UIBarButtonItemStylePlain target:self action:@selector(onTweetButton)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onRetweet:(id)sender {
    
    if (self.tweet.isRetweet) {
        [[TwitterClient sharedInstance] deletTweete:self.tweet.id completion:^(Tweet *tweet, NSError *error) {
            if ( tweet != nil) {
                self.tweet.isRetweet = NO;
                self.tweet.RetweetsCount--;
                self.retweetCount.text = [NSString stringWithFormat:@"%ld", self.tweet.RetweetsCount];
                [self.btnRetweet setImage:[UIImage imageNamed:@"tweet_retweet_off.png"] forState:UIControlStateNormal];
                
            }
        }];
    } else {
        [[TwitterClient sharedInstance] retweet:self.tweet.id completion:^(Tweet *tweet, NSError *error) {
            if (tweet != nil) {
                self.tweet.isRetweet = YES;
                self.tweet.RetweetsCount++;
                self.retweetCount.text = [NSString stringWithFormat:@"%ld", self.tweet.RetweetsCount];
                [self.btnRetweet setImage:[UIImage imageNamed:@"tweet_retweet_on.png"] forState:UIControlStateNormal];
            }
        }];
    }
}

- (IBAction)onFavoriate:(id)sender {
    if (self.tweet.isFavorite) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            self.tweet.isFavorite = NO;
//            self.tweet.favoritesCount --;
//            self.favoriateCount.text = [NSString stringWithFormat:@"%ld", self.tweet.favoritesCount];
//            [self.btnFavoriate setImage:[UIImage imageNamed:@"tweet_favoriate_off.png"] forState:UIControlStateNormal];
//        });
//        
        [[TwitterClient sharedInstance] unfavorite:self.tweet.id completion:^(Tweet *tweet, NSError *error) {
            if (tweet != nil) {
                self.tweet.isFavorite = NO;
                self.tweet.favoritesCount--;
                self.favoriteCount.text = [NSString stringWithFormat:@"%ld", self.tweet.favoritesCount];
                [self.btnFavoriate setImage:[UIImage imageNamed:@"tweet_favorite_off.png"] forState:UIControlStateNormal];
            }
        }];
    } else {
        [[TwitterClient sharedInstance] favorite:self.tweet.id completion:^(Tweet *tweet, NSError *error) {
            if (tweet != nil) {
                self.tweet.isFavorite = YES;
                self.tweet.favoritesCount++;
                self.favoriteCount.text = [NSString stringWithFormat:@"%ld", self.tweet.favoritesCount];
                [self.btnFavoriate setImage:[UIImage imageNamed:@"tweet_favorite_on.png"] forState:UIControlStateNormal];
            }
        }];
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    ComposeViewController *vc = segue.destinationViewController;
    vc.delegate = self;
}


- (void)newTweet:(ComposeViewController *)sender tweetText:(NSString *)tweetText {
    [[TwitterClient sharedInstance] tweet:tweetText repliesTo:self.tweet.id completion:^(Tweet *tweet, NSError *error) {
        NSLog(@"reply tweet");
    }];
}


@end
