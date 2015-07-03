//
//  TweetDetailViewController.h
//  Twitter
//
//  Created by Issen Su on 7/2/15.
//  Copyright (c) 2015 Issen Su. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

//@class TweetDetailViewController;
//
//@protocol TweetDetailViewDelegate <NSObject>
//@required
//-(void)detailViewController:(TweetDetailViewController *)controller doActions:(NSString *)action;
//
//@end

@interface TweetDetailViewController : UIViewController

@property (strong, nonatomic) Tweet *tweet;
@property (weak, nonatomic) IBOutlet UILabel *tweetMessage;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *screenName;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *retweetCount;
@property (weak, nonatomic) IBOutlet UILabel *favoriteCount;
@property (weak, nonatomic) IBOutlet UILabel *dateTimeLabel;

@property (weak, nonatomic) IBOutlet UIButton *btnRetweet;
@property (weak, nonatomic) IBOutlet UIButton *btnFavoriate;
//@property (weak, nonatomic) id<TweetDetailViewDelegate> delegate;

@end
