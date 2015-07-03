//
//  TwitterClient.m
//  Twitter
//
//  Created by Issen Su on 7/2/15.
//  Copyright (c) 2015 Issen Su. All rights reserved.
//

#import "TwitterClient.h"
#import "Tweet.h"

NSString * const kTwitterConsumerKey = @"P6oJkUJXCWbWtg6a0RdVTiyPw";
NSString * const kTwitterConsumerSecret = @"F0bpst2oUGSNZ4aqERKS7XjfY9NrQG3I7bYjPGx0n5CcUvfBdP";
NSString * const kTwitterBaseUrl = @"https://api.twitter.com";

@implementation TwitterClient


+ (TwitterClient *) sharedInstance {
    static TwitterClient *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [[TwitterClient alloc] initWithBaseURL:[NSURL URLWithString:kTwitterBaseUrl] consumerKey:kTwitterConsumerKey consumerSecret:kTwitterConsumerSecret];
        }
    });
    
    
    return instance;
}

- (void)loginWithCompletion:(void (^)(User *user, NSError *error))completion {
    self.loginCompletion = completion;
    [self.requestSerializer removeAccessToken];
    [self fetchRequestTokenWithPath:@"oauth/request_token" method:@"GET" callbackURL:[NSURL URLWithString:@"iosStudy://oauth"] scope:nil success:^(BDBOAuth1Credential *request_token) {
        NSLog(@"success with token");
        NSURL *authURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/oauth/authorize?oauth_token=%@", request_token.token]];
        [[UIApplication sharedApplication] openURL:authURL];
        
    } failure:^(NSError *error) {
        NSLog(@"[ERROR] Failed with token retreival");
        self.loginCompletion(nil, error);
    }];
}

- (void)openURL:(NSURL *)url {
    [self fetchAccessTokenWithPath:@"oauth/access_token" method:@"POST" requestToken:[BDBOAuth1Credential credentialWithQueryString:url.query] success:^(BDBOAuth1Credential *accessToken) {
        [self.requestSerializer saveAccessToken:accessToken];
        [self GET:@"1.1/account/verify_credentials.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            User *user = [[User alloc] initWithDictionary:responseObject];
            NSLog(@"current user %@", responseObject);
            self.loginCompletion(user, nil);
            [User setCurrentUser:user];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"[ERROR] Failed with credential verification");
            self.loginCompletion(nil, error);
        }];
    } failure:^(NSError *error) {
        NSLog(@"[ERROR] Failed with token access");
    }];
}

- (void)homeTimelineWithParams:(NSDictionary *)params completion:(void (^)(NSArray *tweets, NSError *error))completion {
    [self GET:@"1.1/statuses/home_timeline.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"param is %@", params);
        //NSLog(@"raw data is %@", responseObject);
        NSArray *tweets = [Tweet tweetsWithArray:responseObject];
        completion(tweets, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"[ERROR] homeTimeline retrieval failed : %@", error);
        completion(nil, error);
    }];
}

- (void)retweet:(NSString *)tweetId completion:(void (^)(Tweet *tweet, NSError *error))completion {
    NSString *url = [NSString stringWithFormat:@"1.1/statuses/retweet/%@.json", tweetId];
    [self POST:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"raw data is %@", responseObject);
        Tweet *tweet = [[Tweet alloc] initWithDictionary:responseObject];
        completion(tweet, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"[ERROR] %@ retrieval failed", url);
        completion(nil, error);
    }];
}

- (void)favorite:(NSString *)tweetId completion:(void (^)(Tweet *tweet, NSError *error))completion {
    NSString *url = [NSString stringWithFormat:@"1.1/favorites/create.json?id=%@", tweetId];
    [self POST:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"raw data is %@", responseObject);
        Tweet *tweet = [[Tweet alloc] initWithDictionary:responseObject];
        completion(tweet, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"[ERROR] %@ retrieval failed", url);
        completion(nil, error);
    }];
}

- (void)unfavorite:(NSString *)tweetId completion:(void (^)(Tweet *tweet, NSError *error))completion {
    NSString *url = [NSString stringWithFormat:@"1.1/favorites/destroy.json?id=%@", tweetId];
    [self POST:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"raw data is %@", responseObject);
        Tweet *tweet = [[Tweet alloc] initWithDictionary:responseObject];
        completion(tweet, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"[ERROR] %@ retrieval failed", url);
        completion(nil, error);
    }];
}

- (void)tweetDetail:(NSString *)tweetId completion:(void (^)(Tweet *tweet, NSError *error))completion {
    NSString *url = [NSString stringWithFormat:@"1.1/statuses/show/%@.json?include_my_retweet=1", tweetId];
    [self GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"raw data is %@", responseObject);
        Tweet *tweet = [[Tweet alloc] initWithDictionary:responseObject];
        completion(tweet, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"[ERROR] %@ retrieval failed", url);
        completion(nil, error);
    }];
}

- (void)deletTweete:(NSString *)tweetId completion:(void (^)(Tweet *tweet, NSError *error))completion {
    NSString *url = [NSString stringWithFormat:@"1.1/statuses/destroy/%@.json?include_my_retweet=1", tweetId];
    [self POST:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"raw data is %@", responseObject);
        Tweet *tweet = [[Tweet alloc] initWithDictionary:responseObject];
        completion(tweet, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"call %@ failed", url);
        completion(nil, error);
    }];
}

- (void)tweet:(NSString *)text repliesTo:(NSString *)idToBeReplied completion:(void (^)(Tweet *tweet, NSError *error))completion {
    NSString *url = [NSString stringWithFormat:@"1.1/statuses/update.json"];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"status": text}];
    if (idToBeReplied != nil) {
        [params setValue:idToBeReplied forKey:@"in_reply_to_status_id"];
    }
    NSLog(@"TWitterClient on tweet");
    [self POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"raw data is %@", responseObject);
        Tweet *tweet = [[Tweet alloc] initWithDictionary:responseObject];
        completion(tweet, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"[ERROR] %@ retrieval failed", url);
        completion(nil, error);
    }];
}

@end
