//
//  HackerNewsCell.h
//  HackerNews
//
//  Created by akshay bansal on 9/21/17.
//  Copyright © 2017 akshay bansal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HackerNewsCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *score;
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UILabel *url;
@property (strong, nonatomic) IBOutlet UILabel *timeAgo;
@property (strong, nonatomic) IBOutlet UILabel *commentCount;
@property (strong, nonatomic) IBOutlet UILabel *userName;

@end
