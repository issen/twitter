//
//  Tweet.h
//  Twitter
//
//  Created by Issen Su on 7/2/15.
//  Copyright (c) 2015 Issen Su. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Tweet : NSObject

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) NSString *interval;
@property (nonatomic, strong) User *user;
@property long favoritesCount;
@property long RetweetsCount;
@property BOOL isFavorite;
@property BOOL isRetweet;

- (id)initWithDictionary:(NSDictionary *)dictionary;

+ (NSArray * ) tweetsWithArray:(NSArray * ) array;

@end
