//
//  TwitterClient.h
//  Twitter
//
//  Created by Issen Su on 7/2/15.
//  Copyright (c) 2015 Issen Su. All rights reserved.
//

#import "BDBOAuth1RequestOperationManager.h"
#import "User.h"
#import "Tweet.h"

@interface TwitterClient : BDBOAuth1RequestOperationManager

@property (nonatomic, strong) void (^loginCompletion)(User *user, NSError *error);


+ (TwitterClient *) sharedInstance;
- (void)loginWithCompletion:(void (^)(User *user, NSError *error))completion;
- (void)openURL:(NSURL *)url;
- (void)homeTimelineWithParams:(NSDictionary *)params completion:(void (^)(NSArray *tweets, NSError *error))completion;
- (void)retweet:(NSString *)id completion:(void (^)(Tweet *tweet, NSError *error))completion;
- (void)tweet:(NSString *)text repliesTo:(NSString *)idToBeReplied completion:(void (^)(Tweet *tweet, NSError *error))completion;
- (void)favorite:(NSString *)tweetId completion:(void (^)(Tweet *tweet, NSError *error))completion;
- (void)unfavorite:(NSString *)tweetId completion:(void (^)(Tweet *tweet, NSError *error))completion;
- (void)tweetDetail:(NSString *)tweetId completion:(void (^)(Tweet *tweet, NSError *error))completion;
- (void)deletTweete:(NSString *)tweetId completion:(void (^)(Tweet *tweet, NSError *error))completion;

@end
