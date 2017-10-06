//
//  CommentsViewController.h
//  HackerNews
//
//  Created by akshay bansal on 9/22/17.
//  Copyright © 2017 akshay bansal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentsDownloader.h"
#import "Story.h"
@interface CommentsViewController : UIViewController
@property(nonatomic,strong) Story *story;

@end
