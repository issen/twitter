//
//  Tweet.m
//  Twitter
//
//  Created by Issen Su on 7/2/15.
//  Copyright (c) 2015 Issen Su. All rights reserved.
//

#import "Tweet.h"

@implementation Tweet


- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        
        self.id = dictionary[@"id_str"];
        self.text = dictionary[@"text"];
        self.user = [[User alloc] initWithDictionary:dictionary[@"user"]];
        
        self.favoritesCount = [dictionary[@"favorite_count"] intValue];
        self.RetweetsCount = [dictionary[@"retweet_count"] intValue];
        
        
        self.isFavorite = [dictionary[@"favorited"] boolValue];
        self.isRetweet = [dictionary[@"retweeted"] boolValue];
        
        NSString *createAtString = dictionary[@"created_at"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"EEE MMM d HH:mm:ss Z y";
        self.createdAt = [formatter dateFromString:createAtString];
        
        float seconds = [[NSDate date] timeIntervalSinceDate:self.createdAt];
        if ( floor(seconds / (3600*24)) > 0) {
            self.interval = [NSString stringWithFormat:@"%dd", (int)floor(seconds/(3600*24))];
        } else if (floor(seconds / 3600) > 0) {
            self.interval = [NSString stringWithFormat:@"%dh", (int)floor(seconds/3600)];
        } else if (floor(seconds / 60) > 0) {
            self.interval = [NSString stringWithFormat:@"%dm", (int)floor(seconds/60)];
        } else {
            self.interval = [NSString stringWithFormat:@"%ds", (int)seconds];
        }
        
        
    }
    
    return self;
}

+ (NSArray * ) tweetsWithArray:(NSArray *)array {
    NSMutableArray *tweets = [NSMutableArray array];
    
    for (NSDictionary *dictionary in array) {
        [tweets addObject:[[Tweet alloc] initWithDictionary:dictionary]];
    }
    
    return tweets;
}

@end
