//
//  ComposeViewController.h
//  Twitter
//
//  Created by Issen Su on 7/2/15.
//  Copyright (c) 2015 Issen Su. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ComposeViewController;

@protocol ComposeViewControllerDelegate <NSObject>

- (void)newTweet:(ComposeViewController *)sender tweetText:(NSString *)tweetText;

@end

@interface ComposeViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *tweetMessage;
@property (nonatomic, assign)   id<ComposeViewControllerDelegate> delegate;

@end
